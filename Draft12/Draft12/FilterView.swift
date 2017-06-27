//
//  FilterView.swift
//  Draft12
//
//  Created by LMAO on 26/06/2017.
//  Copyright © 2017 Jiahuan He. All rights reserved.
//

import UIKit

protocol FilterViewDelegate{
    func doneFiltering(todayChecked: Bool, tomorrowChecked: Bool, f0Checked: Bool, f1Checked: Bool, f2Checked: Bool, f3Checked: Bool)
    func removeFiltering()
}

class FilterView: UIView {
    
    var delegate: FilterViewDelegate?
    
    var dateView = UIView()
    var dateLabel = UILabel()
    var todayButton = UIButton()
    var tomorrowButton = UIButton()
    var noDate = UIButton()
    
    var flagView = UIView()
    var flagLabel = UILabel()
    var f0Button = UIButton()
    var f1Button = UIButton()
    var f2Button = UIButton()
    var f3Button = UIButton()
    
    var confirmView = UIView()
    var removeButton = UIButton(type: .custom)
    var doneButton = UIButton(type: .custom)
    
    var isTodayChecked = false {
        didSet{
            if isTodayChecked{
            }
            else{
                
            }
        }
    }
    
    var isTomorrowChecked = false {
        didSet{
            if isTomorrowChecked{
                
            }
            else{
                
            }
        }
    }
    
    var isF0Checked = false {
        didSet{
            if isF0Checked{
                
            }
            else{
                
            }
        }
    }
    
    var isF1Checked = false {
        didSet{
            if isF1Checked{
                
            }
            else{
                
            }
        }
    }
    
    var isF2Checked = false {
        didSet{
            if isF2Checked{
            }
            else{
                
            }
        }
    }
    
