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
    
    func refresh(){
        backgroundColor = Color.filterIndicator
        resultLabel.textColor = Color.text
        removeButton.setTitleColor(Color.remove, for: .normal)
    }
   
}
