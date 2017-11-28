//
//  ZonesViewController.swift
//
//  Created by ToKoRo on 2017-08-27.
//

import UIKit
import HomeKit

class ZonesViewController: UITableViewController, ContextHandler {
    typealias ContextType = HMHome

    var home: HMHome { return context! }
    var zones: [HMZone] { return home.zones }

    var selectedZone: HMZone?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        refresh()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "Zone"?:
            sendContext(selectedZone, to: segue.destination)
        default:
            break
        }
    }

    func refresh() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func zone(at indexPath: IndexPath) -> HMZone? {
        return zones.safe[indexPath.row]
    }

    @IBAction func addButtonDidTap(sender: AnyObject) {
        let alert = UIAlertController(title: nil, message: "追加するZoneの名前を入力してください", preferredStyle: .alert)
        alert.addTextField()
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
        home.addZone(withName: name) { [weak self] zone, error in
            if let zone = zone {
                print("# added zone: \(zone)")
            }
            if let error = error {
                print("# error: \(error)")
            }
            self?.refresh()
        }
    }
}

// MARK: - ZoneActionHandler

extension ZonesViewController: ZoneActionHandler {
    func handleRemove(_ zone: HMZone) {
        home.removeZone(zone) { [weak self] error in
            if let error = error {
                print("# error: \(error)")
            }
            self?.refresh()
        }
    }
}

// MARK: - UITableViewDataSource

extension ZonesViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return zones.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Zone", for: indexPath)
        if let zone = zone(at: indexPath) {
            cell.textLabel?.text = zone.name
        }
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ZonesViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer { tableView.deselectRow(at: indexPath, animated: true) }

        self.selectedZone = zone(at: indexPath)

        performSegue(withIdentifier: "Zone", sender: nil)
    }
}
