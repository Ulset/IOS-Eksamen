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
        vc.title = personObj.name.first as String
        vc.person = personObj
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension PersonsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personController.getPersons().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath)
        let firstname = personController.getPersons()[indexPath.row].name.first as String
        let lastName = personController.getPersons()[indexPath.row].name.last as String
        cell.textLabel?.text = "\(firstname) \(lastName)"
        return cell
    }
}
