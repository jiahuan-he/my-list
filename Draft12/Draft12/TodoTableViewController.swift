//
//  TodoTableViewController.swift
//  MyList
//
//  Created by Jiahuan He on 28/02/2017.
//  Copyright © 2017 Jiahuan He. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import AudioToolbox
import AVFoundation
import StoreKit


extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

class TodoTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TodoItemTableViewCellDelegate, FilterViewDelegate, FilterIndicatorDelegate, SettingItemDelegate, ThemeDelegate{
    var modifyingDate = false
    var resignAfterModifyingDate = false
    var isCreatingNewCell = false
    
    var pickerOffset: CGFloat{
        switch UIScreen.main.bounds.width {
        case 375:
            return CGFloat(30)
        case 414:
            return CGFloat(40)
        default:
            return CGFloat(0)
        }
        
    }
    
    
    
    var initContentOffset: CGPoint = CGPoint.zero
    
    var barView = UIView()
    
    let datePickerHeight = ScreenSize.h/3.6
    
    var editingCell: TodoItemTableViewCell?
    
    var datePicker = UIDatePicker()
    var doneButton = UIButton()
    var removeButton = UIButton()
    var buttonHeight = ScreenSize.h/18
    var buttonWidth = ScreenSize.w/6
    
    @IBOutlet weak var tableView: UITableView!
    
