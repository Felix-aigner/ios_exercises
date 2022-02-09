//
//  PostGameDetailViewController.swift
//  Geome
//
//  Created by Felix-Xaver Aigner on 12.01.22.
//

import UIKit
import MapKit

class PostGameDetailViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var MapLabel: UILabel!
    @IBOutlet weak var postGameMapView: MKMapView!
    var game: GameModel!
    var pictureLoc: CLLocation?
    var guessedLoc: CLLocation?
    var midPointLocation: CLLocation?
    var distance: Double = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        postGameMapView.delegate = self
        if let game = game {
            title = game.name
            pointLabel.text = "You reached \(game.points) Points in \(game.timeElapsed) sec"
            
            let url = URL(string: game.img_url)
            let data = try? Data(contentsOf: url!)
            self.imageView.image = UIImage(data: data!)
        
            annotateMap()
            if let pic = pictureLoc,let guess = guessedLoc {
                self.midPointLocation = midPointWith(start: pic, end: guess)
                let distance = pic.distance(from: guess) as Double
                self.distance = distance
                if(distance < 1000) {
                    MapLabel.text = "Your Guess was \(String(format: "%.0f", distance)) Meters off"
                } else {
                    MapLabel.text = "Your Guess was \(String(format: "%.2f", (distance/1000))) km off"
                }
                
            }
            if let center = midPointLocation {
                let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: center.coordinate.latitude, longitude: center.coordinate.longitude), latitudinalMeters: distance*1.2, longitudinalMeters: distance*1.2)
                postGameMapView.setRegion(region, animated: true)
            }
        } else {
            let alertFailure = UIAlertController(title: "Failure", message: "The game could not be loaded, please head back to the main screen", preferredStyle: .alert)
            alertFailure.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: "Default action"), style: .default, handler: { _ in
                self.navigationController?.popToRootViewController(animated: true)
            }))
            alertFailure.message = "The game could not be loaded, please head back to the main screen"
            self.present(alertFailure, animated: true, completion: nil)
        }
        
        // Do any additional setup after loading the view.
    }
    
    func annotateMap() {
        print("in function createLine")
        guard let game = self.game else {return}
        
        
        let points = [
            CLLocationCoordinate2D(latitude: game.pictureLat, longitude: game.pictureLong),
            CLLocationCoordinate2D(latitude: game.guessedLat, longitude: game.guessedLong)
        ]
        
        self.pictureLoc = CLLocation(latitude: points[0].latitude, longitude: points[0].longitude)
        self.guessedLoc =  CLLocation(latitude: points[1].latitude, longitude: points[1].longitude)
        
        let pin1 = MKPointAnnotation()
        pin1.coordinate = points[0]
        pin1.title = "Picture Location"
        postGameMapView.addAnnotation(pin1)
        
        let pin2 = MKPointAnnotation()
        pin2.coordinate = points[1]
        pin2.title = "Guessed Location"
        postGameMapView.addAnnotation(pin2)
        
        let line = MKPolyline(coordinates: points, count: points.count)
        
        postGameMapView.addOverlay(line)
    }
    
    func midPointWith(start: CLLocation, end: CLLocation) -> CLLocation {
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
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        print("mapview base function, rendering")
        let lineRender: MKPolylineRenderer = MKPolylineRenderer(overlay: overlay)
        lineRender.strokeColor = UIColor.red
        lineRender.lineWidth = 3
        print("created linerenderer")
        return lineRender
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

