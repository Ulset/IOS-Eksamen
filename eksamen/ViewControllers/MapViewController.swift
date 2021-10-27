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
    }
    
    func populateMap(){
        let persons = personController.getPersons()
        mapOutlet.removeAnnotations(mapOutlet.annotations)
        for person in persons {
            let annotation = PersonAnnotation(person: person)
            mapOutlet.addAnnotation(annotation)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "Placemark"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        } else {
            annotationView?.annotation = annotation
        }
        
        if let thumbnailPicture = (annotation as? PersonAnnotation)?.personObj.picture.thumbnail{
            ApiHandler.getImageFromURL(url: thumbnailPicture, finished: {image in
                annotationView?.image = image
            })
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let pressedEnt = view.annotation as! PersonAnnotation
        let vc = storyboard?.instantiateViewController(withIdentifier: "person") as! PersonViewController
        
        let personObj = pressedEnt.personObj
        vc.title = personObj.name.first as String
        vc.person = personObj
        DispatchQueue.main.async {
            self.present(vc, animated: true, completion: nil)
        }
    }
}

class PersonAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var personObj: Person
    var title: String?
    
    init(person: Person) {
        let lat = Double(person.location.coordinates.latitude)!
        let long = Double(person.location.coordinates.longitude)!
        coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        personObj = person
        title = person.name.first
    }
}
