//
//  TableController.swift
//  AppleWatchDemo
//
//  Created by jianghai on 15/11/20.
//  Copyright © 2015年 jianghai. All rights reserved.
//

import WatchKit

class TableController: WKInterfaceController {
    
    
    @IBOutlet var myTitle: WKInterfaceLabel!
    @IBOutlet var table: WKInterfaceTable!
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
//        table.setNumberOfRows(3, withRowType: "MyRowType")
        let image = UIImage(named:"left")
        self.addMenuItemWithImage(image!, title: "Second", action: Selector("domenuAction:"))
    }
    
    @IBAction func firstItemAction() {
        
        print("111111111111111111")
    }
    func domenuAction(sender:AnyObject){
        print("___________")
    }
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        
    }

    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
}