//
//  SideBarController.swift
//  SidebarSwift
//
//  Created by Don Whiteside on 20/05/15.
//  Copyright (c) 2015 Flying Saucer. All rights reserved.
//

import UIKit

@objc protocol SidebarControllerDelegate {
    optional func menuItemTapped(index: Int)
    
}

class SideBarController: NSObject {
    var delegate:SidebarControllerDelegate?
    
    var menuColor: UIColor?
    var isOpen: Bool? = false
    var backgroundMenuView: UIView?
    var menuButton: UIButton?
    var buttonList: Array<UIButton>?
    
    override init(){
        super.init()
    }
    
    init(images: [UIImage]) {
        super.init()
        self.menuButton = UIButton.buttonWithType(UIButtonType.Custom) as? UIButton
        self.menuButton?.frame = CGRectMake(0,0,40,40)
        self.menuButton?.setImage(UIImage(named: "menuIcon"), forState: UIControlState.Normal)
        self.menuButton?.addTarget(self, action: "showMenu", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.backgroundMenuView = UIView()
        self.menuColor = UIColor.whiteColor()
        self.buttonList = Array<UIButton>()
        
        var index: Int = 0
       
        for image:UIImage in images{
            let button: UIButton = UIButton.buttonWithType( UIButtonType.Custom) as! UIButton
            button.setImage(image, forState: UIControlState.Normal)
            var yPos = 50.0 + (80.0 * CGFloat(index)) as CGFloat
            button.frame = CGRectMake(CGFloat(20.0),yPos,CGFloat(50.0),CGFloat(50.0))
            button.tag = index;
            button.addTarget(self, action: "onMenuButtonTap:", forControlEvents: UIControlEvents.TouchUpInside)
            buttonList?.append(button)
            ++index
        }
        
        return
    }
    
    func insertMenuButtonOnView(view: UIView, position: CGPoint){
        self.menuButton!.frame = CGRectMake(CGFloat(position.x),CGFloat(position.y),self.menuButton!.frame.size.width, self.menuButton!.frame.size.height)
        view.addSubview(menuButton!)
        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissMenu")
        view.addGestureRecognizer(singleTap)
        
        for button in self.buttonList!{
            self.backgroundMenuView?.addSubview(button)
        }
        
        self.backgroundMenuView?.frame = CGRectMake(view.frame.size.width, CGFloat(0), CGFloat(90), view.frame.size.height)
        self.backgroundMenuView?.backgroundColor = UIColor(red: CGFloat(1), green: CGFloat(1), blue: CGFloat(1), alpha: CGFloat(0.5))
        view.addSubview(backgroundMenuView!)
    }
    
    // MARK: Menu Button Action
    
    func dismissMenuWithSelection(button:UIButton){
        
        UIView.animateWithDuration(0.7, delay: 0.4, usingSpringWithDamping: CGFloat(0), initialSpringVelocity: CGFloat(0), options: UIViewAnimationOptions.allZeros, animations: {
            button.transform = CGAffineTransformScale(CGAffineTransformIdentity, CGFloat(1.2),  CGFloat(1.2))
            }, completion: {
                (finished: Bool) -> Void in
            self.dismissMenu()
        })
    }
    
    func dismissMenu(){
        if isOpen!{
            isOpen = false
            self.performCloseAnimation()
            
        }
    }
    
    func showMenu(){
        if isOpen == false {
            isOpen = true
           // var dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC)))
            
           // dispatch_after(dispatchTime, dispatch_get_main_queue(), { () -> Void in
                self.performOpenAnimation()
           // })
        }
    }
    
    func onMenuButtonTap(button: UIButton){
        // Equivalent in ObjC as Checking for an Implementation of a Method Prior to Calling It
        // This just retuens nil if it's not implemented
        self.delegate?.menuItemTapped?(button.tag)
        self.dismissMenuWithSelection(button)
    }
    
    // MARK: Animations
    func performOpenAnimation(){
        
        dispatch_async(dispatch_get_main_queue()) {
            UIView.animateWithDuration(0.4, animations: {
                self.menuButton?.alpha = 0.0
                // Move Menu Button
                self.menuButton?.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, CGFloat(-90), CGFloat(0))
                // Move in Menu
                self.backgroundMenuView?.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, CGFloat(-90), CGFloat(0))
                }, completion: { finished in

            
            })
        }
        
        for button:UIButton in self.buttonList!{
            NSThread.sleepForTimeInterval(0.02)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                button.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 20, 0)
                UIView.animateWithDuration(0.3, delay: 0.3, usingSpringWithDamping: CGFloat(0.3), initialSpringVelocity: CGFloat(10.0), options: UIViewAnimationOptions.allZeros, animations: { () -> Void in
                    button.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0)
                    }, completion: { (finished:Bool) -> Void in
                    
                })
            })
        }
    }
    
    func performCloseAnimation(){
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.menuButton?.alpha = 1.0
            self.menuButton?.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0)
            self.backgroundMenuView?.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0)
        })
    }
}
