//
//  ViewController.swift
//  Awareness
//
//  Created by Sushma on 3/30/16.
//  Copyright © 2016 Sush. All rights reserved.
//

import UIKit
import MapKit

let SFLatitude = 37.773972
let SFLongitude = -122.431297
let regionRadius: CLLocationDistance = 5000

class ViewController: UIViewController {

    
    @IBOutlet weak var mapview: MKMapView!
    
    
    @IBAction func reloadData(sender: AnyObject) {
        
        self.loadData()
    }
    
   
    
    
    let initialLocation = CLLocation(latitude: SFLatitude, longitude: SFLongitude)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapview.delegate = self
        centerMapOnLocation(initialLocation)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        self.mapview.setRegion(coordinateRegion, animated: true)
        
        self.loadData()
    }
    
    func loadData() {
        //get the annotations
        let crimeDetailManager = CrimeDetailManager()
        crimeDetailManager.getCrimeData { (message, var response) -> () in
            self.mapview.removeAnnotations(self.mapview.annotations)
            self.mapview.addAnnotations(response)
            response.removeAll()
        }
    }
}

extension ViewController: MKMapViewDelegate {
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation is MKUserLocation) {
            return nil
        }
        
        let reuseId = "pin"
        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if let anAnnotation = annotation as? CrimeDetail {
            let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView.pinTintColor = anAnnotation.pinColor()
            anView = pinView
        }
        anView!.canShowCallout = true
        
        return anView
    }
}

