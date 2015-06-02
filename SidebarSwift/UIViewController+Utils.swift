//
//  UIViewController+Utils.swift
//  SidebarSwift
//
//  Created by Don Whiteside on 1/06/15.
//  Copyright (c) 2015 Flying Saucer. All rights reserved.
//

import UIKit
extension UIViewController {
    
    /* Recursive Class that works through the ViewControllers to Find Current */
    
    class func getControllerInStack(vc: UIViewController) -> UIViewController{
        /* If this is a Presented, Get Next and Recall Our Method to Cycle Up The Chain */
        if (vc.presentedViewController != nil) {
            return UIViewController.getControllerInStack(vc.presentedViewController!)
        }else if (vc.isKindOfClass(UISplitViewController)){
            // Return Righthand Side of Controller
            var spvc: UISplitViewController = vc as! UISplitViewController
            if (spvc.viewControllers.count > 0){
                return UIViewController.getControllerInStack(spvc.viewControllers.last as! UIViewController)
            }else{
                return vc
            }
        }else if (vc.isKindOfClass(UINavigationController)){
            // Return the Top View
            var nvc: UINavigationController = vc as! UINavigationController
            if (nvc.viewControllers.count > 0){
                return UIViewController.getControllerInStack(nvc.topViewController)
            }else{
                return vc
            }
        }else if (vc.isKindOfClass(UITabBarController)){
            var tvc : UITabBarController = vc as! UITabBarController
            if (tvc.viewControllers?.count > 0){
                return UIViewController.getControllerInStack(tvc.selectedViewController!)
            }else{
                return vc
            }
            
        }else{
            return vc
        }
        
    }
    
    /* Call This Method From Any Class and Get Back the Current View Controller */
    class func getCurrentViewController() -> UIViewController?{
        var vc: UIViewController? = UIApplication.sharedApplication().keyWindow?.rootViewController
       
        return vc
    }
}
