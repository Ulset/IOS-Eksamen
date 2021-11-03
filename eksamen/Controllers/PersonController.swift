//
//  PersonController.swift
//  eksamen
//
//  Created by Sander Ulset on 25/10/2021.
//

import Foundation
import CoreData
import UIKit
class PersonController: NSObject, NSFetchedResultsControllerDelegate{
    // localPersons stores the data from CoreData to pass down to viewControllers
    // fetchedResultsController is just used for the controllerDidChangeContent function
    private var localPersons: [Person] = []
    private var fetchedResultsController: NSFetchedResultsController<PersonCoreData>
    
    //For a app of this scope, ive just added a way of adding a 'updateFunction' to the PersonController
    // Every time there is new data, every function added via 'addUpdateFunction' will run.
    private var updateFunctions: [() -> Void] = []
    
    // ApiHandler does the actual fetching
    private let api = ApiHandler()
    private let context: NSManagedObjectContext
    
    override init(){
        self.context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchReq = PersonCoreData.fetchRequest()
        fetchReq.sortDescriptors = [NSSortDescriptor(key: "uuid", ascending: true)]
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchReq, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        super.init()
        
        fetchedResultsController.delegate = self
        try! fetchedResultsController.performFetch()
        
        refreshFromCoreData()
        
        if(self.localPersons.count == 0){
            refreshPersonsFromApi()
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("controllerDidChangeContent trigger")
        refreshFromCoreData()
        //Run all update functions
        for function in self.updateFunctions {
            DispatchQueue.main.async {
                //Function may be a table update, so im running them on the main thread.
                function()
            }
        }
    }
    
    func refreshFromCoreData(){
        // Gets the data from CoreData and transforms in to Person structs.
        let fetchReq = PersonCoreData.fetchRequest()
        fetchReq.sortDescriptors = [NSSortDescriptor(key: "uuid", ascending: true)]
        let personDataCoreArr = try! context.fetch(fetchReq)
        self.localPersons = personDataCoreArr.map { personDc in
            return Person(from: personDc)
        }
    }
    
    func getPersons() -> [Person] {
        return localPersons
    }
    
    func getPersonByIndex(index: Int) -> Person {
        return localPersons[index]
    }
    
    func getPersonByUUID(uuid: String) -> Person? {
        let match =  localPersons.filter({person in
            return person.login.uuid == uuid
        })
        return match.count>0 ? match[0] : nil
    }
    
    func addUpdateFunction(updateFunc: (() -> Void)?) {
        // Adds a function to the updateArray, this function will trigger everytime there is fresh data.
        if let updateFunc = updateFunc {
            updateFunctions.append(updateFunc)
        }
    }
    
    func refreshPersonsFromApi(onlyFetchNew: Bool = true) {
        let deletedPersonsArr = try! context.fetch(DeletedPersons.fetchRequest())
        let uuidStringArr = deletedPersonsArr.map { dEl in
            return dEl.uuid
        }
        api.getPersonsFromApi(finished: {persons in
            for person in persons {
                let isNotPrevDeleted = !onlyFetchNew || !uuidStringArr.contains(where: {$0 == person.login.uuid})
                let alreadyAdded = self.localPersons.contains(where: {addedP in addedP.login.uuid == person.login.uuid})
                if(isNotPrevDeleted && !alreadyAdded){
                    let newPerson = PersonCoreData(context: self.context)
                    self.applyPersonToPdc(from: person, to: newPerson)
                }
            }
            try! self.context.save()
        })
    }
    
    private func applyPersonToPdc(from person: Person, to pDc: PersonCoreData){
        //Just a helper function to convert a Person to a PersonDataCore object
        pDc.firstname = person.name.first
        pDc.lastname = person.name.last
        pDc.longitude = person.location.coordinates.longitude
        pDc.latitude = person.location.coordinates.latitude
        pDc.pictureThumbnail = person.picture.thumbnail
        pDc.pictureHighres = person.picture.large
        pDc.email = person.email
        pDc.birthdate = person.dob.date
        pDc.city = person.location.city
        pDc.uuid = person.login.uuid
        pDc.phoneNumber = person.phone
    }
    
    func updatePerson(person p: Person){
        let fetchReq = PersonCoreData.fetchRequest()
        fetchReq.predicate = NSPredicate(format: "uuid = %@", p.login.uuid!)
        if let fetchedUsers = try? context.fetch(fetchReq) {
            for user in fetchedUsers {
                // Burde bare være 1, men kan hende bruker har trykket på "Hent brukere" flere ganger
                self.applyPersonToPdc(from: p, to: user)
                user.isChanged = true
            }
            try! context.save()
        }
    }
    
    func deletePerson(person p: Person){
        let fetchReq = PersonCoreData.fetchRequest()
        fetchReq.predicate = NSPredicate(format: "uuid = %@", p.login.uuid!)
        var deletedUsers: [String] = []
        if let fetchedUsers = try? context.fetch(fetchReq) {
            for user in fetchedUsers {
                // Burde bare være 1, men kan hende bruker har trykket på "Hent brukere" flere ganger
                self.context.delete(user)
                deletedUsers.append(user.uuid!)
            }
            try! context.save()
        }
        logPersonsAsDeleted(uuids: deletedUsers)
    }
    
    func deleteEverything(onlyNonChanged: Bool = true, markAsDeleted: Bool = true) {
        //I am become death, the destroyer of Persons
        print("Deleting data....")
        let fetchReq = PersonCoreData.fetchRequest()
        if(onlyNonChanged){
            fetchReq.predicate = NSPredicate(format: "isChanged = %d", false)
        }
        let personDataCoreArr = try! context.fetch(fetchReq)
        var deletedUuids: [String] = []
        for personManaged in personDataCoreArr {
            deletedUuids.append(personManaged.uuid!)
            context.delete(personManaged)
        }
        try! context.save()
        print("Deleted")
        if(markAsDeleted){
            logPersonsAsDeleted(uuids: deletedUuids)
        }
    }
    
    func resetDeletedList(){
        // Removes every element from the DeletedPersons CoreData storage, so they will be accepted again.
        let deletedPersonsArray = try! context.fetch(DeletedPersons.fetchRequest())
        for dPers in deletedPersonsArray {
            context.delete(dPers)
        }
        try! context.save()
    }
    
    func logPersonsAsDeleted(uuids: [String]) {
        // Logs the supplied UUIDs as deleted, these will not be added back.
        for uuid in uuids {
            let newDeleted = DeletedPersons(context: self.context)
            newDeleted.uuid = uuid
        }
        try! context.save()
    }
}
