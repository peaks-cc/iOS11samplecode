//
//  TriggersViewController.swift
//
//  Created by ToKoRo on 2017-08-22.
//

import UIKit
import HomeKit

class TriggersViewController: UITableViewController, ContextHandler {
    typealias ContextType = HMHome

    var home: HMHome { return context! }
    var triggers: [HMTrigger] { return home.triggers }

    var selectedTrigger: HMTrigger?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        refresh()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "TimerTrigger"?, "EventTrigger"?, "Trigger"?:
            sendContext(selectedTrigger, to: segue.destination)
        default:
            break
        }
    }

    func refresh() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func trigger(at indexPath: IndexPath) -> HMTrigger? {
        return triggers.safe[indexPath.row]
    }

    @IBAction func addButtonDidTap(sender: AnyObject) {
        displayTriggerTypeAction()
    }

    private func displayTriggerTypeAction() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "HMTimerTrigger", style: .default) { [weak self] _ in
            self?.performSegue(withIdentifier: "CreateTimerTrigger", sender: nil)
        })
        alert.addAction(UIAlertAction(title: "HMEventTrigger", style: .default) { [weak self] _ in
            self?.performSegue(withIdentifier: "CreateEventTrigger", sender: nil)
        })
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension TriggersViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return triggers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Trigger", for: indexPath)
        if let trigger = trigger(at: indexPath) {
            cell.textLabel?.text = trigger.name
        }
        return cell
    }
}

// MARK: - UITableViewDelegate

extension TriggersViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer { tableView.deselectRow(at: indexPath, animated: true) }

        self.selectedTrigger = trigger(at: indexPath)

        switch selectedTrigger {
        case is HMTimerTrigger:
            performSegue(withIdentifier: "TimerTrigger", sender: nil)
        case is HMEventTrigger:
            performSegue(withIdentifier: "EventTrigger", sender: nil)
        default:
            performSegue(withIdentifier: "Trigger", sender: nil)
        }
    }
}

// MARK: - TriggerSelector

extension TriggersViewController: TriggerSelector {
    func selectTrigger(_ trigger: HMTrigger) {
        home.addTrigger(trigger) { [weak self] error in
            if let error = error {
                print("# error: \(error)")
            }
            self?.refresh()
        }
    }
}

// MARK: - TriggerActionHandler

extension TriggersViewController: TriggerActionHandler {
    func handleRemove(_ trigger: HMTrigger) {
        home.removeTrigger(trigger) { [weak self] error in
            if let error = error {
                print("# error: \(error)")
            }
            self?.refresh()
        }
    }
}
