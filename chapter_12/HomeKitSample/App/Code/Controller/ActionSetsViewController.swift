//
//  ActionSetsViewController.swift
//
//  Created by ToKoRo on 2017-08-22.
//

import UIKit
import HomeKit

class ActionSetsViewController: UITableViewController, ContextHandler {
    typealias ContextType = ActionSetStore

    @IBInspectable var isSelectMode: Bool = false

    var store: ActionSetStore { return context! }
    var actionSets: [HMActionSet] { return store.actionSets }

    var selectedActionSet: HMActionSet?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        refresh()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ActionSet"?:
            sendContext(selectedActionSet, to: segue.destination)
        case "SelectActionSet"?:
            switch store.actionSetStoreKind {
            case .home(let home):
                sendContext(home, to: segue.destination)
            case .trigger(let trigger):
                sendContext(trigger.home, to: segue.destination)
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

    func actionSet(at indexPath: IndexPath) -> HMActionSet? {
        return actionSets.safe[indexPath.row]
    }

    @IBAction func addButtonDidTap(sender: AnyObject) {
        switch store.actionSetStoreKind {
        case .home:
            displayNewActionSetAlert()
        case .trigger:
            selectExistingActionSet()
        }
    }

    @IBAction func cancelButtonDidTap(sender: AnyObject) {
        dismiss(animated: true)
    }

    private func displayNewActionSetAlert() {
        let alert = UIAlertController(title: nil, message: "追加するActionSetの名前を入力してください", preferredStyle: .alert)
        alert.addTextField()
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
        switch store.actionSetStoreKind {
        case .home(let home):
            home.addActionSet(withName: name) { [weak self] actionSet, error in
                if let actionSet = actionSet {
                    print("# added actionSet: \(actionSet)")
                }
                if let error = error {
                    print("# error: \(error)")
                }
                self?.refresh()
            }
        default:
            break
        }
    }

    private func selectExistingActionSet() {
        performSegue(withIdentifier: "SelectActionSet", sender: nil)
    }
}

// MARK: - UITableViewDataSource

extension ActionSetsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actionSets.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActionSet", for: indexPath)
        if let actionSet = actionSet(at: indexPath) {
            cell.textLabel?.text = actionSet.name
            cell.detailTextLabel?.text = ActionSetType(typeString: actionSet.actionSetType).description
        }
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ActionSetsViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer { tableView.deselectRow(at: indexPath, animated: true) }

        self.selectedActionSet = actionSet(at: indexPath)

        if isSelectMode, let actionSet = selectedActionSet {
            ResponderChain(from: self).send(actionSet, protocol: ActionSetSelector.self) { actionSet, handler in
                handler.selectActionSet(actionSet)
            }
            dismiss(animated: true)
        } else {
            performSegue(withIdentifier: "ActionSet", sender: nil)
        }
    }
}

// MARK: - ActionSetActionHandler

extension ActionSetsViewController: ActionSetActionHandler {
    func handleExecute(_ actionSet: HMActionSet) {
        switch store.actionSetStoreKind {
        case .home(let home):
            home.executeActionSet(actionSet) { [weak self] error in
                if let error = error {
                    print("# error: \(error)")
                }
                self?.refresh()
            }
        case .trigger(let trigger):
            trigger.home?.executeActionSet(actionSet) { [weak self] error in
                if let error = error {
                    print("# error: \(error)")
                }
                self?.refresh()
            }
        }
    }

    func handleRemove(_ actionSet: HMActionSet) {
        switch store.actionSetStoreKind {
        case .home(let home):
            home.removeActionSet(actionSet) { [weak self] error in
                if let error = error {
                    print("# error: \(error)")
                }
                self?.refresh()
            }
        case .trigger(let trigger):
            trigger.removeActionSet(actionSet) { [weak self] error in
                if let error = error {
                    print("# error: \(error)")
                }
                self?.refresh()
            }
        }
    }
}

// MARK: - ActionSetSelector

extension ActionSetsViewController: ActionSetSelector {
    func selectActionSet(_ actionSet: HMActionSet) {
        switch store.actionSetStoreKind {
        case .trigger(let trigger):
            trigger.addActionSet(actionSet) { [weak self] error in
                if let error = error {
                    print("# error: \(error)")
                }
                self?.refresh()
            }
        default:
            break
        }
    }
}
