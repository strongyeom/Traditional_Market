//
//  CustomAnnotation.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/09/26.
//

import Foundation
import MapKit

class CustomAnnotation: NSObject, MKAnnotation {
    
    // This property must be key-value observable, which the `@objc dynamic` attributes provide.
    @objc dynamic var coordinate: CLLocationCoordinate2D
    
    var title: String?
    
    var subtitle: String?
    
    var imageName: String?
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        self.title = title
        super.init()
    }
}
