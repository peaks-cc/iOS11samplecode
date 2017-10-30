//
//  EventsViewController.swift
//
//  Created by ToKoRo on 2017-09-04.
//

import UIKit
import HomeKit

class EventsViewController: UITableViewController, ContextHandler {
    typealias ContextType = [HMEvent]

    var events: [HMEvent] { return context! }

    var selectedEvent: HMEvent?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        refresh()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "Event"?:
            sendContext(selectedEvent, to: segue.destination)
        default:
            break
        }
    }

    func refresh() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func event(at indexPath: IndexPath) -> HMEvent? {
        return events.safe[indexPath.row]
    }
}

// MARK: - UITableViewDataSource

extension EventsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Event", for: indexPath)
        if let event = event(at: indexPath) {
            cell.textLabel?.text = String(describing: type(of: event))
        }
        return cell
    }
}

// MARK: - UITableViewDelegate

extension EventsViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer { tableView.deselectRow(at: indexPath, animated: true) }

        self.selectedEvent = event(at: indexPath)

        performSegue(withIdentifier: "Event", sender: nil)
    }
}
