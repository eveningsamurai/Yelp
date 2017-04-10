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

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate, DealCellDelegate, SortByCellDelegate, DistanceCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    //for categories
    var categories: [[String:String]]!
    var switchStates = [Int:Bool]()
    
    //for deals
    var isDealOnState = [Int:Bool]()
    
    //for pre selected sort options
    var sortByState = (rowSelected:0,rowSelectedLabel: "Best Match")
    var sortByOptions:[String]!
    var sortByExpanded = false
    
    //for distance options
    var distanceState = (rowSelected:0,rowSelectedLabel: "Auto")
    var distanceExpanded = false
    var distances:[String]!
    
    //setting up delegate for FiltersView
    weak var delegate: FiltersViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        sortByOptions = ["Best Match","Distance","Rating", "Most Reviewed"]
        distances = ["Auto","0.3 miles", "1 mile","5 mile","20 miles"]
        
        // Do any additional setup after loading the view.
        categories = yelpCategories()

        let dealNib = UINib(nibName: "DealCell", bundle: nil)
        tableView.register(dealNib, forCellReuseIdentifier: "DealCell")
        
        let selectedDropDownNib = UINib(nibName: "SelectedDropDownCell", bundle: nil)
        tableView.register(selectedDropDownNib, forCellReuseIdentifier: "SelectedDropDownCell")
        
        let sortByNib = UINib(nibName: "SortByCell", bundle: nil)
        tableView.register(sortByNib, forCellReuseIdentifier: "SortByCell")
        
        let distanceNib = UINib(nibName: "DistanceCell", bundle: nil)
        tableView.register(distanceNib, forCellReuseIdentifier: "DistanceCell")
    }
    
    @IBAction func onCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSearchButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
        var filters = [String: AnyObject]()
    
        //categories
        var selectedCategories = [String]()
        for (row, isSelected) in switchStates {
            if isSelected {
                selectedCategories.append(categories[row]["code"]!)
            }
        }
        if selectedCategories.count > 0 {
            filters["categories"] = selectedCategories as AnyObject?
        }
        
        //offering deals
        var dealsOn = false
        for (_, isSelected) in isDealOnState{
            if(isSelected){
                dealsOn = true
            }
        }
        filters["dealsOn"] = dealsOn as AnyObject?
        
        //sort by options
        filters["sortBy"] = sortByState.rowSelectedLabel as AnyObject?
        filters["sortByRowIndex"] = sortByState.rowSelected as AnyObject?
        
        //distance options
        filters["distanceRowIndex"] = distanceState.rowSelected as AnyObject?
        filters["distance"] = distanceState.rowSelectedLabel as AnyObject?
        
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return getSection(section: section).sectionLabel
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return categories.count

        if(section == 2) {
            if(sortByExpanded){
                return getSection(section: section).noOfRows
            }
            else{
                return 1
            }
        } else if(section == 3) {
            if(distanceExpanded){
                return getSection(section: section).noOfRows
            }
            else{
                return 1
            }
        } else {
            return getSection(section: section).noOfRows
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
        
            cell.switchLabel.text = categories[indexPath.row]["name"]
            cell.delegate = self
        
            if switchStates[indexPath.row] != nil {
                cell.onSwitch.setOn(switchStates[indexPath.row]!, animated: true)
            } else {
                cell.onSwitch.setOn(false, animated: true)
            }
            
            return cell
        } else if indexPath.section == 2 {
            if(sortByExpanded) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SortByCell", for: indexPath) as! SortByCell
                cell.sortByLabel.text = getSection(section: indexPath.section).rows[indexPath.row]
                cell.sortByDelegate = self
            
                if(sortByState.rowSelected == indexPath.row)
                {
                    cell.sortByButton.setImage(UIImage(named: "done"), for: UIControlState.normal)
                    cell.sortByButton.tintColor = UIColor.init(red: CGFloat(0)/255, green: CGFloat(151)/255, blue: (236)/255, alpha: 1)
                }
                else{
                    cell.sortByButton.setImage(UIImage(named: "oval"), for: UIControlState.normal)
                    cell.sortByButton.tintColor = UIColor.init(red: CGFloat(102)/255, green: CGFloat(102)/255, blue: (102)/255, alpha: 1)
                }
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedDropDownCell", for: indexPath) as! SelectedDropDownCell
                cell.selectedDropDownLabel.text = sortByState.rowSelectedLabel
                return cell
            }
        } else if indexPath.section == 3 {
            print("in distance")
            if(distanceExpanded){
                print("in distance 1")
                let cell = tableView.dequeueReusableCell(withIdentifier: "DistanceCell", for: indexPath) as! DistanceCell
                cell.distanceLabel.text = getSection(section: indexPath.section).rows[indexPath.row]
                cell.distanceDelegate = self
                if(distanceState.rowSelected == indexPath.row)
                {
                    cell.distanceButton.setImage(UIImage(named: "done"), for: UIControlState.normal)
                    cell.distanceButton.tintColor = UIColor.init(red: CGFloat(0)/255, green: CGFloat(151)/255, blue: (236)/255, alpha: 1)
                }
                else{
                    cell.distanceButton.setImage(UIImage(named: "oval"), for: UIControlState.normal)
                    cell.distanceButton.tintColor = UIColor.init(red: CGFloat(102)/255, green: CGFloat(102)/255, blue: (102)/255, alpha: 1)//gray
                }
                return cell
            }
            else{
                print("in distance 2")
                let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedDropDownCell", for: indexPath) as! SelectedDropDownCell
                cell.selectedDropDownLabel.text = distanceState.rowSelectedLabel
                return cell
            }
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DealCell", for: indexPath) as! DealCell
            cell.dealDelegate = self
            cell.dealsLabel?.text = getSection(section: indexPath.section).rows[indexPath.row]
            cell.dealsSwitch.isOn = false
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if(indexPath.section == 2){
            sortByExpanded = !sortByExpanded
            tableView.reloadSections(IndexSet(indexPath), with: UITableViewRowAnimation.fade)
        } else if(indexPath.section == 3) {
            distanceExpanded = !distanceExpanded
            tableView.reloadSections(IndexSet(indexPath), with: UITableViewRowAnimation.fade)
        }
    }
    
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPath(for: switchCell)!
        
        print("filters event view controller got the switch event")
        switchStates[indexPath.row] = value
    }
    
    func dealSwitchCell(dealSwitchCell: DealCell, didChangeValue: Bool) {
        let indexPath = tableView.indexPath(for: dealSwitchCell)!
        isDealOnState[indexPath.row] = didChangeValue
    }
    
    func sortBySwitchCell(sortByCell: SortByCell, didChangeValue: Bool) {
        if(didChangeValue){
            let indexPath = tableView.indexPath(for: sortByCell)!
            sortByState = (rowSelected:indexPath.row,rowSelectedLabel: sortByOptions[indexPath.row])
            sortByExpanded = !sortByExpanded
            tableView.reloadSections(IndexSet(indexPath), with: UITableViewRowAnimation.fade)
        }
    }
    
    func distanceSwitchCell(distanceCell: DistanceCell, didChangeValue: Bool) {
        if(didChangeValue){
            let indexPath = tableView.indexPath(for: distanceCell)!
            distanceState = (rowSelected:indexPath.row,rowSelectedLabel: distances[indexPath.row])
            distanceExpanded = !distanceExpanded
            tableView.reloadSections(IndexSet(indexPath), with: UITableViewRowAnimation.fade)
        }
    }
    
    func getSection(section: Int) -> (noOfRows:Int,sectionLabel: String, rowType: String, rows: [String]) {
        var sectionData:(Int,String,String, [String])?
        switch section {
        case 0:
            sectionData = (1,"","Switch",["Offering a Deal"])
        case 1:
            sectionData = (categories.count,"Category","Dropdown",[])
        case 2:
            sectionData = (3,"Sort By","Dropdown",["Best Match","Distance","Rating"])
        case 3:
            sectionData = (5,"Distance","Dropdown",["Auto","0.3 miles", "1 mile","5 mile","20 miles"])
        default:
            break
        }
        return sectionData!
    }
}
