//
//  ProfilesViewController.swift
//
//  Created by ToKoRo on 2017-09-12.
//

import UIKit
import HomeKit

class ProfilesViewController: UITableViewController, ContextHandler {
    typealias ContextType = [HMAccessoryProfile]

    var profiles: [HMAccessoryProfile] { return context! }

    var selectedProfile: HMAccessoryProfile?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        refresh()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "CameraProfile"?:
            sendContext(selectedProfile, to: segue.destination)
        default:
            break
        }
    }

    func refresh() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func profile(at indexPath: IndexPath) -> HMAccessoryProfile? {
        return profiles.safe[indexPath.row]
    }
}

// MARK: - UITableViewDataSource

extension ProfilesViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profiles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Profile", for: indexPath)
        if let profile = profile(at: indexPath) {
            cell.textLabel?.text = String(describing: type(of: profile))
            switch profile {
            case is HMCameraProfile:
                cell.accessoryType = .disclosureIndicator
            default:
                cell.accessoryType = .none
            }
        }
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ProfilesViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer { tableView.deselectRow(at: indexPath, animated: true) }

        self.selectedProfile = profile(at: indexPath)

        switch selectedProfile {
        case is HMCameraProfile:
            performSegue(withIdentifier: "CameraProfile", sender: nil)
        default:
            break
        }
    }
}
