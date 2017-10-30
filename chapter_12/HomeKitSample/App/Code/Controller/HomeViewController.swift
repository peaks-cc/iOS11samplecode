//
//  HomeViewController.swift
//
//  Created by ToKoRo on 2017-08-20.
//

import UIKit
import HomeKit

class HomeViewController: UITableViewController, ContextHandler {
    typealias ContextType = HMHome

    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var uniqueIdentifierLabel: UILabel?
    @IBOutlet weak var isPrimaryLabel: UILabel?
    @IBOutlet weak var homeHubStateLabel: UILabel?
    @IBOutlet weak var accessoriesCountLabel: UILabel?
    @IBOutlet weak var roomsCountLabel: UILabel?
    @IBOutlet weak var zonesCountLabel: UILabel?
    @IBOutlet weak var serviceGroupsCountLabel: UILabel?
    @IBOutlet weak var actionSetsCountLabel: UILabel?
    @IBOutlet weak var triggersCountLabel: UILabel?
    @IBOutlet weak var userNameLabel: UILabel?
    @IBOutlet weak var userIdentifierLabel: UILabel?
    @IBOutlet weak var isAdministratorLabel: UILabel?

    var home: HMHome { return context! }

    override func viewDidLoad() {
        super.viewDidLoad()

        home.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setToolbarHidden(false, animated: true)

        refresh()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "Accessory"?:
            sendContext(home, to: segue.destination)
        case "RoomForEntireHome"?:
            sendContext(home.roomForEntireHome(), to: segue.destination)
        case "Room"?:
            sendContext(home, to: segue.destination)
        case "Zone"?:
            sendContext(home, to: segue.destination)
        case "ServiceGroup"?:
            sendContext(home, to: segue.destination)
        case "ActionSet"?:
            sendContext(home, to: segue.destination)
        case "Trigger"?:
            sendContext(home, to: segue.destination)
        default:
            break
        }
    }

    private func refresh() {
        nameLabel?.text = home.name
        uniqueIdentifierLabel?.text = home.uniqueIdentifier.uuidString
        isPrimaryLabel?.text = String(home.isPrimary)
        homeHubStateLabel?.text = String(describing: home.homeHubState)

        accessoriesCountLabel?.text = String(home.accessories.count)
        roomsCountLabel?.text = String(home.rooms.count)
        zonesCountLabel?.text = String(home.zones.count)
        serviceGroupsCountLabel?.text = String(home.serviceGroups.count)
        actionSetsCountLabel?.text = String(home.actionSets.count)
        triggersCountLabel?.text = String(home.triggers.count)

        let user = home.currentUser
        userNameLabel?.text = user.name
        userIdentifierLabel?.text = user.uniqueIdentifier.uuidString
        isAdministratorLabel?.text = String(home.homeAccessControl(for: user).isAdministrator)
    }

    private func updateName() {
        let home = self.home

        let alert = UIAlertController(title: nil, message: "Homeの名前を入力してください", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = home.name
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard
                let name = alert.textFields?.first?.text,
                name.count > 0
            else {
                return
            }
            self?.handleNewHomeName(name)
        })
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel))
        present(alert, animated: true)
    }

    private func handleNewHomeName(_ name: String) {
        home.updateName(name) { [weak self] error in
            if let error = error {
                print("# error: \(error)")
            }
            self?.refresh()
        }
    }

    private func manageUsers() {
        home.manageUsers { [weak self] error in
            if let error = error {
                print("# error: \(error)")
            }
            self?.refresh()
        }
    }
}

// MARK: - Actions

extension HomeViewController {
    @IBAction func removeButtonDidTap(sender: AnyObject) {
        ResponderChain(from: self).send(home, protocol: HomeActionHandler.self) { [weak self] home, handler in
            handler.handleRemove(home)

            DispatchQueue.main.async {
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }

    @IBAction func primaryButtonDidTap(sender: AnyObject) {
        ResponderChain(from: self).send(home, protocol: HomeActionHandler.self) { [weak self] home, handler in
            handler.handleMakePrimary(home)

            DispatchQueue.main.async {
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
}

// MARK: - UITableViewDelegate

extension HomeViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer { tableView.deselectRow(at: indexPath, animated: true) }

        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            // name
            updateName()
        case (2, 3):
            // manageUsers
            manageUsers()
        default:
            break
        }
    }
}

// MARK: - HMHomeDelegate

extension HomeViewController: HMHomeDelegate {
}
