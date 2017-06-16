//
//  TodoTableViewController.swift
//  Draft11
//
//  Created by LMAO on 28/02/2017.
//  Copyright © 2017 Jiahuan He. All rights reserved.
//

import UIKit
import CoreData

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
    
    var initContentOffset: CGFloat = 0
    var blurView: UIVisualEffectView?
    
    var barView = UIView()
    
    let datePickerHeight = CGFloat(150)
    
    var editingCell: TodoItemTableViewCell?
    
    var datePicker = UIDatePicker()
    var doneButton = UIButton()
    var cancelButton = UIButton()
    var deleteButton = UIButton()
    var buttonHeight = CGFloat(30)
    var buttonWidth = CGFloat(40)
    
    @IBOutlet weak var tableView: UITableView!
    
    var items: [TodoItem] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //    var editingOffset: CGFloat?
    var offset: CGFloat?
    //    var headerView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.frame = CGRect(x:  0, y:  UIScreen.main.bounds.height - datePickerHeight - (self.navigationController?.navigationBar.bounds.height)! - 20, width:  UIScreen.main.bounds.width, height: datePickerHeight)
        datePicker.layer.borderWidth = 1
        datePicker.layer.borderColor = UIColor.green.cgColor
        
        tableView.addSubview(datePicker)
        datePicker.isHidden = true
        datePicker.datePickerMode = .date
        
        
        barView.frame = CGRect(x: 0, y: datePicker.frame.origin.y - buttonHeight, width: UIScreen.main.bounds.width, height: buttonHeight)
        barView.backgroundColor = UIColor.blue
        barView.isHidden = true
        tableView.addSubview(barView)
        
        cancelButton.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
        cancelButton.setTitle("CANCEL", for: UIControlState.normal)
        cancelButton.setTitleColor(UIColor.gray, for: UIControlState.normal)
        cancelButton.titleLabel?.font = UIFont(name: "Avenir", size: 13)!
        cancelButton.sizeToFit()
        barView.addSubview(cancelButton)
        cancelButton.addTarget(self, action: #selector(self.cancelButtonPressed), for: UIControlEvents.touchUpInside)
        
        
        deleteButton.frame = CGRect(x: (UIScreen.main.bounds.width-buttonWidth)/2 , y: 0, width: buttonWidth, height: buttonHeight)
        deleteButton.setTitle("DELETE", for: UIControlState.normal)
        deleteButton.setTitleColor(UIColor.red, for: UIControlState.normal)
        deleteButton.titleLabel?.font = UIFont(name: "Avenir", size: 13)!
        deleteButton.sizeToFit()
        barView.addSubview(deleteButton)
        
        doneButton.frame = CGRect(x: UIScreen.main.bounds.width-buttonWidth, y: 0, width: buttonWidth, height: buttonHeight)
        doneButton.setTitle("DONE", for: UIControlState.normal)
        doneButton.setTitleColor(UIColor.gray, for: UIControlState.normal)
        doneButton.titleLabel?.font = UIFont(name: "Avenir", size: 13)!
        barView.addSubview(doneButton)
        doneButton.addTarget(self, action: #selector(self.doneButtonPressed), for: UIControlEvents.touchUpInside)
        
        
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorColor = UIColor.lightGray.withAlphaComponent(0.3)

        
        blurView = UIVisualEffectView()
        tableView.addSubview(blurView!)
        tableView.estimatedRowHeight = 30
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(UINib(nibName: "TodoItemTableViewCell", bundle: nil), forCellReuseIdentifier: "todoCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
//        let item1 = TodoItem(context: context)
//        item1.name = "item1"
//        item1.isComplete = false
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        getData()
        tableView.reloadData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        initContentOffset = -tableView.contentOffset.y
    }
    
    func getData(){
        do {
            items = try context.fetch(TodoItem.fetchRequest())
            // Temp
            items.reverse()
        }
        catch{
            print("Wrong")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as! TodoItemTableViewCell
        cell.delegate = self
        cell.todoItem = items[indexPath.row]
        
        assignBorderColor(cell: cell)
        assignDateText(cell: cell)
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
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
    func cancelButtonPressed(){
       hidePicker()
    }
    
    func doneButtonPressed(){
        hidePicker()
//        let timeFormatter = DateFormatter()
//        timeFormatter.timeStyle = DateFormatter.Style.short
//        let strDate = timeFormatter.string(from: datePicker.date)
//        print(strDate)
        
        editingCell!.todoItem!.dueDate = datePicker.date as NSDate
        let dateButton = editingCell!.dateButton
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        UIView.animate(withDuration: 0.2, animations: { () in
            dateButton.setTitle(self.datePicker.date.toString(dateFormat: "dd-MMM-yyyy"), for: UIControlState.normal)
        })
//        let labelSize =  dateButton.titleLabel?.sizeThatFits(CGSize(width: dateButton.frame.size.width, height: CGFloat.greatestFiniteMagnitude)) ?? CGSize.zero
//        let desiredButtonSize = CGSize(width: labelSize.width + dateButton.titleEdgeInsets.left + dateButton.titleEdgeInsets.right, height: labelSize.height + dateButton.titleEdgeInsets.top + dateButton.titleEdgeInsets.bottom)
//        dateButton.titleLabel?.sizeThatFits(desiredButtonSize)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        print(editingCell!.todoItem!.dueDate!.toString(dateFormat: "dd-MMM-yyyy"))
        
    }
    
    //TodoItemTableViewCell delegate
    
    func popupDatePicker(editingCell: TodoItemTableViewCell) {
        datePicker.backgroundColor = UIColor.lightGray
        datePicker.setDate(NSDate() as Date, animated: false)
        datePicker.isHidden = false
        barView.isHidden = false
        self.editingCell = editingCell
    }
  
    func cellHeightDidChange(editingCell: TodoItemTableViewCell, heightChange: CGFloat) {
        
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        // calculate the height to adjust.
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        
        let visibleCells = tableView.visibleCells as! [TodoItemTableViewCell]
        for cell in visibleCells {
            if cell !== editingCell {
                cell.textView.isEditable = false
                //                    cell.alpha = 0.3
            }
            cell.frame = cell.frame.offsetBy(dx: 0, dy: self.offset!)
        }
        UIView.animate(withDuration: 0.2, animations: { () in
            self.blurView!.frame = self.blurView!.frame.offsetBy(dx: 0, dy: heightChange)

        })
        }
    
    private func assignBorderColor (cell: TodoItemTableViewCell){
        if let f = cell.todoItem?.flag{
            switch f {
            case "0" :
                cell.rightBorder.backgroundColor = UIColor.red.cgColor
                print("assignBorderColor: ", f)
            case "1":
                cell.rightBorder.backgroundColor = UIColor.orange.cgColor
            case "2":
                cell.rightBorder.backgroundColor = UIColor.cyan.cgColor
            case "3":
                cell.rightBorder.backgroundColor = UIColor.green.cgColor
            case "-1":
                cell.rightBorder.backgroundColor = UIColor.clear.cgColor
                print("assignBorderColor: ", f)
            default:
                print("assignBorderColor: ", f)
                fatalError()
            }}
    }
    
    private func assignDateText (cell: TodoItemTableViewCell){
        cell.dateButton.setTitle(cell.todoItem!.dueDate?.toString(dateFormat: "dd-MMM-yyyy") ?? "", for: UIControlState.normal)
    }
    
    
    func cellFlagDidChange(editingCell: TodoItemTableViewCell){
//        print("current flag: ", editingCell.todoItem?.flag ?? "wrong flag")
        UIView.animate(withDuration: 0.5, animations: {() in
            self.assignBorderColor(cell: editingCell)
        })
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        }
    
    func itemDeleted(item: TodoItem) {
        let itemIndex = (items as NSArray).index(of: item)
        items.remove(at: itemIndex)
        context.delete(item)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        //        tableView.reloadData()
        tableView.beginUpdates()
        let indexPathForRow = NSIndexPath(row: itemIndex, section: 0)
        tableView.deleteRows(at: [indexPathForRow as IndexPath], with: .top)
        tableView.endUpdates()
    }
    
    
    func cellDidBeginEditing(editingCell: TodoItemTableViewCell) {
        offset = tableView.contentOffset.y - editingCell.frame.origin.y
        offset = initContentOffset + offset!
        self.blurView!.isHidden = false
        // Important feature: scrolview content offset !!
        print("content Offset " , tableView.contentOffset.y)
        let visibleCells = tableView.visibleCells as! [TodoItemTableViewCell]
        let blurEffect = UIBlurEffect(style: .dark)
        let y = editingCell.frame.origin.y + editingCell.frame.height
        let screenHeight = UIScreen.main.bounds.height
        
        blurView!.frame = CGRect(x: 0, y: y, width: editingCell.bounds.width, height: screenHeight - editingCell.bounds.height )
        print("blur y: ",y, "height: ", tableView.bounds.height - y)
        blurView!.effect = blurEffect
        blurView!.alpha = 0
        for cell in visibleCells {
            UIView.animate(withDuration: 0.3, animations: {() in
                cell.frame = cell.frame.offsetBy(dx: 0, dy: self.offset!)
            })
        }
        UIView.animate(withDuration: 0.3, animations: {() in
            self.blurView!.frame = self.blurView!.frame.offsetBy(dx: 0, dy: self.offset!)
        })
        
        UIView.animate(withDuration: 0.5, animations: {() in
            self.blurView!.alpha = 0.90
            self.tableView.separatorColor = UIColor.clear
        })
    }
    
    func cellDidEndEditing(editingCell: TodoItemTableViewCell) {
        
        let visibleCells = tableView.visibleCells as! [TodoItemTableViewCell]
        for cell: TodoItemTableViewCell in visibleCells {
            UIView.animate(withDuration: 0.3, animations: {() in
                cell.frame = cell.frame.offsetBy(dx: 0, dy: -self.offset!)
            })
        }
        UIView.animate(withDuration: 0.3, animations: {() in
            self.blurView!.frame = self.blurView!.frame.offsetBy(dx: 0, dy: -self.offset!)
        })
        
        UIView.animate(withDuration: 0.5, animations: {() in
            self.blurView!.alpha = 0
            self.tableView.separatorColor = UIColor.lightGray.withAlphaComponent(0.3)
        }, completion: {(finished: Bool) in
            self.blurView!.isHidden = true
            for cell: TodoItemTableViewCell in visibleCells {
                cell.textView.isEditable = true}
        })
        
        if editingCell.todoItem?.name == "" {
            itemDeleted(item: editingCell.todoItem!)
        }
        else{
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        }
        
    }
    
    // MARK: - UIScrollViewDelegate methods
    // contains scrollViewDidScroll, and other methods, to keep track of dragging the scrollView
    
    // a cell that is rendered as a placeholder to indicate where a new item is added
    //    var placeHolderCell: TodoItemTableViewCell?
    // indicates the state of this behavior
    var pullDownInProgress = false
    var clueView: UIView?
    let marginalHeight = CGFloat(26)
    var addClueLabel = UILabel()
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        clueView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        addClueLabel.font = UIFont(name: "ArialMT ", size: 8)
        addClueLabel.textColor = UIColor.black
        
        //        // this behavior starts when a user pulls down while at the top of the table
        pullDownInProgress = (scrollView.contentOffset.y + initContentOffset) <= 0.0
        clueView!.backgroundColor = UIColor.clear
        if pullDownInProgress {
            tableView.insertSubview(clueView!, at: 0)
            clueView?.addSubview(addClueLabel)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
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
            addClueLabel.frame = CGRect(x: tableView.frame.size.width/2-30, y: -scrollViewContentOffsetY-30, width: 100, height: 30)
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
            let indexPath = IndexPath(row: 0, section: 0)
            items.insert(newItem, at: 0)
            tableView.insertRows(at: [indexPath], with: .fade)
            tableView.reloadData()
            (tableView.cellForRow(at: indexPath) as! TodoItemTableViewCell).textView!.becomeFirstResponder()
            cellDidBeginEditing(editingCell: tableView.cellForRow(at: indexPath) as! TodoItemTableViewCell)
        }
    }
    
    
}
