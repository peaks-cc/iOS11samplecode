//
//  ActionSetViewController.swift
//
//  Created by ToKoRo on 2017-08-22.
//

import UIKit
import HomeKit

class ActionSetViewController: UITableViewController, ContextHandler {
    typealias ContextType = HMActionSet

    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var uniqueIdentifierLabel: UILabel?
    @IBOutlet weak var actionSetTypeLabel: UILabel?
    @IBOutlet weak var isExecutingLabel: UILabel?
    @IBOutlet weak var lastExecutionDateLabel: UILabel?
    @IBOutlet weak var actionsCountLabel: UILabel?

    var actionSet: HMActionSet { return context! }

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
        case "Action"?:
            sendContext(actionSet, to: segue.destination)
        default:
            break
        }
    }

    private func refresh() {
        nameLabel?.text = actionSet.name
        uniqueIdentifierLabel?.text = actionSet.uniqueIdentifier.uuidString
        actionSetTypeLabel?.text = ActionSetType(typeString: actionSet.actionSetType).description
        isExecutingLabel?.text = String(actionSet.isExecuting)
        lastExecutionDateLabel?.text = {
            guard let date = actionSet.lastExecutionDate else {
                return nil
            }
            return DateFormatter.localizedString(from: date, dateStyle: .short, timeStyle: .short)
        }()

        actionsCountLabel?.text = String(actionSet.actions.count)
    }

    private func updateName() {
        let actionSet = self.actionSet

        let alert = UIAlertController(title: nil, message: "ActionSetの名前を入力してください", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = actionSet.name
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard
                let name = alert.textFields?.first?.text,
                name.count > 0
            else {
                return
            }
            self?.handleNewActionSetName(name)
        })
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel))
        present(alert, animated: true)
    }

    private func handleNewActionSetName(_ name: String) {
        actionSet.updateName(name) { [weak self] error in
            if let error = error {
                print("# error: \(error)")
            }
            self?.refresh()
        }
    }
}

// MARK: - Actions

extension ActionSetViewController {
    @IBAction func removeButtonDidTap(sender: AnyObject) {
        ResponderChain(from: self).send(actionSet, protocol: ActionSetActionHandler.self) { [weak self] actionSet, handler in
            handler.handleRemove(actionSet)

            DispatchQueue.main.async {
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }

    @IBAction func executeButtonDidTap(sender: AnyObject) {
        ResponderChain(from: self).send(actionSet, protocol: ActionSetActionHandler.self) { actionSet, handler in
            handler.handleExecute(actionSet)
        }
    }
}

// MARK: - UITableViewDelegate

extension ActionSetViewController {
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
