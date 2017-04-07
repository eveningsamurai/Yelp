//
//  BusinessCell.swift
//  Yelp
//
//  Created by Padmanabhan, Avinash on 4/7/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import AFNetworking

class BusinessCell: UITableViewCell {

    @IBOutlet weak var businessImage: UIImageView!
    @IBOutlet weak var businessName: UILabel!
    @IBOutlet weak var businessDistance: UILabel!
    @IBOutlet weak var businessRating: UIImageView!
    @IBOutlet weak var businessNumReviews: UILabel!
    @IBOutlet weak var businessDollars: UILabel!
    @IBOutlet weak var businessAddress: UILabel!
    @IBOutlet weak var businessCategories: UILabel!
    
    var business: Business! {
        didSet {
            businessName.text = business.name
            businessDistance.text = business.distance
            if let reviewCount = business.reviewCount {
                businessNumReviews.text = "\(reviewCount) Reviews"
            }
            businessDistance.text = business.distance
            businessCategories.text = business.categories
            businessImage.setImageWith(business.imageURL!)
            businessRating.setImageWith(business.ratingImageURL!)
            businessAddress.text = business.address
            businessDollars.text = "$$"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        businessImage.layer.cornerRadius = 4
        businessImage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
