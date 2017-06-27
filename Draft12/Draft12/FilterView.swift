//
//  FilterView.swift
//  Draft12
//
//  Created by LMAO on 26/06/2017.
//  Copyright © 2017 Jiahuan He. All rights reserved.
//

import UIKit

class FilterView: UIView {
    
    var dateView = UIView()
    var flagView = UIView()
    var todayLabel = UILabel()
    var tomorrowLabel = UILabel()
    var flagLabel = UILabel()
    var f1 = UILabel()
    var f2 = UILabel()
    var f3 = UILabel()
    var f4 = UILabel()
//    var checkBox = UIButton()
    var todayButton = UIButton(type: .custom)
    
    var tomorrowButton = UIButton(type: .custom)
    var f1Button = UIButton(type: .custom)
    
    var f2Button = UIButton(type: .custom)
    var f3Button = UIButton(type: .custom)
    var f4Button = UIButton(type: .custom)
    
    var isTodayChecked = false {
        didSet{
            if isTodayChecked{
                todayButton.setImage(renderedCheckedImage, for: .normal)
            }
            else{
                todayButton.setImage(renderedUncheckedImage, for: .normal)
            }
        }
    }
    
    var isTomorrowChecked = false {
        didSet{
            if isTomorrowChecked{
                tomorrowButton.setImage(renderedCheckedImage, for: .normal)
            }
            else{
                tomorrowButton.setImage(renderedUncheckedImage, for: .normal)
            }
        }
    }
    
    var isF1Checked = false {
        didSet{
            if isF1Checked{
                f1Button.setImage(renderedCheckedImage, for: .normal)
            }
            else{
                f1Button.setImage(renderedUncheckedImage, for: .normal)
            }
        }
    }
    
    var isF2Checked = false {
        didSet{
            if isF2Checked{
                f2Button.setImage(renderedCheckedImage, for: .normal)
            }
            else{
                f2Button.setImage(renderedUncheckedImage, for: .normal)
            }
        }
    }
    
    var isF3Checked = false {
        didSet{
            if isF3Checked{
                f3Button.setImage(renderedCheckedImage, for: .normal)
            }
            else{
                f3Button.setImage(renderedUncheckedImage, for: .normal)
            }
        }
    }
    
    var isF4Checked = false {
        didSet{
            if isF4Checked{
                f4Button.setImage(renderedCheckedImage, for: .normal)
            }
            else{
                f4Button.setImage(renderedUncheckedImage, for: .normal)
            }
        }
    }
    
    let uncheckedImage = UIImage(named: "img/unchecked.png")
    let checkedImage = UIImage(named: "img/checked.png")
    var renderedUncheckedImage = UIImage()
    var renderedCheckedImage = UIImage()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = Color.cellBackground
        dateView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height/2)
        flagView.frame = CGRect(x: 0, y: frame.height/2, width: frame.width, height: frame.height/2)
        dateView.backgroundColor = UIColor.blue
        flagView.backgroundColor = UIColor.brown
        
