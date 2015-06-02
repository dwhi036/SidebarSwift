//
//  ================================================
//  Code based on an Objective C Implementation by
//  Christophe Dellac on 9/11/14.
//  ================================================
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

enum Direction: Int{
    case Left   = 1
    case Right  = 2
}

class SideBarController: NSObject {
    var delegate:SidebarControllerDelegate?
    
    var menuColor: UIColor?
    var isOpen: Bool? = false
    var backgroundMenuView: UIView?
    var menuButton: UIButton?
    var buttonList: Array<UIButton>?
    
    var menuSlideDirection: Direction?
    
    override init(){
        super.init()
    }
    
    init(images: [UIImage]) {
        super.init()
        self.menuButton = UIButton.buttonWithType(UIButtonType.Custom) as? UIButton
        self.menuButton?.frame = CGRectMake(0,0,40,40)
        self.menuButton?.addTarget(self, action: "showMenu", forControlEvents: UIControlEvents.TouchUpInside)
        
        /* == Bit of Code to Change the Color of the Menu Button from it's Original == */
        var imageView: UIImageView! = UIImageView()
        
        // Read the Image In as a Template so that we can Courise it
        imageView.image = UIImage(named: "menuIcon")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        
        self.menuButton?.setImage(imageView.image, forState: UIControlState.Normal)
        // self.menuButton?.setImage(UIImage(named: "menuIcon"), forState: UIControlState.Normal)
        self.menuButton?.tintColor = UIColor.redColor();
        
        /* ============  Finish Tint of Button ============ */
        
        self.backgroundMenuView = UIView()
        self.menuColor = UIColor.whiteColor()
        self.buttonList = Array<UIButton>()
        
        var index: Int = 0
       
        // Build the List of Buttons and their Relative Positions 
        
        for image:UIImage in images{
            let button: UIButton = UIButton.buttonWithType( UIButtonType.Custom) as! UIButton
            button.setImage(image, forState: UIControlState.Normal)
            // Arrange the Buttons YPos Under Each Other
            var yPos = 50.0 + (80.0 * CGFloat(index)) as CGFloat
            button.frame = CGRectMake(CGFloat(20.0),yPos,CGFloat(50.0),CGFloat(50.0))
            button.tag = index;
            button.addTarget(self, action: "onMenuButtonTap:", forControlEvents: UIControlEvents.TouchUpInside)
            buttonList?.append(button)
            ++index
        }
        
        return
    }
    
    // Method is Called from ViewController to Position Menu Button on Current View
    
    func insertMenuButtonOnView(view: UIView, menuPosition: Direction){
        var position: CGPoint!
        // Save the Slide Direction as the one the MenuButton Appears On
        menuSlideDirection = menuPosition
        
        // Get Current ViewController and See if we Have a NavBar
        var vc : UIViewController? = UIViewController.getCurrentViewController()
        var menuYpos : CGFloat!
        if (vc != nil){
            if (vc!.isKindOfClass(UINavigationController)) {
                menuYpos = CGFloat(20) // Position Menu Button in Nav Bar
            }else{
                menuYpos = CGFloat(50) // Position Slightly Further Down as it looks better
            }
        }
        
        // Left and Right Side Positioning for Menu Button
        var leftCoord:  CGPoint! = CGPointMake(CGFloat(20), menuYpos)
        var rightCoord: CGPoint! = CGPointMake(CGFloat(view.frame.size.width - 70), menuYpos)
        
        switch menuPosition {
            case Direction.Left:
                position = leftCoord
            case Direction.Right:
                position = rightCoord
            default: // To Left
                position = leftCoord
        }
        
        self.menuButton!.frame = CGRectMake(CGFloat(position.x),CGFloat(position.y),self.menuButton!.frame.size.width, self.menuButton!.frame.size.height)
        view.addSubview(menuButton!)
        
        // Single Tap to Dismiss on View
        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissMenu")
        view.addGestureRecognizer(singleTap)
        
        for button in self.buttonList!{
            self.backgroundMenuView?.addSubview(button)
        }
        
        // Define the MenuView Frame (Position on Screen)
        // Build it -90 Off the Screen to the Left so it can transition on
        // or Build it off the Screen to the Right (from the View Width) 
        
        switch menuPosition {
            case Direction.Left:
                self.backgroundMenuView?.frame = CGRectMake(CGFloat(-90), CGFloat(0), CGFloat(90), view.frame.size.height)
            case Direction.Right:
                self.backgroundMenuView?.frame = CGRectMake(view.frame.size.width, CGFloat(0), CGFloat(90), view.frame.size.height)
            default:
                self.backgroundMenuView?.frame = CGRectMake(CGFloat(-90), CGFloat(0), CGFloat(90), view.frame.size.height)
        }
        
        self.backgroundMenuView?.backgroundColor = UIColor(red: CGFloat(1), green: CGFloat(1), blue: CGFloat(1), alpha: CGFloat(0.5))
        
        view.addSubview(backgroundMenuView!)
    }
    
    // MARK: Menu Button Action
    
    func dismissMenuWithSelection(button:UIButton){
        
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: CGFloat(0), initialSpringVelocity: CGFloat(0), options: UIViewAnimationOptions.allZeros, animations: {
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
                self.performOpenAnimation()
        }else{
            dismissMenu()
        }
    }
    
    func onMenuButtonTap(button: UIButton){
        // Equivalent in ObjC as Checking for an Implementation of a Delegate Method Prior to Calling It
        // This just returns nil if it's not implemented
        self.delegate?.menuItemTapped?(button.tag)
        
        self.dismissMenuWithSelection(button)
    }
    
    // MARK: Animations
    func performOpenAnimation(){
        
        // Work Out Which Way Menu Button Should Slide
        var transform: CGAffineTransform!
        
        switch menuSlideDirection!{
        case Direction.Left :
            transform = CGAffineTransformTranslate(CGAffineTransformIdentity, CGFloat(90), CGFloat(0))
        case Direction.Right :
            transform = CGAffineTransformTranslate(CGAffineTransformIdentity, CGFloat(-90), CGFloat(0))
        default: // To Left
            transform = CGAffineTransformTranslate(CGAffineTransformIdentity, CGFloat(90), CGFloat(0))
            
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            UIView.animateWithDuration(0.4, animations: {
                self.menuButton?.alpha = 1.0
                // Move Menu Button
                self.menuButton?.transform = transform
                // Move in Menu
                self.backgroundMenuView?.transform = transform
                }, completion: { finished in

            
            })
        }
        
        for button:UIButton in self.buttonList!{
            NSThread.sleepForTimeInterval(0.02)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                button.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 20, 0)
                UIView.animateWithDuration(0.3, delay: 0.3, usingSpringWithDamping: CGFloat(0.3), initialSpringVelocity: CGFloat(8.0), options: UIViewAnimationOptions.allZeros, animations: { () -> Void in
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
