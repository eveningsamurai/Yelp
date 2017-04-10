//
//  DealCell.swift
//  Yelp
//
//  Created by Padmanabhan, Avinash on 4/9/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol DealCellDelegate {
    @objc optional func dealCell(dealSwitchCell: DealCell, didChangeValue:Bool)
}

class DealCell: UITableViewCell {

    @IBOutlet weak var dealsLabel: UILabel!
    @IBOutlet weak var dealsSwitch: UISwitch!
    @IBOutlet weak var dealsSwitchView: UIView!
    
    weak var dealDelegate:DealCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        dealsSwitch.addTarget(self, action: #selector(DealCell.dealValueChanged), for: UIControlEvents.valueChanged)
    }

    func dealValueChanged() {
        dealDelegate?.dealCell?(dealSwitchCell: self, didChangeValue: dealsSwitch.isOn)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
