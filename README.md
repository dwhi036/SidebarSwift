# SidebarSwift
Swift Implementation of CDSideBar for Hamburger Menu Style 
Original was written by Christopher Dellac on 9/11/14 in Objective-C

SideBarController is a light and easy side bar with custom iOS7 animations and actions

How does it work ?

**Import SideBarController.swift in your project**

**Import UIViewController+Utils.swift in your project**

In your ViewController Class (ViewController.swift)

Implement the Delegate 

*class ViewController: UIViewController, SidebarControllerDelegate*

Implement This Method to detect Menu Items Tapped

    func menuItemTapped(index: Int) {
      // Do Some Menu Selection Stuff
      println("Menu Line Tapped \(index)")
    }

In viewDidLoad, create an array of menu images 
Create your instance of #SideBarController# and setup ViewController as delegate

    override func viewDidLoad() {
        super.viewDidLoad()
        var imageList = [UIImage(named: "menuChat")!,UIImage(named: "menuUsers")!, UIImage(named: "menuMap")!, UIImage(named: "menuClose")!]
        sideBar = SideBarController(images: imageList)
        sideBar?.delegate = self
    }
 

To get the SideBar to Appear Invoke Method

*insertMenuButtonOnView(appWindow!, menuPosition:Direction.Left) or menuPosition:Direction.Right*


See the ViewController.swift for an example of how to invoke this

