//
//  SwipeableTableViews.swift
//  SwipeableTableViews
//
//  Created by Maykel Farha on 3/5/16.
//  Copyright © 2016 Slintapps. All rights reserved.
//

import UIKit

protocol SwipeableTableViewsDataSource {
    func numberOfItems()->Int
    func viewForItemAtIndex(swipeableTableviews:SwipeableTableViews, index:Int, var reusingView view: UIView?)->UIView?
}

protocol SwipeableTableViewsDelegate {
    func swipeableTableViewsCurrentItemDidChange(swipeableTableviews:SwipeableTableViews)
}


class SwipeableTableViews: UIView,UIGestureRecognizerDelegate {
    
    var dataSource:SwipeableTableViewsDataSource?
    var delegate:SwipeableTableViewsDelegate?
    var numberOfItems:Int = 0
    var currentItemIndex:Int = 0
    var scrollEnabled:Bool = true
    let itemViewPool:NSMutableSet = NSMutableSet()
    let itemViews:NSMutableDictionary = NSMutableDictionary()
    let width:CGFloat = UIScreen.mainScreen().bounds.width
    let height:CGFloat = UIScreen.mainScreen().bounds.height
    
    
    init(){
        super.init(frame: CGRectMake(0, 0, width, height))
        self.setUp()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp(){
        self.backgroundColor = UIColor.darkGrayColor()
        
        let swipe:UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handleSwipe:")
        swipe.delegate = self
        self.addGestureRecognizer(swipe)
        
    }

    func handleSwipe(recognizer:UIPanGestureRecognizer){
        let currentView = itemViewForIndex(currentItemIndex)
        let nextView = itemViewForIndex(currentItemIndex+1)
        let prevView = itemViewForIndex(currentItemIndex-1)
        
        
        if(recognizer.state == UIGestureRecognizerState.Ended || recognizer.state == UIGestureRecognizerState.Failed || recognizer.state == UIGestureRecognizerState.Cancelled)
        {
            if(currentView?.frame.origin.x < ((width/2) * -1)){
                if(currentItemIndex < dataSource?.numberOfItems()){
                    currentItemIndex++
                }
            }else if(currentView?.frame.origin.x > ((width/2))){
                if(currentItemIndex > 0){
                    currentItemIndex--
                }
            }
            loadUnloadViews()
        }else{
            let point:CGPoint = recognizer.locationInView(self)
            
            let velocity:CGPoint = recognizer.velocityInView(self)
            if(velocity.x > 0){ // right
                currentView?.frame.origin.x = point.x
                prevView?.frame.origin.x = -width+point.x
                nextView?.frame.origin.x = width+point.x
            } else { // left
                currentView?.frame.origin.x = point.x-width
                nextView?.frame.origin.x = point.x
                prevView?.frame.origin.x = -width-point.x
            }
        }
    }
    
    
    
    
    func itemViewForIndex(index:Int)->UIView?{
        return itemViews.objectForKey(index) as? UIView
    }
    
    func loadViewAtIndex(index:Int)->UIView?{
        var view:UIView? = dataSource?.viewForItemAtIndex(self, index: index, reusingView: dequeueItemView())
        if(view == nil){
            view = UIView()
        }
        
        let oldView:UIView? = self.itemViewForIndex(index)
        if(oldView != nil){
            self.itemViewPool.addObject(oldView!)
        }
        
        self.itemViews.setObject(view!, forKey: index)
        
        view?.frame.origin.x = width * CGFloat(index)
        
        self.addSubview(view!)
        
        return view
    }
    
    func dequeueItemView()->UIView?{
        let view:UIView? = itemViewPool.anyObject() as? UIView
        if(view != nil){
            itemViewPool.removeObject(view!)
        }
        return view
    }
    
    func loadUnloadViews(){
        
        let visibleIndexes:NSMutableArray = NSMutableArray()
        if(currentItemIndex == 0){
            visibleIndexes.addObject(0)
            visibleIndexes.addObject(1)
        } else if (currentItemIndex >= dataSource?.numberOfItems()){
            visibleIndexes.addObject(currentItemIndex-1)
            visibleIndexes.addObject(currentItemIndex)
        }else if (currentItemIndex < dataSource?.numberOfItems()){
            visibleIndexes.addObject(currentItemIndex-1)
            visibleIndexes.addObject(currentItemIndex)
            visibleIndexes.addObject(currentItemIndex+1)
        }
        
        for key in itemViews.allKeys {
            if(!visibleIndexes.containsObject(key)){
                let view:UIView? = itemViews.objectForKey(key) as? UIView
                if(view != nil){
                    self.itemViewPool.addObject(view!)
                    view?.removeFromSuperview()
                    itemViews.removeObjectForKey(key)
                }
            }
        }
        
        for visibleKey in visibleIndexes {
            let view:UIView? = itemViews.objectForKey(visibleKey) as? UIView
            if(view == nil){
                loadViewAtIndex(visibleKey as! Int)
            }
        }
        
        updateLayout()
        
    }
    
    func reloadData(){
        for key in itemViews.allKeys {
            let view:UIView? = itemViews.objectForKey(key) as? UIView
            view?.removeFromSuperview()
        }
        
        itemViews.removeAllObjects()
        itemViewPool.removeAllObjects()
        
        currentItemIndex = 0
        
        loadUnloadViews()

    }
    
    func updateLayout(){
        let currentView = itemViewForIndex(currentItemIndex)
        let nextView = itemViewForIndex(currentItemIndex+1)
        let prevView = itemViewForIndex(currentItemIndex-1)
        
        if(nextView != nil){
            self.bringSubviewToFront(nextView!)
        }
        
        self.bringSubviewToFront(currentView!)
        
        UIView.animateWithDuration(0.5,
            delay: 0.0,
            options: [.CurveEaseInOut, .AllowUserInteraction],
            animations: {
                currentView?.frame.origin.x = 0
                nextView?.frame.origin.x = self.width
                prevView?.frame.origin.x = -self.width
            },
            completion: { finished in
                
            }
        )
    }
    
    

}
