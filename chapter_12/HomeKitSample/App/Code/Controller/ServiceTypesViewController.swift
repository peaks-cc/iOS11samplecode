//
//  ServiceTypesViewController.swift
//
//  Created by ToKoRo on 2017-08-27.
//

import UIKit
import HomeKit

class ServiceTypesViewController: UITableViewController {
    lazy var home: HMHome? = HMHomeManager.shared.primaryHome
    lazy var serviceTypes: [ServiceType] = ServiceType.all

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        refresh()
    }

    func refresh() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func serviceType(at indexPath: IndexPath) -> ServiceType? {
        return serviceTypes.safe[indexPath.row]
    }

    func service(for serviceType: ServiceType) -> HMService? {
        guard let typeString = serviceType.typeString else {
            return nil
        }
        return home?.servicesWithTypes([typeString])?.first
    }
}

// MARK: - UITableViewDataSource

extension ServiceTypesViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serviceTypes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceType", for: indexPath)
        if let serviceType = serviceType(at: indexPath) {
            cell.textLabel?.text = serviceType.description
            cell.detailTextLabel?.text = service(for: serviceType)?.localizedDescription
        }
        return cell
    }
}
