//
//  GlanceController.swift
//  AppleWatch Extension
//
//  Created by jianghai on 15/11/17.
//  Copyright © 2015年 jianghai. All rights reserved.
//

import WatchKit
import Foundation


class GlanceController: WKInterfaceController {

    @IBOutlet var messageLabel: WKInterfaceLabel!
    @IBOutlet var image: WKInterfaceImage!
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        
        let message = ["message" : "from Glance"];
        self.updateUserActivity("xx", userInfo: message, webpageURL: nil)
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
