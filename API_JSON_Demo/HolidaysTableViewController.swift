//
//  HolidaysTableViewController.swift
//  API_JSON_Demo
//
//  Created by Chinh on 10/8/19.
//  Copyright © 2019 Chinh. All rights reserved.
//

import UIKit

class HolidaysTableViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    var listOfHolidays = [HolidayDetail](){
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.navigationItem.title = "\(self.listOfHolidays.count) Holidays found"

            }
        }
    }
    var url : URL!
    let resourceURL:URL! = nil
    let API_KEY = "699c588b1b1e800ced002fa836be54abbc10ee7d"
    
    func getCountryCode(countrycode:String){
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy"
        let currentYear = format.string(from: date)
        let resourceString = "https://calendarific.com/api/v2/holidays?api_key=\(API_KEY)&country=\(countrycode)&year=\(currentYear)"
        guard let resourceURL = URL(string: resourceString) else { fatalError()}
        self.url = resourceURL
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    func getHolidays(){
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let jsonData = data else {
                return
            }
            do {
                let holidayDecoder = try JSONDecoder().decode(HolidayResponse.self, from: jsonData)
                self.listOfHolidays = holidayDecoder.response.holidays
                print(self.listOfHolidays)
            } catch let jsonErr {
                print("Err",jsonErr)
            }
            
            }.resume()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listOfHolidays.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let holiday = listOfHolidays[indexPath.row]
        cell.textLabel?.text = holiday.name
        cell.detailTextLabel?.text = holiday.date.iso
        return cell
    }

}
extension HolidaysTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBarText = searchBar.text else {return}
        getCountryCode(countrycode: searchBarText)
        getHolidays()
    }
}
