//
//  ServiceGroupViewController.swift
//
//  Created by ToKoRo on 2017-09-02.
//

import UIKit
import HomeKit

class ServiceGroupViewController: UITableViewController, ContextHandler {
    typealias ContextType = HMServiceGroup

    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var uniqueIdentifierLabel: UILabel?
    @IBOutlet weak var servicesCountLabel: UILabel?

    var serviceGroup: HMServiceGroup { return context! }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setToolbarHidden(false, animated: true)

        refresh()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "Service"?:
            sendContext(serviceGroup, to: segue.destination)
        default:
            break
        }
    }

    private func refresh() {
        nameLabel?.text = serviceGroup.name
        uniqueIdentifierLabel?.text = serviceGroup.uniqueIdentifier.uuidString

        servicesCountLabel?.text = String(serviceGroup.services.count)
    }

    private func updateName() {
        let serviceGroup = self.serviceGroup

        let alert = UIAlertController(title: nil, message: "ServiceGroupの名前を入力してください", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = serviceGroup.name
        }
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
        serviceGroup.updateName(name) { [weak self] error in
            if let error = error {
                print("# error: \(error)")
            }
            self?.refresh()
        }
    }
}

// MARK: - Actions

extension ServiceGroupViewController {
    @IBAction func removeButtonDidTap(sender: AnyObject) {
        ResponderChain(from: self).send(serviceGroup, protocol: ServiceGroupActionHandler.self) { [weak self] serviceGroup, handler in
            handler.handleRemove(serviceGroup)

            DispatchQueue.main.async {
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
}

// MARK: - UITableViewDelegate

extension ServiceGroupViewController {
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
