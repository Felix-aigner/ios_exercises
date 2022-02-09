//
//  PhotoModel.swift
//  Geome
//
//  Created by Felix-Xaver Aigner on 24.01.22.
//

import Foundation
import UIKit

//struct Results: Codable {
//    var photos: [Photo]
    
struct Photo: Codable {
    var id: String
    var location: Location
    var urls: URLs
    
    struct URLs: Codable {
        var small: String?
        var medium: String?
        var alrge: String?
        var regular: String?
    }
    
    struct Location: Codable {
        var position: Position
        
        
        struct Position: Codable {
            var latitude: Double?
            var longitude: Double?
        }
    }
}
//}

