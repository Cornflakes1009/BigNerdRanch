//
//  ItemsViewController.swift
//  Homepwner
//
//  Created by HaroldDavidson on 12/24/19.
//  Copyright © 2019 HaroldDavidson. All rights reserved.
//

import UIKit

class ItemsViewController: UITableViewController {
    var itemStore: ItemStore!
    let sections = ["Less Than $50", "More than or equal to $50"]
    var items = [[Item]]()
    var lessThan50Dollars = [Item]()
    var greaterThan50Dollars = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let lastRow = Item(name: "No More Rows", serialNumber: "", valueInDollars: 1000000)
        itemStore.allItems.append(lastRow)
        
        for item in itemStore.allItems {
            if(item.valueInDollars >= 50) {
                greaterThan50Dollars.append(item)
            } else {
                lessThan50Dollars.append(item)
            }
        }
        
        items.append(lessThan50Dollars)
        items.append(greaterThan50Dollars)
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return itemStore.allItems.count
        return items[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        
        let item = itemStore.allItems[indexPath.row]

        cell.textLabel?.text = item.name
        cell.textLabel?.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        cell.backgroundColor = #colorLiteral(red: 0.5810584426, green: 0.1285524964, blue: 0.5745313764, alpha: 1)
        
        if (item.valueInDollars != 1000000) {
            cell.detailTextLabel?.text = "$" + String(items[indexPath.section][indexPath.row].valueInDollars)
        }
            
        
        
        cell.detailTextLabel?.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        return cell
    }

//    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//
//        if(section == sections.count - 1) {
//            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
//            footerView.backgroundColor = .red
//            let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 21))
//            label.center = CGPoint(x: 160, y: 285)
//            label.textAlignment = .center
//            label.text = "No more rows"
//            footerView.addSubview(label)
//            return footerView
//        } else {
//            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
//            return footerView
//        }
//
//    }
    
    
}
