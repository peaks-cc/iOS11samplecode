//
//  EventViewController.swift
//
//  Created by ToKoRo on 2017-09-04.
//

import UIKit
import HomeKit

class EventViewController: UITableViewController, ContextHandler {
    typealias ContextType = HMEvent

    @IBOutlet weak var uniqueIdentifierLabel: UILabel?
    @IBOutlet weak var typeLabel: UILabel?

    var event: HMEvent { return context! }

    override func viewDidLoad() {
        super.viewDidLoad()

        refresh()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ActionSet"?:
            sendContext(event, to: segue.destination)
        default:
            break
        }
    }

    func refresh() {
        uniqueIdentifierLabel?.text = event.uniqueIdentifier.uuidString
        typeLabel?.text = String(describing: type(of: event))
    }
}
