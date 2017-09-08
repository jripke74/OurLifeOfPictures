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
    weak var database: CKDatabase!
    
    // fieldnames
    var fileNameOfPhoto: String!
    var locationPictureWasTaken: CLLocation!
    var datePhotoTaken: Date!
    var cameraPhotoTakenWith: String!
    
    
    // used to hold the number of records returned by CKQuery
    var assetCount = 0
    
    var coordinate: CLLocationCoordinate2D {
        return locationPictureWasTaken.coordinate
    }
    
    init(record: CKRecord, database: CKDatabase) {
        self.record = record
        self.database = database
        
        self.fileNameOfPhoto = record["fileNameOfPhoto"] as? String
    }
    
    func fetchPhotos(_ completion: @escaping (_ assets: [CKRecord]?) -> ()) {
        let predicate = NSPredicate(format: "Photograph == %@", record)
        let query = CKQuery(recordType: "Photograph", predicate: predicate)
        
        database.perform(query, inZoneWith: nil) { [weak self] results, error in
            defer {
                completion(results)
            }
            guard error == nil,
                let results = results else {
                    return
            }
            self?.assetCount = results.count
        }
    }
    
    func loadPhoto(completion:@escaping (_ photo: UIImage?) -> ()) {
        // load image asynchronously
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            var image: UIImage!
            defer {
                completion(image)
            }
            
            guard let asset = self.record["photo"] as? CKAsset else {
                return
            }
            
            let imageData: Data
            do {
                imageData = try Data(contentsOf: asset.fileURL)
            } catch {
                return
            }
            
            image = UIImage(data: imageData)
        }
    }
}