    var isF3Checked = false {
        didSet{
            if isF3Checked{
                
            }
            else{
                
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = Color.cellBackground
        let numOfRows = CGFloat(3.0)
        dateView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height/numOfRows)
        flagView.frame = CGRect(x: 0, y: 1*frame.height/numOfRows, width: frame.width, height: frame.height/numOfRows)
        confirmView.frame = CGRect(x: 0, y: 2*frame.height/numOfRows, width: frame.width, height: frame.height/numOfRows)
        
        dateView.backgroundColor = UIColor.blue
        flagView.backgroundColor = UIColor.brown
        confirmView.backgroundColor = UIColor.blue
        
        addSubview(dateView)
        addSubview(flagView)
        addSubview(confirmView)
        
        initDateView()
        initFlagView()
        initConfirmView()
        
    }
    
    let labelX = CGFloat(0.02*ScreenSize.w)
    let firstPosX = CGFloat(0.25*ScreenSize.w)
    let secondPosX = CGFloat(0.47*ScreenSize.w)
    let thirdPosX = CGFloat(0.7*ScreenSize.w)
    
    func initDateView(){
        dateLabel.text = "By Date"
        todayButton.setTitle("Today", for: .normal)
        tomorrowButton.setTitle("Tomorrow", for: .normal)
        noDate.setTitle("No Date", for: .normal)
        
        dateLabel.frame = CGRect(x: labelX, y: 0, width: 0, height: 0)
        
        todayButton.frame = CGRect(x: firstPosX, y: 0, width: 0, height: 0)
        tomorrowButton.frame = CGRect(x: secondPosX, y: 0, width: 0, height: 0)
        
        
        dateLabel.font = Font.text
        todayButton.titleLabel?.font = Font.text
        tomorrowButton.titleLabel?.font = Font.text
        todayButton.titleLabel?.font = Font.text
        noDate.titleLabel?.font = Font.text
        
        
        dateLabel.sizeToFit()
        todayButton.sizeToFit()
        tomorrowButton.sizeToFit()
        noDate.sizeToFit()
        noDate.frame = CGRect(x: ScreenSize.w-labelX-noDate.frame.width, y: 0, width: noDate.frame.width, height: noDate.frame.height)
        
        dateLabel.center.y = dateView.frame.size.height/2
        todayButton.center.y = dateView.frame.size.height/2
        tomorrowButton.center.y = dateView.frame.size.height/2
        noDate.center.y = dateView.frame.size.height/2
        
        dateLabel.textColor = Color.settingLabel
        
        todayButton.setTitleColor(Color.settingText, for: .normal)
        tomorrowButton.setTitleColor(Color.settingText, for: .normal)
        noDate.setTitleColor(Color.settingText, for: .normal)
        
        
        dateView.addSubview(dateLabel)
        dateView.addSubview(todayButton)
        dateView.addSubview(tomorrowButton)
        dateView.addSubview(noDate)
    }
    
    let flagButtonDistance = ScreenSize.w/8
    let labelRadius = 5.0
    func initFlagView(){
        
        flagLabel.frame = CGRect(x: labelX, y: 0, width: 0, height: 0)
        flagLabel.text = "By Flag"
        flagLabel.textColor = Color.settingLabel
        flagLabel.font = Font.text
        flagLabel.sizeToFit()
        flagLabel.center.y = flagView.frame.height/2
        
        let flagLabelHeight = flagLabel.frame.height
        f0Button.frame = CGRect(x: firstPosX, y: 0, width: flagLabelHeight, height: flagLabelHeight)
        f1Button.frame = CGRect(x: firstPosX + 1*flagButtonDistance, y: 0, width: flagLabelHeight, height: flagLabelHeight)
        f2Button.frame = CGRect(x: firstPosX + 2*flagButtonDistance, y: 0, width: flagLabelHeight, height: flagLabelHeight)
        f3Button.frame = CGRect(x: firstPosX + 3*flagButtonDistance, y: 0, width: flagLabelHeight, height: flagLabelHeight)
        
        f0Button.center.y = flagView.frame.height/2
        f1Button.center.y = flagView.frame.height/2
        f2Button.center.y = flagView.frame.height/2
        f3Button.center.y = flagView.frame.height/2
        
        f0Button.backgroundColor = Color.f0
        f1Button.backgroundColor = Color.f1
        f2Button.backgroundColor = Color.f2
        f3Button.backgroundColor = Color.f3
        
        
        f0Button.layer.masksToBounds = true
        f0Button.layer.cornerRadius = CGFloat(labelRadius)
        f1Button.layer.masksToBounds = true
        f1Button.layer.cornerRadius = CGFloat(labelRadius)
        f2Button.layer.masksToBounds = true
        f2Button.layer.cornerRadius = CGFloat(labelRadius)
        f3Button.layer.masksToBounds = true
        f3Button.layer.cornerRadius = CGFloat(labelRadius)
        
        flagView.addSubview(flagLabel)
        flagView.addSubview(f0Button)
        flagView.addSubview(f1Button)
        flagView.addSubview(f2Button)
        flagView.addSubview(f3Button)
    }
    
    
    
    func initConfirmView(){
        removeButton.setTitle("REMOVE", for: .normal)
        removeButton.setTitleColor(Color.remove, for: .normal)
        removeButton.titleLabel!.font = Font.button
        removeButton.frame = CGRect(x: labelX, y: 0, width: 0, height: 0)
        removeButton.sizeToFit()
        removeButton.center.y = confirmView.frame.height/2
        removeButton.addTarget(self, action: #selector(removePressed), for: .touchUpInside)
        
        doneButton.setTitle("DONE", for: .normal)
        doneButton.setTitleColor(Color.text, for: .normal)
        doneButton.titleLabel!.font = Font.button
        doneButton.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        doneButton.sizeToFit()
        doneButton.frame = CGRect(x: ScreenSize.w - labelX - doneButton.frame.width, y: 0, width: doneButton.frame.width, height: doneButton.frame.height)
        doneButton.center.y = confirmView.frame.height/2
        doneButton.addTarget(self, action: #selector(donePressed), for: .touchUpInside)
        
        confirmView.addSubview(removeButton)
        confirmView.addSubview(doneButton)
    }
    
    func checkToday(){
        isTodayChecked = !isTodayChecked
    }
    
    func checkTomorrow(){
        isTomorrowChecked = !isTomorrowChecked
    }
    
    func checkF0(){
        isF0Checked = !isF0Checked
    }
    
    func checkF1(){
        isF1Checked = !isF1Checked
    }
    
    func checkF2(){
        isF2Checked = !isF2Checked
    }
    
    func checkF3(){
        isF3Checked = !isF3Checked
    }
    
    func removePressed(){
        delegate!.removeFiltering()
    }
    
    func donePressed(){
        delegate!.doneFiltering(todayChecked: isTodayChecked, tomorrowChecked: isTodayChecked, f0Checked: isF0Checked, f1Checked: isF1Checked, f2Checked: isF2Checked, f3Checked: isF3Checked)
    }
    
    
    
    
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
