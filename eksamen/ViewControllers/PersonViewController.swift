//
//  PersonViewController.swift
//  eksamen
//
//  Created by Sander Ulset on 25/10/2021.
//

import UIKit

class PersonViewController: UIViewController {
    var person: Person?
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var birthdateLabel: UILabel!
    @IBOutlet weak var alderLabel: UILabel!
    @IBOutlet weak var bostedLabel: UILabel!
    
    let personController = (UIApplication.shared.delegate as! AppDelegate).personController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let firstname = person?.name.first
        let lastname = person?.name.last
        self.title = "\(firstname!) \(lastname!)"
        emailLabel.text = person?.email
        birthdateLabel.text = person?.dob.getDateFormatted(format: "dd-MM-yyyy")
        alderLabel.text = String(person?.dob.age ?? 0)
        bostedLabel.text = person?.location.city
        if(person!.dob.hasBirthdayThisWeek()){
            //TODO Lage bursdagsgreia
            print("Har bursdag!")
        }
        
        DispatchQueue.global().async {
            if let pictureUrl = self.person?.picture.large {
                ApiHandler.getImageFromURL(url: pictureUrl, finished: {image in
                    self.profilePicture.image = image
                })
            }
        }
    }
    
    func refreshPersonData(){
        let uuid = self.person!.login.uuid!
        if let newPerson = personController.getPersonByUUID(uuid: uuid){
            // If person currently exists (not deleted) refresh content
            self.person = newPerson
            self.viewDidLoad()
        }else{
            //Else return to the last vievcontroller in the stack
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func changeUser(_ sender: UIButton) {
        self.person?.name.first = "TISSEMANN HEHE"
        self.person?.dob.date = "2005-01-01"
        personController.updatePerson(person: self.person!)
    }
    @IBAction func showOnMapPressed(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "map") as! MapViewController
        vc.focusOnPerson = person
        
        navigationController?.present(vc, animated: true, completion: nil)
    }
}
