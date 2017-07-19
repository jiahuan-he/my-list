//
//  SettingItem.swift
//  MyList
//
//  Created by Jiahuan He on 04/07/2017.
//  Copyright © 2017 Jiahuan He. All rights reserved.
//

import UIKit


protocol SettingItemDelegate {
    func resetBadgeCount()
    func cancelScheduledNotifications()
    func resetScheduledNotifications()
}

protocol ThemeDelegate {
    func updateTheme()
}

class SettingItem: UIView {
   
    var buttonChecked = false{
        didSet{
        
            if buttonChecked == true{
                UserDefaults.standard.set(true, forKey: key)
                button.setImage(renderedCheckedImage, for: .normal)
                if key == settingKey.badge{
                    delegate!.resetBadgeCount()
                }
                else if(key == settingKey.reminder){
                    delegate!.resetScheduledNotifications()
                }
            }
            else{
                UserDefaults.standard.set(false, forKey: key)
                button.setImage(renderedUncheckedImage, for: .normal)
                if key == settingKey.badge{
                    delegate!.resetBadgeCount()
                }
                else if(key == settingKey.reminder){
                    delegate!.cancelScheduledNotifications()
                }
                else if(key == settingKey.sound){
                    
                }
            }
            UserDefaults.standard.synchronize()
        }
    }
    
    var key: String = ""
    let labelX = CGFloat(0.04 * ScreenSize.w)
    let buttonX = CGFloat(ScreenSize.w * 0.9)
    let label = UILabel()
    let button = UIButton()
    let seperatorWidth = sizeConvert(size: 1)
    var renderedCheckedImage: UIImage?
    var renderedUncheckedImage: UIImage?
    var delegate: TodoTableViewController?
    var themeDelegates: [ThemeDelegate] = []
    
    var darkLabel: UILabel?
//    var darkLabelX = CGFloat(ScreenSize.w * 0.75)
    var lightLabel: UILabel?
    let lightLabelX = CGFloat(ScreenSize.w * 0.55)
    let themeLabelDistance = CGFloat(ScreenSize.w * 0.01)
    
    var darkButton: UIButton?
    var lightButton: UIButton?
    
    var darkButtonX = CGFloat(ScreenSize.w * 0.9)
    
    var darkChecked = false{
        didSet{
            if darkChecked == true{
                darkButton!.setImage(renderedCheckedImage, for: .normal)
                lightButton!.setImage(renderedUncheckedImage, for: .normal)
                UserDefaults.standard.set("dark", forKey: settingKey.theme)
                
                
            }
            else{
                darkButton!.setImage(renderedUncheckedImage, for: .normal)
                lightButton!.setImage(renderedCheckedImage, for: .normal)
                UserDefaults.standard.set("light", forKey: settingKey.theme)
            }
            UserDefaults.standard.synchronize()
            print(UserDefaults.standard.string(forKey: settingKey.theme)!)
            for delegate in themeDelegates {
                delegate.updateTheme()
            }
        }
    }
    
    let seperator = CALayer()
    init(frame: CGRect, title: String, key: String) {
        self.key = key
        
        super.init(frame: frame)
        label.text = title
        label.font = Font.text
        label.textColor = Color.text
        label.frame = CGRect(x: labelX, y: 0, width: 0, height: 0)
        label.sizeToFit()
        label.center.y = self.frame.height/2
        
        
        let checkedImage = UIImage(named: "img/checked.png")
        let uncheckedImage = UIImage(named: "img/unchecked.png")
        
        renderedCheckedImage = checkedImage!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        renderedUncheckedImage = uncheckedImage!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        button.setImage(renderedCheckedImage, for: .normal)
        button.tintColor = Color.crossLabel
        button.setTitleColor(Color.crossLabel, for: .normal)
        button.frame = CGRect(x: buttonX, y: 0, width: label.frame.height*1.2, height: label.frame.height*1.2)
        button.center.y = self.frame.height/2
        
        if key == settingKey.theme{
            
            lightLabel = UILabel()
            lightLabel!.text = "light"
            lightLabel!.textColor = Color.text
            lightLabel!.font = Font.text
            lightLabel!.frame = CGRect(x: lightLabelX, y: 0, width: 0, height: 0)
            lightLabel!.sizeToFit()
            lightLabel!.center.y = self.frame.height/2
            
            lightButton = UIButton()
            lightButton!.setImage(renderedUncheckedImage, for: .normal)
            lightButton!.tintColor = Color.crossLabel
            lightButton!.frame = CGRect(x: lightLabelX + lightLabel!.frame.width + themeLabelDistance, y: 0, width: label.frame.height*1.2, height: label.frame.height*1.2)
            lightButton!.center.y = self.frame.height/2
            
            
            
            darkButton = UIButton()
            darkButton!.setImage(renderedUncheckedImage, for: .normal)
            darkButton!.tintColor = Color.crossLabel
            darkButton!.frame = CGRect(x: darkButtonX, y: 0, width: label.frame.height*1.2, height: label.frame.height*1.2)
            darkButton!.center.y = self.frame.height/2
            
            darkLabel = UILabel()
            darkLabel!.text = "dark"
            darkLabel!.textColor = Color.text
            darkLabel!.font = Font.text
            darkLabel!.sizeToFit()
            darkLabel!.frame = CGRect(x: darkButtonX-themeLabelDistance-darkLabel!.frame.width, y: 0, width: darkLabel!.frame.width, height: 0)
            darkLabel!.sizeToFit()
            darkLabel!.center.y = self.frame.height/2
            
            addSubview(lightLabel!)
            addSubview(lightButton!)
            addSubview(darkLabel!)
            addSubview(darkButton!)
            
            darkButton!.addTarget(self, action: #selector(self.checkDark), for: .touchUpInside)
            lightButton!.addTarget(self, action: #selector(self.checkLight), for: .touchUpInside)
            let theme = UserDefaults.standard.string(forKey: settingKey.theme)
            if theme == "dark"{
                darkChecked = true
                darkButton!.setImage(renderedCheckedImage, for: .normal)
            }
            else {
                darkChecked = false
                lightButton!.setImage(renderedCheckedImage, for: .normal)
            }
        }
        seperator.frame = CGRect(x: 0, y: frame.height-seperatorWidth, width: ScreenSize.w, height: seperatorWidth)
        seperator.backgroundColor = Color.separator.cgColor
        
        layer.addSublayer(seperator)
        if key != settingKey.theme{
            addSubview(button)
        }
        addSubview(label)
    }
    
    func checkDark(){
        button.tintColor = UIColor.red
        button.setTitleColor(UIColor.red, for: .normal)
        if darkChecked{
            return
        }
        darkChecked = true
    }
    
    func checkLight(){
        if !darkChecked{
            return
        }
        darkChecked = false
    }
    
    func refresh(){
        label.textColor = Color.text
        button.tintColor = Color.crossLabel                
        lightLabel?.textColor = Color.text
        lightButton?.tintColor = Color.crossLabel
        darkButton?.tintColor = Color.crossLabel
        darkLabel?.textColor = Color.text
        seperator.backgroundColor = Color.separator.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
