//
//  ActionsViewController.swift
//
//  Created by ToKoRo on 2017-08-22.
//

import UIKit
import HomeKit

class ActionsViewController: UITableViewController, ContextHandler {
    typealias ContextType = ActionStore

    var store: ActionStore { return context! }
    var actions: [HMAction] { return Array(store.actions) }

    var selectedAction: HMAction?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        refresh()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "Action"?:
            sendContext(selectedAction, to: segue.destination)
        case "CreateCharacteristicWriteAction"?:
            switch store.actionStoreKind {
            case .actionSet(let actionSet):
                sendContext(actionSet.home, to: segue.destination)
            }
        default:
            break
        }
    }

    func refresh() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func action(at indexPath: IndexPath) -> HMAction? {
        return actions.safe[indexPath.row]
    }

    @IBAction func addButtonDidTap(sender: AnyObject) {
        performSegue(withIdentifier: "CreateCharacteristicWriteAction", sender: nil)
    }
}

// MARK: - UITableViewDataSource

extension ActionsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Action", for: indexPath)
        if let action = action(at: indexPath) {
            cell.textLabel?.text = String(describing: type(of: action))
            if let writeAction = action as? HMCharacteristicWriteAction<NSNumber> {
                cell.detailTextLabel?.text = writeAction.characteristic.localizedDescription
            } else {
                cell.detailTextLabel?.text = nil
            }
        }
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ActionsViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer { tableView.deselectRow(at: indexPath, animated: true) }

        self.selectedAction = action(at: indexPath)

        performSegue(withIdentifier: "Action", sender: nil)
    }
}

// MARK: - ActionSelector

extension ActionsViewController: ActionSelector {
    func selectAction(_ action: HMAction) {
        switch store.actionStoreKind {
        case .actionSet(let actionSet):
            actionSet.addAction(action) { [weak self] error in
                if let error = error {
                    print("# error: \(error)")
                }
                self?.refresh()
            }
        }
    }
}

// MARK: - ActionActionHandler

extension ActionsViewController: ActionActionHandler {
    func handleRemove(_ action: HMAction) {
        switch store.actionStoreKind {
        case .actionSet(let actionSet):
            actionSet.removeAction(action) { [weak self] error in
                if let error = error {
                    print("# error: \(error)")
                }
                self?.refresh()
            }
        }
    }
}
