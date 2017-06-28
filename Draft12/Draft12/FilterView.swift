//
//  FilterView.swift
//  Draft12
//
//  Created by LMAO on 26/06/2017.
//  Copyright © 2017 Jiahuan He. All rights reserved.
//

import UIKit

protocol FilterViewDelegate{
    func doneFiltering(todaySelected: Bool, tomorrowSelected: Bool, f0Selected: Bool, f1Selected: Bool, f2Selected: Bool, f3Selected: Bool)
    func removeFiltering()
}

class FilterView: UIView {
    
    var delegate: FilterViewDelegate?
    
    var dateView = UIView()
    var dateLabel = UILabel()
    var todayButton = UIButton()
    var tomorrowButton = UIButton()
    var noDateButton = UIButton()
    
    var flagView = UIView()
    var flagLabel = UILabel()
    var f0Button = UIButton()
    var f1Button = UIButton()
    var f2Button = UIButton()
    var f3Button = UIButton()
    
    var confirmView = UIView()
    var removeButton = UIButton(type: .custom)
    var doneButton = UIButton(type: .custom)
    
    var seperator1 = CALayer()
    var seperator2 = CALayer()
    var seperator3 = CALayer()
    let seperatorWidth = sizeConvert(size: 1)
    let decoBarWidth = sizeConvert(size: 2)
    
    var isTodaySelected = false {
        didSet{
            if isTodaySelected{
                clearFlagSelection()
                todayButton.setTitleColor(Color.settingSelected, for: .normal)
            }
            else{
                todayButton.setTitleColor(Color.settingUnselected, for: .normal)
            }
        }
    }
    
    var isTomorrowSelected = false {
        didSet{
            if isTomorrowSelected{
                clearFlagSelection()
                tomorrowButton.setTitleColor(Color.settingSelected, for: .normal)
            }
            else{
                tomorrowButton.setTitleColor(Color.settingUnselected, for: .normal)
            }
        }
    }
    
    var isNoDateSelected = false {
        didSet{
            if isNoDateSelected{
                clearFlagSelection()
                noDateButton.setTitleColor(Color.settingSelected, for: .normal)
            }
            else{
                noDateButton.setTitleColor(Color.settingUnselected, for: .normal)
            }
        }
    }
    
    var isF0Selected = false {
        didSet{
            if isF0Selected{
                clearDateSelection()
                f0Button.alpha = 1
            }
            else{
                f0Button.setTitleColor(Color.settingUnselected, for: .normal)
                f0Button.alpha = 0.5
            }
        }
    }
    
    var isF1Selected = false {
        didSet{
            if isF1Selected{
                clearDateSelection()
                f1Button.alpha = 1
            }
            else{
                f1Button.alpha = 0.5
            }
        }
    }
    
    var isF2Selected = false {
        didSet{
            if isF2Selected{
                clearDateSelection()
                f2Button.alpha = 1
            }
            else{
                f2Button.alpha = 0.5
            }
        }
    }
    
    var isF3Selected = false {
        didSet{
            if isF3Selected{
                clearDateSelection()
                f3Button.alpha = 1
            }
            else{
                f3Button.alpha = 0.5
            }
        }
    }
    
    private func clearDateSelection(){
        isTodaySelected = false
        isTomorrowSelected = false
        isNoDateSelected = false
    }
    
    private func clearFlagSelection(){
        isF0Selected = false
        isF1Selected = false
        isF2Selected = false
        isF3Selected = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = Color.cellBackground
        let numOfRows = CGFloat(3.0)
        dateView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height/numOfRows)
        flagView.frame = CGRect(x: 0, y: 1*frame.height/numOfRows, width: frame.width, height: frame.height/numOfRows)
        confirmView.frame = CGRect(x: 0, y: 2*frame.height/numOfRows, width: frame.width, height: frame.height/numOfRows)
        
        dateView.backgroundColor = Color.cellBackground
        flagView.backgroundColor = Color.cellBackground
        confirmView.backgroundColor = Color.cellBackground
        
        seperator1.backgroundColor = Color.separator.cgColor
        seperator2.backgroundColor = Color.separator.cgColor
        seperator3.backgroundColor = Color.separator.cgColor
        
