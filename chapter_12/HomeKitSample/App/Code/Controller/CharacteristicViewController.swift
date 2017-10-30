//
//  CharacteristicViewController.swift
//
//  Created by ToKoRo on 2017-08-21.
//

import UIKit
import HomeKit

class CharacteristicViewController: UITableViewController, ContextHandler {
    typealias ContextType = HMCharacteristic

    @IBOutlet weak var valueLabel: UILabel?
    @IBOutlet weak var valueTypeLabel: UILabel?
    @IBOutlet weak var uniqueIdentifierLabel: UILabel?
    @IBOutlet weak var characteristicTypeLabel: UILabel?
    @IBOutlet weak var localizedDescriptionLabel: UILabel?
    @IBOutlet weak var propertyIsReadableLabel: UILabel?
    @IBOutlet weak var propertyIsWriteableLabel: UILabel?
    @IBOutlet weak var propertyIsHiddenLabel: UILabel?
    @IBOutlet weak var propertySupportsEventLabel: UILabel?
    @IBOutlet weak var formatLabel: UILabel?
    @IBOutlet weak var unitsLabel: UILabel?
    @IBOutlet weak var validValuesLabel: UILabel?
    @IBOutlet weak var minimumValueLabel: UILabel?
    @IBOutlet weak var maximumValueLabel: UILabel?
    @IBOutlet weak var stepValueLabel: UILabel?
    @IBOutlet weak var maxLengthLabel: UILabel?
    @IBOutlet weak var manufacturerDescriptionLabel: UILabel?
    @IBOutlet weak var isNotificationEnabledLabel: UILabel?

    @IBInspectable var isCreateMode: Bool = false

    var characteristic: HMCharacteristic { return context! }
    var targetValue: NSCopying?

    override func viewDidLoad() {
        super.viewDidLoad()

        refresh()
    }

    private func refresh() {
        if let value = targetValue {
            valueLabel?.text = String(describing: value)
            valueTypeLabel?.text = String(describing: type(of: value))
        } else if let value = characteristic.value {
            valueLabel?.text = String(describing: value)
            valueTypeLabel?.text = String(describing: type(of: value))
        } else {
            valueLabel?.text = "nil"
            valueTypeLabel?.text = "nil"
        }

        uniqueIdentifierLabel?.text = characteristic.uniqueIdentifier.uuidString
        characteristicTypeLabel?.text = String(describing: CharacteristicType(typeString: characteristic.characteristicType))
        print("# characteristicType: \(characteristic.characteristicType)")
        localizedDescriptionLabel?.text = characteristic.localizedDescription

        propertyIsReadableLabel?.text = String(characteristic.properties.contains(HMCharacteristicPropertyReadable))
        propertyIsWriteableLabel?.text = String(characteristic.properties.contains(HMCharacteristicPropertyWritable))
        propertyIsHiddenLabel?.text = String(characteristic.properties.contains(HMCharacteristicPropertyHidden))
        propertySupportsEventLabel?.text =
            String(characteristic.properties.contains(Notification.Name.HMCharacteristicPropertySupportsEvent.rawValue))

        if let metadata = characteristic.metadata {
            formatLabel?.text = metadata.format
            unitsLabel?.text = metadata.units
            validValuesLabel?.text = metadata.validValues?.map { $0.stringValue }.joined(separator: ",")
            minimumValueLabel?.text = metadata.minimumValue?.stringValue
            maximumValueLabel?.text = metadata.maximumValue?.stringValue
            stepValueLabel?.text = metadata.stepValue?.stringValue
            maxLengthLabel?.text = metadata.maxLength?.stringValue
            manufacturerDescriptionLabel?.text = metadata.manufacturerDescription
        } else {
            formatLabel?.text = nil
            unitsLabel?.text = nil
            validValuesLabel?.text = nil
            minimumValueLabel?.text = nil
            maximumValueLabel?.text = nil
            stepValueLabel?.text = nil
            maxLengthLabel?.text = nil
            manufacturerDescriptionLabel?.text = nil
        }

        isNotificationEnabledLabel?.text = String(characteristic.isNotificationEnabled)
    }

    private func displayValueAction() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if characteristic.properties.contains(HMCharacteristicPropertyReadable) {
            alert.addAction(UIAlertAction(title: "現在のvalueを取得", style: .default) { [weak self] _ in
                self?.updateValue()
            })
        }
        if characteristic.properties.contains(HMCharacteristicPropertyWritable) {
            alert.addAction(UIAlertAction(title: "valueを上書き", style: .default) { [weak self] _ in
                self?.displayWriteValueAlert()
            })
        }
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel))
        present(alert, animated: true)
    }

    private func updateValue() {
        characteristic.readValue { [weak self] error in
            if let error = error {
                print("# error: \(error)")
            }
            self?.refresh()
        }
    }

    private func displayWriteValueAlert() {
        let characteristic = self.characteristic

        let alert = UIAlertController(title: nil, message: "設定するvalueを入力してください", preferredStyle: .alert)
        alert.addTextField { textField in
            if let value = characteristic.value {
                textField.text = String(describing: value)
            }
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard
                let value = alert.textFields?.first?.text,
                value.count > 0
            else {
                return
            }
            self?.handleNewValue(value)
        })
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel))
        present(alert, animated: true)
    }

    private func handleNewValue(_ stringValue: String) {
        let value = stringValue.characteristicValue(for: characteristic.metadata?.format)
        if isCreateMode {
            self.targetValue = value as? NSCopying
            refresh()
        } else {
            writeValue(value)
        }
    }

    private func writeValue(_ value: Any?) {
        characteristic.writeValue(value) { [weak self] error in
            if let error = error {
                print("# error: \(error)")
            }
            self?.refresh()
        }
    }

    private func displayEnableNotificationAction() {
        let message = "Enables/disables notifications or indications for the value of the characteristic"
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Enable", style: .default) { [weak self] _ in
            self?.enableNotification(true)
        })
        alert.addAction(UIAlertAction(title: "Disable", style: .default) { [weak self] _ in
            self?.enableNotification(false)
        })
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel))
        present(alert, animated: true)
    }

    private func enableNotification(_ enable: Bool) {
        characteristic.enableNotification(enable) { [weak self] error in
            if let error = error {
                print("# error: \(error)")
            }
            self?.refresh()
        }
    }

    @IBAction func doneButtonDidTap(sender: AnyObject) {
        let value: NSCopying? = {
            if let value = targetValue {
                return value
            } else if let value = characteristic.value as? NSCopying {
                return value
            } else {
                return nil
            }
        }()

        guard let validValue = value else {
            return
        }

        let action = HMCharacteristicWriteAction(characteristic: characteristic, targetValue: validValue)

        ResponderChain(from: self).send(action, protocol: ActionSelector.self) { action, handler in
            handler.selectAction(action)
        }
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDelegate

extension CharacteristicViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer { tableView.deselectRow(at: indexPath, animated: true) }

        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            if isCreateMode {
                displayWriteValueAlert()
            } else {
                displayValueAction()
            }
        case (3, 0):
            displayEnableNotificationAction()
        default:
            break
        }
    }
}
