//
//  GameSummaryViewController.swift
//  Geome
//
//  Created by Felix-Xaver Aigner on 12.01.22.
//

import UIKit
import CoreLocation
import MapKit
import CoreData

class GameSummaryViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var picturePositionLabel: UILabel!
    @IBOutlet weak var GuessedPositionLabel: UILabel!
    @IBOutlet weak var pointsReachedLabel: UILabel!
    
    @IBOutlet weak var SummaryMapView: MKMapView!
    
    @IBAction func backToMain(_ sender: Any) {
        print("saving, then navigation back to root")
        self.saveGame()
        navigationController?.popToRootViewController(animated: true)
    }
    
    var pictureLocation: CLLocation!
    var guessedLocation: CLLocation!
    var distance: Double = 0
    var guessingTime: TimeInterval?
    
    var midPointLocation: CLLocation?

    override func viewDidLoad() {
        super.viewDidLoad()
        SummaryMapView.delegate = self
        title = "Good Job!"
        displayResults()
        
        if let center = midPointLocation {
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: center.coordinate.latitude, longitude: center.coordinate.longitude), latitudinalMeters: distance*1.2, longitudinalMeters: distance*1.2)
            SummaryMapView.setRegion(region, animated: true)
        }
        createLine()
    }
    
    func createLine() {
        print("in function createLine")
        guard let picture = self.pictureLocation else {return}
        guard let guess = self.guessedLocation else {return}
        
        
        let points = [
            CLLocationCoordinate2D(latitude: picture.coordinate.latitude, longitude: picture.coordinate.longitude),
            CLLocationCoordinate2D(latitude: guess.coordinate.latitude, longitude: guess.coordinate.longitude)
        ]
        
        
        let pin1 = MKPointAnnotation()
        pin1.coordinate = points[0]
        pin1.title = "Picture Location"
        SummaryMapView.addAnnotation(pin1)
        
        let pin2 = MKPointAnnotation()
        pin2.coordinate = points[1]
        pin2.title = "Guessed Location"
        SummaryMapView.addAnnotation(pin2)
        
        let line = MKPolyline(coordinates: points, count: points.count)
        
        SummaryMapView.addOverlay(line)
    }
    
    func displayResults() {
        guard let picture = self.pictureLocation else {return}
        guard let guess = self.guessedLocation else {return}
        
        formatLocation(location: picture, button: self.picturePositionLabel)
        formatLocation(location: guess, button: self.GuessedPositionLabel)
        pointsReachedLabel.text = "You reached \(getPoints()) Points"
        
        self.midPointLocation = midPointWith(start: picture, end: guess)
        
        if let navControllerCount = navigationController?.viewControllers.count {
            let createGameController = (navigationController?.viewControllers[navControllerCount - 3]) as! CreateGameViewController
            self.guessingTime = NSDate().timeIntervalSince(NSDate(timeIntervalSince1970: createGameController.startGuessingTime) as Date)
        }
        if let timeElapsed = self.guessingTime {
            pointsReachedLabel.text = "You reached \(getPoints()) Points in \(String(format: "%.1f", timeElapsed)) sec"
        }
        
        
    }
    
    func getPoints() -> String {
        let distance = pictureLocation.distance(from: guessedLocation) as Double
        if let dist = distance as? Double {
            self.distance = dist
        }
        var points = (1000000 - distance)/1000
        if points < 0 {
            points = 0
        }
        let ret: String = String(format: "%.1f", points)
        return ret
    }
    
    func formatLocation(location: CLLocation, button: UILabel) {
        let geoCoder = CLGeocoder()
        // return "not an adress"
        
        geoCoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            if let _ = error {
                return
            }
            
            guard let placemark = placemarks?.first else {
                return
            }
            
            let region = placemark.country ?? ""
            
            DispatchQueue.main.async {
                button.text = "\(region)"
            }
        }
    }
    
    
    func midPointWith(start: CLLocation, end: CLLocation) ->CLLocation {
        print("calculating mid point")
        
        let lat1 = Double.pi * start.coordinate.latitude / 180.0
        let long1 = Double.pi * start.coordinate.longitude / 180.0
        
        let lat2 = Double.pi * end.coordinate.latitude / 180.0
        let long2 = Double.pi * end.coordinate.longitude / 180.0
        
        let bxLoc = cos(lat2) * cos(long2 - long1)
        let byLoc = cos(lat2) * sin(long2 - long1)
        
        let mlat = atan2(sin(lat1) + sin(lat2), sqrt((cos(lat1) + bxLoc) * (cos(lat1) + bxLoc) + (byLoc * byLoc)))
        let mlong = long1 + atan2(byLoc, cos(lat1) + bxLoc)
        
        return CLLocation(latitude: mlat * 180 / Double.pi, longitude: mlong * 180 / Double.pi)
        
        
    }
    
    // https://stackoverflow.com/questions/58445093/compiler-error-invalid-library-file-corelocation
    // xcode simulator throws a compiler error: invalid library file error when rerendering the line (or on any move of the map), this is not an issue when using a real device but rather an issue with xcode
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        print("mapview base function, rendering")
        let lineRender: MKPolylineRenderer = MKPolylineRenderer(overlay: overlay)
        lineRender.strokeColor = UIColor.red
        lineRender.lineWidth = 3
        print("created linerenderer")
        return lineRender
    }
    
    func saveGame() {
        print("trying to save game")
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            guard let entityDescription = NSEntityDescription.entity(forEntityName: "Game", in: context) else {return}
            
            let newValue = NSManagedObject(entity: entityDescription, insertInto: context)
            newValue.setValue(getPoints(), forKey: "points")
            newValue.setValue(pictureLocation.coordinate.latitude, forKey: "picture_lat")
            newValue.setValue(pictureLocation.coordinate.longitude, forKey: "picture_long")
            newValue.setValue(guessedLocation.coordinate.latitude, forKey: "guessed_lat")
            newValue.setValue(guessedLocation.coordinate.longitude, forKey: "guessed_long")
            // get picture url
            if let navControllerCount = navigationController?.viewControllers.count {
                let createGameController = (navigationController?.viewControllers[navControllerCount - 3]) as! CreateGameViewController
                newValue.setValue(createGameController.guessPhoto?.urls.regular, forKey: "img_url")
            }
            if let timeElapsed = self.guessingTime {
                newValue.setValue(String(format: "%.1f", timeElapsed), forKey: "time_elapsed")
            }
            newValue.setValue(retrieveGameName(), forKey: "name")
            
            do {
                try context.save()
                print("saved game")
            } catch {
                print("saving error")
            }
        }
    }
    
    func retrieveGameName() -> String {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<Game>(entityName: "Game")
            
            do {
                let results = try context.fetch(fetchRequest)
                let title = "Game #\(results.count)"
                return title
            } catch {
                print("could not retrieve")
            }
        }
        return "Game #0"
    }
}
