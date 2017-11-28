//
//  ServicesViewController.swift
//
//  Created by ToKoRo on 2017-08-21.
//

import UIKit
import HomeKit

class ServicesViewController: UITableViewController, ContextHandler {
    typealias ContextType = ServiceStore

    @IBInspectable var isSelectMode: Bool = false

    var store: ServiceStore { return context! }
    var services: [HMService] { return store.services }

    var selectedService: HMService?

    override func viewDidLoad() {
        super.viewDidLoad()

        if !isSelectMode && !store.isServiceAddable {
            navigationItem.rightBarButtonItem = nil
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        refresh()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "Service"?:
            sendContext((selectedService, store), to: segue.destination)
        case "SelectService"?:
            let context: ServiceStore = {
                switch store.serviceStoreKind {
                case .accessory(let accessory):
                    return accessory.home ?? accessory
                case .serviceGroup(let serviceGroup):
                    return serviceGroup.home ?? serviceGroup
                case .home(let home):
                    return home
                }
            }()
            sendContext(context, to: segue.destination)
        default:
            break
        }
    }

    func refresh() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func service(at indexPath: IndexPath) -> HMService? {
        return services.safe[indexPath.row]
    }

    @IBAction func addButtonDidTap(sender: AnyObject) {
        performSegue(withIdentifier: "SelectService", sender: nil)
    }

    @IBAction func cancelButtonDidTap(sender: AnyObject) {
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDataSource

extension ServicesViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return services.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Service", for: indexPath)
        if let service = service(at: indexPath) {
            cell.textLabel?.text = service.name
            cell.detailTextLabel?.text = service.localizedDescription
        }
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ServicesViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer { tableView.deselectRow(at: indexPath, animated: true) }

        self.selectedService = service(at: indexPath)

        if isSelectMode, let service = selectedService {
            ResponderChain(from: self).send(service, protocol: ServiceSelector.self) { service, handler in
                handler.selectService(service)
            }
            dismiss(animated: true)
        } else {
            performSegue(withIdentifier: "Service", sender: nil)
        }
    }
}

// MARK: - ServiceSelector

extension ServicesViewController: ServiceSelector {
    func selectService(_ service: HMService) {
        guard case .serviceGroup(let serviceGroup) = store.serviceStoreKind else {
            return
        }

        serviceGroup.addService(service) { [weak self] error in
            if let error = error {
                print("# error: \(error)")
            }
            self?.refresh()
        }
    }
}

// MARK: - ServiceActionHandler

extension ServicesViewController: ServiceActionHandler {
    func handleRemove(_ service: HMService) {
        guard case .serviceGroup(let serviceGroup) = store.serviceStoreKind else {
            return
        }

        serviceGroup.removeService(service) { [weak self] error in
            if let error = error {
                print("# error: \(error)")
            }
            self?.refresh()
        }
    }
}
