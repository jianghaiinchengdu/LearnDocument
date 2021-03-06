//
//  ComplicationController.swift
//  AppleWatch Extension
//
//  Created by jianghai on 15/11/17.
//  Copyright © 2015年 jianghai. All rights reserved.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    
    var allData : [CLKComplicationTimelineEntry]?
    
    override init() {
        super.init()
    }
    
     func getSupportedTimeTravelDirectionsForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTimeTravelDirections) -> Void){
        handler([.Backward,.Forward])
    }
    
    func getTimelineEntriesForComplication(complication: CLKComplication, afterDate date: NSDate, limit: Int, withHandler handler: ([CLKComplicationTimelineEntry]?) -> Void){
    
        var entries : [CLKComplicationTimelineEntry] = [CLKComplicationTimelineEntry]()
        
        for i in 1...3{
            
            var entry2 : CLKComplicationTimelineEntry?

            
            let textTemplate = CLKComplicationTemplateModularLargeStandardBody()
            textTemplate.body1TextProvider = CLKSimpleTextProvider(text: "\(33*i)")
            textTemplate.body2TextProvider = CLKSimpleTextProvider(text: "\(i)hourlater")
            textTemplate.headerTextProvider = CLKSimpleTextProvider(text: "yejing\(i)")
            entry2 = CLKComplicationTimelineEntry(date: date.dateByAddingTimeInterval(Double(i*600)), complicationTemplate: textTemplate)
            
            entries.append(entry2!)
        }
        allData = entries
        handler(entries)
    }
    
    func getCurrentTimelineEntryForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTimelineEntry?) -> Void){
        var entry : CLKComplicationTimelineEntry?
        let now = NSDate()
        
        // Create the template and timeline entry.
        if complication.family == .ModularSmall {
            let longText = "22222222"
            let shortText = "555"
            
            let textTemplate = CLKComplicationTemplateModularSmallStackText()
            textTemplate.line1TextProvider = CLKSimpleTextProvider(text: longText)
            textTemplate.line2TextProvider = CLKSimpleTextProvider(text: shortText)
            
            // Create the entry.
            entry = CLKComplicationTimelineEntry(date: now, complicationTemplate: textTemplate)
        }
        else if complication.family == .ModularLarge{
            if let entries = self.allData{
                
                for aItem in entries{
                    if aItem.date == NSDate(){
                        handler(aItem)
                        return
                    }
                    
                }
            }
            let textTemplate = CLKComplicationTemplateModularLargeStandardBody()
            
            textTemplate.body1TextProvider = CLKSimpleTextProvider(text: "meeting")
            textTemplate.body2TextProvider = CLKSimpleTextProvider(text: "4hourlater")
            textTemplate.headerTextProvider = CLKSimpleTextProvider(text: "yejing")
             entry = CLKComplicationTimelineEntry(date: NSDate(timeIntervalSinceNow: 20), complicationTemplate: textTemplate)
        }else if complication.family == .UtilitarianSmall{
            let textTemplate = CLKComplicationTemplateUtilitarianSmallFlat()
            
            let image = UIImage(named: "rain")
            textTemplate.textProvider = CLKSimpleTextProvider(text: "meeting")
            textTemplate.imageProvider = CLKImageProvider(onePieceImage: image!)
            entry = CLKComplicationTimelineEntry(date: NSDate(timeIntervalSinceNow: 20), complicationTemplate: textTemplate)
            
        }
        
        // Pass the timeline entry back to ClockKit.
        handler(entry)
    }
     func getPlaceholderTemplateForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTemplate?) -> Void){
        if complication.family == .ModularLarge{
            
            let template = CLKComplicationTemplateModularLargeTable()
            
            template.headerTextProvider = CLKSimpleTextProvider(text: "head")
            template.row1Column1TextProvider = CLKSimpleTextProvider(text: "r1c1")
            template.row1Column2TextProvider = CLKSimpleTextProvider(text: "r1c2")
            template.row2Column1TextProvider = CLKSimpleTextProvider(text: "r2c1")
            template.row2Column2TextProvider = CLKSimpleTextProvider(text: "r2c2")
            
            handler(template)
        }
    }
    
}
