//
//  CreateTriggerViewController.swift
//
//  Created by ToKoRo on 2017-09-03.
//

import UIKit
import HomeKit

class CreateTriggerViewController: UITableViewController {
    @IBOutlet weak var nameField: UITextField?

    var newName: String? {
        return nameField?.text
    }

    func createTriggerAndSend() {
        guard let trigger = createTrigger() else {
            dismiss(animated: true)
            return
        }

        ResponderChain(from: self).send(trigger, protocol: TriggerSelector.self) { trigger, handler in
            handler.selectTrigger(trigger)
        }
        dismiss(animated: true)
    }

    func createTrigger() -> HMTrigger? {
        return nil
    }

    @IBAction func doneButtonDidTap(sender: AnyObject) {
        createTriggerAndSend()
    }
}