    var items: [TodoItem] = []{
        didSet{
            if items.count == 0 && !isFiltered{
                backgroundTextView.isHidden = false
            }
            else if items.count > 0 || isFiltered{
                backgroundTextView.isHidden = true
            }
            resetBadgeCount()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var offset: CGFloat?
//        didSet{
//            print(offset)
//        }
    
    var tableTap: UITapGestureRecognizer?
    let filterIndicator = FilterIndicator()

    
    var newItemSound =  URL(fileURLWithPath: Bundle.main.path(forResource: "sound/newItem", ofType: "wav")!)
    var dingSound =  URL(fileURLWithPath: Bundle.main.path(forResource: "sound/ding", ofType: "wav")!)
    var tapSound =  URL(fileURLWithPath: Bundle.main.path(forResource: "sound/tap", ofType: "wav")!)
    var newItemPlayer: AVAudioPlayer?
    var dingPlayer: AVAudioPlayer?
    var tapPlayer: AVAudioPlayer?
    
    var backgroundDate = UILabel()
    var backgroundCue = UILabel()
    var backgroundTextView = UIView()
    
    func initBackgroundText(){
        
        backgroundDate.font = Font.text
        backgroundDate.textColor = Color.text
        let today = Date().toString(dateFormat: "EEEE, MMM d, yyyy")
        backgroundDate.text = today
        backgroundDate.sizeToFit()
        
        backgroundCue.font = Font.text
        backgroundCue.textColor = Color.text
        backgroundCue.text = "pull down to add"
        backgroundCue.sizeToFit()
        
        backgroundTextView = UIView()
        backgroundTextView.frame = CGRect(x: 0, y: 0, width: ScreenSize.w, height: backgroundDate.frame.height * 3)
        backgroundTextView.center = tableView.center
        
        backgroundDate.center.x = backgroundTextView.center.x
        backgroundDate.center.y = backgroundTextView.frame.height/4
        
        backgroundCue.center.x = backgroundTextView.center.x
        backgroundCue.center.y = backgroundTextView.frame.height * 5/6
        
        backgroundTextView.addSubview(backgroundDate)
        backgroundTextView.addSubview(backgroundCue)
        tableView.addSubview(backgroundTextView)
        
        backgroundTextView.isHidden = true
    }
    
    
    func initSounds(){
        // Load "mysoundname.wav"
        do {
            do{
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
                try AVAudioSession.sharedInstance().setActive(true)
            }
            catch{
                
            }
            newItemPlayer = try AVAudioPlayer(contentsOf: newItemSound)
            dingPlayer = try AVAudioPlayer(contentsOf: dingSound)
            tapPlayer = try AVAudioPlayer(contentsOf: tapSound)
            newItemPlayer!.prepareToPlay()
            dingPlayer!.prepareToPlay()
            tapPlayer!.prepareToPlay()
            
            
        }
        catch{
            // print("SOUND ERROR")
        }
    }
    
    func playTapSound(){
        if UserDefaults.standard.bool(forKey: settingKey.sound){
            if UserDefaults.standard.bool(forKey: settingKey.sound){
                if tapPlayer!.isPlaying{
                    tapPlayer!.stop()
                    tapPlayer!.currentTime = 0
                }
                tapPlayer!.play()
            }
        }
    }
    
    func playNewItemSound(){
        if UserDefaults.standard.bool(forKey: settingKey.sound){
            if newItemPlayer!.isPlaying{
                newItemPlayer!.stop()
                newItemPlayer!.currentTime = 0
            }
            newItemPlayer!.play()
        }
    }
    
    
    func playDingSound(){
        if UserDefaults.standard.bool(forKey: settingKey.sound){
            if dingPlayer!.isPlaying{
                dingPlayer!.stop()
                dingPlayer!.currentTime = 0
            }
            dingPlayer!.play()
        }
    }
    
    
    var firstLaunch = false
    let todayLabel = UILabel()
    func checkFirstLaunch(){
        if(UserDefaults.standard.bool(forKey: "HasLaunchedOnce"))
        {
            // app already launched
            firstLaunch = false

        }
        else
        {
            firstLaunch = true
            // This is the first launch ever
            UserDefaults.standard.set(true, forKey: settingKey.badge)
            UserDefaults.standard.set(true, forKey: settingKey.sound)
            UserDefaults.standard.set(true, forKey: settingKey.reminder)
            
            UserDefaults.standard.set(0, forKey: "num")
            UserDefaults.standard.set(true, forKey: "HasLaunchedOnce")
            UserDefaults.standard.set(0, forKey: "numOfEditings")
            UserDefaults.standard.set("dark", forKey: settingKey.theme)
            
            // print("has Launched once", UserDefaults.standard.bool(forKey: "HasLaunchedOnce"))
        }
        UserDefaults.standard.synchronize()
    }
    
    func incrementNumOfEditings(){
        var num = UserDefaults.standard.integer(forKey: "numOfEditings")
        num += 1
        UserDefaults.standard.set(num, forKey: "numOfEditings")
        if num > 16 && num%10 == 0{
            if #available(iOS 10.3, *) {
                SKStoreReviewController.requestReview()
            } else {
                // Fallback on earlier versions
            }
        }
        
    }
    
    override func viewDidLoad() {
        
        checkFirstLaunch()
        // print("Screen height: ", ScreenSize.h)
        // print("Screen width: ", ScreenSize.w)
        initSounds()
        
        
        if let theme = UserDefaults.standard.string(forKey: settingKey.theme){
            if  theme == "dark"{
                UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
            }
            else if theme == "light"{
                UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
            }
        }
        else{
            UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        }
        
        
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = Color.navigationBar
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: Color.navigationBarText, NSAttributedStringKey.font: Font.navigationBarText!]
        
        datePicker.frame = CGRect(x:  0, y:  ScreenSize.h - datePickerHeight, width:  UIScreen.main.bounds.width, height: datePickerHeight)
        
        //        datePicker.layer.borderWidth = 1
        //        datePicker.layer.borderColor = UIColor.green.cgColor
        
        // print("VIEW x", self.view.frame.origin.x)
        // print("VIEW y", self.view.frame.origin.y)
        //        self.view.addSubview(datePicker)
        UIApplication.shared.keyWindow?.addSubview(datePicker)
        
        datePicker.isHidden = true
        datePicker.datePickerMode = .dateAndTime
        
        barView.frame = CGRect(x: 0, y: datePicker.frame.origin.y - buttonHeight, width: UIScreen.main.bounds.width, height: buttonHeight)
        barView.backgroundColor = Color.cellBackground
        barView.layer.borderColor = Color.separator.cgColor
        barView.layer.borderWidth = 1
        barView.isHidden = true
        
        
        todayLabel.text = "Today is \(Date().toString(dateFormat: "MMM d, yyyy"))"
        todayLabel.font = Font.button
        todayLabel.textColor = Color.text
        todayLabel.sizeToFit()
        todayLabel.center.x = barView.frame.width/2
        todayLabel.center.y = barView.frame.height/2
        barView.addSubview(todayLabel)
        
        UIApplication.shared.keyWindow?.addSubview(barView)
        
        
        removeButton.frame = CGRect(x: 0.015*ScreenSize.w, y: 0, width: buttonWidth, height: buttonHeight)
        removeButton.setTitle("REMOVE", for: UIControlState.normal)
        removeButton.setTitleColor(Color.remove, for: UIControlState.normal)
        removeButton.titleLabel?.font = Font.button
        removeButton.sizeToFit()
        removeButton.center.y = barView.frame.height/2
        
        removeButton.addTarget(self, action: #selector(self.removeButtonPressed), for: UIControlEvents.touchUpInside)
        barView.addSubview(removeButton)
        
        doneButton.frame = CGRect(x: UIScreen.main.bounds.width-buttonWidth, y: 0, width: buttonWidth, height: buttonHeight)
        
        doneButton.setTitle("DONE", for: UIControlState.normal)
        doneButton.setTitleColor(Color.done, for: UIControlState.normal)
        doneButton.titleLabel?.font = Font.button
        doneButton.sizeToFit()
        doneButton.center.y = removeButton.center.y
        
        barView.addSubview(doneButton)
        doneButton.addTarget(self, action: #selector(self.doneButtonPressed), for: UIControlEvents.touchUpInside)
        
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        tableView.backgroundColor = Color.tableViewBackground
        
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "TodoItemTableViewCell", bundle: nil), forCellReuseIdentifier: "todoCell")
        
        tableTap = UITapGestureRecognizer(target: self, action: #selector(self.handleTableTap(_:)))
        tableView.addGestureRecognizer(tableTap!)
        
        initNavButton()
        filterView.isHidden = true
        filterView.delegate = self
        filterIndicator.isHidden = true
        filterIndicator.delegate = self
        tableView.addSubview(filterView)
//        tableView.addSubview(filterIndicator)
        filterIndicator.frame = CGRect(x: 0, y: (navigationController?.navigationBar.frame.height)! + (navigationController?.navigationBar.frame.origin.y)!, width: ScreenSize.w, height: ScreenSize.h/16)
        UIApplication.shared.keyWindow?.addSubview(filterIndicator)
        
        initBackgroundText()
        
        initContentOffset.y = -(self.navigationController?.navigationBar.frame.height)! - (self.navigationController?.navigationBar.frame.origin.y)!
        initContentOffset.x = 0
        //        tableView.setContentOffset(initContentOffset, animated: false)
        // print("INIT OFFSET" ,initContentOffset.y)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        super.viewWillAppear(animated)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        getData()
        tableView.reloadData()
        
        UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
        }
        //        UIApplication.shared.registerForRemoteNotifications()
        resetBadgeCount()
        
        tableView.setContentOffset(initContentOffset, animated: false)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.setContentOffset(initContentOffset, animated: false)
        
    }
    
    
    @objc func handleTableTap(_ sender: UITapGestureRecognizer){
        editingCell?.textView.resignFirstResponder()
    }
    
    struct dateSelector {
        static var today = false
        static var tomorrow = false
        static var noDate = false
    }
    
    struct flagSelector {
        static var f0 = false
        static var f1 = false
        static var f2 = false
        static var f3 = false
    }
    
