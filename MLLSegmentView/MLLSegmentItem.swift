//
//  MLLSegmentItem.swift
//  MLLSegmentView
//
//  Created by jianghai on 15/12/15.
//  Copyright © 2015年 jianghai. All rights reserved.
//

import UIKit

/** MLLSegmentItem Class

*/
public class MLLSegmentItem: UIControl {
    
    public var title : String?
    public var index : Int = -1
    
    public var titleLabel : UILabel!
    
    public var defaultWidth : CGFloat = 50
    
    public init(title : String? ,  index : Int){
        self.index = index
        self.title = title
        self.titleLabel = UILabel()
        super.init(frame: CGRectZero)
        
        self.backgroundColor = UIColor.redColor()
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.whiteColor().CGColor
        
        self.titleLabel.text = title
        self.titleLabel.textAlignment = .Center
        self.addSubview(titleLabel)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.titleLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
