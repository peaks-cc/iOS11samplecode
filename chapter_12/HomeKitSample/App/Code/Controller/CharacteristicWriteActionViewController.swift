//
//  CharacteristicWriteActionViewController.swift
//
//  Created by ToKoRo on 2017-08-22.
//

import UIKit
import HomeKit

class CharacteristicWriteActionViewController: UITableViewController, ContextHandler {
    typealias ContextType = HMAction

    @IBOutlet weak var typeLabel: UILabel?
    @IBOutlet weak var targetValueLabel: UILabel?
    @IBOutlet weak var characteristicLabel: UILabel?

    var action: HMAction { return context! }
    lazy var numberWriteAction: HMCharacteristicWriteAction<NSNumber>? = { action as? HMCharacteristicWriteAction<NSNumber> }()

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
        case "Characteristic"?:
            if let numberWriteAction = numberWriteAction {
                sendContext(numberWriteAction.characteristic, to: segue.destination)
            }
        default:
            break
        }
    }

    private func refresh() {
        typeLabel?.text = {
            return String(describing: type(of: action))
        }()

        targetValueLabel?.text = {
            guard let numberWriteAction = numberWriteAction else {
                return nil
            }
            return String(describing: numberWriteAction.targetValue)
        }()

        characteristicLabel?.text = {
            if let numberWriteAction = numberWriteAction {
                return CharacteristicType(typeString: numberWriteAction.characteristic.characteristicType).description
            }
            return nil
        }()
    }
}

// MARK: - Actions

extension CharacteristicWriteActionViewController {
    @IBAction func removeButtonDidTap(sender: AnyObject) {
        ResponderChain(from: self).send(action, protocol: ActionActionHandler.self) { [weak self] action, handler in
            handler.handleRemove(action)

            DispatchQueue.main.async {
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
}
