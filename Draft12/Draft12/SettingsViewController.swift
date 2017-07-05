//
//  SettingsViewController.swift
//  Draft12
//
//  Created by LMAO on 04/07/2017.
//  Copyright © 2017 Jiahuan He. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    
    var badgeCount: SettingItem?
    
    var originalHeight: CGFloat?
    let lineSpace = CGFloat(0.08 * ScreenSize.h)
    
    override func viewDidLoad() {
        originalHeight = (self.navigationController?.navigationBar.frame.height)! + (self.navigationController?.navigationBar.frame.origin.y)!
        super.viewDidLoad()
        self.title = "Settings"
        initLeftNavButton()
        self.view.backgroundColor = Color.cellBackground
        
        badgeCount = SettingItem(frame: CGRect(x: 0, y: originalHeight!, width: ScreenSize.w, height: lineSpace), title: "Badge Count")
        
        
        
        
        view.addSubview(badgeCount!)
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
