//
//  ZoneViewController.swift
//
//  Created by ToKoRo on 2017-08-27.
//

import UIKit
import HomeKit

class ZoneViewController: UITableViewController, ContextHandler {
    typealias ContextType = HMZone

    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var uniqueIdentifierLabel: UILabel?
    @IBOutlet weak var roomsCountLabel: UILabel?

    var zone: HMZone { return context! }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setToolbarHidden(false, animated: true)

        refresh()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "Room"?:
            sendContext(zone, to: segue.destination)
        default:
            break
        }
    }

    private func refresh() {
        nameLabel?.text = zone.name
        uniqueIdentifierLabel?.text = zone.uniqueIdentifier.uuidString

        roomsCountLabel?.text = String(zone.rooms.count)
    }

    private func updateName() {
        let zone = self.zone

        let alert = UIAlertController(title: nil, message: "Zoneの名前を入力してください", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = zone.name
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard
                let name = alert.textFields?.first?.text,
                name.count > 0
            else {
                return
            }
            self?.handleNewZoneName(name)
        })
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel))
        present(alert, animated: true)
    }

    private func handleNewZoneName(_ name: String) {
        zone.updateName(name) { [weak self] error in
            if let error = error {
                print("# error: \(error)")
            }
            self?.refresh()
        }
    }
}

// MARK: - Actions

extension ZoneViewController {
    @IBAction func removeButtonDidTap(sender: AnyObject) {
        ResponderChain(from: self).send(zone, protocol: ZoneActionHandler.self) { [weak self] zone, handler in
            handler.handleRemove(zone)

            DispatchQueue.main.async {
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
}

// MARK: - UITableViewDelegate

extension ZoneViewController {
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
