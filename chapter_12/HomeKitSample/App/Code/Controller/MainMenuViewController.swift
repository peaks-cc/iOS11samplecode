//
//  MainMenuViewController.swift
//
//  Created by ToKoRo on 2017-08-27.
//

import UIKit
import HomeKit

class MainMenuViewController: UITableViewController {
    lazy var homeManager: HMHomeManager = HMHomeManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        print("# homeManager: \(homeManager)")
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "PrimaryHome"?:
            sendContext(homeManager.primaryHome, to: segue.destination)
        default:
            break
        }
    }
}
