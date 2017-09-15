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
        refreshControl?.addTarget(model, action: #selector(Model.refresh), for: .valueChanged)
        
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
        cell.titleLabel.text = object.fileNameOfPhoto
        object.loadPhoto { (image) in
            DispatchQueue.main.async {
                cell.photoView.image = image
            }
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MasterViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard case(.pad) = traitCollection.userInterfaceIdiom else { return }
        
        let detailItem = Model.sharedInstance.items[(indexPath as NSIndexPath).row]
        detaileViewController?.detailItem = detailItem
    }
}

// MARK: - ModelDelgate
extension MasterViewController: ModelDelegate {
    
    func modelUpdated() {
        refreshControl?.endRefreshing()
        tableView.reloadData()
    }
    
    func errorUpdate(_ error: NSError) {
        let message: String
        if error.code == 1 {
            message = "Log into iCloud on your device and make sure the iCloud is turned on for this app."
        } else {
            message = error.localizedDescription
        }
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        present(alertController, animated: true, completion: nil)
    }
}
