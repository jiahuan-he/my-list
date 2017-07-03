//
//  TodoTableViewController.swift
//  Draft11
//
//  Created by LMAO on 28/02/2017.
//  Copyright © 2017 Jiahuan He. All rights reserved.
//

import UIKit
import CoreData

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
}

struct Color{
    
    static let text = UIColor(red: 237/255, green: 236/255, blue: 232/255, alpha: 1)
    static let cellBackground = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
    static let tableViewBackground = UIColor(red: 55/255, green: 60/255, blue: 58/255, alpha: 1)
    static let navigationBar = tableViewBackground
    static let navigationBarText = UIColor(red: 237/255, green: 236/255, blue: 232/255, alpha: 1)
    static let separator = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 0.4)
    static let settingLabel = Color.text
    static let settingUnselected = Color.text.withAlphaComponent(0.5)
    static let settingSelected = Color.text
    static let dateButton = #colorLiteral(red: 0.9995340705, green: 0.9866005873, blue: 0.04135324298, alpha: 0.9740475171)
    static let cue = #colorLiteral(red: 0.9995340705, green: 0.9866005873, blue: 0.04135324298, alpha: 0.9740475171)
    static let crossLabel = Color.text
    static let complete = #colorLiteral(red: 0.02237439216, green: 0.6006702094, blue: 0.1028243576, alpha: 1)
    static let f0 = UIColor.red
    static let f1 = UIColor.orange
    static let f2 = UIColor.cyan
    static let f3 = UIColor.green
    static let remove = UIColor.red
    static let done = Color.text
    static let filtering = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
}

struct FlagColor{
    static let n1 = Color.cellBackground
    static let c0 = UIColor.red
    static let c1 = UIColor.orange
    static let c2 = UIColor.cyan
    static let c3 = UIColor.green
}

struct Alpha {
    static let notEditingCell = CGFloat(0.3)
    static let complete = CGFloat(0.5)
}

struct DateFormat {
    static let normal = "yyyy-MM-dd, E HH:mm "
    static let timeOnly = "HH:mm"
}

extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

class TodoTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TodoItemTableViewCellDelegate, FilterViewDelegate{
    var modifyingDate = false
    var resignAfterModifyingDate = false
    var createdNewCell = false
    
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
    
    var initContentOffsetY: CGFloat = 0
    
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
    
    var items: [TodoItem] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var offset: CGFloat?
    var tableTap: UITapGestureRecognizer?

    
    override func viewDidLoad() {
        print("Screen height: ", ScreenSize.h)
        print("Screen width: ", ScreenSize.w)
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = Color.navigationBar
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Color.navigationBarText, NSFontAttributeName: Font.navigationBarText!]
        
        datePicker.frame = CGRect(x:  0, y:  ScreenSize.h - datePickerHeight, width:  UIScreen.main.bounds.width, height: datePickerHeight)
        
        datePicker.layer.borderWidth = 1
        datePicker.layer.borderColor = UIColor.green.cgColor
        
        print("VIEW x", self.view.frame.origin.x)
        print("VIEW y", self.view.frame.origin.y)
//        self.view.addSubview(datePicker)
        UIApplication.shared.keyWindow?.addSubview(datePicker)
        
        datePicker.isHidden = true
        datePicker.datePickerMode = .dateAndTime
        
        barView.frame = CGRect(x: 0, y: datePicker.frame.origin.y - buttonHeight, width: UIScreen.main.bounds.width, height: buttonHeight)
        barView.backgroundColor = Color.cellBackground
        barView.layer.borderColor = Color.separator.cgColor
        barView.layer.borderWidth = 1
        barView.isHidden = true
        UIApplication.shared.keyWindow?.addSubview(barView)
        
        
        removeButton.frame = CGRect(x: 0.015*ScreenSize.w, y: 0, width: buttonWidth, height: buttonHeight)
        removeButton.setTitle("REMOVE", for: UIControlState.normal)
        removeButton.setTitleColor(UIColor.red, for: UIControlState.normal)
        removeButton.titleLabel?.font = Font.button
        removeButton.sizeToFit()
        removeButton.center.y = barView.frame.height/2
        
