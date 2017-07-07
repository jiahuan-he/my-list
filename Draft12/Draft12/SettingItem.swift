//
//  SettingItem.swift
//  Draft12
//
//  Created by LMAO on 04/07/2017.
//  Copyright © 2017 Jiahuan He. All rights reserved.
//

import UIKit


protocol SettingItemDelegate {
    func resetBadgeCount()
    func cancelScheduledNotifications()
    func resetScheduledNotifications()
}

class SettingItem: UIView {
    var key: String = ""
    let labelX = CGFloat(0.04 * ScreenSize.w)
    let buttonX = CGFloat(ScreenSize.w * 0.9)
    let label = UILabel()
    let button = UIButton()
    let seperatorWidth = sizeConvert(size: 1)
    var renderedCheckedImage: UIImage?
    var renderedUncheckedImage: UIImage?
    var delegate: TodoTableViewController?
    
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
        button.frame = CGRect(x: buttonX, y: 0, width: label.frame.height, height: label.frame.height)
        button.center.y = self.frame.height/2
        
        let seperator = CALayer()
        seperator.frame = CGRect(x: 0, y: frame.height-seperatorWidth, width: ScreenSize.w, height: seperatorWidth)
        seperator.backgroundColor = Color.separator.cgColor
        
        layer.addSublayer(seperator)
        addSubview(button)
        addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
