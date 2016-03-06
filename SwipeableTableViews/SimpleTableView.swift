//
//  BookingsTableViewController.swift
//  Nauroo
//
//  Created by Maykel Farha on 3/5/16.
//  Copyright © 2016 Nauroo. All rights reserved.
//

import UIKit

class SimpleTableView: UIView,UITableViewDelegate,UITableViewDataSource {

    let width:CGFloat = UIScreen.mainScreen().bounds.width
    let height:CGFloat = UIScreen.mainScreen().bounds.height
    let tableView:UITableView = UITableView()
    var index:Int = 0
    
    init(){
        super.init(frame: CGRectMake(0, 0, width, height))
        tableView.frame = CGRectMake(0, 0, width, height)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.bounces = true
        tableView.alwaysBounceVertical = true
        tableView.separatorColor = UIColor.whiteColor()
        self.addSubview(tableView)
        
        self.tableView.backgroundColor = getRandomColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        

        // Configure the cell...

        return cell
    }
    
    
    func getRandomColor() -> UIColor{
        
        let randomRed:CGFloat = CGFloat(drand48())
        let randomGreen:CGFloat = CGFloat(drand48())
        let randomBlue:CGFloat = CGFloat(drand48())
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        
    }
    

   
}
