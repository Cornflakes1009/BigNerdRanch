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

    // MARK: Add Button
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        // create new item and add to store
        let newItem = itemStore.createItem()
        
        if let index = itemStore.allItems.firstIndex(of: newItem) {
            let indexPath = IndexPath(row: index, section: 0)
            
            // insert this new row into the table
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    // MARK: Edit Button
//    @IBAction func toggleEditingMode(_ sender: UIButton) {
//        // if you are currently in editing mode
//        if(isEditing) {
//            sender.setTitle("Edit", for: .normal)
//            // turning off editing
//            setEditing(false, animated: true)
//        } else {
//            sender.setTitle("Done", for: .normal)
//            // entering edit mode
//            setEditing(true, animated: true)
//        }
//    }
    
    // MARK: Number of Rows in Section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemStore.allItems.count
    }
    
    // MARK: Building the TableView - cellForRowAt
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        
        let item = itemStore.allItems[indexPath.row]
        
        // configure the cell with the item
        cell.nameLabel.text = item.name
        cell.serialNumberLabel.text = item.serialNumber
        cell.valueLabel.text = "$\(item.valueInDollars)"
        if(item.valueInDollars >= 50) {
            cell.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        } else {
            cell.backgroundColor = #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)
        }
        
        return cell
    }
    
    // MARK: Deleting Items
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // if the table view is asking to commit a delete command
        if editingStyle == .delete {
            let item = itemStore.allItems[indexPath.row]
            
            // MARK: alert stuff
            let title = "Delete \(item.name)?"
            let message = "Are you sure you want to delete this item?"
            
            let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            ac.addAction(cancelAction)
            let deleteAction = UIAlertAction(title: "Remove", style: .destructive, handler: {
                (action) -> Void in
                // remove the item from the store
                self.itemStore.removeItem(item)
                
                // removing the row from the tableview with animation
                tableView.deleteRows(at: [indexPath], with: .automatic)
            })
            ac.addAction(deleteAction)
            
            // present the alert controller
            present(ac, animated: true, completion: nil)
        }
    }
    
    // MARK: Reordering Items
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // update the model
        itemStore.moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // determining which segue was triggered
        switch segue.identifier {
        case "showItem"?:
            // figuring out which row was just tapped
            if let row = tableView.indexPathForSelectedRow?.row {
                // getting the item associated with the row
                let item = itemStore.allItems[row]
                
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.item = item
            }
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
        
        
    }
    
    // creating the left bar button item - this automatically triggers editing mode
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData() 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 65
    }
    
    
}
