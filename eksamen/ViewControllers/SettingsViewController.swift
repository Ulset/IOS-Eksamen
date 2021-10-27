//
//  SettingsViewController.swift
//  eksamen
//
//  Created by Sander Ulset on 27/10/2021.
//

import UIKit
import CoreData

class SettingsViewController: UIViewController {
    let personController = (UIApplication.shared.delegate as! AppDelegate).personController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func deleteFunc(_ sender: UIButton) {
        personController.deleteEverything()
    }
    
    @IBAction func getNew(_ sender: UIButton) {
        personController.refreshPersonsFromApi()
    }
}
