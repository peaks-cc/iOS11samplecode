//
//  RoomViewController.swift
//
//  Created by ToKoRo on 2017-08-26.
//

import UIKit
import HomeKit

class RoomViewController: UITableViewController, ContextHandler {
    typealias ContextType = HMRoom

    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var uniqueIdentifierLabel: UILabel?
    @IBOutlet weak var zoneLabel: UILabel?
    @IBOutlet weak var accessoriesCountLabel: UILabel?

    var room: HMRoom { return context! }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setToolbarHidden(false, animated: true)

        refresh()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "Accessory"?:
            sendContext(room, to: segue.destination)
        case "Zone"?:
            sendContext(room.zone, to: segue.destination)
        default:
            break
        }
    }

    private func refresh() {
        nameLabel?.text = room.name
        uniqueIdentifierLabel?.text = room.uniqueIdentifier.uuidString

        zoneLabel?.text = room.zone?.name
        accessoriesCountLabel?.text = String(room.accessories.count)
    }

    private func updateName() {
        let room = self.room

        let alert = UIAlertController(title: nil, message: "Roomの名前を入力してください", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = room.name
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard
                let name = alert.textFields?.first?.text,
                name.count > 0
            else {
                return
            }
            self?.handleNewRoomName(name)
        })
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel))
        present(alert, animated: true)
    }

    private func handleNewRoomName(_ name: String) {
        room.updateName(name) { [weak self] error in
            if let error = error {
                print("# error: \(error)")
            }
            self?.refresh()
        }
    }
}

// MARK: - Actions

extension RoomViewController {
    @IBAction func removeButtonDidTap(sender: AnyObject) {
        ResponderChain(from: self).send(room, protocol: RoomActionHandler.self) { [weak self] room, handler in
            handler.handleRemove(room)

            DispatchQueue.main.async {
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
}

// MARK: - UITableViewDelegate

extension RoomViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer { tableView.deselectRow(at: indexPath, animated: true) }

        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            // name
            updateName()
        case (1, 0):
            // zone
            guard room.zone != nil else {
                return
            }
            performSegue(withIdentifier: "Zone", sender: nil)
        default:
            break
        }
    }
}