        seperator1.frame = CGRect(x: 0, y: dateView.frame.height-seperatorWidth, width: ScreenSize.w, height: seperatorWidth)
        seperator2.frame = CGRect(x: 0, y: flagView.frame.height-seperatorWidth, width: ScreenSize.w, height: seperatorWidth)
        seperator3.frame = CGRect(x: 0, y: confirmView.frame.height-seperatorWidth, width: ScreenSize.w, height: seperatorWidth)
        
       
        
        dateView.layer.addSublayer(seperator1)
        flagView.layer.addSublayer(seperator2)
        confirmView.layer.addSublayer(seperator3)
        
        
        addSubview(dateView)
        addSubview(flagView)
        addSubview(confirmView)
        
        initDateView()
        initFlagView()
        initConfirmView()
        
    }
    
    let labelX = CGFloat(0.02*ScreenSize.w)
    let firstPosX = CGFloat(0.25*ScreenSize.w)
    let secondPosX = CGFloat(0.46*ScreenSize.w)
    let thirdPosX = CGFloat(0.68*ScreenSize.w)
    
    func initDateView(){
        dateLabel.text = "By Date"
        todayButton.setTitle("Today", for: .normal)
        tomorrowButton.setTitle("Tomorrow", for: .normal)
        noDateButton.setTitle("No Date", for: .normal)
        
        dateLabel.frame = CGRect(x: labelX, y: 0, width: 0, height: 0)
        
        todayButton.frame = CGRect(x: firstPosX, y: 0, width: 0, height: 0)
        tomorrowButton.frame = CGRect(x: secondPosX, y: 0, width: 0, height: 0)
        
        
        dateLabel.font = Font.text
        todayButton.titleLabel?.font = Font.text
        tomorrowButton.titleLabel?.font = Font.text
        todayButton.titleLabel?.font = Font.text
        noDateButton.titleLabel?.font = Font.text
        
        dateLabel.sizeToFit()
        todayButton.sizeToFit()
        tomorrowButton.sizeToFit()
        noDateButton.sizeToFit()
        noDateButton.frame = CGRect(x: ScreenSize.w-labelX-noDateButton.frame.width, y: 0, width: noDateButton.frame.width, height: noDateButton.frame.height)
        
        dateLabel.center.y = dateView.frame.size.height/2
        todayButton.center.y = dateView.frame.size.height/2
        tomorrowButton.center.y = dateView.frame.size.height/2
        noDateButton.center.y = dateView.frame.size.height/2
        
        dateLabel.textColor = Color.settingLabel
        
        todayButton.setTitleColor(Color.settingUnselected, for: .normal)
        tomorrowButton.setTitleColor(Color.settingUnselected, for: .normal)
        noDateButton.setTitleColor(Color.settingUnselected, for: .normal)
        
        dateView.addSubview(dateLabel)
        dateView.addSubview(todayButton)
        dateView.addSubview(tomorrowButton)
        dateView.addSubview(noDateButton)
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
        
        todayButton.addTarget(self, action: #selector(self.selectToday), for: .touchUpInside)
        tomorrowButton.addTarget(self, action: #selector(self.selectTomorrow), for: .touchUpInside)
        noDateButton.addTarget(self, action: #selector(self.selectNoDate), for: .touchUpInside)
        f0Button.addTarget(self, action: #selector(self.selectF0), for: .touchUpInside)
        f1Button.addTarget(self, action: #selector(self.selectF1), for: .touchUpInside)
        f2Button.addTarget(self, action: #selector(self.selectF2), for: .touchUpInside)
        f3Button.addTarget(self, action: #selector(self.selectF3), for: .touchUpInside)
        
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
    
    func selectToday(){
        isTodaySelected = !isTodaySelected
    }
    
    func selectTomorrow(){
        isTomorrowSelected = !isTomorrowSelected
    }
    
    func selectNoDate(){
        isNoDateSelected = !isNoDateSelected
    }
    
    func selectF0(){
        isF0Selected = !isF0Selected
    }
    
    func selectF1(){
        isF1Selected = !isF1Selected
    }
    
    func selectF2(){
        isF2Selected = !isF2Selected
    }
    
    func selectF3(){
        isF3Selected = !isF3Selected
    }
    
    func removePressed(){
        delegate!.removeFiltering()
    }
    
    func donePressed(){
        delegate!.doneFiltering(todaySelected: isTodaySelected, tomorrowSelected: isTomorrowSelected, f0Selected: isF0Selected, f1Selected: isF1Selected, f2Selected: isF2Selected, f3Selected: isF3Selected)
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
