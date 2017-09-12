//
//  File.swift
//  OurLifeOfPictures
//
//  Created by Jeff Ripke on 9/6/17.
//  Copyright © 2017 Jeff Ripke. All rights reserved.
//

import Foundation
import CloudKit
import CoreLocation

// Specify the protocol to be used by view controllers to handle notifications
protocol ModelDelegate {
    func errorUpdate(_ error: NSError)
    func modelUpdated()
}

class Model {
    
    // MARK: - Properties
    let photographType = "Photograph"
    static let sharedInstance = Model()
    var delegate: ModelDelegate?
    var items: [Photograph] = []
    let userInfo: UserInfo
    
    // Define databases
    
    // Represents the default container specified in the iCloud section of the capabilities tab for the project.
    let container: CKContainer
    let publicDB: CKDatabase
    let privateDB: CKDatabase
    
    // MARK: - Initializers
    init() {
        container = CKContainer.default()
        publicDB = container.publicCloudDatabase
        privateDB = container.privateCloudDatabase
        userInfo = UserInfo(container: container)
    }
    
    @objc func refresh() {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Photograph", predicate: predicate)
        publicDB.perform(query, inZoneWith: nil) { [unowned self] results, error in
            guard error == nil else {
                DispatchQueue.main.async {
                    self.delegate?.errorUpdate(error! as NSError)
                    print("Cloud Query Error - Refresh: \(String(describing: error))")
                }
                return
            }
            
            self.items.removeAll(keepingCapacity: true)
            
            for record in results! {
                let photograph = Photograph(record: record, database: self.publicDB)
                self.items.append(photograph)
            }
            
            DispatchQueue.main.async {
                self.delegate?.modelUpdated()
            }
        }
    }
    
    func photograph(_ ref: CKReference) -> Photograph! {
        let matching = items.filter { $0.record.recordID == ref.recordID }
        return matching.first
    }
    
    
}
