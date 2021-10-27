//
//  MapViewController.swift
//  eksamen
//
//  Created by Sander Ulset on 27/10/2021.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    let personController = (UIApplication.shared.delegate as! AppDelegate).personController
    
    @IBOutlet weak var mapOutlet: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateMap()
        personController.addUpdateFunction {
            self.populateMap()
        }
        mapOutlet.delegate = self
        let center = CLLocationCoordinate2D(latitude: 59.911491, longitude: 10.757933)
        let span = MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
        let region = MKCoordinateRegion(center: center, span: span)
        mapOutlet.setRegion(region, animated: true)
    }
    
    func populateMap(){
        let persons = personController.getPersons()
        mapOutlet.removeAnnotations(mapOutlet.annotations)
        for person in persons {
            let lat = Double(person.location.coordinates.latitude)!
            let long = Double(person.location.coordinates.longitude)!
            let annotation = PersonAnnotation(cord: CLLocationCoordinate2D(latitude: lat, longitude: long), person: person)
            mapOutlet.addAnnotation(annotation)
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        view.isSelected = false
        let pressedEnt = view.annotation as! PersonAnnotation
        let vc = storyboard?.instantiateViewController(withIdentifier: "person") as! PersonViewController
        
        let personObj = pressedEnt.personObj
        vc.title = personObj.name.first as String
        vc.person = personObj
        
        navigationController?.present(vc, animated: true, completion: nil)
    }
}

class PersonAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var personObj: Person
    var title: String?
    
    init(cord: CLLocationCoordinate2D, person: Person) {
        coordinate = cord
        personObj = person
        title = person.name.first
    }
}
