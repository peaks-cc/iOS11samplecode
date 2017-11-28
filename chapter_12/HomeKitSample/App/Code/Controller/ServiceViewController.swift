//
//  ServiceViewController.swift
//
//  Created by ToKoRo on 2017-08-21.
//

import UIKit
import HomeKit

class ServiceViewController: UITableViewController, ContextHandler {
    typealias ContextType = (service: HMService, store: ServiceStore)

    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var uniqueIdentifierLabel: UILabel?
    @IBOutlet weak var serviceTypeLabel: UILabel?
    @IBOutlet weak var associatedServiceTypeLabel: UILabel?
    @IBOutlet weak var isPrimaryServiceLabel: UILabel?
    @IBOutlet weak var isUserInteractiveLabel: UILabel?
    @IBOutlet weak var localizedDescriptionLabel: UILabel?
    @IBOutlet weak var characteristicsCountLabel: UILabel?
    @IBOutlet weak var linkedServicesCountLabel: UILabel?

    var service: HMService { return context!.service }
    var store: ServiceStore { return context!.store }

    override func viewDidLoad() {
        super.viewDidLoad()

        refresh()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setToolbarHidden(false, animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if !store.isServiceRemovable {
            navigationController?.toolbar.items?.forEach { item in
                item.isEnabled = false
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "Characteristic"?:
            sendContext(service, to: segue.destination)
        default:
            break
        }
    }

    private func refresh() {
        nameLabel?.text = service.name
        uniqueIdentifierLabel?.text = service.uniqueIdentifier.uuidString
        serviceTypeLabel?.text = ServiceType(typeString: service.serviceType).description
        print("# serviceType: \(service.serviceType)")
        associatedServiceTypeLabel?.text = {
            guard let serviceType = service.associatedServiceType else {
                return nil
            }
            return ServiceType(typeString: serviceType).description
        }()
        isPrimaryServiceLabel?.text = String(service.isPrimaryService)
        isUserInteractiveLabel?.text = String(service.isUserInteractive)
        localizedDescriptionLabel?.text = service.localizedDescription

        characteristicsCountLabel?.text = String(service.characteristics.count)
        linkedServicesCountLabel?.text = String(service.linkedServices?.count ?? 0)
    }

    private func updateName() {
        let alert = UIAlertController(title: nil, message: "Serviceの名前を入力してください", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = self.service.name
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard
                let name = alert.textFields?.first?.text,
                name.count > 0
            else {
                return
            }
            self?.handleNewServiceName(name)
        })
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel))
        present(alert, animated: true)
    }

    private func handleNewServiceName(_ name: String) {
        service.updateName(name) { [weak self] error in
            if let error = error {
                print("# error: \(error)")
            }
            self?.refresh()
        }
    }
}

// MARK: - Actions

extension ServiceViewController {
    @IBAction func removeButtonDidTap(sender: AnyObject) {
        ResponderChain(from: self).send(service, protocol: ServiceActionHandler.self) { [weak self] service, handler in
            handler.handleRemove(service)

            DispatchQueue.main.async {
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
}

// MARK: - UITableViewDelegate

extension ServiceViewController {
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
