//
//  KeyboardDelegate.swift
//  eksamen
//
//  Created by Sander Ulset on 08/11/2021.
//

import UIKit

class KeyboardDelegate: NSObject, UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Enter key collapses the keyboard.
        textField.resignFirstResponder()
        return true
    }
}
