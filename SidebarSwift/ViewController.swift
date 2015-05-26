//
//  ViewController.swift
//  SidebarSwift
//
//  Created by Don Whiteside on 20/05/15.
//  Copyright (c) 2015 Flying Saucer. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SidebarControllerDelegate {

    var sideBar : SideBarController?
    
    @IBOutlet weak var myButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var imageList = [UIImage(named: "menuChat")!,UIImage(named: "menuUsers")!, UIImage(named: "menuMap")!, UIImage(named: "menuClose")!]
        
        sideBar = SideBarController(images: imageList)
        sideBar?.delegate = self
        
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        var appWindow = UIApplication.sharedApplication().delegate?.window!
       
        sideBar?.insertMenuButtonOnView(self.view, position: CGPointMake(CGFloat(self.view.frame.size.width - 70), CGFloat(50)))
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    //MARK: Delegate Methods
    
    func menuItemTapped(index: Int) {
        // Do Some Menu Selection Stuff
        println("Menu Line Tapped \(index)")
    }
}

