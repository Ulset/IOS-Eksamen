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
    let name: Name
    let location: Location
    let picture: Picture
    let email: String?
    let dob: DateOfBirth
    
    init(from pDc: PersonCoreData) {
        // Data os stored in CoreData as a PersonCoreData object.
        // Can be initalized back to a Person struct with this
        let nameS = Name(title: "notSet", first: pDc.firstname!, last: pDc.lastname!)
        let coordinates = Coordinates(latitude: pDc.latitude!, longitude: pDc.longitude!)
        let location = Location(coordinates: coordinates)
        self.picture = Picture(thumbnail: pDc.pictureThumbnail, large: pDc.pictureHighres)
        self.location = location
        self.name = nameS
        self.email = pDc.email
        self.dob = DateOfBirth(date: pDc.birthdate)
    }
}

struct Name: Decodable {
    let title: String
    let first: String
    let last: String
}

struct Location: Decodable {
    let coordinates: Coordinates
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
    let date: String?
    
    func getDateFormatted(format: String) -> String{
        //Couldt get the whole iso string to work so im just using day/monnth/year
        let strIndex = date?.index(date!.startIndex, offsetBy: 10)
        let t = self.date?[..<strIndex!]
        let onlyDayDate = String(t!)
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = format
        
        let Newdate = dateFormatterGet.date(from: onlyDayDate)
        let formatted = dateFormatterPrint.string(from: Newdate!)
        return formatted
    }
    
    func hasBirthday() -> Bool {
        let format = "dd-MM"
        let todaysDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let todaysDateFormatted = dateFormatter.string(from: todaysDate)
        return getDateFormatted(format: format) == todaysDateFormatted
    }
}
