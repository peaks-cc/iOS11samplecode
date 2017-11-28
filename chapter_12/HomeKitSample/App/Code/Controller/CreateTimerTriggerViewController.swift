//
//  CreateTimerTriggerViewController.swift
//
//  Created by ToKoRo on 2017-09-03.
//

import UIKit
import HomeKit

class CreateTimerTriggerViewController: CreateTriggerViewController {
    @IBOutlet weak var fireDatePicker: UIDatePicker?

    lazy var calendar: Calendar = Calendar(identifier: .gregorian)

    var newFireDate: Date? {
        guard let date = fireDatePicker?.date else {
            return nil
        }

        let comp = calendar.dateComponents([.minute, .hour, .day, .month, .year, .era], from: date)
        let fireDate = calendar.date(from: comp)
        return fireDate
    }

    var newTimeZone: TimeZone? {
        return fireDatePicker?.timeZone
    }

    override func createTrigger() -> HMTrigger? {
        guard
            let name = newName,
            let fireDate = newFireDate
        else {
            return nil
        }

        return HMTimerTrigger(
            name: name,
            fireDate: fireDate,
            timeZone: newTimeZone,
            recurrence: nil,
            recurrenceCalendar: nil
        )
    }
}
