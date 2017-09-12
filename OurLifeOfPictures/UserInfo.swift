//
//  UserInfo.swift
//  OurLifeOfPictures
//
//  Created by Jeff Ripke on 9/8/17.
//  Copyright © 2017 Jeff Ripke. All rights reserved.
//

import Foundation
import CloudKit

class UserInfo {
    
    // MARK: - Properties
    let container: CKContainer
    var userRecordID: CKRecordID!
    var contacts: [AnyObject] = []
    
    // MARK: - Initializers
    init (container: CKContainer) {
        self.container = container
    }
    
    func loggedInToIcloud(_ completion: (_ accountStatus: CKAccountStatus, _ error: NSError?) -> ()) {
        // not yet implemented
        completion(.couldNotDetermine, nil)
    }
    
    
}
