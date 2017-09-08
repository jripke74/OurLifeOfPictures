//
//  Picture.swift
//  OurLifeOfPictures
//
//  Created by Jeff Ripke on 9/6/17.
//  Copyright © 2017 Jeff Ripke. All rights reserved.
//

import Foundation
import CloudKit
import MapKit

class Photograph: NSObject, MKAnnotation {
    
    // MARK: - Properties
    var record: CKRecord!
    // file name of picture
    var fileName: String!
    var locationPictureWasTaken: CLLocation!
    weak var database: CKDatabase!
    var assetCount = 0
    
    var coordinate: CLLocationCoordinate2D {
        return locationPictureWasTaken.coordinate
    }
}
