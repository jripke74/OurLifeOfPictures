//
//  MasterViewController.swift
//  OurLifeOfPictures
//
//  Created by Jeff Ripke on 9/12/17.
//  Copyright © 2017 Jeff Ripke. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    
    // MARK: - Properties
    let model: Model = Model.sharedInstance
    
    var detaileViewController: DetailViewController?
    
    // MARK: - View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        guard case(.pad) = traitCollection.userInterfaceIdiom else { return }
        
        clearsSelectionOnViewWillAppear = false
        preferredContentSize = CGSize(width: 320.0, height: 600.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model.delegate = self
        model.refresh()
        
        // Set up a refresh control
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(Model, action: #selector(Model.refresh), for: .valueChanged)
        
        guard let splitViewController = splitViewController,
            let navigationController = splitViewController.viewControllers.last as? UINavigationController,
            let detailViewController = navigationController.topViewController as? DetailViewController else {
                return
        }
        
        self.detaileViewController = detailViewController
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showDetail",
            let indexPath = tableView.indexPathForSelectedRow,
            let navigationController = segue.destination as? UINavigationController,
            let detailController = navigationController.topViewController as? DetailViewController else {
                return
        }
        let detailItem = Model.sharedInstance.items[(indexPath as NSIndexPath).row]
        detailController.detailItem = detailItem
    }
}

// MARK: - UITableViewDataSource
extension MasterViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Model.sharedInstance.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PhotographCell
        let object = Model.sharedInstance.items[(indexPath as NSIndexPath).row]
        cell.titleLabel.text = object.name
        object.loadPhoto { (image) in
            DispatchQueue.main.async {
                cell.photo.image = image
            }
        }
        return cell
    }
}
