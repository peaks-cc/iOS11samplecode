//
//  DatePickerController.swift
//
//  Created by ToKoRo on 2017-09-03.
//

import UIKit

class DatePickerController: UITableViewController, ContextHandler, HasCallback {
    typealias ContextType = Date
    typealias CallbackType = Date

    @IBOutlet weak var datePicker: UIDatePicker?

    var defaultDate: Date? { return context }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let defaultDate = defaultDate {
            datePicker?.date = defaultDate
        }
    }

    @IBAction func okButtonDidTap(sender: AnyObject) {
        ok()
    }

    @IBAction func cancelButtonDidTap(sender: AnyObject) {
        cancel()
    }
}

// MARK: - Private

private extension DatePickerController {
    func ok() {
        guard let date = datePicker?.date else {
            dismiss(animated: true)
            return
        }

        callback?(date)

        dismiss(animated: true)
    }

    func cancel() {
        dismiss(animated: true)
    }
}
