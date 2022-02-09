//
//  GuessMapViewController.swift
//  Geome
//
//  Created by Felix-Xaver Aigner on 12.01.22.
//

import UIKit
import MapKit
import CoreLocation

class GuessMapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var SubmitButton: UIButton!
    
    
    let regionInMeters: Double = 10000
    let locationManager = CLLocationManager()
    
    var previousLocation: CLLocation?
    var pictureLocation: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Guess the Location"
        // self.pictureLocation = CLLocation(latitude: 48, longitude: 16)
        print(pictureLocation)
        checkLocationServices()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "SubmitGuessSegue") {
            if let summaryViewController = segue.destination as? GameSummaryViewController{
                guard let prev = self.previousLocation else {return}
                guard let pic = self.pictureLocation else {return}
                
                summaryViewController.guessedLocation = prev
                summaryViewController.pictureLocation = pic
            }
            
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }


    func centerViewOnUserLocation() {
        /*if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }*/ 
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // Show alert letting the user know they have to turn this on.
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
        case .denied:
            // Show alert instructing them how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Show an alert letting them know what's up
            break
        case .authorizedAlways:
            break
        }
        
    }
    
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longtitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longtitude)
    }

}
extension GuessMapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

extension GuessMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(for: mapView)
        // let geoCoder = CLGeocoder()
        
        guard let previousLocation = self.previousLocation else { self.previousLocation = center
            return
        }
        
        guard let previousLocation = self.previousLocation else {return}
        guard center.distance(from: previousLocation) > 50 else {return}
        self.previousLocation = center
        
        
    }
}