    func doneFiltering(todaySelected: Bool, tomorrowSelected: Bool, noDateSelected: Bool, f0Selected: Bool, f1Selected: Bool, f2Selected: Bool, f3Selected: Bool) {
        
        isFiltering = false
        if todaySelected{
            dateSelector.today = true
        }
        else{
            dateSelector.today = false
        }
        
        if tomorrowSelected{
            dateSelector.tomorrow = true
        }
        else {
            dateSelector.tomorrow = false
        }
        
        if noDateSelected{
            dateSelector.noDate = true
        }
        else {
            dateSelector.noDate = false
        }
        
        if f0Selected{
            flagSelector.f0 = true
        }
        else{
            flagSelector.f0 = false
        }
        
        
        if f1Selected{
            flagSelector.f1 = true
        }
        else{
            flagSelector.f1 = false
        }
        if f2Selected{
            flagSelector.f2 = true
        }
        else{
            flagSelector.f2 = false
        }
        if f3Selected{
            flagSelector.f3 = true
        }
        else{
            flagSelector.f3 = false
        }
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(todaySelected, forKey: filterKey.today)
        userDefaults.set(tomorrowSelected, forKey: filterKey.tomorrow)
        userDefaults.set(noDateSelected, forKey: filterKey.noDate)
        userDefaults.set(f0Selected, forKey: filterKey.f0)
        userDefaults.set(f1Selected, forKey: filterKey.f1)
        userDefaults.set(f2Selected, forKey: filterKey.f2)
        userDefaults.set(f3Selected, forKey: filterKey.f3)
        userDefaults.synchronize()
        
        getData()
        let section = NSIndexSet(index: 0)
        filterView.isHidden = true
        tableView.reloadSections(section as IndexSet, with: .automatic)
        if todaySelected || tomorrowSelected || noDateSelected || f0Selected || f1Selected || f2Selected || f3Selected{
//            leftNavButton.setTitleColor(Color.filtering, for: .normal)
            isFiltered = true
            
        }
        else{
            isFiltered = false
        }
    }
    
    
    var rightNavButton = UIButton(type: .custom)
    var leftNavButton = UIButton(type: .custom)
    private func initNavButton(){
        let renderedFilterImage = UIImage(named: "img/filter")!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)

        leftNavButton.setImage(renderedFilterImage, for: .normal)
        leftNavButton.frame = CGRect(x: 0, y: 0, width: sizeConvert(size: 25), height: sizeConvert(size: 25))
        leftNavButton.addTarget(self, action: #selector(self.handleLeftNavButton), for: .touchUpInside)
//        leftNavButton.setTitleColor(Color.text, for: .normal)
        leftNavButton.tintColor = Color.text
        let item1 = UIBarButtonItem(customView: leftNavButton)
        
        let renderedSettingsImage = UIImage(named: "img/settings")!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        rightNavButton.setImage(renderedSettingsImage, for: .normal)
        rightNavButton.frame = CGRect(x: 0, y: 0, width: sizeConvert(size: 25), height: sizeConvert(size: 25))
        rightNavButton.addTarget(self, action: #selector(self.handleRightNavButton), for: .touchUpInside)
        rightNavButton.tintColor = Color.text
        
        let item2 = UIBarButtonItem(customView: rightNavButton)
        
        self.navigationItem.setRightBarButton(item2, animated: true)
        self.navigationItem.setLeftBarButton(item1, animated: true)
    }
    
    @objc func handleRightNavButton(){
        let settingsC = SettingsViewController()
        self.navigationController?.pushViewController(settingsC, animated: true)
        playTapSound()
        //        AudioServicesPlaySystemSound(tapSound)
    }
    
    
    var filterView = FilterView(frame: CGRect(x: 0, y: 0, width: ScreenSize.w, height: ScreenSize.h/5))
    var isFiltering: Bool = false{
        didSet{
            if isFiltering == true{
                tableView.isScrollEnabled = false
                self.filterView.isHidden = false
                tableTap!.isEnabled = false
                leftNavButton.isEnabled = false
                rightNavButton.isEnabled = false
                let vCells = tableView.visibleCells as! [TodoItemTableViewCell]
                for cell in vCells{
                    cell.isUserInteractionEnabled = false
                    cell.textView.isUserInteractionEnabled = false
                }
                tableView.setContentOffset(initContentOffset, animated: false)
            }
            else{
                tableView.isScrollEnabled = true
                self.filterView.isHidden = true
                tableTap!.isEnabled = true
                leftNavButton.isEnabled = true
                rightNavButton.isEnabled = true
                let vCells = tableView.visibleCells as! [TodoItemTableViewCell]
                for cell in vCells{
                    cell.isUserInteractionEnabled = true
                    cell.textView.isUserInteractionEnabled = true
                }
            }
        }
    }
    
    var isFiltered: Bool = false{
        didSet{
            if isFiltered{
                rightNavButton.isEnabled = false
                backgroundTextView.isHidden = true
                filterIndicator.isHidden = false
                filterIndicator.isHidden = false
                filterIndicator.addFilter(num: items.count)
                let vCells = tableView.visibleCells as! [TodoItemTableViewCell]
                tableView.frame.offsetBy(dx: 0, dy: 200)
//                let contentOffset = CGPoint(x: tableView.contentOffset.x, y: tableView.contentOffset.y - filterIndicator.frame.height)
//                tableView.setContentOffset(contentOffset, animated: true)
                print(initContentOffset.y)
                UIView.animate(withDuration: 0.5, animations: {() in
                    for cell in vCells{
                        cell.frame = cell.frame.offsetBy(dx: 0, dy: self.filterIndicator.frame.height)
                    }})
            }
            else{
                rightNavButton.isEnabled = true
                filterIndicator.isHidden = true
                
            }
        }
    }
    
    @objc func handleLeftNavButton(){
        //        AudioServicesPlaySystemSound(tapSound)
        playTapSound()
        if isFiltered{
            let vCells = tableView.visibleCells
            UIView.animate(withDuration: 0.5, animations: {() in
                for cell in vCells{
                    cell.alpha = Alpha.notEditingCell
                    cell.frame = cell.frame.offsetBy(dx: 0, dy: -self.filterIndicator.frame.height)
                }})
            isFiltered = false
        }
        
        if isFiltering == false {
            tableView.setContentOffset(initContentOffset, animated: false)
            // print("is setting init offset ", initContentOffset.y)
            isFiltering = true
            let vCells = tableView.visibleCells as! [TodoItemTableViewCell]
            
            UIView.animate(withDuration: 0.5, animations: {() in
                for cell in vCells{
                    cell.alpha = Alpha.notEditingCell
                    cell.frame = cell.frame.offsetBy(dx: 0, dy: self.filterView.frame.height)
                    // print(cell.textView.text)
                }})
        }
    }
    
    
    
    func removeFilterIndicator() {
        doneFiltering(todaySelected: false, tomorrowSelected: false, noDateSelected: false, f0Selected: false, f1Selected: false, f2Selected: false, f3Selected: false)
        filterView.clearDateSelection()
        filterView.clearFlagSelection()
        if items.count == 0 {
            backgroundTextView.isHidden = false
        }
        else{
            backgroundTextView.isHidden = true
        }
    }
    
    func assignOpacity(cell: TodoItemTableViewCell){
        
        cell.aButton?.alpha = 0.3
        cell.bButton?.alpha = 0.3
        cell.cButton?.alpha = 0.3
        cell.dButton?.alpha = 0.3
        if cell.todoItem!.flag == nil{
            return
        }
        switch Int(cell.todoItem!.flag!)! {
        case 0:
            cell.aButton!.alpha = 1
        case 1:
            cell.bButton!.alpha = 1
        case 2:
            cell.cButton!.alpha = 1
        case 3:
            cell.dButton!.alpha = 1
        default:
            break
        }
    }
    
    
    func getNotificationNum(){
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { requests in
            // print ("-------------------")
            var i=0
            for _ in requests {
                // print(request)
                i += 1
            }
            // print ("NUM OF NOTIFICATIONS: ", i)
            // print ("-------------------")
        })
    }
    
