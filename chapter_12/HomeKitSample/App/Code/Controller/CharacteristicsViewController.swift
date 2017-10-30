//
//  CharacteristicsViewController.swift
//
//  Created by ToKoRo on 2017-08-21.
//

import UIKit
import HomeKit

class CharacteristicsViewController: UITableViewController, ContextHandler {
    typealias ContextType = CharacteristicStore

    @IBInspectable var isSelectMode: Bool = false

    var store: CharacteristicStore { return context! }
    var characteristics: [HMCharacteristic] { return store.characteristics }

    var selectedCharacteristic: HMCharacteristic?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        refresh()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "Characteristic"?:
            sendContext(selectedCharacteristic, to: segue.destination)
        default:
            break
        }
    }

    func refresh() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func characteristic(at indexPath: IndexPath) -> HMCharacteristic? {
        return characteristics.safe[indexPath.row]
    }

    @IBAction func cancelButtonDidTap(sender: AnyObject) {
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDataSource

extension CharacteristicsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characteristics.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Characteristic", for: indexPath)
        if let characteristic = characteristic(at: indexPath) {
            cell.textLabel?.text = characteristic.localizedDescription
        }
        return cell
    }
}

// MARK: - UITableViewDelegate

extension CharacteristicsViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer { tableView.deselectRow(at: indexPath, animated: true) }

        self.selectedCharacteristic = characteristic(at: indexPath)

        if isSelectMode, let characteristic = selectedCharacteristic {
            ResponderChain(from: self).send(characteristic, protocol: CharacteristicSelector.self) { characteristic, handler in
                handler.selectCharacteristic(characteristic)
            }
            dismiss(animated: true)
        } else {
            performSegue(withIdentifier: "Characteristic", sender: nil)
        }
    }
}
