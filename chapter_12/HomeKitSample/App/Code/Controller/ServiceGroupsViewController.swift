//
//  ServiceGroupsViewController.swift
//
//  Created by ToKoRo on 2017-09-02.
//

import UIKit
import HomeKit

class ServiceGroupsViewController: UITableViewController, ContextHandler {
    typealias ContextType = HMHome

    var home: HMHome { return context! }
    var serviceGroups: [HMServiceGroup] { return home.serviceGroups }

    var selectedServiceGroup: HMServiceGroup?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        refresh()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ServiceGroup"?:
            sendContext(selectedServiceGroup, to: segue.destination)
        default:
            break
        }
    }

    func refresh() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func serviceGroup(at indexPath: IndexPath) -> HMServiceGroup? {
        return serviceGroups.safe[indexPath.row]
    }

    @IBAction func addButtonDidTap(sender: AnyObject) {
        displayNewServiceGroupAlert()
    }

    private func displayNewServiceGroupAlert() {
        let alert = UIAlertController(title: nil, message: "追加するServiceGroupの名前を入力してください", preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard
                let name = alert.textFields?.first?.text,
                name.count > 0
            else {
                return
            }
            self?.handleNewServiceGroupName(name)
        })
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel))
        present(alert, animated: true)
    }

    private func handleNewServiceGroupName(_ name: String) {
        home.addServiceGroup(withName: name) { [weak self] serviceGroup, error in
            if let serviceGroup = serviceGroup {
                print("# added serviceGroup: \(serviceGroup)")
            }
            if let error = error {
                print("# error: \(error)")
            }
            self?.refresh()
        }
    }
}

// MARK: - UITableViewDataSource

extension ServiceGroupsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serviceGroups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceGroup", for: indexPath)
        if let serviceGroup = serviceGroup(at: indexPath) {
            cell.textLabel?.text = serviceGroup.name
            cell.detailTextLabel?.text = String(serviceGroup.services.count)
        }
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ServiceGroupsViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer { tableView.deselectRow(at: indexPath, animated: true) }

        self.selectedServiceGroup = serviceGroup(at: indexPath)

        performSegue(withIdentifier: "ServiceGroup", sender: nil)
    }
}

// MARK: - ServiceGroupActionHandler

extension ServiceGroupsViewController: ServiceGroupActionHandler {
    func handleRemove(_ serviceGroup: HMServiceGroup) {
        home.removeServiceGroup(serviceGroup) { [weak self] error in
            if let error = error {
                print("# error: \(error)")
            }
            self?.refresh()
        }
    }
}
