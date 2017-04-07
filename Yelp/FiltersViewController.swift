//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Padmanabhan, Avinash on 4/7/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
    @objc func filtersViewController(filterViewController: FiltersViewController, didUpdateFilters filters: [String: AnyObject])
}

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var categories: [[String:String]]!
    var switchStates = [Int:Bool]()
    weak var delegate: FiltersViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Do any additional setup after loading the view.
        categories = yelpCategories()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSearchButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
        var filters = [String: AnyObject]()
        
        var selectedCategories = [String]()
        for (row, isSelected) in switchStates {
            if isSelected {
                selectedCategories.append(categories[row]["code"]!)
            }
        }
        if selectedCategories.count > 0 {
            filters["categories"] = selectedCategories as AnyObject?
        }
        delegate?.filtersViewController(filterViewController: self, didUpdateFilters: filters)
    }
    
    func yelpCategories() -> [[String:String]] {
        return
            [
                ["name": "Afghan", "code": "afghani"],
                ["name": "Tapas Bars", "code": "tapas"],
                ["name": "Thai", "code": "thai"],
                ["name": "Turkish", "code": "turkish"],
                ["name": "Vietnamese", "code": "vietnamese"]
            ]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
        
        cell.switchLabel.text = categories[indexPath.row]["name"]
        cell.delegate = self
        
        if switchStates[indexPath.row] != nil {
            cell.onSwitch.setOn(switchStates[indexPath.row]!, animated: true)
        } else {
            cell.onSwitch.setOn(false, animated: true)
        }
        
        return cell
    }
    
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPath(for: switchCell)!
        
        print("filters event view controller got the switch event")
        switchStates[indexPath.row] = value
    }
    
}
