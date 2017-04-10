//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MBProgressHUD

class BusinessesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FiltersViewControllerDelegate, UISearchBarDelegate {
    
    var businesses: [Business]!
    var filteredBusinesses: [Business]!
    var distancesInMeters:[Double]!
    
    var searchBar = UISearchBar()
    var searchActive = false
    
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
        searchBar.delegate = self
        
        // add searchbar to top navigation bar
        searchBar.placeholder = "Restaurant name..."
        navigationItem.titleView = self.searchBar
        
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
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // populate businessesFiltered array based on business names
        filteredBusinesses = businesses?.filter({ (business) -> Bool in
            let businessName = business.name
            print(businessName!)
            let range = businessName?.lowercased().range(of: searchText.lowercased(), options: .regularExpression)
            
            return range != nil
        })

        if(filteredBusinesses!.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        
        self.tableView.reloadData()
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive {
            return filteredBusinesses.count
        }
        else if businesses != nil {
            return businesses.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell") as! BusinessCell
        if searchActive {
            cell.business = filteredBusinesses[indexPath.row]
        } else {
            cell.business = businesses[indexPath.row]
        }
        
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
        
        let sortByRowIndex = filters["sortByRowIndex"] as? Int
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
        let distance = filters["distance"] as? String
        let distancesInMeters = [0, 0.3 * 1609.34, 1609.34, 5 * 1609.34 , 20 * 1609.34]

        //update filters used to pass it to filter view
        currentFilters.sortMode = sortyBy!
        currentFilters.sortRowIndex = sortByRowIndex!
        currentFilters.distanceRowIndex = distanceRow!
        currentFilters.distance = distance!
        currentFilters.isDealON = dealsOn!
        
        Business.searchWithTerm(term: "Restaurants", distance: distancesInMeters[distanceRow!], sort: sortByMode, categories: categories, deals: dealsOn) {
            (businesses: [Business]?, error: Error?) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
        }
    }
}
