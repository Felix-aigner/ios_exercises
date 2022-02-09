//
//  Networking.swift
//  Geome
//
//  Created by Felix-Xaver Aigner on 12.01.22.
//

import Foundation
import UIKit

class Networking {
    let session = URLSession(configuration: .default)
    let jsonDecoder = JSONDecoder()
    
    func downloadRandomImage(completionHandler: @escaping(_ result: (Bool, [Photo]?)) -> ()) {
        print("in networking")
        
        let api = "3f-PYbiCuDxI0kqJGfhkbfItNLcCErF1UtsnIerovh8"
        let url = URL(string:"https://api.unsplash.com/photos/random?count=15&query=europe,city")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Client-ID \(api)", forHTTPHeaderField: "Authorization")
        print("request created")
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completionHandler((false, nil))
                return
            }
            print(data)
            do {
                let res = try JSONDecoder().decode([Photo].self, from: data)
                completionHandler((true, res))
                return
            } catch {
                print(error)
            }

            completionHandler((false, nil))
            return
        }
        dataTask.resume()
    }
}
