//
//  PersonsViewController.swift
//  eksamen
//
//  Created by Sander Ulset on 25/10/2021.
//

import UIKit
import CoreData

class PersonsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let personController = (UIApplication.shared.delegate as! AppDelegate).personController

    
    override func viewDidLoad() {
        super.viewDidLoad()
        personController.addUpdateFunction {
            self.tableView.reloadData()
        }
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension PersonsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = storyboard?.instantiateViewController(withIdentifier: "person") as! PersonViewController
        
        let personObj = personController.getPersons()[indexPath.row]
        let firstname = personObj.name.first
        let lastname = personObj.name.last
        vc.title = "\(firstname) \(lastname)"
        vc.person = personObj
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension PersonsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personController.getPersons().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath) as! PersonTableViewCell
        let personObj = personController.getPersons()[indexPath.row]
        let firstname = personObj.name.first as String
        let lastName = personObj.name.last as String
        cell.nameLabel.text = "\(firstname) \(lastName)"
        if let pictureUrl = personObj.picture.thumbnail {
            ApiHandler.getImageFromURL(url: pictureUrl, finished: {image in
                cell.profilePicture.image = image
            })
        }
        return cell
    }
}
