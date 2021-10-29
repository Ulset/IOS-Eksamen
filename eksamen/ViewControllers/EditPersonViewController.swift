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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