        removeButton.addTarget(self, action: #selector(self.removeButtonPressed), for: UIControlEvents.touchUpInside)
        barView.addSubview(removeButton)
        
        doneButton.frame = CGRect(x: UIScreen.main.bounds.width-buttonWidth, y: 0, width: buttonWidth, height: buttonHeight)
        
        doneButton.setTitle("DONE", for: UIControlState.normal)
        doneButton.setTitleColor(UIColor.gray, for: UIControlState.normal)
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
        tableView.addSubview(filterView)
    }
    
    func handleTableTap(_ sender: UITapGestureRecognizer){
        editingCell!.textView.resignFirstResponder()
        //        cellDidEndEditing(editingCell: self.editingCell!)
        
    }

//    struct predicate {
//        static let today = NSPredicate(format: "dueDate = %@", NSDate())
//        static let f0 = NSPredicate(format: "flag = %@", "0")
//        static let f1 = NSPredicate(format: "flag = %@", "1")
//        static let f2 = NSPredicate(format: "flag = %@", "2")
//        static let f3 = NSPredicate(format: "flag = %@", "3")
//    }
    
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
        
        if todaySelected || tomorrowSelected || f0Selected || f1Selected || f2Selected || f3Selected{
            leftNavButton.tintColor = Color.filtering
            UserDefaults.standard.set(todaySelected, forKey: "todaySelected")
            UserDefaults.standard.set(tomorrowSelected, forKey: "tomorrowSelected")
            UserDefaults.standard.set(f0Selected, forKey: "f0Selected")
            UserDefaults.standard.set(f1Selected, forKey: "f1Selected")
            UserDefaults.standard.set(f2Selected, forKey: "f2Selected")
            UserDefaults.standard.set(f3Selected, forKey: "f3Selected")
        }
        
