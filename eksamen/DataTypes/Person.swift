//
//  Person.swift
//  eksamen
//
//  Created by Sander Ulset on 25/10/2021.
//

import Foundation
import CoreData

struct Person: Decodable {
    let gender: String
    let name: Name
    let location: Location
    
    static func generateFromDataCore(from pDc: PersonCoreData) -> Person{
        let nameS = Name(title: "notSet", first: pDc.firstname!, last: pDc.lastname!)
        let coordinates = Coordinates(latitude: pDc.latitude!, longitude: pDc.longitude!)
        let location = Location(coordinates: coordinates)
        return Person(gender: "male", name: nameS, location: location)
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
