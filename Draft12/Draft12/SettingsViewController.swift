

//
//  SettingsViewController.swift
//  Draft12
//
//  Created by LMAO on 04/07/2017.
//  Copyright © 2017 Jiahuan He. All rights reserved.
//

import UIKit
import UserNotifications

class SettingsViewController: UIViewController {
    
    var badgeCountView: SettingItem?
    var soundEffectView: SettingItem?
    var reminderView: SettingItem?
    
    var originalHeight: CGFloat?
    let lineSpace = CGFloat(0.08 * ScreenSize.h)
    var authorized = false
    
    override func viewDidLoad() {
        
        originalHeight = (self.navigationController?.navigationBar.frame.height)! + (self.navigationController?.navigationBar.frame.origin.y)!
        super.viewDidLoad()
        self.title = "Settings"
        initLeftNavButton()
        self.view.backgroundColor = Color.cellBackground
        
        badgeCountView = SettingItem(frame: CGRect(x: 0, y: originalHeight!, width: ScreenSize.w, height: lineSpace), title: "Badge Count", key: settingKey.badge)
        soundEffectView = SettingItem(frame: (badgeCountView?.frame.offsetBy(dx: 0, dy: (badgeCountView?.frame.height)!))!, title: "Sound Effect", key: settingKey.sound)
        reminderView = SettingItem(frame: (soundEffectView?.frame.offsetBy(dx: 0, dy: (badgeCountView?.frame.height)!))!, title: "Due Reminder", key: settingKey.reminder)

        if let navController = self.navigationController, navController.viewControllers.count >= 2 {
            let viewController = navController.viewControllers[navController.viewControllers.count - 2]
            badgeCountView!.delegate = viewController as? TodoTableViewController
            soundEffectView!.delegate = viewController as? TodoTableViewController
            reminderView!.delegate = viewController as? TodoTableViewController
        }

        getBadgeAuthorizationResult()
        if UserDefaults.standard.bool(forKey: settingKey.badge) && authorized{
            badgeCountView?.buttonChecked = true
        }
        else{
            badgeCountView?.buttonChecked = false
        }
        
        getAlertAuthorizationResult()
        if UserDefaults.standard.bool(forKey: settingKey.reminder) && authorized{
            reminderView?.buttonChecked = true
        }
        else{
            reminderView?.buttonChecked = false
        }
        
        if UserDefaults.standard.bool(forKey: settingKey.sound) {
            soundEffectView?.buttonChecked = true            
        }
        
        badgeCountView!.button.addTarget(self, action: #selector(handleBadgeButton), for: .touchUpInside)
        soundEffectView!.button.addTarget(self, action: #selector(handleSoundButton), for: .touchUpInside)
        reminderView!.button.addTarget(self, action: #selector(handleReminderButton), for: .touchUpInside)
        
        
        view.addSubview(soundEffectView!)
        view.addSubview(badgeCountView!)
        view.addSubview(reminderView!)
        
        
    }
    
    func handleBadgeButton(){
        checkAuthorization(forKey: settingKey.badge)
    }
  
    func handleReminderButton(){
        checkAuthorization(forKey: settingKey.reminder)
    }
    
    func handleSoundButton(){
        //        checkAuthorization(forKey: "soundEffect")
    }
    
    func getAlertAuthorizationResult(){
        if let settings = UIApplication.shared.currentUserNotificationSettings {
            if settings.types.contains([.alert]) {
                authorized = true
            } else {
                authorized = false
            }
        }
    }
    
    func getBadgeAuthorizationResult(){
        if let settings = UIApplication.shared.currentUserNotificationSettings {
            if settings.types.contains([.badge]) {
                authorized = true
            } else{
                authorized = false
            }
        }
    }
    
    
    func checkAuthorization(forKey key: String){
        
        
        var currentView: SettingItem
        switch key {
        case settingKey.badge:
            currentView = badgeCountView!
        case settingKey.reminder:
            currentView = reminderView!
        default:
            fatalError()
        }
        
        if UserDefaults.standard.bool(forKey: key) {
            currentView.buttonChecked = false
            return
        }
        else{
            if key == settingKey.badge{
                getBadgeAuthorizationResult()
            }
            else{
                getAlertAuthorizationResult()
            }
            if authorized{
                currentView.buttonChecked = true
            }
            else{
                alert()
            }
        }
    }

    
    func alert(){
        let alert = UIAlertController(title: "MyList", message: "Please turn on notification", preferredStyle: UIAlertControllerStyle.alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(settingsAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func initLeftNavButton(){
        self.navigationItem.leftBarButtonItem?.title = "DONE"
        let leftNavButton = UIButton(type: .custom)
        leftNavButton.setTitle("DONE", for: .normal)
        leftNavButton.setTitleColor(Color.done, for: .normal)
        leftNavButton.titleLabel?.font = Font.text
        leftNavButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftNavButton.titleLabel?.sizeToFit()
        leftNavButton.sizeToFit()
        leftNavButton.addTarget(self, action: #selector(self.handleLeftNavButton), for: .touchUpInside)
        let leftItem = UIBarButtonItem(customView: leftNavButton)
        self.navigationItem.setLeftBarButton(leftItem, animated: false)
    }
    
    
    private func initSettingItemTF(frame: CGRect, labelText: String){
        
    }
    
    
    func handleLeftNavButton(){
        _ = navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
}
