//
//  EditPersonViewController.swift
//  eksamen
//
//  Created by Sander Ulset on 29/10/2021.
//

import UIKit

class EditPersonViewController: UIViewController {
    var person: Person?
    let personController = (UIApplication.shared.delegate as! AppDelegate).personController
    let keyboardDelegate = KeyboardDelegate()
    
    @IBOutlet weak var firstNameInput: UITextField!
    @IBOutlet weak var lastNameInput: UITextField!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var cityInput: UITextField!
    @IBOutlet weak var dobInput: UIDatePicker!
    @IBOutlet weak var teleInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameInput.text = person?.name.first
        lastNameInput.text = person?.name.last
        emailInput.text = person?.email
        cityInput.text = person?.location.city
        dobInput.date = person?.dob.getDateObject() ?? Date()
        teleInput.text = person?.phone
        
        // Close the keyboard when pressing enter
        firstNameInput.delegate = self.keyboardDelegate
        lastNameInput.delegate = self.keyboardDelegate
        emailInput.delegate = self.keyboardDelegate
        cityInput.delegate = self.keyboardDelegate
        teleInput.delegate = self.keyboardDelegate
        
    }
    @IBAction func pressedSave(_ sender: UIButton) {
        self.person?.name.first = firstNameInput.text ?? ""
        self.person?.name.last = lastNameInput.text ?? ""
        self.person?.email = emailInput.text ?? ""
        self.person?.location.city = cityInput.text ?? ""
        self.person?.phone = teleInput.text ?? ""
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "yyyy-MM-dd"
        let Newdate = dobInput.date
        let formatted = dateFormatterPrint.string(from: Newdate)
        self.person?.dob.date = formatted
        
        self.personController.updatePerson(person: self.person!)
        self.dismiss(animated: true, completion: nil)
    }
}
