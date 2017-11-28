//
//  CharacteristicMetadataUnitsViewController.swift
//
//  Created by ToKoRo on 2017-08-29.
//

import UIKit
import HomeKit

class CharacteristicMetadataUnitsViewController: UITableViewController {
    lazy var units: [CharacteristicMetadataUnits] = CharacteristicMetadataUnits.all

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        refresh()
    }

    func refresh() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func unit(at indexPath: IndexPath) -> CharacteristicMetadataUnits? {
        return units.safe[indexPath.row]
    }
}

// MARK: - UITableViewDataSource

extension CharacteristicMetadataUnitsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return units.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacteristicMetadataUnits", for: indexPath)
        if let unit = unit(at: indexPath) {
            cell.textLabel?.text = unit.description
        }
        return cell
    }
}
