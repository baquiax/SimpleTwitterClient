//
//  LastTweetsViewController.swift
//  SimpleTwitterClient
//
//  Created by Alexander Baquiax on 4/8/16.
//  Copyright © 2016 Alexander Baquiax. All rights reserved.
//

import Foundation
import UIKit

public class LastTweetsViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet var tableView: UITableView!
    var urlSession: NSURLSession!
    var data : NSArray = NSArray()
    
    public override func viewDidLoad() {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        self.urlSession = NSURLSession(configuration: configuration)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.loader.hidesWhenStopped = true
        
        loadData()
    }
    
    
    func loadData () {
        self.loader.hidden = false
        self.loader.startAnimating()
        if let user = NSUserDefaults.standardUserDefaults().objectForKey("user") {
            print("UserId: ", user.objectForKey("user_id")!)
            TwitterClient.getTwitterClient().client.get("https://api.twitter.com/1.1/statuses/home_timeline.json", parameters: ["count" : 100], headers: nil, success: { data, response in
                do {
                    self.data = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! NSArray
                } catch {
                    self.data = NSArray()
                }
                self.tableView.reloadData()
                self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
                self.loader.stopAnimating()
                }, failure: { (error) -> Void in
            })
        } else {
            self.loader.stopAnimating()
        }
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TwitterPost", forIndexPath: indexPath) as! TwitterPostCell
        let item = self.data.objectAtIndex(indexPath.row) as! NSDictionary
        if let user = item.objectForKey("user") as? NSDictionary {
            if let name = user.objectForKey("name") as? String {
                cell.name.text = name
            }
            if let screenName = user.objectForKey("screen_name") as? String {
                cell.username.text = screenName
            }
            if let imageStringURL = user.objectForKey("profile_image_url") as? String {
                let imageURL = NSURL(string: imageStringURL)
                let request = NSURLRequest(URL: imageURL!)
                cell.dataTask = self.urlSession.dataTaskWithRequest(request) { (data, response, error) -> Void in
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        if error == nil && data != nil {
                            let image = UIImage(data: data!)
                            cell.profileImage.image = image
                        }
                    })
                    
                }
                cell.dataTask?.resume()
            }
        }
        
        if let text = item.objectForKey("text") as? String {
            cell.tweet.text = text
        }
        
        
        return cell
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 115;
    }
    
    public func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = cell as? TwitterPostCell {
            print("Canceling download!")
            cell.dataTask?.cancel()
        }
    }
    
    @IBAction func afterLongPress(sender: UILongPressGestureRecognizer) {
        print("Long press has been succed!")
        self.loadData()
    }
}
