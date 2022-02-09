//
//  CreateGameViewController.swift
//  Geome
//
//  Created by Felix-Xaver Aigner on 12.01.22.
//

import UIKit
import CoreLocation

class CreateGameViewController: UIViewController {
    
    let networking = Networking()
    var guessPhoto: Photo? = nil
    var location: CLLocation? = nil
    var startGuessingTime: TimeInterval = TimeInterval(0)
    
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    @IBOutlet weak var uiImage: UIImageView!
    @IBOutlet weak var startGuessingButton: UIButton!
    
    @IBAction func startGuessingAction(_ sender: UIButton) {
        print("start guessing button pressed")
        performSegue(withIdentifier: "startGuessingIdentifier", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Create Game"
        
        
        loadingSpinner.startAnimating()
        startGuessingButton.isEnabled = false;
        
        let timestamp = NSDate().timeIntervalSince1970
        self.startGuessingTime = timestamp
        print(self.startGuessingTime)
        
        let  callback: (_ result: Bool,_ images: [Photo]?) -> () = {
            (result, images) in
            DispatchQueue.main.async {
                if(result) {
                    guard let photos = images else {return}
                    let fittingImg = self.getFittingPhoto(photos: photos)
                    if let fittingImg = fittingImg {
                        self.guessPhoto = fittingImg
                        if let regular = fittingImg.urls.regular, let lat = fittingImg.location.position.latitude, let long = fittingImg.location.position.longitude {
                            let url = URL(string: regular)
                            let data = try? Data(contentsOf: url!)
                            self.uiImage.image = UIImage(data: data!)
                            
                            self.location = CLLocation(latitude: lat, longitude: long)
                        }
                        
                    } else {
                        let alertFailure = UIAlertController(title: "Failure", message: "Pictures could not be loaded correctly", preferredStyle: .alert)
                        alertFailure.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: "Default action"), style: .default, handler: { _ in
                            self.navigationController?.popToRootViewController(animated: true)
                        }))
                        alertFailure.message = "There was a problem loading the images, please try again"
                        self.present(alertFailure, animated: true, completion: nil)
                    }
                }
                self.loadingSpinner.stopAnimating()
                self.startGuessingButton.isEnabled = true;
                
            }
        }
        print("callback created, calling networking")
        networking.downloadRandomImage(completionHandler: callback)
        // Do any additional setup after loading the view.
    }
    

    // The unsplash API sometimes has photos with the location set to null/nil, although this is unlikely, i wanted to minimize the risk of having a pciture with no lcoation data and therefore fetch a few pictures and only take the first with any location data.
    // Theoretically it still could happen that the program fetches 15 photos without location data, but this is just to reduce times where an error might occure.
    func getFittingPhoto(photos: [Photo]) -> Photo? {
        for photo in photos {
            if let long = photo.location.position.longitude, let lat = photo.location.position.latitude {
                return photo
            }
        }
        return nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "startGuessingIdentifier") {
            if let guessMapController = segue.destination as? GuessMapViewController{
                guessMapController.pictureLocation = self.location
            }
            
        }
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

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
