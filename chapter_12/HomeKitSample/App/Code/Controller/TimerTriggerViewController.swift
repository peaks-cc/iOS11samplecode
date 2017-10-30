//
//  TimerTriggerViewController.swift
//
//  Created by ToKoRo on 2017-09-03.
//

import UIKit
import HomeKit

class TimerTriggerViewController: TriggerViewController {
    @IBOutlet weak var fireDateLabel: UILabel?
    @IBOutlet weak var timeZoneLabel: UILabel?
    @IBOutlet weak var recurrenceLabel: UILabel?
    @IBOutlet weak var recurrenceCalendarLabel: UILabel?

    var timerTrigger: HMTimerTrigger { return (trigger as? HMTimerTrigger)! }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "DatePicker"?:
            sendContext(timerTrigger.fireDate, to: segue.destination)
            bindCallback(type: Date.self, to: segue.destination) { [weak self] date in
                self?.handleNewFireDate(date)
            }
        default:
            super.prepare(for: segue, sender: sender)
        }
    }

    override func refresh() {
        super.refresh()

        fireDateLabel?.text = DateFormatter.localizedString(from: timerTrigger.fireDate, dateStyle: .short, timeStyle: .short)

        timeZoneLabel?.text = {
            guard let timeZone = timerTrigger.timeZone else {
                return nil
            }
            return String(describing: timeZone)
        }()

        recurrenceLabel?.text = {
            guard let components = timerTrigger.recurrence else {
                return nil
            }
            return String(describing: components)
        }()

        recurrenceCalendarLabel?.text = {
            guard let calendar = timerTrigger.recurrenceCalendar else {
                return nil
            }
            return String(describing: calendar)
        }()
    }

    private func displayFireDateAlert() {
        performSegue(withIdentifier: "DatePicker", sender: nil)
    }

    private func handleNewFireDate(_ date: Date) {
        timerTrigger.updateFireDate(date) { [weak self] error in
            if let error = error {
                print("# error: \(error)")
            }
            self?.refresh()
        }
    }

}

// MARK: - UITableViewDelegate

extension TimerTriggerViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)

        switch (indexPath.section, indexPath.row) {
        case (1, 0):
            // fireDate
            displayFireDateAlert()
        default:
            break
        }
    }
}
