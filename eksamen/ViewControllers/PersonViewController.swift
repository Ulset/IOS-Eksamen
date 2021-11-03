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
    @IBOutlet weak var telephoneLabel: UILabel!
    
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
        telephoneLabel.text = person?.phone
        if(person!.dob.hasBirthdayThisWeek()){
            print("har bursdag")
            self.rainCake()
        }
        
        for view in self.profilePicture.subviews {
            // If user was edited and now doesnt have birthday, remove subviews (cake) from profilepicture.
            view.removeFromSuperview()
        }
        
        DispatchQueue.global().async {
            if let pictureUrl = self.person?.picture.large {
                ApiHandler.getImageFromURL(url: pictureUrl, finished: {image in
                    self.profilePicture.image = image
                    if(self.person!.dob.hasBirthdayThisWeek()){
                        let imageHeigth = self.profilePicture.image?.size.height
                        let labelHeigth = 60.0
                        let bLabel = UILabel(frame: CGRect.init(x: 0, y: imageHeigth!-labelHeigth, width: self.profilePicture.frame.width, height: labelHeigth))
                        bLabel.text = "🎂"
                        bLabel.textAlignment = .right
                        bLabel.font = bLabel.font.withSize(60)
                        self.profilePicture.addSubview(bLabel)
                    }
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
    
    func rainCake(){
        let cakesAndStuff = ["🍰", "🧁", "🎂", "🎊", "🎉", "❤️", "🥰"]
        for _ in 0...80 {
            let randomXStartingPos = Double.random(in: 0.0...self.view.frame.width)
            let randomLength = Double.random(in: 5.0...11.0)
            let randomSize = Double.random(in: 10...60)
            let newLabel = UILabel.init(frame: CGRect(x: randomXStartingPos, y: -20, width: randomSize, height: randomSize))
            newLabel.text = cakesAndStuff[Int.random(in: 0...cakesAndStuff.count-1)]
            newLabel.font = newLabel.font.withSize(randomSize)
            self.view.addSubview(newLabel)
            UIView.animate(withDuration: Double(randomLength), animations: {
                newLabel.frame.origin.y = self.view.frame.height+20
            }, completion: {_ in
                newLabel.removeFromSuperview()
            })
        }
    }
    
    @IBAction func editUserPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "showEdit", sender: self)
    }
    
    @IBAction func deleteUserPressed(_ sender: UIButton) {
        self.personController.deletePerson(person: self.person!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! EditPersonViewController
        vc.person = self.person
    }
    
    @IBAction func showOnMapPressed(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "map") as! MapViewController
        vc.focusOnPerson = person
        
        navigationController?.present(vc, animated: true, completion: nil)
    }
}
