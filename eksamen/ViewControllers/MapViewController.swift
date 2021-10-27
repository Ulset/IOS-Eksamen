//
//  MapViewController.swift
//  eksamen
//
//  Created by Sander Ulset on 27/10/2021.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    let personController = (UIApplication.shared.delegate as! AppDelegate).personController
    
    @IBOutlet weak var mapOutlet: MKMapView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        populateMap()
        personController.addUpdateFunction {
            self.populateMap()
        }
    }
    
    func populateMap(){
        let persons = personController.getPersons()
        mapOutlet.removeAnnotations(mapOutlet.annotations)
        for person in persons {
            let lat = Double(person.location.coordinates.latitude)!
            let long = Double(person.location.coordinates.longitude)!
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            annotation.title = "\(person.name.first) \(person.name.last)"
            annotation.subtitle = "Test"
            mapOutlet.addAnnotation(annotation)
        }
    }

}
