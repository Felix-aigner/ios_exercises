//
//  CountryViewController.swift
//  TableviewExercise
//
//  Created by Felix-Xaver Aigner on 10.12.21.
//

import Foundation
import UIKit

class CountryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var reusableCellIdentifier = "countryCell"
    
    
    
    @IBOutlet var tableview: UITableView!
    
    var urlSessionHandler: Networking?
    var countries: [Country]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.delegate = self
        
        
        let callback: (_ countries: [Country]?,_ error: NetworkingError?) -> () = { (countryList, error) in
            DispatchQueue.main.async {
                if let countries = countryList {
                    print(countries)
                    self.countries = countries
                    self.tableview.reloadData()
                }
                if let error = error {
                    print(error)
                }
            }
        }
        urlSessionHandler?.downloadCountries(completionHandler: callback)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillAppear(animated)
        if let selected = tableview.indexPathForSelectedRow {
            tableview.deselectRow(at: selected, animated: false)
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
         if let countryCount = countries?.count {
            return countryCount
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.reusableCellIdentifier, for: indexPath);
        
        if let unwrappedCountries = countries {
            cell.textLabel?.text = unwrappedCountries[indexPath.row].name
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSeque" {
            if let countryDetailViewController = segue.destination as? CountryDetailViewController {
                if let selected = self.tableview.indexPathForSelectedRow, let countries = countries {
                    countryDetailViewController.country = countries[selected.row]
                }
            }
        }
        
    }
}