    func cancelScheduledNotifications(){
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        getNotificationNum()
    }
    func scheduleNotification(item: TodoItem?){
        if item == nil || !UserDefaults.standard.bool(forKey: settingKey.reminder){
            return
        }
        let today = Date()
        if item!.dueDate == nil || item!.dueDate!.compare(today) == .orderedAscending ||  item!.isComplete{
            return
        }
        let content = UNMutableNotificationContent()
        content.title = "Your task is due!"
        content.body = item!.name!
        content.sound = UNNotificationSound.default()
        
        //        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: item!.dueDate!.timeIntervalSince(today), repeats: false)
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: item!.dueDate! as Date)
        // print(dateComponents)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: String(item!.id), content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        
        center.add(request) { (error : Error?) in
            if error != nil {
                // print(theError.localizedDescription)
            }
        }
        getNotificationNum()
    }
    func resetScheduledNotifications(){
        if UserDefaults.standard.bool(forKey: settingKey.reminder){
            for item in items{
                scheduleNotification(item: item)
            }
        }
    }
    
    func removeNotification(item: TodoItem?){
        if item == nil{
            return
        }
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [String(item!.id)])
        getNotificationNum()
    }
    
    func resetBadgeCount(){
        if !UserDefaults.standard.bool(forKey: settingKey.badge){
            UIApplication.shared.applicationIconBadgeNumber = 0
            return
        }
        
        var badgeNum = 0
        for item in items{
            if item.isComplete == false {
                badgeNum += 1
            }
        }
        UIApplication.shared.applicationIconBadgeNumber = badgeNum
    }
    
    func onBoarding(){
        for i in 0...6{
            let newItem = TodoItem(context: context)
            let userDefault = UserDefaults.standard
            let id = userDefault.integer(forKey: "num")
            newItem.id = Int64(id)
            userDefault.set(id+1, forKey: "num")
            items.append(newItem)
            newItem.flag = String(i%4)
            
        }
        
        let today = Date() as NSDate
        items[0].name = "Pull down to add new task."
        items[0].createDate = today
        
        items[1].name = "Slide right to complete a task."
        items[2].name = "Slide left to delete a task."
        items[3].name = "Tap the filter at the left corner to filter tasks."
        
        items[4].name = "Overdue tasks' date is displayed as red."
        items[4].dueDate = Date() as NSDate
        
        items[5].name = "Date and flag can't be modified when filtering."
        items[5].dueDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())! as NSDate
        
        items[6].name = "Enjoy ʘ‿ʘ"
        items[6].dueDate = Calendar.current.date(byAdding: .day, value: 2, to: Date())! as NSDate

        items[1].createDate = items[0].createDate!.addingTimeInterval(-1)
        items[2].createDate = items[1].createDate!.addingTimeInterval(-1)
        items[3].createDate = items[2].createDate!.addingTimeInterval(-1)
        items[4].createDate = items[3].createDate!.addingTimeInterval(-1)
        items[5].createDate = items[4].createDate!.addingTimeInterval(-1)
        items[6].createDate = items[5].createDate!.addingTimeInterval(-1)
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let userDefaults = UserDefaults.standard
        userDefaults.set(false, forKey: filterKey.today)
        userDefaults.set(false, forKey: filterKey.tomorrow)
        userDefaults.set(false, forKey: filterKey.noDate)
        userDefaults.set(false, forKey: filterKey.f0)
        userDefaults.set(false, forKey: filterKey.f1)
        userDefaults.set(false, forKey: filterKey.f2)
        userDefaults.set(false, forKey: filterKey.f3)
        userDefaults.synchronize()
    }
    
    func getData(){
        do {
            if firstLaunch{
                onBoarding()
                firstLaunch = false
                return
            }
            let createDate = NSSortDescriptor(key: "createDate", ascending: false)
            let sortDate = NSSortDescriptor(key: "dueDate", ascending: true)
            let sortComplete = NSSortDescriptor(key: "isComplete", ascending: true)
            
            let fetchRequest:NSFetchRequest = TodoItem.fetchRequest()
            fetchRequest.sortDescriptors = [sortComplete, sortDate, createDate]
            items = try context.fetch(fetchRequest)
            
            var filteredItems: [TodoItem] = []
            
            let today = UserDefaults.standard.bool(forKey: filterKey.today)
            let tomorrow = UserDefaults.standard.bool(forKey: filterKey.tomorrow)
            let noDate = UserDefaults.standard.bool(forKey: filterKey.noDate)
            let f0Selected = UserDefaults.standard.bool(forKey: filterKey.f0)
            let f1Selected = UserDefaults.standard.bool(forKey: filterKey.f1)
            let f2Selected = UserDefaults.standard.bool(forKey: filterKey.f2)
            let f3Selected = UserDefaults.standard.bool(forKey: filterKey.f3)
            
            
            if today || tomorrow || noDate{
                for item in items{
                    if noDate{
                        if item.dueDate == nil{
                            filteredItems.append(item)
                        }
                    }
                    if item.dueDate == nil{
                        continue
                    }
                    if today{
                        if Calendar.current.isDateInToday(item.dueDate! as Date){
                            filteredItems.append(item)
                        }
                    }
                    if tomorrow{
                        if Calendar.current.isDateInTomorrow(item.dueDate! as Date){
                            filteredItems.append(item)
                        }
                    }
                }
            }
            
            if (f0Selected||f1Selected||f2Selected||f3Selected) {
                for item in items{
                    if f0Selected{
                        if item.flag == "0"{
                            filteredItems.append(item)
                        }
                    }
                    if f1Selected{
                        if item.flag == "1"{
                            filteredItems.append(item)
                        }
                    }
                    if f2Selected{
                        if item.flag == "2"{
                            filteredItems.append(item)
                        }
                    }
                    if f3Selected{
                        if item.flag == "3"{
                            filteredItems.append(item)
                        }
                    }
                }
            }
            if f0Selected||f1Selected||f2Selected||f3Selected||today||tomorrow||noDate{
                items = filteredItems
            }
        }
        catch{
            // print("Wrong")
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as! TodoItemTableViewCell
        
        //Clear all attributed text. Every time a cell is being recycled and reused, its attributed text is not entirely erased, which leads to new cell "born with" attributed text. So I have to clear all attributed text right after a cell is "being born"
        cell.textView.attributedText = nil
        cell.textView.typingAttributes = [:]
        cell.textView.linkTextAttributes = [:]
        cell.textView.allowsEditingTextAttributes = false
        
        cell.overdueLabel.textColor = Color.cue
        cell.crossLabel.tintColor = Color.crossLabel
        cell.checkLabel.tintColor = Color.crossLabel
        cell.contentView.backgroundColor = Color.cellBackground
        cell.textView.backgroundColor = Color.cellBackground
        cell.backgroundColor = Color.cellBackground
        if let theme = UserDefaults.standard.string(forKey: settingKey.theme){
            if theme == "light"{
                cell.textView.keyboardAppearance = UIKeyboardAppearance.light
            }
            else{
                cell.textView.keyboardAppearance = UIKeyboardAppearance.dark
            }
        }
        else{
            cell.textView.keyboardAppearance = UIKeyboardAppearance.dark
        }
        
        cell.delegate = self
        cell.todoItem = items[indexPath.row]
        
        cell.rightBorder.backgroundColor = assignBorderColor(cell: cell).cgColor
        if cell.todoItem != nil{
            if cell.todoItem!.dueDate != nil{
                cell.dateButton.isHidden = false
                let pickerDate = cell.todoItem!.dueDate! as Date
                var date: String = ""
                if NSCalendar.current.isDateInToday(pickerDate){
                    date = "Today @ " + cell.todoItem!.dueDate!.toString(dateFormat: DateFormat.timeOnly)
                }
                else if NSCalendar.current.isDateInTomorrow(pickerDate){
                    date = "Tomorrow @ " + cell.todoItem!.dueDate!.toString(dateFormat: DateFormat.timeOnly)
                }
                else{
                    date = cell.todoItem!.dueDate!.toString(dateFormat: DateFormat.normal)
                    date.insert("@", at: date.index(date.startIndex, offsetBy: 15))
                    date.insert(" ", at: date.index(date.startIndex, offsetBy: 15
                        
                    ))
                }
                cell.dateButton.setTitle(date, for: UIControlState.normal)
                cell.dateButton.titleLabel?.sizeToFit()
                cell.dateButton.sizeToFit()
                
                let today = Date()
                if cell.todoItem!.dueDate!.compare(today) == .orderedAscending && !cell.todoItem!.isComplete  {
                    cell.dateButton.setTitleColor(Color.overdue, for: .normal)
                }
                else{
                    cell.dateButton.setTitleColor(Color.dateButton, for: .normal)
                }
                
            }
            else{
                cell.dateButton.isHidden = true
                cell.dateButton.setTitle("", for: .normal)
            }
        }
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        cell.dateButton.isEnabled = false
        
        
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: cell.textView.text)
        attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: sizeConvert(size: 2), range: NSMakeRange(0, attributeString.length))
        if cell.todoItem!.isComplete{
            cell.textView.attributedText = attributeString
            cell.textView.font = Font.text
            cell.textView.textColor = Color.complete
            cell.dateButton.alpha = Alpha.complete
            cell.rightBorder.opacity = Float(Alpha.complete)
            cell.textView.typingAttributes = [:]
            //            editingCell.textView.backgroundColor = Color.complete
        }
        else{
            attributeString.removeAttribute(NSAttributedStringKey.strikethroughColor, range: NSMakeRange(0, attributeString.length))
            //            cell.textView.attributedText = attributeString
            cell.textView.typingAttributes = [:]
            cell.textView.font = Font.text
            cell.textView.textColor = Color.text
            cell.dateButton.alpha = 1
            cell.rightBorder.opacity = 1
            //            editingCell.textView
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    private func hidePicker(){
        datePicker.isHidden = true
        barView.isHidden = true
    }
    
    // buttons helper function
    @objc func removeButtonPressed(){
        modifyingDate = false
        hidePicker()
        editingCell!.todoItem!.dueDate = nil
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        UIView.animate(withDuration: 0, animations: {() in
            self.editingCell!.dateButton.setTitle("Add Due Date", for: UIControlState.normal)
            self.editingCell!.dateButton.setTitleColor(Color.dateButton, for: .normal)
            self.editingCell!.dateButton.titleLabel?.sizeToFit()
            self.editingCell!.dateButton.sizeToFit()
        })
        editingCell!.isUserInteractionEnabled = true
        resignAfterModifyingDate = true
        editingCell!.textView.becomeFirstResponder()
    }
    
    @objc func doneButtonPressed(){
        leftNavButton.isEnabled = true
        rightNavButton.isEnabled = true
        modifyingDate = false
        hidePicker()
        editingCell!.todoItem!.dueDate = datePicker.date as NSDate
        let dateButton = editingCell!.dateButton
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        UIView.animate(withDuration: 0.2, animations: { () in
            
            let pickerDate = self.datePicker.date as Date
            
            var date = ""
            if NSCalendar.current.isDateInToday(pickerDate){
                date = "Today @ " + pickerDate.toString(dateFormat: DateFormat.timeOnly)
                
            }
            else if NSCalendar.current.isDateInTomorrow(pickerDate){
                date = "Tomorrow @ " + pickerDate.toString(dateFormat: DateFormat.timeOnly)
            }
            else{
                date = pickerDate.toString(dateFormat: DateFormat.normal)
                date.insert("@", at: date.index(date.startIndex, offsetBy: 15))
                date.insert(" ", at: date.index(date.startIndex, offsetBy: 15))
            }
            dateButton.setTitle(date, for: UIControlState.normal)
            dateButton.titleLabel?.sizeToFit()
            dateButton.sizeToFit()
            
        })
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        editingCell!.isUserInteractionEnabled = true
        resignAfterModifyingDate = true
        
        leftNavButton.isEnabled = true
        rightNavButton.isEnabled = true
        
        let today = Date()
        if editingCell!.todoItem!.dueDate!.compare(today) == .orderedAscending && !editingCell!.todoItem!.isComplete {
            editingCell!.dateButton.setTitleColor(Color.overdue, for: .normal)
        }
        else{
            editingCell!.dateButton.setTitleColor(Color.dateButton, for: .normal)
        }
        
        editingCell!.textView.becomeFirstResponder()
        removeNotification(item: editingCell!.todoItem)
        scheduleNotification(item: editingCell!.todoItem)
    }
    
    //TodoItemTableViewCell delegate
    
    func popupDatePicker(editingCell: TodoItemTableViewCell) {
        
        
        tableView.isScrollEnabled = false
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        
        modifyingDate = true
        datePicker.backgroundColor = Color.cellBackground
        
        
        datePicker.setValue(false, forKey: "highlightsToday")
        datePicker.setValue(Color.text, forKey: "textColor")

        if editingCell.todoItem?.dueDate == nil{
            datePicker.setDate(NSDate() as Date, animated: false)
        }
        else {
            datePicker.setDate(editingCell.todoItem!.dueDate! as Date, animated: false)
        }
        
        datePicker.isHidden = false
        barView.isHidden = false
        
        editingCell.isUserInteractionEnabled = false
        
        self.editingCell = editingCell
        editingCell.textView.resignFirstResponder()
        leftNavButton.isEnabled = false
        rightNavButton.isEnabled = false
    }
    
    func cellHeightDidChange(editingCell: TodoItemTableViewCell, heightChange: CGFloat) {
        
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        // calculate the height to adjust.
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        
        let visibleCells = self.tableView.visibleCells as! [TodoItemTableViewCell]
        for cell in visibleCells {
            if cell !== editingCell {
                cell.textView.isEditable = false
                cell.alpha = Alpha.notEditingCell
            }
            
            if isFiltered{
                cell.frame = cell.frame.offsetBy(dx: 0, dy: self.filterIndicator.frame.height)
            }
            else{
                cell.frame = cell.frame.offsetBy(dx: 0, dy: self.offset!)
            }
        }
    }
    
    private func assignBorderColor (cell: TodoItemTableViewCell) -> UIColor{
        if let f = cell.todoItem?.flag{
            switch f {
            case "0" :
                return Color.f0
            case "1":
                return Color.f1
            case "2":
                return Color.f2
            case "3":
                return Color.f3
            case "-1":
                return Color.cellBackground
            default:
                break
            }}
        return UIColor.clear
    }
    
    func cellFlagDidChange(editingCell: TodoItemTableViewCell){
        UIView.animate(withDuration: 0.5, animations: {() in
            self.assignOpacity(cell: editingCell)
            editingCell.rightBorder.backgroundColor = self.assignBorderColor(cell: editingCell).cgColor
            //            editingCell.textView.backgroundColor = self.assignBorderColor(cell: editingCell)
        })
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    func itemDeleted(item: TodoItem) {
        incrementNumOfEditings()
        removeNotification(item: item)
        let itemIndex = (items as NSArray).index(of: item)
        let cellIndex = IndexPath(row: itemIndex, section: 0)
        if items.contains(item){
            items.remove(at: itemIndex)
        }
        if isFiltered{
            filterIndicator.addFilter(num: items.count)
        }
        item.dueDate = nil
        item.flag = nil
        
        let deletedCell = tableView.cellForRow(at: cellIndex) as! TodoItemTableViewCell
        deletedCell.dateButton.setTitle("", for: .normal)
        //        deletedCell.dateButton.isHidden = true
        context.delete(item)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        tableView.beginUpdates()
        let indexPathForRow = NSIndexPath(row: itemIndex, section: 0)
        //        deletedCell.textView.attributedText = nil
        tableView.deleteRows(at: [indexPathForRow as IndexPath], with: .left)
        tableView.endUpdates()
        if isFiltered{
            for cell in tableView.visibleCells{
                UIView.animate(withDuration: 0.3, animations: {() in
                    cell.frame = cell.frame.offsetBy(dx: 0, dy: self.filterIndicator.frame.height)
                    
                })
            }
        }
        playDingSound()
    }
    
    func itemComplete(editingCell: TodoItemTableViewCell){
        incrementNumOfEditings()
        editingCell.todoItem!.isComplete = !editingCell.todoItem!.isComplete
        removeNotification(item: editingCell.todoItem!)
        scheduleNotification(item: editingCell.todoItem!)
        
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: editingCell.textView.text)
        attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: sizeConvert(size: 2), range: NSMakeRange(0, attributeString.length))
        if (editingCell.todoItem?.isComplete)! {
            editingCell.textView.attributedText = attributeString
            editingCell.textView.font = Font.text
            editingCell.textView.textColor = Color.complete
            editingCell.dateButton.alpha = Alpha.complete
            editingCell.rightBorder.opacity = Float(Alpha.complete)
            editingCell.dateButton.setTitleColor(Color.dateButton, for: .normal)
        }
        else{
            
            attributeString.removeAttribute(NSAttributedStringKey.strikethroughColor, range: NSMakeRange(0, attributeString.length))
            editingCell.textView.typingAttributes = [:]
            editingCell.textView.text = editingCell.todoItem?.name
            editingCell.textView.font = Font.text
            editingCell.textView.textColor = Color.text
            editingCell.dateButton.alpha = 1
            editingCell.rightBorder.opacity = 1
            let today = Date()
            
            
            if editingCell.todoItem!.dueDate != nil && editingCell.todoItem!.dueDate!.compare(today) == .orderedDescending{
                editingCell.dateButton.setTitleColor(Color.dateButton, for: .normal)
            }
            else{
                editingCell.dateButton.setTitleColor(Color.overdue, for: .normal)
            }
            
        }
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        if items.contains(editingCell.todoItem!) {
            let fromPath = IndexPath(row: items.index(of: editingCell.todoItem!)!, section: 0)
            getData()
            let toPath = IndexPath(row: items.index(of: editingCell.todoItem!)!, section: 0)
            tableView.beginUpdates()
            tableView.moveRow(at: fromPath, to: toPath)
            tableView.endUpdates()
        }
        let vCells = tableView.visibleCells as! [TodoItemTableViewCell]
        for cell in vCells{
            if !(cell.todoItem?.isComplete)!{
                cell.textView.typingAttributes = [:]
            }
            if isFiltered{
                UIView.animate(withDuration: 0.3, animations: {() in
                    cell.frame = cell.frame.offsetBy(dx: 0, dy: self.filterIndicator.frame.height)
                })
            }
        }
        resetBadgeCount()
        playDingSound()
    }
    
    func cellDidBeginEditing(editingCell: TodoItemTableViewCell) {
//        print("head in cellDidbeginEditing " , editingCell.frame.origin.y)
        playNewItemSound()
        leftNavButton.isEnabled = false
        rightNavButton.isEnabled = false
        //        filterIndicator.isHidden = true
        UIView.animate(withDuration: 0.3, animations: {() in
//            self.filterIndicator.frame = self.filterIndicator.frame.offsetBy(dx: 0, dy: -self.filterIndicator.frame.height)
        })
        self.editingCell = editingCell
        assignOpacity(cell: editingCell)
        tableView.isScrollEnabled = false
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        editingCell.dateButton.isEnabled = true
        if resignAfterModifyingDate{
            resignAfterModifyingDate = false
            return
        }
        
        
        // IMPORTANT: (-initContentOffset.y + tableView.contentOffset.y) should be 0 if at beginning position
//        print("-initContentOffset.y: ", -initContentOffset.y)
//        print("tableView.contentOffset.y: ", tableView.contentOffset.y)
//        print("editingCell.frame.origin.y ", -editingCell.frame.origin.y)
        offset =  -initContentOffset.y + tableView.contentOffset.y - editingCell.frame.origin.y
        if isCreatingNewCell{
            offset = 0
            isCreatingNewCell = false
        }
        // Important feature: scrolview content offset !!
        let visibleCells = tableView.visibleCells as! [TodoItemTableViewCell]
        for cell in visibleCells {
            UIView.animate(withDuration: 0.3, animations: {() in
                cell.frame = cell.frame.offsetBy(dx: 0, dy: self.offset!)
                
                if self.isFiltered{                    
                        cell.frame = cell.frame.offsetBy(dx: 0, dy: self.filterIndicator.frame.height)
                }
                
                
                if cell != editingCell{
                    cell.alpha = Alpha.notEditingCell
                    cell.textView.isEditable = false
                }
                else{
                }
            })
        }

        if(editingCell.todoItem!.dueDate == nil){
            editingCell.dateButton.setTitle("Add Due Date", for: UIControlState.normal)
            editingCell.dateButton.setTitleColor(Color.dateButton, for: .normal)
            editingCell.dateButton.titleLabel?.sizeToFit()
            editingCell.dateButton.sizeToFit()
        }
        if isFiltered {
            editingCell.dateButton.isHidden = true
            editingCell.hideLabels()
        }
        else{
            editingCell.dateButton.isHidden = false
        }
    }
    
    func cellDidEndEditing(editingCell: TodoItemTableViewCell) {
      
        var deletedItem = false
        
        incrementNumOfEditings()
        if !isFiltered{
            leftNavButton.isEnabled = true
            rightNavButton.isEnabled = true
        }
        if(modifyingDate == true){
            return
        }
        if(editingCell.todoItem?.dueDate == nil){
            UIView.transition(with: editingCell.dateButton, duration: 0.3, options: .transitionCrossDissolve, animations:{ () -> Void  in
                editingCell.dateButton.isHidden = true
            }, completion: nil)
        }
        if(editingCell.todoItem!.dueDate != nil){
            editingCell.dateButton.isHidden = false
            let pickerDate = editingCell.todoItem!.dueDate! as Date
            var date = ""
            if NSCalendar.current.isDateInToday(pickerDate){
                date = "Today @ " + pickerDate.toString(dateFormat: DateFormat.timeOnly)
            }
            else if NSCalendar.current.isDateInTomorrow(pickerDate){
                date = "Tomorrow @ " + pickerDate.toString(dateFormat: DateFormat.timeOnly)
            }
            else{
                date = pickerDate.toString(dateFormat: DateFormat.normal)
                date.insert("@", at: date.index(date.startIndex, offsetBy: 15))
                date.insert(" ", at: date.index(date.startIndex, offsetBy: 15))
            }
            editingCell.dateButton.setTitle(date, for: UIControlState.normal)
            editingCell.dateButton.titleLabel?.sizeToFit()
            editingCell.dateButton.sizeToFit()
            
        }
        else{
            editingCell.dateButton.isHidden = true
        }

        if editingCell.todoItem?.name == "" {
            deletedItem = true
            itemDeleted(item: editingCell.todoItem!)
        }
        else{
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        }
        
        let visibleCells = tableView.visibleCells as! [TodoItemTableViewCell]
        for cell: TodoItemTableViewCell in visibleCells {
            cell.textView.isEditable = true
            if !deletedItem{
                UIView.animate(withDuration: 0.3, animations: {() in
                    cell.frame = cell.frame.offsetBy(dx: 0, dy: -self.offset!)
                })
            }
        }
        offset = 0
        editingCell.dateButton.isEnabled = false
        if !deletedItem{
            if items.contains(editingCell.todoItem!) {
                tableView.beginUpdates()
                let fromPath = IndexPath(row: items.index(of: editingCell.todoItem!)!, section: 0)
                getData()
                let toPath = IndexPath(row: items.index(of: editingCell.todoItem!)!, section: 0)
                tableView.moveRow(at: fromPath, to: toPath)
                tableView.endUpdates()
            }
            if isFiltered{
                let vCells = tableView.visibleCells
                UIView.animate(withDuration: 0.3, animations: {() in
                    for cell in vCells{
                        cell.frame = cell.frame.offsetBy(dx: 0, dy: self.filterIndicator.frame.height)
                    }})
            }
        }
        self.navigationItem.leftBarButtonItem?.isEnabled = true
        tableView.isScrollEnabled = true
        isCreatingNewCell = false
    }
    
    // MARK: - UIScrollViewDelegate methods
    // contains scrollViewDidScroll, and other methods, to keep track of dragging the scrollView
    
    // a cell that is rendered as a placeholder to indicate where a new item is added
    //    var placeHolderCell: TodoItemTableViewCell?
    // indicates the state of this behavior
    var pullDownInProgress = false
    var clueView: UIView?
    let marginalHeight = ScreenSize.h/15
    var addClueLabel = UILabel()
    
    var scrolledByUser = false
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrolledByUser = true
        clueView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        addClueLabel.font = Font.clue
        addClueLabel.textColor = Color.cue
        
        //        // this behavior starts when a user pulls down while at the top of the table
        pullDownInProgress = (scrollView.contentOffset.y + -initContentOffset.y) <= 0.0
        clueView!.backgroundColor = UIColor.clear
        if pullDownInProgress {
            if !isFiltered{
                tableView.insertSubview(clueView!, at: 0)
                clueView?.addSubview(addClueLabel)
            }
        }
    }
    
    private var lastContentOffset: CGFloat = 0
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isFiltered{
            if (self.lastContentOffset > scrollView.contentOffset.y) && scrolledByUser {
                // move up
                filterIndicator.resultLabel.text = "REMOVE FILTER TO ADD"
                filterIndicator.resultLabel.sizeToFit()
            }
            else if (self.lastContentOffset < scrollView.contentOffset.y) {
                // move down
                
            }
            // update the new position acquired
            self.lastContentOffset = scrollView.contentOffset.y
            addClueLabel.isHidden = true

            
            return
        }
        
        addClueLabel.isHidden = false
        let maxOffsetY = sizeConvert(size: -110)

        if scrollView.contentOffset.y < maxOffsetY{
            scrollView.contentOffset.y = maxOffsetY
        }
        
        let scrollViewContentOffsetY = scrollView.contentOffset.y + -initContentOffset.y
        if(scrollViewContentOffsetY <= -marginalHeight){
            addClueLabel.text = "release to add"
        }
        else{
            addClueLabel.text = "pull to add"
        }
        if pullDownInProgress && scrollViewContentOffsetY <= 0.0 {
            addClueLabel.sizeToFit()
            addClueLabel.frame = CGRect(x: 0, y: -scrollViewContentOffsetY-sizeConvert(size: 30), width: ScreenSize.w/3, height: addClueLabel.frame.height)
            
            addClueLabel.center.x = tableView.center.x
            
            clueView!.frame = CGRect(x: 0, y: scrollViewContentOffsetY,
                                     width: tableView.frame.size.width, height: -scrollViewContentOffsetY)
        } else {
            pullDownInProgress = false
        }
    }

    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrolledByUser = false
        if isFiltered{
            filterIndicator.addFilter(num: items.count)
            return
        }
        let scrollViewContentOffsetY = scrollView.contentOffset.y - initContentOffset.y
        if pullDownInProgress && scrollViewContentOffsetY <= -marginalHeight{
            clueView?.isHidden = true
            
            let newItem = TodoItem(context: context)
            let userDefault = UserDefaults.standard
            let id = userDefault.integer(forKey: "num")
            newItem.createDate = Date() as NSDate
            newItem.id = Int64(id)
            userDefault.set(id+1, forKey: "num")
            newItem.flag = "0"
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.beginUpdates()
            items.insert(newItem, at: 0)
            tableView.insertRows(at: [indexPath], with: .top)
            tableView.endUpdates()
            let newCell = tableView.cellForRow(at: indexPath) as! TodoItemTableViewCell

            isCreatingNewCell = true
            newCell.textView!.becomeFirstResponder()

        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("end decelerating content offset", tableView.contentOffset.y)
        if isFiltered{
            filterIndicator.addFilter(num: items.count)
            let path = IndexPath(row: 0, section: 0)
            if let cell = tableView.cellForRow(at: path){
                print(cell.frame.origin.y)
                if cell.frame.origin.y == 0 && tableView.contentOffset.y == initContentOffset.y{
                    tableView.reloadData()
                    let vCells = tableView.visibleCells
                    UIView.animate(withDuration: 0.3, animations: {() in
                        for cell in vCells{
                            cell.frame = cell.frame.offsetBy(dx: 0, dy: self.filterIndicator.frame.height)
                    }})
                }
            }
            return
        }
    }
    
    
    func updateTheme() {
        backgroundDate.textColor = Color.text
        backgroundCue.textColor = Color.text
        navigationController?.navigationBar.barTintColor = Color.navigationBar
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: Color.navigationBarText, NSAttributedStringKey.font: Font.navigationBarText!]
        barView.backgroundColor = Color.cellBackground
        barView.layer.borderColor = Color.separator.cgColor
        removeButton.setTitleColor(Color.remove, for: UIControlState.normal)
        doneButton.setTitleColor(Color.done, for: UIControlState.normal)
        tableView.backgroundColor = Color.tableViewBackground
        leftNavButton.tintColor = Color.text
        rightNavButton.tintColor = Color.text
        todayLabel.textColor = Color.text
        datePicker.backgroundColor = Color.cellBackground        
        datePicker.setValue(Color.text, forKey: "textColor")
        datePicker.setValue(false, forKey: "highlightsToday")
        filterIndicator.refresh()
        filterView.refresh()
    }
    
    
}
