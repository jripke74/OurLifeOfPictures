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
}
