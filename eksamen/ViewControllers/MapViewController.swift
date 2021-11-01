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
    var focusOnPerson: Person?
    
    @IBOutlet weak var mapOutlet: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if focusOnPerson != nil {
            // Only show a single person, and focus on that person
            mapOutlet.isZoomEnabled = false
            mapOutlet.isScrollEnabled = false
            mapOutlet.isPitchEnabled = false
            mapOutlet.isRotateEnabled = false
            let annotation = PersonAnnotation(person: focusOnPerson!)
            mapOutlet.addAnnotation(annotation)
            
            mapOutlet.centerCoordinate = annotation.coordinate
            mapOutlet.region = MKCoordinateRegion(center: annotation.coordinate, span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))
        } else {
            populateMap()
            personController.addUpdateFunction {
                if let pvc = self.navigationController?.topViewController as? PersonViewController {
                    if let uuid = pvc.person?.login.uuid, self.personController.getPersonByUUID(uuid: uuid) == nil {
                        //If viewing a person that was deleted, return to main map.
                        self.navigationController?.popToViewController(self, animated: true)
                    }
                }
                self.populateMap()
            }
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
                annotationView?.layer.cornerRadius = (annotationView?.frame.size.height)!/2
                annotationView?.layer.masksToBounds = true
                annotationView?.layer.borderWidth = 3
                annotationView?.layer.borderColor = UIColor.white.cgColor
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
            self.navigationController?.pushViewController(vc, animated: true)
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
