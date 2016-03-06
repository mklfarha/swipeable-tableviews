//
//  ViewController.swift
//  SwipeableTableViews
//
//  Created by Maykel Farha on 3/5/16.
//  Copyright © 2016 Slintapps. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SwipeableTableViewsDataSource, SwipeableTableViewsDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.lightGrayColor()
        
        let swipe:SwipeableTableViews = SwipeableTableViews()
        swipe.dataSource = self
        swipe.delegate = self
        self.view.addSubview(swipe)
        
        swipe.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfItems()->Int{
        return 4;
    }
    
    func viewForItemAtIndex(swipeableTableviews:SwipeableTableViews, index:Int, var reusingView view: UIView?)->UIView?{
        if(view == nil){
            view = SimpleTableView()
        }        
        return view
    }
    
    func swipeableTableViewsCurrentItemDidChange(swipeableTableviews:SwipeableTableViews){
        
    }
    

}

