//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MBProgressHUD

class BusinessesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FiltersViewControllerDelegate {
    
    var businesses: [Business]!
    var currentFilters = (
        sortMode: "Best Match",
        sortRowIndex:0,
        isDealON: false,
        distance: "Auto",
        distanceRowIndex:0
    )
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Business.searchWithTerm(term: "Thai", completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            self.businesses = businesses
            MBProgressHUD.hide(for: self.view, animated: true)
            self.tableView.reloadData()
            if let businesses = businesses {
                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                }
            }
            
            }
        )
        
        /* Example of Yelp search with more search options specified
         Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
         self.businesses = businesses
         
         for business in businesses {
         print(business.name!)
         print(business.address!)
         }
         }
         */
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil {
            return businesses.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell") as! BusinessCell
        cell.business = businesses[indexPath.row]
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let filtersViewController = navigationController.topViewController as! FiltersViewController
        
        filtersViewController.delegate = self
    }
    
    func filtersViewController(filterViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject]) {
        
        let categories = filters["categories"] as? [String]
        
        let dealsOn = filters["dealsOn"] as? Bool
        
        let sortyBy = filters["sortBy"] as? String
        
        var sortByMode = YelpSortMode.bestMatched
        if(sortyBy == "Best Match"){
            sortByMode = YelpSortMode.bestMatched
        }
        else if(sortyBy == "Distance"){
            sortByMode = YelpSortMode.distance
        }
        else if(sortyBy == "Rating"){
            sortByMode = YelpSortMode.highestRated
        }
        
        let distanceRow = filters["distanceRowIndex"] as? Int
        let distancesInMeters = [0, 0.3 * 1609.34, 1609.34, 5 * 1609.34 , 20 * 1609.34]

        Business.searchWithTerm(term: "Restaurants", distance: distancesInMeters[distanceRow!], sort: sortByMode, categories: categories, deals: dealsOn) {
            (businesses: [Business]?, error: Error?) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
        }
    }
}
