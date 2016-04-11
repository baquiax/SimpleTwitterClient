//
//  HashtagViewController.swift
//  SimpleTwitterClient
//
//  Created by Alexander Baquiax on 4/8/16.
//  Copyright © 2016 Alexander Baquiax. All rights reserved.
//

import Foundation
import UIKit

class HashtagViewController : LastTweetsViewController , UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    var textToSearch = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
    }

    override func loadData() {
        self.loader.hidden = false
        self.loader.startAnimating()
        if let _ = NSUserDefaults.standardUserDefaults().objectForKey("user") {
            if (self.textToSearch.isEqual("")) {
                self.loader.stopAnimating()
                return
            }
            TwitterClient.getTwitterClient().client.get("https://api.twitter.com/1.1/search/tweets.json", parameters: ["count" : 100, "q" : self.textToSearch], headers: nil, success: { data, response in
                do {
                    let result = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! NSDictionary
                    self.data = result.objectForKey("statuses") as! NSArray
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
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        self.textToSearch = searchText
        loadData()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TwitterPostHashtag", forIndexPath: indexPath) as! TwitterPostCell
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
    
    
}