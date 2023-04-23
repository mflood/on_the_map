//
//  OtmTableViewController.swift
//  On The Map
//
//  Created by Matthew Flood on 3/5/23.
// NOTE: To scroll in the simulator, hold down the track pad and then scroll

import Foundation


import UIKit
import MapKit

class OtmTableViewController: UIViewController {
    
    @IBOutlet var peopleTableView: UITableView!
    
    // MARK: - Shared data
    var studentLocations: [StudentInformation]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.studentInformation
    }
    
    // MARK: - View Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        peopleTableView.delegate = self
        peopleTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.peopleTableView.reloadData()
    }
}

// MARK: - TableView Delegate

extension OtmTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OtmTableViewCell")!
        
        
        let studentLocation = studentLocations[(indexPath as NSIndexPath).row]
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // If the studentLocation has a mediaUrl, open it in safari
        let studentLocation = studentLocations[(indexPath as NSIndexPath).row]
        if let url = URL(string: studentLocation.mediaUrl) {
            UIApplication.shared.open(url)
        }
    }
}


