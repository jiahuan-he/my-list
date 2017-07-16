

//
//  SettingsViewController.swift
//  MyList
//
//  Created by Jiahuan He on 04/07/2017.
//  Copyright © 2017 Jiahuan He. All rights reserved.
//

import UIKit
import UserNotifications
import AVFoundation
import MessageUI



class SettingsViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    var badgeCountView: SettingItem?
    var soundEffectView: SettingItem?
    var reminderView: SettingItem?
    
    var feedbackView: SettingItem?
    
    var originalHeight: CGFloat?
    let lineSpace = CGFloat(0.08 * ScreenSize.h)
    var authorized = false
    
    var tapSound =  URL(fileURLWithPath: Bundle.main.path(forResource: "sound/tap", ofType: "wav")!)
    var tapPlayer: AVAudioPlayer?
    
    
    
    func initSounds(){
        do {
            tapPlayer = try AVAudioPlayer(contentsOf: tapSound)
            tapPlayer?.prepareToPlay()
        }
        catch{
            print("SOUND ERROR")
        }
    }
    
    func playTapSound(){
        if UserDefaults.standard.bool(forKey: settingKey.sound){
            if tapPlayer!.isPlaying{
                tapPlayer!.stop()
                tapPlayer!.currentTime = 0
            }
            tapPlayer!.play()
        }
    }
    
    
    
    override func viewDidLoad() {
        initSounds()
        originalHeight = (self.navigationController?.navigationBar.frame.height)! + (self.navigationController?.navigationBar.frame.origin.y)!
        super.viewDidLoad()
        self.title = "Settings"
        initLeftNavButton()
        self.view.backgroundColor = Color.cellBackground
        
        badgeCountView = SettingItem(frame: CGRect(x: 0, y: originalHeight!, width: ScreenSize.w, height: lineSpace), title: "Badge Count", key: settingKey.badge)
        soundEffectView = SettingItem(frame: (badgeCountView?.frame.offsetBy(dx: 0, dy: (badgeCountView?.frame.height)!))!, title: "Sound Effect", key: settingKey.sound)
        reminderView = SettingItem(frame: (soundEffectView?.frame.offsetBy(dx: 0, dy: (badgeCountView?.frame.height)!))!, title: "Due Reminder", key: settingKey.reminder)
        
        feedbackView = SettingItem(frame: (reminderView?.frame.offsetBy(dx: 0, dy: (badgeCountView?.frame.height)!))!, title: "Send Feedback", key: settingKey.sound)
        feedbackView?.button.isHidden = true
        //        feedbackView?.label.center.x = self.view.center.x
        let feedbackRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.sendEmailButtonTapped(sender:)))
        feedbackView?.addGestureRecognizer(feedbackRecognizer)
        
        
        
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
        else{
            soundEffectView?.buttonChecked = false
        }
        
        badgeCountView!.button.addTarget(self, action: #selector(handleBadgeButton), for: .touchUpInside)
        soundEffectView!.button.addTarget(self, action: #selector(handleSoundButton), for: .touchUpInside)
        reminderView!.button.addTarget(self, action: #selector(handleReminderButton), for: .touchUpInside)
        
        
        view.addSubview(soundEffectView!)
        view.addSubview(badgeCountView!)
        view.addSubview(reminderView!)
        view.addSubview(feedbackView!)
        
        
    }
    
    func handleBadgeButton(){
        checkAuthorization(forKey: settingKey.badge)
    }
    
    func handleReminderButton(){
        checkAuthorization(forKey: settingKey.reminder)
    }
    
    func handleSoundButton(){
        soundEffectView!.buttonChecked = !soundEffectView!.buttonChecked
    }
    
    func getAlertAuthorizationResult(){
        if let settings = UIApplication.shared.currentUserNotificationSettings {
            if settings.types.contains([.alert, .sound]) {
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
    
    
    func handleLeftNavButton(){
        playTapSound()
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    
    func sendEmailButtonTapped(sender: AnyObject) {
        print("email")
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            //            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["jiahuanhe.dev@gmail.com"])
        mailComposerVC.setSubject("Feedback")
        mailComposerVC.setMessageBody("Hello, ", isHTML: false)
        
        return mailComposerVC
    }
    
    //
    //    func showSendMailErrorAlert() {
    //        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
    //        let
    //        sendMailErrorAlert.show()
    //    }
    
    // MARK: MFMailComposeViewControllerDelegate
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
}
