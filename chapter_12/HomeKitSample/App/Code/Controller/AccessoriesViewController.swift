//
//  AccessoriesViewController.swift
//
//  Created by ToKoRo on 2017-08-21.
//

import UIKit
import HomeKit

class AccessoriesViewController: UITableViewController, ContextHandler {
    typealias ContextType = AccessoryStore

    @IBInspectable var isSelectMode: Bool = false

    var store: AccessoryStore { return context! }
    var accessories: [HMAccessory] { return store.accessories }

    var selectedAccessory: HMAccessory?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        refresh()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "Accessory"?:
            sendContext(selectedAccessory, to: segue.destination)
        case "SelectAccessory"?:
            let context: AccessoryStore = {
                switch store.accessoryStoreKind {
                case .home(let home):
                    return home
                case .room(let room):
                    return room.home ?? room
                case .identifiers(let identifiers):
                    return identifiers
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

    func accessory(at indexPath: IndexPath) -> HMAccessory? {
        return accessories.safe[indexPath.row]
    }

    @IBAction func addButtonDidTap(sender: AnyObject) {
        switch store.accessoryStoreKind {
        case .home(let home):
            home.addAndSetupAccessories { [weak self] error in
                if let error = error {
                    print("# error: \(error)")
                }
                self?.refresh()
            }
        case .room:
            performSegue(withIdentifier: "SelectAccessory", sender: nil)
        case .identifiers:
            break
        }
    }

    @IBAction func cancelButtonDidTap(sender: AnyObject) {
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDataSource

extension AccessoriesViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accessories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Accessory", for: indexPath)
        if let accessory = accessory(at: indexPath) {
            cell.textLabel?.text = accessory.name
            cell.detailTextLabel?.text = accessory.model
        }
        return cell
    }
}

// MARK: - UITableViewDelegate

extension AccessoriesViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer { tableView.deselectRow(at: indexPath, animated: true) }

        self.selectedAccessory = accessory(at: indexPath)

        if isSelectMode, let accessory = selectedAccessory {
            ResponderChain(from: self).send(accessory, protocol: AccessorySelector.self) { accessory, handler in
                handler.selectAccessory(accessory)
            }
            dismiss(animated: true)
        } else {
            performSegue(withIdentifier: "Accessory", sender: nil)
        }
    }
}

// MARK: - AccessorySelector

extension AccessoriesViewController: AccessorySelector {
    func selectAccessory(_ accessory: HMAccessory) {
        guard
            case .room(let room) = store.accessoryStoreKind,
            let home = room.home
        else {
            return
        }

        home.assignAccessory(accessory, to: room) { [weak self] error in
            if let error = error {
                print("# error: \(error)")
            }
            self?.refresh()
        }
    }
}

// MARK: - AccessoryActionHandler

extension AccessoriesViewController: AccessoryActionHandler {
    func handleRemove(_ accessory: HMAccessory) {
        switch store.accessoryStoreKind {
        case .home(let home):
            home.removeAccessory(accessory) { [weak self] error in
                if let error = error {
                    print("# error: \(error)")
                }
                self?.refresh()
            }
        case .room(let room):
            guard let home = room.home else {
                return
            }
            home.assignAccessory(accessory, to: home.roomForEntireHome()) { [weak self] error in
                if let error = error {
                    print("# error: \(error)")
                }
                self?.refresh()
            }
        case .identifiers:
            break
        }
    }
}