        getData()
        let section = NSIndexSet(index: 0)
        filterView.isHidden = true
        tableView.reloadSections(section as IndexSet, with: .automatic)
//        UIView.transition(with: tableView,
//                          duration: 0.35,
//                          options: .transitionCrossDissolve,
//                          animations: { self.tableView.reloadData() })
        
    }
    
    func removeFiltering() {
        
    }
    
    var rightNavButton = UIButton(type: .custom)
    var leftNavButton = UIButton(type: .custom)
    private func initNavButton(){
        
        leftNavButton.setImage(UIImage(named: "img/filter"), for: .normal)
        leftNavButton.frame = CGRect(x: 0, y: 0, width: sizeConvert(size: 25), height: sizeConvert(size: 25))
        leftNavButton.addTarget(self, action: #selector(self.handleLeftNavButton), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: leftNavButton)
        
        rightNavButton.setImage(UIImage(named: "img/settings"), for: .normal)
        rightNavButton.frame = CGRect(x: 0, y: 0, width: sizeConvert(size: 25), height: sizeConvert(size: 25))
        rightNavButton.addTarget(self, action: #selector(self.handleRightNavButton), for: .touchUpInside)
        let item2 = UIBarButtonItem(customView: rightNavButton)
        
        self.navigationItem.setRightBarButton(item2, animated: true)
        self.navigationItem.setLeftBarButton(item1, animated: true)
    }
    
    func handleRightNavButton(){
        
    }
    
    
    var filterView = FilterView(frame: CGRect(x: 0, y: 0, width: ScreenSize.w, height: ScreenSize.h/5))
    var isFiltering: Bool = false{
        didSet{
            if isFiltering == true{
                self.filterView.isHidden = false
                tableTap!.isEnabled = false
                let vCells = tableView.visibleCells as! [TodoItemTableViewCell]
                for cell in vCells{
                    cell.isUserInteractionEnabled = false
                    cell.textView.isUserInteractionEnabled = false
                }
            }
            else{
                self.filterView.isHidden = true
                tableTap!.isEnabled = true
                let vCells = tableView.visibleCells as! [TodoItemTableViewCell]
                for cell in vCells{
                    cell.isUserInteractionEnabled = true
                    cell.textView.isUserInteractionEnabled = true
                }
            }
        }
    }
    
    func handleLeftNavButton(){
                        
        if isFiltering == false {
            tableView.setContentOffset(initContentOffset, animated: false)

            isFiltering = true
            let vCells = tableView.visibleCells as! [TodoItemTableViewCell]
            
            
            UIView.animate(withDuration: 0.5, animations: {() in
                for cell in vCells{
                    cell.alpha = Alpha.notEditingCell
                    cell.frame = cell.frame.offsetBy(dx: 0, dy: self.filterView.frame.height)
                    print(cell.textView.text)
                }})
            
        }
//        else{
//            isFiltering = false
//            self.filterView.isHidden = true
//            let vCells = tableView.visibleCells as! [TodoItemTableViewCell]
//            UIView.animate(withDuration: 0.5, animations: {() in
//                for cell in vCells{
//                    cell.alpha = 1
//                    cell.frame = cell.frame.offsetBy(dx: 0, dy: -self.filterView.frame.height)
//                }})
//        }
    }
    
    func assignOpacity(cell: TodoItemTableViewCell){
        
        cell.aButton?.alpha = 0.5
        cell.bButton?.alpha = 0.5
        cell.cButton?.alpha = 0.5
        cell.dButton?.alpha = 0.5
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        getData()
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        initContentOffsetY = -tableView.contentOffset.y
        initContentOffset = tableView.contentOffset
        print(initContentOffsetY)
    }
    
//    var subPredicates : [NSPredicate] = []
    func getData(){
        do {
            let sortDate = NSSortDescriptor(key: "dueDate", ascending: true)
            let sortComplete = NSSortDescriptor(key: "isComplete", ascending: true)
            
            let fetchRequest:NSFetchRequest = TodoItem.fetchRequest()
            fetchRequest.sortDescriptors = [sortComplete, sortDate]
//            
//            if !subPredicates.isEmpty{
//                let compoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: subPredicates)
//                fetchRequest.predicate = compoundPredicate
//            }
//            
            
            items = try context.fetch(fetchRequest)
            
            
            
            var filteredItems: [TodoItem] = []
            if dateSelector.today || dateSelector.tomorrow || dateSelector.noDate{
                for item in items{
                    if dateSelector.noDate{
                        if item.dueDate == nil{
                            filteredItems.append(item)
                        }
                    }
                    if item.dueDate == nil{
                        continue
                    }
                    if dateSelector.today{
                        if Calendar.current.isDateInToday(item.dueDate! as Date){
                            filteredItems.append(item)
                        }
                    }
                    if dateSelector.tomorrow{
                        if Calendar.current.isDateInTomorrow(item.dueDate! as Date){
                            filteredItems.append(item)
                        }
                    }
                }
            }
            
            if (flagSelector.f0 || flagSelector.f1 || flagSelector.f2 || flagSelector.f3) {
                for item in items{
                    if flagSelector.f0{
                        if item.flag == "0"{
                            filteredItems.append(item)
                        }
                    }
                    if flagSelector.f1{
                        if item.flag == "1"{
                            filteredItems.append(item)
                        }
                    }
                    if flagSelector.f2{
                        if item.flag == "2"{
                            filteredItems.append(item)
                        }
                    }
                    if flagSelector.f3{
                        if item.flag == "3"{
                            filteredItems.append(item)
                        }
                    }
                }
            }
            if flagSelector.f0 || flagSelector.f1 || flagSelector.f2 || flagSelector.f3 || dateSelector.today || dateSelector.tomorrow || dateSelector.noDate{
                items = filteredItems
            }
            
        }
        catch{
            print("Wrong")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as! TodoItemTableViewCell
        //        cell.textView.attributedText = nil
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
        attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: sizeConvert(size: 2), range: NSMakeRange(0, attributeString.length))
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
            attributeString.removeAttribute(NSStrikethroughColorAttributeName, range: NSMakeRange(0, attributeString.length))
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
    func removeButtonPressed(){
        modifyingDate = false
        hidePicker()
        editingCell!.todoItem!.dueDate = nil
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        UIView.animate(withDuration: 0, animations: {() in
            self.editingCell!.dateButton.setTitle("Add Due Date", for: UIControlState.normal)
        })
        editingCell!.isUserInteractionEnabled = true
        resignAfterModifyingDate = true
        editingCell!.textView.becomeFirstResponder()
    }
    
    func doneButtonPressed(){
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
        editingCell!.textView.becomeFirstResponder()
        
    }
    
    //TodoItemTableViewCell delegate
    
    func popupDatePicker(editingCell: TodoItemTableViewCell) {
        tableView.isScrollEnabled = false
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        
        modifyingDate = true
        datePicker.backgroundColor = Color.cellBackground
        datePicker.setValue(Color.text, forKey: "textColor")
        
        datePicker.setValue(false, forKey: "highlightsToday")
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
            cell.frame = cell.frame.offsetBy(dx: 0, dy: self.offset!)
        }
    }
    
    private func assignBorderColor (cell: TodoItemTableViewCell) -> UIColor{
        if let f = cell.todoItem?.flag{
            switch f {
            case "0" :
                return FlagColor.c0
            case "1":
                return FlagColor.c1
            case "2":
                return FlagColor.c2
            case "3":
                return FlagColor.c3
            case "-1":
                return FlagColor.n1
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
        let itemIndex = (items as NSArray).index(of: item)
        let cellIndex = IndexPath(row: itemIndex, section: 0)
        if items.contains(item){
            items.remove(at: itemIndex)
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
        
    }
    
    func itemComplete(editingCell: TodoItemTableViewCell){
        editingCell.todoItem!.isComplete = !editingCell.todoItem!.isComplete
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: editingCell.textView.text)
        attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: sizeConvert(size: 2), range: NSMakeRange(0, attributeString.length))
        if (editingCell.todoItem?.isComplete)! {
            editingCell.textView.attributedText = attributeString
            editingCell.textView.font = Font.text
            editingCell.textView.textColor = Color.complete
            editingCell.dateButton.alpha = Alpha.complete
            editingCell.rightBorder.opacity = Float(Alpha.complete)
            //            editingCell.textView.backgroundColor = Color.complete
        }
        else{
            //            editingCell.textView.backgroundColor = Color.cellBackground
            //            editingCell.textView.attributedText = attributeString
            attributeString.removeAttribute(NSStrikethroughColorAttributeName, range: NSMakeRange(0, attributeString.length))
            //            editingCell.textView.attributedText = attributeString
            editingCell.textView.typingAttributes = [:]
            editingCell.textView.text = editingCell.todoItem?.name
            editingCell.textView.font = Font.text
            editingCell.textView.textColor = Color.text
            editingCell.dateButton.alpha = 1
            editingCell.rightBorder.opacity = 1
            
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
        }
    }
    
    func cellDidBeginEditing(editingCell: TodoItemTableViewCell) {
        self.editingCell = editingCell
        assignOpacity(cell: editingCell)
        tableView.isScrollEnabled = false
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        editingCell.dateButton.isEnabled = true
        if resignAfterModifyingDate{
            resignAfterModifyingDate = false
            return
        }
        
        offset = tableView.contentOffset.y - editingCell.frame.origin.y
        offset = initContentOffsetY + offset!
        
        // Important feature: scrolview content offset !!
        let visibleCells = tableView.visibleCells as! [TodoItemTableViewCell]
        for cell in visibleCells {
            UIView.animate(withDuration: 0.3, animations: {() in
                cell.frame = cell.frame.offsetBy(dx: 0, dy: self.offset!)
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
            editingCell.dateButton.isHidden = false
        }
        
    }
    
    func cellDidEndEditing(editingCell: TodoItemTableViewCell) {
        
        if(modifyingDate == true){
            return
        }
        if(editingCell.todoItem?.dueDate == nil){
            UIView.transition(with: editingCell.dateButton, duration: 0.3, options: .transitionCrossDissolve, animations:{ _ in
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
        
        
        let visibleCells = tableView.visibleCells as! [TodoItemTableViewCell]
        print("offset " , self.offset!)
        for cell: TodoItemTableViewCell in visibleCells {
            UIView.animate(withDuration: 0.3, animations: {() in
                cell.frame = cell.frame.offsetBy(dx: 0, dy: -self.offset!)
            })
        }
        
        UIView.animate(withDuration: 0.5, animations: {() in
            
            
        }, completion: {(finished: Bool) in
            
            for cell: TodoItemTableViewCell in visibleCells {
                cell.textView.isEditable = true
            }
        })
        
        if editingCell.todoItem?.name == "" {
            itemDeleted(item: editingCell.todoItem!)
        }
        else{
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        }
        offset = 0
        editingCell.dateButton.isEnabled = false
        
        
        if items.contains(editingCell.todoItem!) {
            
            // WOW! The API is AMAZING! Thanks Apple!
            tableView.beginUpdates()
            //            if !createdNewCell{
            let fromPath = IndexPath(row: items.index(of: editingCell.todoItem!)!, section: 0)
            getData()
            let toPath = IndexPath(row: items.index(of: editingCell.todoItem!)!, section: 0)
            tableView.moveRow(at: fromPath, to: toPath)
            //            }
            tableView.endUpdates()
//            let index = NSIndexSet(index: 0)
//            tableView.reloadSections(index as IndexSet, with: .automatic)
        }
        createdNewCell = false
        self.navigationItem.leftBarButtonItem?.isEnabled = true
        tableView.isScrollEnabled = true
    }
    
    // MARK: - UIScrollViewDelegate methods
    // contains scrollViewDidScroll, and other methods, to keep track of dragging the scrollView
    
    // a cell that is rendered as a placeholder to indicate where a new item is added
    //    var placeHolderCell: TodoItemTableViewCell?
    // indicates the state of this behavior
    var pullDownInProgress = false
    var clueView: UIView?
    let marginalHeight = sizeConvert(size: 26)
    var addClueLabel = UILabel()
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        clueView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        addClueLabel.font = Font.clue
        addClueLabel.textColor = Color.cue
        
        //        // this behavior starts when a user pulls down while at the top of the table
        pullDownInProgress = (scrollView.contentOffset.y + initContentOffsetY) <= 0.0
        clueView!.backgroundColor = UIColor.clear
        if pullDownInProgress {
            tableView.insertSubview(clueView!, at: 0)
            clueView?.addSubview(addClueLabel)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let maxOffsetY = sizeConvert(size: -110)
        
        print("scroll: ",scrollView.contentOffset.y)
        if scrollView.contentOffset.y < maxOffsetY{
            scrollView.contentOffset.y = maxOffsetY
        }
        
        let scrollViewContentOffsetY = scrollView.contentOffset.y + initContentOffsetY
        if(scrollViewContentOffsetY <= -marginalHeight){
            addClueLabel.text = "Release"
        }
        else{
            addClueLabel.text = "Test"
        }
        if pullDownInProgress && scrollViewContentOffsetY <= 0.0 {
            // maintain the location of the placeholder
            print(scrollViewContentOffsetY)
            addClueLabel.frame = CGRect(x: tableView.frame.size.width/2-30, y: -scrollViewContentOffsetY-sizeConvert(size: 30), width: sizeConvert(size: 100), height: sizeConvert(size: 30))
            clueView!.frame = CGRect(x: 0, y: scrollViewContentOffsetY,
                                     width: tableView.frame.size.width, height: -scrollViewContentOffsetY)
            //            addClueLabel!.alpha = min(1.0, -scrollViewContentOffsetY/marginalHeight)
        } else {
            pullDownInProgress = false
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let scrollViewContentOffsetY = scrollView.contentOffset.y + initContentOffsetY
        if pullDownInProgress && scrollViewContentOffsetY <= -marginalHeight{
            clueView?.isHidden = true
            let newItem = TodoItem(context: context)
            newItem.flag = "0"
            let indexPath = IndexPath(row: 0, section: 0)
//            if subPredicates.isEmpty == false{
//                subPredicates = []
//                getData()
//                tableView.reloadData()
//            }
            tableView.beginUpdates()
            items.insert(newItem, at: 0)
            tableView.insertRows(at: [indexPath], with: .top)
            tableView.endUpdates()
            let newCell = tableView.cellForRow(at: indexPath) as! TodoItemTableViewCell
            newCell.textView!.becomeFirstResponder()
            createdNewCell = true
            cellDidBeginEditing(editingCell: tableView.cellForRow(at: indexPath) as! TodoItemTableViewCell)
        }
    }
    
    
}
