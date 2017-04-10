//
//  SortByCell.swift
//  Yelp
//
//  Created by Padmanabhan, Avinash on 4/9/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol SortByCellDelegate {
    @objc optional func sortByCell(sortBySwitchCell: SortByCell, didChangeValue:Bool)
}

class SortByCell: UITableViewCell {

    @IBOutlet weak var sortByView: UIView!
    @IBOutlet weak var sortByButton: UIButton!
    @IBOutlet weak var sortByLabel: UILabel!
    
    weak var sortByDelegate:SortByCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        sortByView.layer.cornerRadius = 8
        sortByView.layer.borderColor = UIColor.init(red: CGFloat(204)/255, green: CGFloat(204)/255, blue: CGFloat(204)/255, alpha: 1).cgColor
        sortByView.layer.borderWidth = 0.8
        
        let notDoneImage = UIImage(named: "oval")
        sortByButton.setImage(notDoneImage, for: UIControlState.normal)

        sortByButton.addTarget(self, action: #selector(SortByCell.sortByValueChanged), for: UIControlEvents.touchUpInside)
    }
    
    func sortByValueChanged() {
        let doneImage = UIImage(named: "done")
        let notDoneImage = UIImage(named: "oval")
        var isSelected = false
        if(sortByButton.currentImage == notDoneImage){
            sortByButton.setImage(doneImage, for: UIControlState.normal)
            sortByButton.tintColor = UIColor.init(red: CGFloat(0)/255, green: CGFloat(151)/255, blue: (236)/255, alpha: 1)//blue
            isSelected = true
        }
        else {
            sortByButton.setImage(notDoneImage, for: UIControlState.normal)
            sortByButton.tintColor = UIColor.init(red: CGFloat(102)/255, green: CGFloat(102)/255, blue: (102)/255, alpha: 1)//gray
            isSelected = false
        }
        
        sortByDelegate?.sortByCell?(sortBySwitchCell: self, didChangeValue: isSelected)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
