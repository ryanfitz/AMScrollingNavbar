//
//  ViewController.swift
//  Sample
//
//  Created by Ryan Fitzgerald on 8/19/15.
//  Copyright (c) 2015 fancypixel. All rights reserved.
//

import UIKit
import AMScrollingNavbar

class AppTabBarViewController : UITabBarController, UITabBarControllerDelegate {
   let data : [ [String : AnyObject?] ]
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        data = [
            [ "controller" : SampleTableViewController(), "title" : "First"],
            [ "controller" : SampleTableViewController(), "title" : "Second"],
            [ "controller" : SampleTableViewController(), "title" : "Third"],
            [ "controller" : SampleTableViewController(), "title" : "Fourth"],
            [ "controller" : SampleTableViewController(), "title" : "Fifth"],
        ]
        
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("storyboards are incompatible with truth and beauty")
    }
    
    override func viewDidLoad() {
        self.viewControllers = createScrollingNavControllers(data)
        
        self.tabBar.barTintColor = UIColor(red: 17/255, green: 19/255, blue: 22/255, alpha: 1)
        self.tabBar.tintColor = UIColor.whiteColor()
        self.tabBar.backgroundColor = UIColor.blackColor()
        self.tabBar.translucent = false
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState:.Selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont.systemFontOfSize(14)], forState: UIControlState.Normal)
        
//        self.delegate = self
    }
    
    private func createScrollingNavControllers(data : [ [String : AnyObject?] ]) -> [UINavigationController] {
        var navControllers  = [ScrollingNavigationController]()
        
        for (index, d) in enumerate(data) {
            let vc = d["controller"] as! UIViewController
            let title : String? = d["title"] as! String?
            vc.title = title
            
            let navController = ScrollingNavigationController()
            navController.viewControllers = [vc]
            navController.tabBarItem = UITabBarItem(title: title, image: nil, tag: index + 1)
            navController.view.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
            navController.tabBarItem.setTitlePositionAdjustment(UIOffsetMake(0, -15))
//            navController.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
            navControllers.append(navController)
        }
        
        return navControllers
    }
}
    
class SampleTableViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    let tableView : UITableView
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        tableView = UITableView(frame: CGRectZero)
        
        super.init(nibName: nil, bundle: nil)
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("storyboards are incompatible with truth and beauty")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let navigationBar = self.navigationController?.navigationBar {
            self.styleNavBar(navigationBar)
        }
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
        
        view.addSubview(tableView)
    }
    
    private func styleNavBar(navigationBar : UINavigationBar) {
        let foreground = UIColor.whiteColor()
        let background = UIColor(red: 211/255, green: 47/255, blue: 47/255, alpha: 1)
        
        navigationBar.translucent = false
        navigationBar.shadowImage = UIImage()
        navigationBar.tintColor = foreground
        navigationBar.barTintColor = background
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : foreground, NSFontAttributeName : UIFont.systemFontOfSize(18)]
    }
    
    override func viewWillLayoutSubviews() {
        self.tableView.frame = self.view.bounds
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let navigationController = self.navigationController as? ScrollingNavigationController {
            navigationController.followScrollView(tableView, delay: 50.0)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let navigationController = self.navigationController as? ScrollingNavigationController {
            navigationController.showNavbar(animated: true)
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        if let navigationController = self.navigationController as? ScrollingNavigationController {
            navigationController.stopFollowingScrollView()
        }
    }
    
    // MARK: - UITableView data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = "Row \(indexPath.row + 1)"
        return cell
    }
    
    func scrollViewShouldScrollToTop(scrollView: UIScrollView) -> Bool {
        if let navigationController = self.navigationController as? ScrollingNavigationController {
            navigationController.showNavbar(animated: true)
        }
        return true
    }
}

