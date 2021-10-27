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
    private var localPersons: [Person] = []
    private var fetchedResultsController: NSFetchedResultsController<PersonCoreData>
    
    //For a app of this scope, ive just added a way of adding a 'updateFunction' to the PersonController
    // This will trigger every function added there everytime there is a refresh of data.
    // Not really scalable, and surely not efficient, but works in this case.
    private var updateFunctions: [() -> Void] = []
    
    // ApiHandler does the actual fetching
    private let api = ApiHandler()
    private let context: NSManagedObjectContext
    
    override init(){
        self.context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchReq = PersonCoreData.fetchRequest()
        fetchReq.sortDescriptors = [NSSortDescriptor(key: "firstname", ascending: true)]
        // I only use this for the 'controllerDidChangeContent' function
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchReq, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        super.init()
        
        fetchedResultsController.delegate = self
        try! fetchedResultsController.performFetch()
        if(self.localPersons.count == 0){
            refreshPersonsFromApi()
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("controllerDidChangeContent trigger")
        // Gets the data from CoreData and transforms in to Person structs.
        let personDataCoreArr = try! context.fetch(PersonCoreData.fetchRequest())
        self.localPersons = personDataCoreArr.map { personDc in
            return Person(from: personDc)
        }
        
        //Run all update functions
        for function in self.updateFunctions {
            DispatchQueue.main.async {
                //Function may be a table update, so im running them on the main thread.
                function()
            }
        }
    }
    
    func getPersons() -> [Person] {
        return localPersons
    }
    
    func addUpdateFunction(updateFunc: @escaping () -> Void) {
        // Adds a function to the updateArray, this function will trigger everytime there is fresh data.
        updateFunctions.append(updateFunc)
    }
    
    func refreshPersonsFromApi() {
        api.getPersonsFromApi(finished: {persons in
            for person in persons {
                let newPerson = PersonCoreData(context: self.context)
                newPerson.firstname = person.name.first
                newPerson.lastname = person.name.last
                newPerson.longitude = person.location.coordinates.longitude
                newPerson.latitude = person.location.coordinates.latitude
                newPerson.pictureThumbnail = person.picture.thumbnail
                newPerson.pictureHighres = person.picture.large
            }
            try! self.context.save()
        })
    }
    
    func deleteEverything() {
        print("Deleting data....")
        let personDataCoreArr = try! context.fetch(PersonCoreData.fetchRequest())
        for personManaged in personDataCoreArr {
            context.delete(personManaged)
        }
        try! context.save()
        print("Deleted")
    }
}
