//
//  MLLSegmentViewDelegate.swift
//  MLLSegmentView
//
//  Created by jianghai on 15/12/15.
//  Copyright © 2015年 jianghai. All rights reserved.
//

import Foundation

/** MLLSegmentViewDelegate protocol

*/
@objc
protocol MLLSegmentViewDelegate : NSObjectProtocol {
    
    func segmentView(view : MLLSegmentView , didSelectedAtIndex index : Int)
    
    optional func segmentView(view : MLLSegmentView , willStartAnimationWithIndex index : Int)
    
    optional func segmentView(view : MLLSegmentView , didStopAnimationWithIndex index : Int)
}
