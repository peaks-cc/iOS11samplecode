//
//  EventTriggerViewController.swift
//
//  Created by ToKoRo on 2017-09-03.
//

import UIKit
import HomeKit

class EventTriggerViewController: TriggerViewController {
    @IBOutlet weak var eventCountLabel: UILabel?
    @IBOutlet weak var predicateLabel: UILabel?
    @IBOutlet weak var endEventCountLabel: UILabel?
    @IBOutlet weak var executeOnceLabel: UILabel?
    @IBOutlet weak var recurrencesCountLabel: UILabel?
    @IBOutlet weak var triggerActivationStateLabel: UILabel?

    var eventTrigger: HMEventTrigger { return (trigger as? HMEventTrigger)! }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "Event"?:
            sendContext(eventTrigger.events, to: segue.destination)
        case "EndEvent"?:
            sendContext(eventTrigger.endEvents, to: segue.destination)
        default:
            super.prepare(for: segue, sender: sender)
        }
    }

    override func refresh() {
        super.refresh()

        eventCountLabel?.text = String(eventTrigger.events.count)
        predicateLabel?.text = {
            guard let predicate = eventTrigger.predicate else {
                return "nil"
            }
            return String(describing: predicate)
        }()
        endEventCountLabel?.text = String(eventTrigger.endEvents.count)
        executeOnceLabel?.text = String(eventTrigger.executeOnce)
        recurrencesCountLabel?.text = String(eventTrigger.recurrences?.count ?? 0)
        triggerActivationStateLabel?.text = String(describing: eventTrigger.triggerActivationState)
    }
}
