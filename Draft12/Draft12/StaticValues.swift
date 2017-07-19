//
//  StaticValues.swift
//  MyList
//
//  Created by LMAO on 18/07/2017.
//  Copyright © 2017 Jiahuan He. All rights reserved.
//

import Foundation
import UIKit

struct ScreenSize {
    static let w = UIScreen.main.bounds.width
    static let h = UIScreen.main.bounds.height
}

struct Font{
    static let text = UIFont(name: "ArialRoundedMTBold", size: sizeConvert(size: 15))
    static let dateButton = UIFont(name: "ArialRoundedMTBold", size: sizeConvert(size: 13))
    static let button = UIFont(name: "ArialRoundedMTBold", size: sizeConvert(size: 13))
    static let clue = UIFont(name: "ArialRoundedMTBold", size: sizeConvert(size: 15))
    static let navigationBarText = UIFont(name: "ArialRoundedMTBold", size: sizeConvert(size: 20))
    static let filter = UIFont(name: "ArialRoundedMTBold", size: sizeConvert(size: 13))
}



struct Color{
    
    static var text: UIColor{
        get{
            if let theme = UserDefaults.standard.string(forKey: settingKey.theme){
                if theme == "dark"{
                    return UIColor(red: 237/255, green: 236/255, blue: 232/255, alpha: 1)
                }
                else{
                    return UIColor.black
                }
            }
            return UIColor.black
        }
    }
    
    static var done: UIColor{
        get{
            if let theme = UserDefaults.standard.string(forKey: settingKey.theme){
                if theme == "dark"{
                    return UIColor(red: 237/255, green: 236/255, blue: 232/255, alpha: 1)
                }
                else{
                    return UIColor.black
                }
            }
                    return UIColor.black
        }
    }
    
    static var navigationBarText: UIColor{
        get{
            if let theme = UserDefaults.standard.string(forKey: settingKey.theme){
                if theme == "dark"{
                    return UIColor(red: 237/255, green: 236/255, blue: 232/255, alpha: 1)
                }
                else{
                    return UIColor.black
                }
            }
            return UIColor.black
        }
    }
    
    static var cellBackground: UIColor{
        get{
            if let theme = UserDefaults.standard.string(forKey: settingKey.theme){
                if theme == "dark"{
                    return UIColor(red: 35/255, green: 35/255, blue: 35/255, alpha: 1)
                }
                else{
                    return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                }
            }
            return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
    
    static var darkerCellBackground: UIColor{
        get{
            if let theme = UserDefaults.standard.string(forKey: settingKey.theme){
                if theme == "dark"{
                    return UIColor(red: 28/255, green: 28/255, blue: 28/255, alpha: 1)
                }
                else{
                    return UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
                }
            }
            return UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        }
    }
    
    static var tableViewBackground: UIColor{
        get{
            if let theme = UserDefaults.standard.string(forKey: settingKey.theme){
                if theme == "dark"{
                    return UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
                }
                else{
                    return UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
                }
            }
            return UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        }
    }
    
    static var separator: UIColor{
        get{
            if let theme = UserDefaults.standard.string(forKey: settingKey.theme){
                if theme == "dark"{
                    return UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 0.4)
                }
                else{
                    return UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 0.4)
                }
            }
            return UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 0.4)
        }
    }
    static var dateButton: UIColor{
        get{
            if let theme = UserDefaults.standard.string(forKey: settingKey.theme){
                if theme == "dark"{
                    return #colorLiteral(red: 0.9995340705, green: 0.9866005873, blue: 0.04135324298, alpha: 0.9740475171)
                }
                else{
                    return Color.text.withAlphaComponent(0.6)
                }
            }
            return Color.text.withAlphaComponent(0.6)
        }
    }
    
    static var navigationBar: UIColor{
        get{
            if let theme = UserDefaults.standard.string(forKey: settingKey.theme){
                if theme == "dark"{
                    return UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
                }
                else{
                    return UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
                }
            }
            return UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        }
    }
    
    static var settingLabel: UIColor{
        get{
            if let theme = UserDefaults.standard.string(forKey: settingKey.theme){
                if theme == "dark"{
                    return UIColor(red: 237/255, green: 236/255, blue: 232/255, alpha: 1)
                }
                else{
                    return UIColor.black
                }
            }
            return UIColor.black
        }
    }
    
    static var crossLabel: UIColor{
        get{
            if let theme = UserDefaults.standard.string(forKey: settingKey.theme){
                if theme == "dark"{
                    return UIColor(red: 237/255, green: 236/255, blue: 232/255, alpha: 1)
                }
                else{
                    return UIColor.black
                }
            }
            return UIColor.black
        }
    }
    
    static var settingSelected: UIColor{
        get{
            if let theme = UserDefaults.standard.string(forKey: settingKey.theme){
                if theme == "dark"{
                    return UIColor(red: 237/255, green: 236/255, blue: 232/255, alpha: 1)
                }
                else{
                    return UIColor.black
                }
            }
            return UIColor.black
        }
    }
    
    static var cue: UIColor{
        get{
            if let theme = UserDefaults.standard.string(forKey: settingKey.theme){
                if theme == "dark"{
                    return #colorLiteral(red: 0.9995340705, green: 0.9866005873, blue: 0.04135324298, alpha: 0.9740475171)
                }
                else{
                    return Color.text.withAlphaComponent(0.6)
                }
            }
            return Color.text.withAlphaComponent(0.6)
        }
    }
    
    static var filterIndicator: UIColor{
        get{
            if let theme = UserDefaults.standard.string(forKey: settingKey.theme){
                if theme == "dark"{
                    return #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
                }
                else{
                    return #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
                }
            }
            return #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        }
    }
    
    static let filterCircle = UIColor.yellow
    
    static let complete = #colorLiteral(red: 0.02237439216, green: 0.6006702094, blue: 0.1028243576, alpha: 1)
    static let f0 = UIColor.red
    static let f1 = UIColor.orange
    static let f2 = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
    static let f3 = UIColor.green
    static let remove = UIColor.red
    static let overdue = UIColor.red
}

struct Alpha {
    static let notEditingCell = CGFloat(0.3)
    static let complete = CGFloat(0.5)
    static let notSelectedFlag = CGFloat(0.3)
}

struct DateFormat {
    static let normal = "yyyy-MM-dd, E HH:mm "
    static let timeOnly = "HH:mm"
}

struct filterKey {
    static let today = "todaySelected"
    static let tomorrow =  "tomorrowSelected"
    static let noDate =  "noDateSelected"
    static let f0 = "f0Selected"
    static let f1 = "f1Selected"
    static let f2 = "f2Selected"
    static let f3 = "f3Selected"
}

struct settingKey {
    static let badge = "badgeCount"
    static let sound = "soundEffect"
    static let reminder = "dueReminder"
    static let theme = "theme"
//    static let dark = "dark"
//    static let light = "light"
}