//        isUserInteractionEnabled = true
//        dateView.isUserInteractionEnabled = true
//        flagView.isUserInteractionEnabled = true
        addSubview(dateView)
        addSubview(flagView)
        
        initTextLabels()
        initFlagLabels()
        initCheckBox()
    }

    let labelButtonDistance = ScreenSize.w/14
    
    func initCheckBox(){
        
        renderedUncheckedImage = uncheckedImage!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        renderedCheckedImage = checkedImage!.withRenderingMode((UIImageRenderingMode.alwaysTemplate))
        
        todayButton.setImage(renderedUncheckedImage, for: .normal)
        todayButton.setImage(renderedCheckedImage, for: .selected)
        todayButton.tintColor = Color.crossLabel
        todayButton.frame = todayLabel.frame.offsetBy(dx: todayLabel.frame.width+ScreenSize.w/18, dy: 0)
        todayButton.frame.size.width = todayButton.frame.size.height
        
        tomorrowButton.setImage(renderedUncheckedImage, for: .normal)
        tomorrowButton.tintColor = Color.crossLabel
        tomorrowButton.frame = tomorrowLabel.frame.offsetBy(dx: tomorrowLabel.frame.width+ScreenSize.w/18, dy: 0)
        tomorrowButton.frame.size.width = tomorrowButton.frame.size.height
        
        f1Button.frame = f1.frame.offsetBy(dx: labelButtonDistance, dy: 0)
        f1Button.setImage(renderedUncheckedImage, for: .normal)
        f1Button.tintColor = Color.crossLabel
        
        f2Button.frame = f2.frame.offsetBy(dx: labelButtonDistance, dy: 0)
        f2Button.setImage(renderedUncheckedImage, for: .normal)
        f2Button.tintColor = Color.crossLabel
        
        f3Button.frame = f3.frame.offsetBy(dx: labelButtonDistance, dy: 0)
        f3Button.setImage(renderedUncheckedImage, for: .normal)
        f3Button.tintColor = Color.crossLabel
        
        f4Button.frame = f4.frame.offsetBy(dx: labelButtonDistance, dy: 0)
        f4Button.setImage(renderedUncheckedImage, for: .normal)
        f4Button.tintColor = Color.crossLabel
        
        dateView.addSubview(todayButton)
        dateView.addSubview(tomorrowButton)
        
        flagView.addSubview(f1Button)
        flagView.addSubview(f2Button)
        flagView.addSubview(f3Button)
        flagView.addSubview(f4Button)
        
        todayButton.addTarget(self, action: #selector(self.checkToday), for: UIControlEvents.touchUpInside)
        todayButton.isUserInteractionEnabled = true
        tomorrowButton.addTarget(self, action: #selector(self.checkTomorrow), for: UIControlEvents.touchUpInside)
        tomorrowButton.isUserInteractionEnabled = true
        f1Button.addTarget(self, action: #selector(self.checkF1), for: .touchUpInside)
        f2Button.addTarget(self, action: #selector(self.checkF2), for: .touchUpInside)
        f3Button.addTarget(self, action: #selector(self.checkF3), for: .touchUpInside)
        f4Button.addTarget(self, action: #selector(self.checkF4), for: .touchUpInside)
    }
    func checkToday(){
        isTodayChecked = !isTodayChecked
    }
    
    func checkTomorrow(){
        isTomorrowChecked = !isTomorrowChecked
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
    
    func checkF4(){
        isF4Checked = !isF4Checked
    }
    
    
    
    
    func initTextLabels(){
        todayLabel.textColor = Color.text
        todayLabel.font = Font.text
        todayLabel.text = "Today"
        todayLabel.frame = CGRect(x: frame.width/18, y: 0, width: frame.width/3, height: dateView.frame.height/2)
        todayLabel.sizeToFit()
        todayLabel.center.y = dateView.frame.height/2
        dateView.addSubview(todayLabel)
        
        tomorrowLabel.textColor = Color.text
        tomorrowLabel.font = Font.text
        
        tomorrowLabel.text = "Tomorrow"
        
        tomorrowLabel.frame = CGRect(x: frame.width/2, y: 0, width: frame.width/3, height: dateView.frame.height/2)
        tomorrowLabel.sizeToFit()
        tomorrowLabel.center.y = dateView.frame.height/2
        dateView.addSubview(tomorrowLabel)
        
        
        flagLabel.textColor = Color.text
        flagLabel.font = Font.text
        flagLabel.text = "Flag"
        flagLabel.frame = CGRect(x: frame.width/18, y: 0, width: frame.width/3, height: flagView.frame.height/2)
        flagLabel.sizeToFit()
        flagLabel.center.y = flagView.frame.height/2
        flagView.addSubview(flagLabel)
    }
    
    let labelRadius = 5.0
    let flagLabelDistance = ScreenSize.w/5
    func initFlagLabels(){
        
        
        f1.frame = flagLabel.frame.offsetBy(dx: flagLabel.frame.width + ScreenSize.w/20, dy: 0)
        f1.backgroundColor = Color.f1
        f1.layer.masksToBounds = true
        f1.layer.cornerRadius = CGFloat(labelRadius)
        f1.frame.size.width = f1.frame.size.height
        flagView.addSubview(f1)
        
        f2.frame = flagLabel.frame.offsetBy(dx: flagLabel.frame.width + ScreenSize.w/20 + flagLabelDistance, dy: 0)
        f2.backgroundColor = Color.f2
        f2.layer.masksToBounds = true
        f2.layer.cornerRadius = CGFloat(labelRadius)
        f2.frame.size.width = f2.frame.size.height
        flagView.addSubview(f2)
        
        f3.frame = flagLabel.frame.offsetBy(dx: flagLabel.frame.width + ScreenSize.w/20 + 2*flagLabelDistance, dy: 0)
        f3.backgroundColor = Color.f3
        f3.layer.masksToBounds = true
        f3.layer.cornerRadius = CGFloat(labelRadius)
        f3.frame.size.width = f3.frame.size.height
        flagView.addSubview(f3)
        
        f4.frame = flagLabel.frame.offsetBy(dx: flagLabel.frame.width + ScreenSize.w/20 + 3*flagLabelDistance, dy: 0)
        f4.backgroundColor = Color.f4
        f4.layer.masksToBounds = true
        f4.layer.cornerRadius = CGFloat(labelRadius)
        f4.frame.size.width = f4.frame.size.height
        flagView.addSubview(f4)
        

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
