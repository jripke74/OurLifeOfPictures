//
//  DetailViewController.swift
//  OurLifeOfPictures
//
//  Created by Jeff Ripke on 9/14/17.
//  Copyright © 2017 Jeff Ripke. All rights reserved.
//

import UIKit
import CloudKit

class DetailViewController: UITableViewController {
    
    // MARK: - Properties
    var detailItem: Photograph! {
        didSet {
            if let _ = presentedViewController {
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - IBOutlet
    @IBOutlet var photo: UIImageView!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photo.clipsToBounds = true
        photo.layer.cornerRadius = 10.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureView()
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        guard let detail: Photograph = detailItem else { return }
        
        title = detail.fileNameOfPhoto
        
        detail.loadPhoto { (image) in
            DispatchQueue.main.async {
                self.photo.image = image
            }
        }
    }
}

extension DetailViewController {
    
    
}
