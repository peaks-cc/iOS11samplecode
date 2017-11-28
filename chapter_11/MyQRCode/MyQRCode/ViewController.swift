//
//  ViewController.swift
//  MyQRCode
//
//  Created by Kishikawa Katsumi on 2017/09/04.
//  Copyright © 2017 Kishikawa Katsumi. All rights reserved.
//

import UIKit
import MyQRCodeKit

class ViewController: UITableViewController, UITextFieldDelegate {
    @IBOutlet private weak var firstnameTextField: UITextField!
    @IBOutlet private weak var lastnameTextField: UITextField!
    @IBOutlet private weak var companyTextField: UITextField!
    @IBOutlet private weak var streetTextField: UITextField!
    @IBOutlet private weak var cityTextField: UITextField!
    @IBOutlet private weak var zipcodeTextField: UITextField!
    @IBOutlet private weak var countryTextField: UITextField!
    @IBOutlet private weak var phoneTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var websiteTextField: UITextField!
    @IBOutlet private weak var birthdayTextField: UITextField!

    @IBOutlet weak var showVisualCodeButton: UIBarButtonItem!

    private let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        birthdayTextField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)

        if let me = Repository.shared.load() {
            firstnameTextField.text = me.firstname
            lastnameTextField.text = me.lastname
            companyTextField.text = me.company
            streetTextField.text = me.street
            cityTextField.text = me.city
            zipcodeTextField.text = me.zipcode
            countryTextField.text = me.country
            phoneTextField.text = me.phone
            emailTextField.text = me.email
            websiteTextField.text = me.website
            birthdayTextField.text = me.birthday
            if let birthday = me.birthday, let date = dateFormatter.date(from: birthday) {
                datePicker.date = date
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navigationController = segue.destination as? UINavigationController,
            let controller = navigationController.topViewController as? VisualCodeViewController {
            if let me = Repository.shared.load(), let image = me.generateVisualCode() {
                controller.visualCodeImage = image
            }
        }
    }

    @objc
    func datePickerValueChanged(_ sender: UIDatePicker) {
        birthdayTextField.text = dateFormatter.string(from: sender.date)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return textField != birthdayTextField
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstnameTextField {
            lastnameTextField.becomeFirstResponder()
        }
        if textField == lastnameTextField {
            companyTextField.becomeFirstResponder()
        }
        if textField == companyTextField {
            streetTextField.becomeFirstResponder()
        }
        if textField == streetTextField {
            cityTextField.becomeFirstResponder()
        }
        if textField == cityTextField {
            zipcodeTextField.becomeFirstResponder()
        }
        if textField == zipcodeTextField {
            countryTextField.becomeFirstResponder()
        }
        if textField == countryTextField {
            phoneTextField.becomeFirstResponder()
        }
        if textField == phoneTextField {
            emailTextField.becomeFirstResponder()
        }
        if textField == emailTextField {
            websiteTextField.becomeFirstResponder()
        }
        if textField == websiteTextField {
            birthdayTextField.becomeFirstResponder()
        }
        if textField == birthdayTextField {
            textField.resignFirstResponder()
        }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        let me = Me(firstname: firstnameTextField.text, lastname: lastnameTextField.text, company: companyTextField.text,
                    street: streetTextField.text, city: cityTextField.text, zipcode: zipcodeTextField.text, country: countryTextField.text,
                    phone: phoneTextField.text, email: emailTextField.text, website: websiteTextField.text,
                    birthday: birthdayTextField.text)
        Repository.shared.save(me: me)
    }
}
