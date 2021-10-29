//
//  Person.swift
//  eksamen
//
//  Created by Sander Ulset on 25/10/2021.
//

import Foundation
import CoreData

struct Person: Decodable {
    //Represents a person fetched from the randomuser.me API.
    var name: Name
    let location: Location
    let picture: Picture
    let email: String?
    var dob: DateOfBirth
    let login: Login
    
    init(from pDc: PersonCoreData) {
        // Data os stored in CoreData as a PersonCoreData object.
        // Can be initalized back to a Person struct with this
        let nameS = Name(first: pDc.firstname!, last: pDc.lastname!)
        let coordinates = Coordinates(latitude: pDc.latitude!, longitude: pDc.longitude!)
        let location = Location(coordinates: coordinates, city: pDc.city)
        self.picture = Picture(thumbnail: pDc.pictureThumbnail, large: pDc.pictureHighres)
        self.location = location
        self.name = nameS
        self.email = pDc.email
        self.dob = DateOfBirth(date: pDc.birthdate)
        self.login = Login(uuid: pDc.uuid)
    }
}

struct Login: Decodable {
    let uuid: String?
}

struct Name: Decodable {
    var first: String
    let last: String
}

struct Location: Decodable {
    let coordinates: Coordinates
    let city: String?
}

struct Coordinates: Decodable {
    let latitude: String
    let longitude: String
}

struct Picture: Decodable {
    let thumbnail: String?
    let large: String?
}

struct DateOfBirth: Decodable {
    var date: String?
    var age: Int {
        get {
            let birthdayDate = getDateObject()
            let calendar: NSCalendar! = NSCalendar(calendarIdentifier: .gregorian)
            let now = Date()
            let calcAge = calendar.components(.year, from: birthdayDate, to: now, options: [])
            let age = calcAge.year
            return age!
        }
    }
    
    func getDateObject() -> Date {
        //Couldt get the whole iso string to work so im just using day/monnth/year
        let strIndex = date?.index(date!.startIndex, offsetBy: 10)
        let t = self.date?[..<strIndex!]
        let onlyDayDate = String(t!)
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        return dateFormatterGet.date(from: onlyDayDate)!
    }
    
    func getDateFormatted(format: String) -> String{
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = format
        
        let Newdate = getDateObject()
        let formatted = dateFormatterPrint.string(from: Newdate)
        return formatted
    }
    
    func hasBirthdayThisWeek() -> Bool {
        let format = "w"
        let todaysDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let todaysDateFormatted = dateFormatter.string(from: todaysDate)
        return getDateFormatted(format: format) == todaysDateFormatted
    }
}
