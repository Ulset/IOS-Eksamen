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
    @IBOutlet weak var seedInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        if let storedSeed = defaults.string(forKey: "seed"){
            seedInput.text = storedSeed
        }else {
            defaults.set("ios", forKey: "seed")
            seedInput.text = "ios"
        }
    }
    
    @IBAction func setSeed(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        defaults.set(String(seedInput.text!), forKey: "seed")
        
        personController.deleteEverything()
        personController.refreshPersonsFromApi()
        let alert = UIAlertController(title: "Alert", message: "Refreshet fra API, med ny seed.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Nice!", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func deleteFunc(_ sender: UIButton) {
        personController.deleteEverything()
    }
    
    @IBAction func getNew(_ sender: UIButton) {
        personController.refreshPersonsFromApi()
    }
}
