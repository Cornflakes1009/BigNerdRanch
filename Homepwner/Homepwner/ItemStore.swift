//
//  ItemStore.swift
//  Homepwner
//
//  Created by HaroldDavidson on 12/24/19.
//  Copyright © 2019 HaroldDavidson. All rights reserved.
//

import UIKit

class ItemStore {
    var allItems = [Item]()
    
    // discardable means that the caller of the function can ignore the result of calling the function
    @discardableResult func createItem() -> Item {
        let newItem = Item(random: true)
        
        allItems.append(newItem)
        
        return newItem
    }
    
    func removeItem(_ item: Item) {
        if let index = allItems.firstIndex(of: item) {
            allItems.remove(at: index)
        }
    }
    
    func moveItem(from fromIndex: Int, to toIndex: Int) {
        if(fromIndex == toIndex) {
            return
        }
        
        // get reference to object being moved so can reinsert it
        let movedItem = allItems[fromIndex]
        
        // remove item from array
        allItems.remove(at: fromIndex)
        
        // insert item into array at new location
        allItems.insert(movedItem, at: toIndex)
    }
}
