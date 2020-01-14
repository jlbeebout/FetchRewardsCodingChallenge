//
//  ViewController.swift
//  Fetch Rewards Coding Challenge
//
//  Created by Jonathan Beebout on 1/10/20.
//  Copyright © 2020 Jonathan Beebout. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  
  struct DataObject: Decodable{
    let id: Int?
    let listId: Int?
    let name: String?
  }
  
  var apiData = [DataObject]()
  var sectionedData = [[DataObject]]()
  var listIdOccurrences: [Int: Int] = [:]

  override func viewDidLoad() {
    super.viewDidLoad()
    getApiData()
  }

  func getApiData() {
    //Url for Http call
    let url = URL(string: "https://api.jsonbin.io/b/5e0f707f56e18149ebbebf5f")!
    
    //Create request for HTTP call setting header with access key
    var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30.0)
    request.setValue("$2b$10$Vr2RAD3mpzFZ6o8bPZNlgOOM0LmFLvN24IoxlELo3arTgNszX7otS", forHTTPHeaderField: "secret-key")
    
    //On completion, decode JSON and initiate filtering and sorting of data
    URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
      if error != nil {
        print(error!)
      }
      if data != nil {
        do {
          self.apiData = try JSONDecoder().decode([DataObject].self, from: data!)
          self.filterAndSortData()
          } catch {
            print("Unable to parse JSON response")
            print("Caught: \(error)")
          }
       } else {
          print("Received empty response.")
       }
    }).resume()
  }
  
  func filterAndSortData() {
    //Remove unnamed items and nil named items
    self.apiData = self.apiData.filter { $0.name != "" && $0.name != nil }
    
    //Create a dictionary of listId occurences
    self.listIdOccurrences = self.apiData.map{ $0.listId }.reduce(into: [:]) { $0[$1!, default: 0] += 1 }
    
    //Create a sorted array of listId's
    let componentArray = Array(listIdOccurrences.keys).sorted()
    
    //Itererate through listId's in order and append array of filtered data
    for section in componentArray {
      self.sectionedData.append(self.apiData.filter {$0.listId == section})
    }
    
    //Sort each section array
    for index in 0...sectionedData.count - 1 {
      sectionedData[index].sort { $0.id! < $1.id! }
    }
    
    //Update table
    DispatchQueue.main.async { self.tableView.reloadData() }
  }
  
  //Retrieve number of rows in section from Dictionary lookup of section key
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.listIdOccurrences[section + 1]!
  }
  
  //Get number of sections from dictionary count
  func numberOfSections(in tableView: UITableView) -> Int {
    return listIdOccurrences.count
  }
  
  //Set title for section
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "Section \(section + 1)"
  }
  
  //Set tableview height
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 25.0
  }
  
  //Handle population of tableview cells
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell")! as! MainTableViewCell
    cell.nameLabel.text = self.sectionedData[indexPath.section][indexPath.row].name
    return cell
  }
}

