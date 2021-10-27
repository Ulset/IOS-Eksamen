//
//  PersonController.swift
//  eksamen
//
//  Created by Sander Ulset on 25/10/2021.
//

import Foundation
import CoreData
import UIKit
class PersonController {
    private var localPersons: [Person] = []
    
    //For a app of this scope, ive just added a way of adding a 'updateFunction' to the PersonController
    // This will trigger every function added there everytime there is a refresh of data.
    // Not really scalable, and surely not efficient, but works in this case.
    private var updateFunctions: [() -> Void] = []
    
    // ApiHandler does the actual fetching
    private let api = ApiHandler()
    private let context: NSManagedObjectContext
    
    init(){
        self.context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        refreshFromCoreData()
        if(self.localPersons.count == 0){
            refreshPersonsFromApi()
        }
    }
    
    func refreshFromCoreData() {
        // Gets the data from CoreData and transforms in to Person structs.
        // This is a pretty heavy function so use this with cauction.
        var output: [Person] = []
        let personDataCoreArr = try! context.fetch(PersonCoreData.fetchRequest())
        for personDC in personDataCoreArr {
            output.append(Person(from: personDC))
        }
        self.localPersons = output
        
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
            self.refreshFromCoreData()
        })
    }
    
    func deleteEverything() {
        print("Deleting data....")
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "PersonCoreData")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
            print("Data deleted.")
        } catch {
            print("Error deleting data: \(error.localizedDescription)")
        }
        refreshFromCoreData()
    }
}
