//
//  SelectedDropDownCell.swift
//  Yelp
//
//  Created by Padmanabhan, Avinash on 4/9/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class SelectedDropDownCell: UITableViewCell {

    @IBOutlet weak var selectedDropDownLabel: UILabel!
    @IBOutlet weak var selectedDropDownImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectedDropDownImageView.layer.cornerRadius = 10
        selectedDropDownImageView.layer.borderColor = UIColor.init(red: CGFloat(204)/255, green: CGFloat(204)/255, blue: CGFloat(204)/255, alpha: 1).cgColor
        selectedDropDownImageView.layer.borderWidth = 1

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
