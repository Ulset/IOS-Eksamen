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
        
        personController.deleteEverything(onlyNonChanged: true, markAsDeleted: false)
        personController.refreshPersonsFromApi()
        let alert = UIAlertController(title: "Alert", message: "Slettet uendrede, lagt til 100 nye (minus de som er markert som tidligere slettet)", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Nice!", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func deleteFunc(_ sender: UIButton) {
        let alert = UIAlertController(title: "Slette", message: "Vil du slette alle, eller bare de som ikke er endret?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Alle", style: UIAlertAction.Style.default, handler: {_ in
            self.personController.deleteEverything(onlyNonChanged: false)
        }))
        alert.addAction(UIAlertAction(title: "Bare uendret", style: UIAlertAction.Style.default, handler: {_ in
            self.personController.deleteEverything()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func getNew(_ sender: UIButton) {
        let alert = UIAlertController(title: "Hente brukere", message: "Vil du hente alt fra API, eller bare brukere som ikke har vært slettet før?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Alt", style: UIAlertAction.Style.default, handler: {_ in
            self.personController.refreshPersonsFromApi(onlyFetchNew: false)
        }))
        alert.addAction(UIAlertAction(title: "Bare ikke slettede", style: UIAlertAction.Style.default, handler: {_ in
            self.personController.refreshPersonsFromApi(onlyFetchNew: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func refreshDeletedList(_ sender: UIButton) {
        let alert = UIAlertController(title: "Refreshe slettede personer", message: "Dette vil fjerne 'tidligere slettet' markering på alle som er tidligere slettet, sikker?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ja", style: UIAlertAction.Style.default, handler: {_ in
            self.personController.resetDeletedList()
        }))
        alert.addAction(UIAlertAction(title: "Nei", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
