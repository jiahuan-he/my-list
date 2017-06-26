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
    static let text = UIFont(name: "ArialRoundedMTBold", size: sizeConvert(size: 16))
    static let dateButton = UIFont(name: "Arial-BoldItalicMT", size: sizeConvert(size: 13))
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
    static let dateButton = #colorLiteral(red: 0.9995340705, green: 0.9866005873, blue: 0.04135324298, alpha: 0.9740475171)
    static let cue = #colorLiteral(red: 0.9995340705, green: 0.9866005873, blue: 0.04135324298, alpha: 0.9740475171)
    static let crossLabel = Color.text
    static let complete = #colorLiteral(red: 0.02237439216, green: 0.6006702094, blue: 0.1028243576, alpha: 1)
    static let f1 = UIColor.red
    static let f2 = UIColor.orange
    static let f3 = UIColor.cyan
    static let f4 = UIColor.green
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

class TodoTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TodoItemTableViewCellDelegate {
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
    
    var initContentOffset: CGFloat = 0
    
    var barView = UIView()
    
    let datePickerHeight = ScreenSize.h/3.6
    
    var editingCell: TodoItemTableViewCell?
    
    var datePicker = UIDatePicker()
    var doneButton = UIButton()
    var deleteButton = UIButton()
    var buttonHeight = ScreenSize.h/18
    var buttonWidth = ScreenSize.w/6
    
    @IBOutlet weak var tableView: UITableView!
    
    var items: [TodoItem] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var offset: CGFloat?
    
    
    override func viewDidLoad() {
        print("Screen height: ", ScreenSize.h)
        print("Screen width: ", ScreenSize.w)
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = Color.navigationBar
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Color.navigationBarText, NSFontAttributeName: Font.navigationBarText!]
        
        
        datePicker.frame = CGRect(x:  0, y:  ScreenSize.h - datePicker.frame.height  - pickerOffset, width:  UIScreen.main.bounds.width, height: datePickerHeight)
        datePicker.layer.borderWidth = 1
        datePicker.layer.borderColor = UIColor.green.cgColor
        
        print("VIEW x", self.view.frame.origin.x)
        print("VIEW y", self.view.frame.origin.y)
        self.view.addSubview(datePicker)
        datePicker.isHidden = true
        datePicker.datePickerMode = .dateAndTime
        
        
        barView.frame = CGRect(x: 0, y: datePicker.frame.origin.y - buttonHeight, width: UIScreen.main.bounds.width, height: buttonHeight)
        barView.backgroundColor = UIColor.blue
        barView.isHidden = true
        tableView.addSubview(barView)
        
        deleteButton.sizeToFit()
        deleteButton.frame = CGRect(x: 0.015*ScreenSize.w, y: 0, width: buttonWidth, height: buttonHeight)
        deleteButton.setTitle("DELETE", for: UIControlState.normal)
        deleteButton.setTitleColor(UIColor.red, for: UIControlState.normal)
        deleteButton.titleLabel?.font = Font.button
        
        deleteButton.addTarget(self, action: #selector(self.deleteButtonPressed), for: UIControlEvents.touchUpInside)
        barView.addSubview(deleteButton)
        doneButton.sizeToFit()
        doneButton.frame = CGRect(x: UIScreen.main.bounds.width-buttonWidth, y: 0, width: buttonWidth, height: buttonHeight)
        
        doneButton.setTitle("DONE", for: UIControlState.normal)
        doneButton.setTitleColor(UIColor.gray, for: UIControlState.normal)
        doneButton.titleLabel?.font = Font.button
        
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
        
        let tableTap = UITapGestureRecognizer(target: self, action: #selector(self.handleTableTap(_:)))
        tableView.addGestureRecognizer(tableTap)
        
        initNavButton()
        
        
        filterView.isHidden = true
        tableView.addSubview(filterView)
    }
    
    func handleTableTap(_ sender: UITapGestureRecognizer){
        editingCell!.textView.resignFirstResponder()
//        cellDidEndEditing(editingCell: self.editingCell!)
        
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
    
    var filterView = FilterView(frame: CGRect(x: 0, y: 0, width: ScreenSize.w, height: ScreenSize.h/6))
    func handleLeftNavButton(){
        
        filterView.isHidden = false
        let vCells = tableView.visibleCells as! [TodoItemTableViewCell]
        print(filterView.frame.height)
        UIView.animate(withDuration: 0.5, animations: {() in
            for cell in vCells{
            cell.frame = cell.frame.offsetBy(dx: 0, dy: self.filterView.frame.height)
            }})
        

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
        initContentOffset = -tableView.contentOffset.y
    }
    
    func getData(){
        do {
            let sortDate = NSSortDescriptor(key: "dueDate", ascending: true)
            let sortComplete = NSSortDescriptor(key: "isComplete", ascending: true)
            let fetchRequest:NSFetchRequest = TodoItem.fetchRequest()
            fetchRequest.sortDescriptors = [sortComplete, sortDate]
            items = try context.fetch(fetchRequest)
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
    
    
    func deleteButtonPressed(){
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
        
        
        //        UIView.animate(withDuration: 0.2, animations: { () in
        ////            self.blurView!.frame = self.blurView!.frame.offsetBy(dx: 0, dy: heightChange)
        //
        //        })
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
        if items.contains(item){
            items.remove(at: itemIndex)
        }
        context.delete(item)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        //        tableView.reloadData()
        tableView.beginUpdates()
        let indexPathForRow = NSIndexPath(row: itemIndex, section: 0)
        let deletedCell = tableView.cellForRow(at: indexPathForRow as IndexPath) as! TodoItemTableViewCell
        deletedCell.todoItem?.isComplete = false
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
            //            editingCell.textView
            
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
        offset = initContentOffset + offset!
        
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
        pullDownInProgress = (scrollView.contentOffset.y + initContentOffset) <= 0.0
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
        
        let scrollViewContentOffsetY = scrollView.contentOffset.y + initContentOffset
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
        
        let scrollViewContentOffsetY = scrollView.contentOffset.y + initContentOffset
        if pullDownInProgress && scrollViewContentOffsetY <= -marginalHeight{
            clueView?.isHidden = true
            let newItem = TodoItem(context: context)
            newItem.flag = "0"
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.beginUpdates()
            items.insert(newItem, at: 0)
            tableView.insertRows(at: [indexPath], with: .top)
            tableView.endUpdates()
            //            tableView.reloadData()
            let newCell = tableView.cellForRow(at: indexPath) as! TodoItemTableViewCell
            newCell.textView!.becomeFirstResponder()
            createdNewCell = true
            cellDidBeginEditing(editingCell: tableView.cellForRow(at: indexPath) as! TodoItemTableViewCell)
        }
    }
    
    
}
