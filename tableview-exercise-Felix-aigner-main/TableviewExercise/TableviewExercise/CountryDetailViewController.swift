//
//  CountryDetailViewController.swift
//  TableviewExercise
//
//  Created by Felix-Xaver Aigner on 15.12.21.
//

import Foundation
import UIKit

class CountryDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var country: Country?
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var currencyLabel: UILabel!
    @IBOutlet var capitalLabel: UILabel!
    @IBOutlet var nativeLabel: UILabel!
    @IBOutlet var continentLabel: UILabel!
    @IBOutlet var phoneLabel: UILabel!
    
    @IBOutlet var languageTableView: UITableView!
    var reusableLanguageCellIdentifier = "languageCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        languageTableView.delegate = self
        
        if let unwrappedCountry = country {
            self.nameLabel.text = unwrappedCountry.name;
            self.currencyLabel.text = unwrappedCountry.currency;
            self.capitalLabel.text = unwrappedCountry.capital;
            self.nativeLabel.text = unwrappedCountry.native;
            self.continentLabel.text = unwrappedCountry.continent;
            self.phoneLabel.text = unwrappedCountry.phone;
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let unwrappedCountry = country {
            return unwrappedCountry.languages.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cell initialization")
        let cell = languageTableView.dequeueReusableCell(withIdentifier: self.reusableLanguageCellIdentifier, for: indexPath);
        
        if let unwrappedCountry = country {
            print(unwrappedCountry.languages[indexPath.row])
            cell.textLabel?.text = unwrappedCountry.languages[indexPath.row]
        }
        return cell
    }
}
