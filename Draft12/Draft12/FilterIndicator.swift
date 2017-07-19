//
//  filterIndicator.swift
//  MyList
//
//  Created by Jiahuan He on 03/07/2017.
//  Copyright © 2017 Jiahuan He. All rights reserved.
//

import UIKit

protocol FilterIndicatorDelegate {
    func removeFilterIndicator()
}

class FilterIndicator: UIView {
    var delegate: FilterIndicatorDelegate?
    
    let resultLabel = UILabel()
    let removeButton = UIButton()
    
    let labelX = CGFloat(0.02*ScreenSize.w)
    let buttonX = CGFloat(0.65*ScreenSize.w)
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Color.filterIndicator
        resultLabel.font = Font.filter
        resultLabel.textColor = Color.text
        resultLabel.frame = CGRect(x: labelX, y: 0, width: 0, height: 0)
        
        
        removeButton.frame = CGRect(x: buttonX, y: 0, width: 0, height: 0)
        removeButton.setTitle("REMOVE FILTER", for: .normal)
        removeButton.setTitleColor(Color.remove, for: .normal)
        removeButton.titleLabel!.font = Font.filter
        removeButton.titleLabel!.sizeToFit()
        removeButton.sizeToFit()
        
        removeButton.center.y = self.frame.height/2
        
        removeButton.addTarget(self, action: #selector(self.removeFilter), for: .touchUpInside)
        
        addSubview(resultLabel)
        addSubview(removeButton)
    }
    
    func removeFilter(){
        delegate!.removeFilterIndicator()
        
    }
    
    func addFilter(num: Int){
        var text = ""
        if num == 0 {
            text = "NO TASKS"
        }
        else if num == 1{
            text = "1 TASK"
        }
        else{
            text = String(num) + " TASKS"
        }
        resultLabel.text = text
        resultLabel.sizeToFit()
        resultLabel.center.y = frame.height/2
        removeButton.center.y = resultLabel.center.y
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    
    
    
    
    
    
//    
//    var todayLabel: UILabel?
//    var tomorrowLabel: UILabel?
//    var noDateLabel: UILabel?
//    
//    var f0Label: UILabel?
//    var f1Label: UILabel?
//    var f2Label: UILabel?
//    var f3Label: UILabel?
//    
//    var todayView: UIView?
//    var tomorrowView: UIView?
//    var noDateView: UIView?
//    
//    var f0View: UIView?
//    var f1View: UIView?
//    var f2View: UIView?
//    var f3View: UIView?
//    
//    var removeButton: UIButton?
//    
//    
//    var dateFilterAccumulation = CGFloat(0)
//    var flagFilterAccumulation = CGFloat(0)
//    let initX = CGFloat(0.02*ScreenSize.w)
//    var spaceBetweenFilter = CGFloat(0.02*ScreenSize.w)
//    
//
//    
//    func addDate(filter: String) {
//        
//        var currentView: UIView?
//        var currentLabel: UILabel?
//        let rmvButton = UIButton()
//        
//        switch filter {
//        case "today":
//            todayView = UIView(frame: CGRect(x: dateFilterAccumulation+initX, y: 0, width: 0, height: frame.height))
//            todayLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
//            currentView = todayView!
//            currentLabel = todayLabel!
//            todayLabel!.text = "Today"
//            
//        case "tomorrow":
//            tomorrowView = UIView(frame: CGRect(x: dateFilterAccumulation+initX, y: 0, width: 0, height: frame.height))
//            tomorrowLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
//            currentView = tomorrowView!
//            currentLabel = tomorrowLabel!
//            tomorrowLabel!.text = "Tomorrow"
//        default:
//            break
//        }
//        
//        currentLabel!.font = Font.filter
//        currentLabel!.textColor = Color.text
//        currentLabel!.sizeToFit()
//        currentLabel!.center.y = frame.height/2
//        rmvButton.frame = CGRect(x: currentLabel!.frame.width, y: 0, width: currentLabel!.frame.height, height: currentLabel!.frame.height)
//        currentView!.sizeToFit()
//        dateFilterAccumulation += currentView!.frame.width + spaceBetweenFilter
//        currentView!.addSubview(currentLabel!)
//        currentView!.addSubview(rmvButton)
//    }
//    
//    func addFlag(filter: String) {
//        
//        var currentView: UIView?
//        var currentLabel: UILabel?
//        let rmvButton = UIButton()
//        
//        switch filter {
//        case "f0":
//            currentView = f0View!
//            currentLabel = f0Label!
//            
//        case "f1":
//            currentView = f1View!
//            currentLabel = f1Label!
//        case "f2":
//            currentView = f2View!
//            currentLabel = f2Label!
//        case "f3":
//            currentView = f3View!
//            currentLabel = f3Label!
//        default:
//            break
//        }
//        
//        currentView = UIView(frame: CGRect(x: dateFilterAccumulation+initX, y: 0, width: 0, height: frame.height))
//        currentLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.height, height: frame.height))
//        
//        currentLabel!.font = Font.filter
//        currentLabel!.textColor = Color.text
//        currentLabel!.sizeToFit()
//        currentLabel!.center.y = frame.height/2
//        rmvButton.frame = CGRect(x: currentLabel!.frame.width, y: 0, width: currentLabel!.frame.height, height: currentLabel!.frame.height)
//        currentView!.sizeToFit()
//        
//        dateFilterAccumulation += currentView!.frame.width + spaceBetweenFilter
//        currentView!.addSubview(currentLabel!)
//        currentView!.addSubview(rmvButton)
//    }
//    
//    func removeDateFilterView(){
//        
//    }
//    
//    func removeFlagFilterView(){
//        
//    }
//    
    
    
   
}
