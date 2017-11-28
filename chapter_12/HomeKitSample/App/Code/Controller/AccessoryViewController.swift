//
//  AccessoryViewController.swift
//
//  Created by ToKoRo on 2017-08-21.
//

import UIKit
import HomeKit

class AccessoryViewController: UITableViewController, ContextHandler {
    typealias ContextType = HMAccessory

    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var uniqueIdentifierLabel: UILabel?
    @IBOutlet weak var categoryLabel: UILabel?
    @IBOutlet weak var isReachableLabel: UILabel?
    @IBOutlet weak var isBlockedLabel: UILabel?
    @IBOutlet weak var firmwareVersionLabel: UILabel?
    @IBOutlet weak var manufacturerLabel: UILabel?
    @IBOutlet weak var modelLabel: UILabel?
    @IBOutlet weak var roomLabel: UILabel?
    @IBOutlet weak var servicesLabel: UILabel?
    @IBOutlet weak var isBridgedLabel: UILabel?
    @IBOutlet weak var bridgedAccessoriesLabel: UILabel?
    @IBOutlet weak var profilesLabel: UILabel?
    @IBOutlet weak var cameraProfilesLabel: UILabel?

    var accessory: HMAccessory { return context! }

    override func viewDidLoad() {
        super.viewDidLoad()

        refresh()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setToolbarHidden(false, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "BridgedAccessories"?:
            let identifiers = accessory.uniqueIdentifiersForBridgedAccessories ?? []
            let context = AccessoryIdentifiers(identifiers: identifiers)
            sendContext(context, to: segue.destination)
        case "Service"?:
            sendContext(accessory, to: segue.destination)
        case "Profile"?:
            sendContext(accessory.profiles, to: segue.destination)
        case "CameraProfile"?:
            sendContext(accessory.cameraProfiles, to: segue.destination)
        default:
            break
        }
    }

    private func refresh() {
        nameLabel?.text = accessory.name
        uniqueIdentifierLabel?.text = accessory.uniqueIdentifier.uuidString
        categoryLabel?.text = {
            let description = String(describing: AccessoryCategoryType(typeString: accessory.category.categoryType))
            let localizedDescription = accessory.category.localizedDescription
            return "\(description)(\(localizedDescription))"
        }()
        isReachableLabel?.text = String(accessory.isReachable)
        isBlockedLabel?.text = String(accessory.isBlocked)
        firmwareVersionLabel?.text = accessory.firmwareVersion
        manufacturerLabel?.text = accessory.manufacturer
        modelLabel?.text = accessory.model

        roomLabel?.text = accessory.room?.name
        servicesLabel?.text = String(accessory.services.count)

        isBridgedLabel?.text = String(accessory.isBridged)
        bridgedAccessoriesLabel?.text = String(accessory.uniqueIdentifiersForBridgedAccessories?.count ?? 0)

        profilesLabel?.text = String(accessory.profiles.count)
        cameraProfilesLabel?.text = String(accessory.cameraProfiles?.count ?? 0)
    }

    private func updateName() {
        let accessory = self.accessory

        let alert = UIAlertController(title: nil, message: "Accessoryの名前を入力してください", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = accessory.name
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard
                let name = alert.textFields?.first?.text,
                name.count > 0
            else {
                return
            }
            self?.handleNewAccessoryName(name)
        })
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel))
        present(alert, animated: true)
    }

    private func handleNewAccessoryName(_ name: String) {
        accessory.updateName(name) { [weak self] error in
            if let error = error {
                print("# error: \(error)")
            }
            self?.refresh()
        }
    }
}

// MARK: - Actions

extension AccessoryViewController {
    @IBAction func removeButtonDidTap(sender: AnyObject) {
        ResponderChain(from: self).send(accessory, protocol: AccessoryActionHandler.self) { [weak self] accessory, handler in
            handler.handleRemove(accessory)

            DispatchQueue.main.async {
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
}

// MARK: - UITableViewDelegate

extension AccessoryViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer { tableView.deselectRow(at: indexPath, animated: true) }

        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            // name
            updateName()
        default:
            break
        }
    }
}
