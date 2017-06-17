//
//  TodoTableViewController.swift
//  Draft11
//
//  Created by LMAO on 28/02/2017.
//  Copyright © 2017 Jiahuan He. All rights reserved.
//

import UIKit
import CoreData

struct Color{
    static let text = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    static let cellBackground = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    static let tableViewBackground = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)

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
        
        
        
        deleteButton.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
        deleteButton.setTitle("DELETE", for: UIControlState.normal)
        deleteButton.setTitleColor(UIColor.red, for: UIControlState.normal)
        deleteButton.titleLabel?.font = UIFont(name: "Avenir", size: 13)!
        deleteButton.sizeToFit()
        
        deleteButton.addTarget(self, action: #selector(self.deleteButtonPressed), for: UIControlEvents.touchUpInside)
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
            let fetchRequest:NSFetchRequest = TodoItem.fetchRequest()
            let sortDescriptor = NSSortDescriptor(key: "dueDate", ascending: false)
            fetchRequest.sortDescriptors = [sortDescriptor]
            items = try context.fetch(fetchRequest)
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
        
        cell.rightBorder.backgroundColor = assignBorderColor(cell: cell)
        assignDateText(cell: cell)
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        cell.dateButton.isEnabled = false
        
        var alpha = 0.0
        if (UIColor(cgColor: assignBorderColor(cell: cell)) != UIColor.clear){
            alpha = 0.05
        }
        cell.textView.backgroundColor = UIColor(cgColor: assignBorderColor(cell: cell)).withAlphaComponent(CGFloat(alpha))
        
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
            dateButton.setTitle(self.datePicker.date.toString(dateFormat: "dd-MMM-yyyy"), for: UIControlState.normal)
        })

        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        print(editingCell!.todoItem!.dueDate!.toString(dateFormat: "dd-MMM-yyyy"))
        
        resignAfterModifyingDate = true
        editingCell!.textView.becomeFirstResponder()
        
    }
    
    //TodoItemTableViewCell delegate
    
    func popupDatePicker(editingCell: TodoItemTableViewCell) {
        modifyingDate = true
        
        datePicker.backgroundColor = UIColor.lightGray
        datePicker.setDate(NSDate() as Date, animated: false)
        datePicker.isHidden = false
        barView.isHidden = false
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
                            //                    cell.alpha = 0.3
                        }
                        cell.frame = cell.frame.offsetBy(dx: 0, dy: self.offset!)
                    }
        
        
//        UIView.animate(withDuration: 0.2, animations: { () in
////            self.blurView!.frame = self.blurView!.frame.offsetBy(dx: 0, dy: heightChange)
//
//        })
        }
    
    private func assignBorderColor (cell: TodoItemTableViewCell) -> CGColor{
        if let f = cell.todoItem?.flag{
            switch f {
            case "0" :
                return UIColor.red.cgColor
            case "1":
                return UIColor.orange.cgColor
            case "2":
                return UIColor.cyan.cgColor
            case "3":
                return UIColor.green.cgColor
            case "-1":
                return UIColor.clear.cgColor
            default:
                break
            }}
        return UIColor.clear.cgColor
    }
    
    private func assignDateText (cell: TodoItemTableViewCell){
        if(cell.todoItem!.dueDate != nil){
            cell.dateButton.isHidden = false
        }
        cell.dateButton.setTitle(cell.todoItem!.dueDate?.toString(dateFormat: "dd-MMM-yyyy") ?? "Add Due Date", for: UIControlState.normal)
    }
    
    
    func cellFlagDidChange(editingCell: TodoItemTableViewCell){
//        print("current flag: ", editingCell.todoItem?.flag ?? "wrong flag")
        var alpha = 0.0
        if (UIColor(cgColor: assignBorderColor(cell: editingCell)) != UIColor.clear){
            alpha = 0.05
        }
        
        UIView.animate(withDuration: 0.5, animations: {() in
            editingCell.rightBorder.backgroundColor = self.assignBorderColor(cell: editingCell)
            editingCell.textView.backgroundColor = UIColor(cgColor: self.assignBorderColor(cell: editingCell)).withAlphaComponent(CGFloat(alpha))
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
        tableView.deleteRows(at: [indexPathForRow as IndexPath], with: .left)
        tableView.endUpdates()
    }
    
    
    func cellDidBeginEditing(editingCell: TodoItemTableViewCell) {
        self.blurView!.isHidden = true
        editingCell.dateButton.isEnabled = true
        if resignAfterModifyingDate{
            resignAfterModifyingDate = false
            return
        }
        
            offset = tableView.contentOffset.y - editingCell.frame.origin.y
            offset = initContentOffset + offset!
        
        
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
                if cell != editingCell{
                   cell.alpha = CGFloat(0.4)
                }
                else{
//                    cell.textView.backgroundColor = cell.textView.backgroundColor?.withAlphaComponent(0.1)
                }
            })
        }
        
        if(editingCell.todoItem!.dueDate == nil){
            editingCell.dateButton.isHidden = false
            UIView.animate(withDuration: 0.3, animations: {() in
                editingCell.dateButton.setTitle("Add Due Date", for: UIControlState.normal)
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
        if(modifyingDate == true){
            return
        }
        if(editingCell.todoItem?.dueDate == nil){
            editingCell.dateButton.isHidden = true
        }
        assignDateText(cell: editingCell)
        
        let visibleCells = tableView.visibleCells as! [TodoItemTableViewCell]
        print("offset " , self.offset!)
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
        offset = 0
        editingCell.dateButton.isEnabled = false
        
        if items.contains(editingCell.todoItem!) {
            let fromPath = IndexPath(row: items.index(of: editingCell.todoItem!)!, section: 0)
            getData()
            let toPath = IndexPath(row: items.index(of: editingCell.todoItem!)!, section: 0)
            
            // WOW! The API is AMAZING! Thanks Apple!
            tableView.beginUpdates()
            tableView.moveRow(at: fromPath, to: toPath)
            tableView.endUpdates()

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
            tableView.insertRows(at: [indexPath], with: .top)
            tableView.reloadData()
            (tableView.cellForRow(at: indexPath) as! TodoItemTableViewCell).textView!.becomeFirstResponder()
            cellDidBeginEditing(editingCell: tableView.cellForRow(at: indexPath) as! TodoItemTableViewCell)
        }
    }
    
    
}
