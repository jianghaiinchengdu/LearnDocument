//
//  ViewController.swift
//  AppleWatch
//
//  Created by jianghai on 15/11/6.
//  Copyright © 2015年 jianghai. All rights reserved.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController,WCSessionDelegate,UIPageViewControllerDataSource , UIPageViewControllerDelegate{
    
    var pageController : PageController!
    var allPage : NSMutableArray = NSMutableArray()
      let weathers = [
        CityModel(city: "成都", low: 18, high: 20),
        CityModel(city: "北京", low: 9, high: 21),
        CityModel(city: "上海", low: 12, high: 29),
        CityModel(city: "南京", low: 2, high: 26)
        ]

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let vc = allPage[0] as! CommonController
        let cityModel = self.weathers[0]
        vc.cityLabel.text = cityModel.city
        vc.high.text = String(cityModel.high)
        vc.low.text = String(cityModel.low)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        let userDefaults  = NSUserDefaults(suiteName: "group.jianghai.AppleWatch")
//        userDefaults!.setInteger(100001, forKey:"jianghai")
//        userDefaults!.synchronize()
        let userDefaults  = NSUserDefaults.standardUserDefaults()
        userDefaults.setInteger(100001, forKey:"jianghai")
        userDefaults.synchronize()
        
        if WCSession.isSupported() {
            let session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
        
        pageController = PageController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        
        for i in 0...3{
            
            let story = UIStoryboard(name: "Main", bundle: nil)
            let controller = story.instantiateViewControllerWithIdentifier("CommonController")
            controller.title = String(i)
            allPage.addObject(controller)
        }
        
        
        self.pageController.setViewControllers([allPage[0] as! UIViewController], direction: .Forward, animated: false, completion: nil)
        self.pageController.dataSource = self
        self.pageController.delegate = self
        self.addChildViewController(pageController)
        self.view.addSubview(pageController!.view)
        
    }
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]){
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
            let errorMessage : UITextView = UITextView(frame: CGRectMake(0, 50, 300,240))
            errorMessage.text = message.description
            self.view.addSubview(errorMessage)
        })
    }
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void){
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
            let errorMessage : UITextView = UITextView(frame: CGRectMake(0, 50, 300,240))
            errorMessage.text = message.description
            self.view.addSubview(errorMessage)
        })
    }
 

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func clicked(sender: AnyObject) {
//        NSNotificationCenter.defaultCenter().postNotificationName("xx", object: nil)
//        let message : [String : AnyObject] = ["message":"message"]
////        do{
////        try WCSession.defaultSession().updateApplicationContext(message)
////        }catch{
////        }
//        WCSession.defaultSession().sendMessage(message, replyHandler: { (message : [String : AnyObject]) -> Void in
//            
//            })
//            { (error : NSError) -> Void in
//                dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                    
//                    let errorMessage : UITextView = UITextView(frame: CGRectMake(0, 50, 300,240))
//                    errorMessage.text = error.description
//                    self.view.addSubview(errorMessage)
//                })
//        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?{
        let index = Int(viewController.title!)
        if index > 0{
            let vc = allPage.objectAtIndex(index! - 1) as? CommonController
            return vc
        }else{
        
            return nil
        }
    }
     func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?{
        let index = Int(viewController.title!)
        if index < allPage.count - 1{
            return allPage.objectAtIndex(index! + 1) as? UIViewController
        }else{
            
            return nil
        }
    }
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [UIViewController])
    {
        let viewController = pendingViewControllers[0] as! CommonController
        let index = Int(viewController.title!)
        
        let cityModel = self.weathers[index!]
        viewController.cityLabel.text = cityModel.city
        viewController.high.text = String(cityModel.high)
        viewController.low.text = String(cityModel.low)
        
        
        
        
        let message : [String : AnyObject] = ["city":cityModel.city,"low":cityModel.low,"high":cityModel.high]
        WCSession.defaultSession().sendMessage(message, replyHandler: { (message : [String : AnyObject]) -> Void in
            
            })
            { (error : NSError) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    let errorMessage : UITextView = UITextView(frame: CGRectMake(0, 50, 300,240))
                    errorMessage.text = error.description
                    self.view.addSubview(errorMessage)
                })
        }
    }
}

