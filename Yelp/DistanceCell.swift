//
//  DistanceCell.swift
//  Yelp
//
//  Created by Padmanabhan, Avinash on 4/9/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol DistanceCellDelegate {
    @objc optional func distanceCell(distanceSwitchCell: DistanceCell, didChangeValue:Bool)
}

class DistanceCell: UITableViewCell {

    @IBOutlet weak var distanceCellView: UIView!
    @IBOutlet weak var distanceButton: UIButton!
    @IBOutlet weak var distanceLabel: UILabel!
    
    weak var distanceDelegate:DistanceCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        distanceCellView.layer.cornerRadius = 8
        distanceCellView.layer.borderColor = UIColor.init(red: CGFloat(204)/255, green: CGFloat(204)/255, blue: CGFloat(204)/255, alpha: 1).cgColor
        distanceCellView.layer.borderWidth = 0.8
        
        let notDoneImage = UIImage(named: "oval")
        distanceButton.setImage(notDoneImage, for: UIControlState.normal)
        distanceButton.addTarget(self, action: #selector(DistanceCell.distanceValueChanged), for: UIControlEvents.touchUpInside)
    }
    
    func distanceValueChanged() {
        let doneImage = UIImage(named: "done")
        let notDoneImage = UIImage(named: "oval")
        var isSelected = false
        if(distanceButton.currentImage == notDoneImage){
            distanceButton.setImage(doneImage, for: UIControlState.normal)
            distanceButton.tintColor = UIColor.init(red: CGFloat(0)/255, green: CGFloat(151)/255, blue: (236)/255, alpha: 1)//blue
            isSelected = true
        }
        else {
            distanceButton.setImage(notDoneImage, for: UIControlState.normal)
            distanceButton.tintColor = UIColor.init(red: CGFloat(102)/255, green: CGFloat(102)/255, blue: (102)/255, alpha: 1)//gray
            isSelected = false
        }
        distanceDelegate?.distanceCell?(distanceSwitchCell: self, didChangeValue: isSelected)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
