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
//
//struct Color{
//
//    static let text = UIColor(red: 237/255, green: 236/255, blue: 232/255, alpha: 1)
//    static let cellBackground = UIColor(red: 35/255, green: 35/255, blue: 35/255, alpha: 1)
//    static let darkerCellBackground =
//    static let tableViewBackground = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
//    static let navigationBar = tableViewBackground
//    static let navigationBarText = UIColor(red: 237/255, green: 236/255, blue: 232/255, alpha: 1)
//    static let separator = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 0.4)
//    static let settingLabel = Color.text
//    static let settingSelected = Color.text
//    static let dateButton = #colorLiteral(red: 0.9995340705, green: 0.9866005873, blue: 0.04135324298, alpha: 0.9740475171)
//    static let cue = #colorLiteral(red: 0.9995340705, green: 0.9866005873, blue: 0.04135324298, alpha: 0.9740475171)
//    static let crossLabel = Color.text
//    static let complete = #colorLiteral(red: 0.02237439216, green: 0.6006702094, blue: 0.1028243576, alpha: 1)
//    static let f0 = UIColor.red
//    static let f1 = UIColor.orange
//    static let f2 = UIColor.cyan
//    static let f3 = UIColor.green
//    static let remove = UIColor.red
//    static let done = Color.text
//    static let filtering = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
//    static let overdue = UIColor.red
//}
struct settings{
    static var theme: String{
        get{
            if UserDefaults.standard.string(forKey: settingKey.light) == "light"{
                return "light"
            }
            else if UserDefaults.standard.string(forKey: settingKey.light) == "dark"{
                return "dark"
            }
            else{
                return "light"
            }
        }
        set{
            UserDefaults.standard.set(theme, forKey: "theme")
            UserDefaults.standard.synchronize()
        }
    }
}



struct Color{
    
    static var text: UIColor{
        get{
            if settings.theme == "dark"{
                return UIColor(red: 237/255, green: 236/255, blue: 232/255, alpha: 1)
            }
            else{
                return UIColor.black
            }
        }
    }
    
    static var cellBackground: UIColor{
        get{
            if settings.theme == "dark"{
                return UIColor(red: 35/255, green: 35/255, blue: 35/255, alpha: 1)
            }
            else{
                return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
        }
    }
    
    static var darkerCellBackground: UIColor{
        get{
            if settings.theme == "dark"{
                return UIColor(red: 28/255, green: 28/255, blue: 28/255, alpha: 1)
            }
            else{
                return UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
            }
        }
    }
    
    static var tableViewBackground: UIColor{
        get{
            if settings.theme == "dark"{
                return UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
            }
            else{
                return UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
            }
        }
    }
    
    static var separator: UIColor{
        get{
            if settings.theme == "dark"{
                return UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 0.4)
            }
            else{
                return UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 0.4)
            }
        }
    }
    static var dateButton: UIColor{
        get{
            if settings.theme == "dark"{
                return #colorLiteral(red: 0.9995340705, green: 0.9866005873, blue: 0.04135324298, alpha: 0.9740475171)
            }
            else{
                return Color.text.withAlphaComponent(0.6)
            }
        }
    }
    
    static let navigationBar = tableViewBackground
    static let navigationBarText = text
    
    static let settingLabel = Color.text
    static let settingSelected = Color.text
    
    static let cue = Color.dateButton
    static let crossLabel = Color.text
    static let filterIndicator = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
    static let complete = #colorLiteral(red: 0.02237439216, green: 0.6006702094, blue: 0.1028243576, alpha: 1)
    static let f0 = UIColor.red
    static let f1 = UIColor.orange
    static let f2 = UIColor.cyan
    static let f3 = UIColor.green
    static let remove = UIColor.red
    static let done = Color.text
    static let overdue = UIColor.red
}

//
//
//struct FlagColor{
//    static let n1 = Color.cellBackground
//    static let c0 = UIColor.red
//    static let c1 = UIColor.orange
//    static let c2 = UIColor.cyan
//    static let c3 = UIColor.green
//}

struct Alpha {
    static let notEditingCell = CGFloat(0.3)
    static let complete = CGFloat(0.5)
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
    static let dark = "dark"
    static let light = "light"
}
