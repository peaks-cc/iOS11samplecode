//
//  TriggerViewController.swift
//
//  Created by ToKoRo on 2017-08-22.
//

import UIKit
import HomeKit

class TriggerViewController: UITableViewController, ContextHandler {
    typealias ContextType = HMTrigger

    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var uniqueIdentifierLabel: UILabel?
    @IBOutlet weak var isEnabledLabel: UILabel?
    @IBOutlet weak var lastFireDateLabel: UILabel?
    @IBOutlet weak var actionSetsCountLabel: UILabel?

    var trigger: HMTrigger { return context! }

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
        case "ActionSet"?:
            sendContext(trigger, to: segue.destination)
        default:
            break
        }
    }

    func refresh() {
        nameLabel?.text = trigger.name
        uniqueIdentifierLabel?.text = trigger.uniqueIdentifier.uuidString
        isEnabledLabel?.text = String(trigger.isEnabled)
        lastFireDateLabel?.text = {
            guard let date = trigger.lastFireDate else {
                return nil
            }
            return DateFormatter.localizedString(from: date, dateStyle: .short, timeStyle: .short)
        }()

        actionSetsCountLabel?.text = String(trigger.actionSets.count)
    }

    private func updateName() {
        let trigger = self.trigger

        let alert = UIAlertController(title: nil, message: "Triggerの名前を入力してください", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = trigger.name
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard
                let name = alert.textFields?.first?.text,
                name.count > 0
            else {
                return
            }
            self?.handleNewTriggerName(name)
        })
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel))
        present(alert, animated: true)
    }

    private func handleNewTriggerName(_ name: String) {
        trigger.updateName(name) { [weak self] error in
            if let error = error {
                print("# error: \(error)")
            }
            self?.refresh()
        }
    }

    private func displayEnableAction() {
        let message = "Enables/disables this trigger"
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Enable", style: .default) { [weak self] _ in
            self?.enable(true)
        })
        alert.addAction(UIAlertAction(title: "Disable", style: .default) { [weak self] _ in
            self?.enable(false)
        })
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel))
        present(alert, animated: true)
    }

    private func enable(_ enable: Bool) {
        trigger.enable(enable) { [weak self] error in
            if let error = error {
                print("# error: \(error)")
            }
            self?.refresh()
        }
    }
}
// MARK: - Actions

extension TriggerViewController {
    @IBAction func removeButtonDidTap(sender: AnyObject) {
        ResponderChain(from: self).send(trigger, protocol: TriggerActionHandler.self) { [weak self] trigger, handler in
            handler.handleRemove(trigger)

            DispatchQueue.main.async {
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
}

// MARK: - UITableViewDelegate

extension TriggerViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer { tableView.deselectRow(at: indexPath, animated: true) }

        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            // name
            updateName()
        case (0, 2):
            // enable
            displayEnableAction()
        default:
            break
        }
    }
}
