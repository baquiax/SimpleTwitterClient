//
//  TwitterPostCell.swift
//  SimpleTwitterClient
//
//  Created by Alexander Baquiax on 4/8/16.
//  Copyright © 2016 Alexander Baquiax. All rights reserved.
//

import Foundation
import UIKit

public class TwitterPostCell : UITableViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var tweet: UITextView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var username: UILabel!
    
    weak var dataTask: NSURLSessionDataTask?

    public override func awakeFromNib() {
        super.awakeFromNib()
        profileImage.image = UIImage(named: "hashtag")
    }
}