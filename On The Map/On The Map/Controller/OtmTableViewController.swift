//
//  OtmTableViewController.swift
//  On The Map
//
//  Created by Matthew Flood on 3/5/23.
// NOTE: To scroll in the simulator, hold down the track pad and then scroll

import Foundation


import UIKit
import MapKit

class OtmTableViewController: UITableViewController {

    // MARK: - Shared data
    var studentLocations: [StudentLocation]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.studentLocations
    }
    
    // MARK: - View Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    // MARK: - Data Provider
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.studentLocations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OtmTableViewCell")!
        
        
        let studentLocation = self.studentLocations[(indexPath as NSIndexPath).row]
        
        // Set the name and image
        cell.textLabel?.text = "\(studentLocation.firstName) \(studentLocation.lastName)"
        cell.imageView?.image = UIImage(named: "icon_pin")
        
        // If the cell has a detail label, we will put the evil scheme in.
        if let detailTextLabel = cell.detailTextLabel {
            detailTextLabel.text = studentLocation.mediaUrl
        }
        
        return cell
    }
    
    // MARK: - Select Cell
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // If the studentLocation has a mediaUrl, open it in safari
        let studentLocation = self.studentLocations[(indexPath as NSIndexPath).row]
        if let url = URL(string: studentLocation.mediaUrl) {
            UIApplication.shared.open(url)
        }
    }
}


