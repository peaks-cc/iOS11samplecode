//
//  CharacteristicMetadataFormatsViewController.swift
//
//  Created by ToKoRo on 2017-08-28.
//

import UIKit
import HomeKit

class CharacteristicMetadataFormatsViewController: UITableViewController {
    lazy var formats: [CharacteristicMetadataFormat] = CharacteristicMetadataFormat.all

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        refresh()
    }

    func refresh() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func format(at indexPath: IndexPath) -> CharacteristicMetadataFormat? {
        return formats.safe[indexPath.row]
    }
}

// MARK: - UITableViewDataSource

extension CharacteristicMetadataFormatsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return formats.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacteristicMetadataFormat", for: indexPath)
        if let format = format(at: indexPath) {
            cell.textLabel?.text = format.description
        }
        return cell
    }
}
