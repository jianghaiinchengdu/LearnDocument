//
//  UIView+MLLSegmentView.swift
//  MLLSegmentView
//
//  Created by jianghai on 15/12/15.
//  Copyright © 2015年 jianghai. All rights reserved.
//

import UIKit

public class MLLSegmentView: UIScrollView {
    
    var segmentViewDelegate : MLLSegmentViewDelegate?
    
    private var allSegments : [MLLSegmentItem] = [MLLSegmentItem]()
    
    public var numberOfSegments: Int{
        get{
            return self.allSegments.count
        }
    }
    
    public var selectedSegmentIndex: Int?
    public var selectedUnderLineView : UIView?
    public var selectedUnderLineHeight : CGFloat = 5
    
    //    public var segmentBackgroundColor : UIColor?{
    //        didSet(newValue){
    //            self.selectedUnderLineView?.backgroundColor = UIColor.blueColor()
    //        }
    //    }
    //    public var segmentBorderColor : UIColor?{
    //        didSet(newValue){
    //            self.selectedUnderLineView?.backgroundColor = UIColor.blueColor()
    //        }
    //    }
    public var segmentUnderLineColor : UIColor?{
        didSet(newValue){
            self.selectedUnderLineView?.backgroundColor = UIColor.blueColor()
        }
    }
    //TODO: margin
    //    var segmentLeftMargin : Float? = 0
    //    var segmentRightMargin : Float? = 0
    //    var segmentTopMargin : Float? = 0
    //    var segmentBottomMargin : Float? = 0
    
    
    //MARK:init method
    public init(_ frame : CGRect , items: [AnyObject]?){ // items can be NSStrings or MLLSegmentItem
        super.init(frame: frame)
        
        guard let inItems = items else {return}
        for item in inItems{
            if item is String{
                guard let title = item as? String else{ fatalError("item could not be nil")}
                let insertItem = MLLSegmentItem(title: title, index:numberOfSegments)
                insertItem.addTarget(self, action: Selector("segmentItemTouched:"), forControlEvents: .TouchUpInside)
                allSegments.insert(insertItem, atIndex: numberOfSegments)
                self.addSubview(insertItem)
            }
            if item is MLLSegmentItem{
                guard let insertItem = item as? MLLSegmentItem else{ fatalError("item could not be nil")}
                insertItem.addTarget(self, action: Selector("segmentItemTouched:"), forControlEvents: .TouchUpInside)
                allSegments.insert(insertItem, atIndex: numberOfSegments)
                self.addSubview(insertItem)
            }
            
        }
        initSelectedBottomLine()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initSelectedBottomLine(){
        self.selectedUnderLineView = UIView(frame: CGRectMake(0,
            self.frame.size.height - self.selectedUnderLineHeight,
            self.frame.size.width,
            self.selectedUnderLineHeight))
        self.segmentUnderLineColor = UIColor.blueColor()
        self.addSubview(selectedUnderLineView!)
    }
    
    
    var shouldLayoutItems : Bool = true
    
    func setNeedsLayoutSegmentItems() {
        self.shouldLayoutItems = true
        self.setNeedsLayout()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        if !self.shouldLayoutItems{
            return
        }
        
        var originalX : CGFloat = 0
        var contentSize : CGSize = CGSizeMake(0, self.frame.size.height)
        
        for item in allSegments{
            if item.frame == CGRectZero{
                item.frame = CGRectMake(originalX, 0, item.defaultWidth, self.frame.size.height - selectedUnderLineHeight)
            }else{
                item.frame = CGRectMake(originalX, 0, item.frame.size.width, item.frame.size.height)
            }
            originalX += item.frame.size.width
            contentSize = CGSizeMake(contentSize.width + item.frame.size.width, contentSize.height)
        }
        self.contentSize = contentSize
        
        if let index = selectedSegmentIndex {
            let selectedItem = allSegments[index]
            if let segmentDelegate = segmentViewDelegate{
                segmentDelegate.segmentView?(self, willStartAnimationWithIndex: index)
            }
            UIView .animateWithDuration(0.2, delay: 0, usingSpringWithDamping: 0.45, initialSpringVelocity: 0.5, options: .CurveEaseOut, animations: { () -> Void in
                
                self.selectedUnderLineView?.frame = CGRectMake(selectedItem.frame.origin.x,
                    self.frame.size.height - self.selectedUnderLineHeight,
                    self.allSegments[index].frame.size.width,
                    self.selectedUnderLineHeight)
                
                }, completion: { (finished : Bool) -> Void in
                    if let segmentDelegate = self.segmentViewDelegate{
                        segmentDelegate.segmentView?(self, didStopAnimationWithIndex: index)
                        self.shouldLayoutItems = false
                    }
            })
        }
    }
    
    //MARK:UIControl Event
    func segmentItemTouched(sender : MLLSegmentItem){
        self.selectedSegmentIndex = sender.index
        if let segmentDelegate = self.segmentViewDelegate{
            segmentDelegate.segmentView(self, didSelectedAtIndex: sender.index)
        }
        setNeedsLayoutSegmentItems()
    }
    //MARK:
    //MARK:control method
    public func insertSegmentWithTitle(title: String?, atIndex segment: Int){
        
        if allSegments.count > (segment - 1){
            let item = MLLSegmentItem(title: title, index:segment)
            allSegments.insert(item, atIndex: segment)
            
            for updateIndex in segment+1..<self.numberOfSegments{
                allSegments[updateIndex].index += 1
            }
            setNeedsLayoutSegmentItems()
        }
    }
    public func insertSegmentWithItem(item: MLLSegmentItem?, atIndex segment: Int){
        if allSegments.count > (segment - 1){
            guard let insertItem = item else{ return}
            allSegments.insert(insertItem, atIndex: segment)
            
            for updateIndex in segment+1..<self.numberOfSegments{
                allSegments[updateIndex].index += 1
            }
            setNeedsLayoutSegmentItems()
        }
    }
    public func removeSegmentAtIndex(segment: Int){
        if allSegments.count >= segment{
            
            for updateIndex in segment+1..<self.numberOfSegments{
                allSegments[updateIndex].index -= 1
            }
            allSegments[segment].removeFromSuperview()
            allSegments.removeAtIndex(segment)
            setNeedsLayoutSegmentItems()
        }
    }
    public func removeAllSegments(){
        for item in allSegments{
            item.removeFromSuperview()
        }
        allSegments.removeAll()
        selectedSegmentIndex = nil
        setNeedsLayoutSegmentItems()
    }
    public func setTitle(title: String?, forSegmentAtIndex segment: Int) {
        
        if allSegments.count >= segment{
            allSegments[segment].title = title
        }
    }
    
    public func titleForSegmentAtIndex(segment: Int) -> String?{
        if allSegments.count >= segment{
            return allSegments[segment].title
        }
        return nil
    }
    
    public func setItem(item: MLLSegmentItem?, forSegmentAtIndex segment: Int){
        if allSegments.count > (segment - 1){
            
            guard let newItem = item else{ return }
            newItem.index = segment
            allSegments[segment] = newItem
            setNeedsLayoutSegmentItems()
        }
    }
    public func itemForSegmentAtIndex(segment: Int) -> MLLSegmentItem?{
        if allSegments.count >= segment{
            return allSegments[segment]
        }
        return nil
    }
    //TODO:setWidth of Item
    public func setWidth(width: CGFloat, forSegmentAtIndex segment: Int){
        if allSegments.count >= segment{
            
            let frame = allSegments[segment].frame
            let size = CGSizeMake(width, frame.size.height)
            var newFrame = CGRectZero
            newFrame.origin = frame.origin
            newFrame.size = size
            allSegments[segment].frame = newFrame
        }
        setNeedsLayoutSegmentItems()
    }
    public func widthForSegmentAtIndex(segment: Int) -> CGFloat{
        if allSegments.count >= segment{
            return allSegments[segment].frame.size.width
        }
        return 0
    }
    public func setEnabled(enabled: Bool, forSegmentAtIndex segment: Int){
        if allSegments.count >= segment{
            allSegments[segment].enabled = enabled
        }
    }
    public func isEnabledForSegmentAtIndex(segment: Int) -> Bool{
        if allSegments.count >= segment{
            return allSegments[segment].enabled
        }
        return false
    }
}
