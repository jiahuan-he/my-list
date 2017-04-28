//
//  TodoTableViewController.swift
//  Draft11
//
//  Created by LMAO on 28/02/2017.
//  Copyright © 2017 Jiahuan He. All rights reserved.
//

import UIKit
import CoreData

class TodoTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TodoItemTableViewCellDelegate {
    
    @IBOutlet var tableView: UITableView!
    var items: [TodoItem] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var editingOffset: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 30
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.dataSource = self
        tableView.delegate = self
        
        //                tableView.register(TodoItemTableViewCell.self, forCellReuseIdentifier: "todoCell")
        tableView.register(UINib(nibName: "TodoItemTableViewCell", bundle: nil), forCellReuseIdentifier: "todoCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let item1 = TodoItem(context: context)
        item1.name = "item1"
        item1.isComplete = false
        //
        //        let item2 = TodoItem(context: context)
        //        item2.name = "item1"
        //        item2.isComplete = false
        //
        //        let item3 = TodoItem(context: context)
        //        item3.name = "item1"
        //        item3.isComplete = false
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        getData()
        tableView.reloadData()
    }
    
    
    func getData(){
        do {
            items = try context.fetch(TodoItem.fetchRequest())
        }
        catch{
            print("Wrong")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as! TodoItemTableViewCell
        cell.delegate = self
        cell.todoItem = items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func cellHeightDidChange(editingCell: TodoItemTableViewCell) {
        
//        tableView.reloadRows(at: [tableView.indexPath(for: editingCell)!], with: .automatic)
        
        
//        print("offsety: " , tableView.contentOffset.y, "originY: ", editingCell.frame.origin.y)
        
        
        tableView.beginUpdates()
        // calculate the height to move up.
        tableView.endUpdates()
        // calculate the height to move up.
//        print("offset2: " , editingOffset!)
//        let visibleCells = tableView.visibleCells as! [TodoItemTableViewCell]
//        for cell in visibleCells {
//            //            prevent editing other cells when a cell is being editing.
//            if cell !== editingCell {
//                //                cell.shouldBeginEditing = false
//                cell.textView.isEditable = false
//            }
//            UIView.animate(withDuration: 0.3, animations: {() in
//                cell.transform = CGAffineTransform(translationX: 0, y: self.editingOffset!.multiplied(by: CGFloat(2*self.timesChangeHeight)))
//                
//                if cell !== editingCell {
//                    cell.alpha = 0.3
//                }
//            })
//        }
    }
    
    //TodoItemTableViewCell delegate
    func itemDeleted(item: TodoItem) {
        let itemIndex = (items as NSArray).index(of: item)
        items.remove(at: itemIndex)
        context.delete(item)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
//        tableView.reloadData()
        tableView.beginUpdates()
        let indexPathForRow = NSIndexPath(row: itemIndex, section: 0)
        tableView.deleteRows(at: [indexPathForRow as IndexPath], with: .fade)
        tableView.endUpdates()
    }
    
    //
    //    func itemAdded() {
    //        let item = TodoItem()
    //        item.name = " "
    //        items.insert(item, at: 0)
    //        tableView.reloadData()
    //        // enter edit mode
    //        var editCell: TodoItemTableViewCell
    //        let visibleCells = tableView.visibleCells as! [TodoItemTableViewCell]
    //        for cell in visibleCells {
    //            if (cell.todoItem === item) {
    //                editCell = cell
    //                editCell.textView.becomeFirstResponder()
    //                break
    //            }
    //        }
    //    }
    
    func cellDidBeginEditing(editingCell: TodoItemTableViewCell) {
        // calculate the height to move up.
        editingOffset = tableView.contentOffset.y - editingCell.frame.origin.y as CGFloat
        print("offset1: " , editingOffset!)
        let visibleCells = tableView.visibleCells as! [TodoItemTableViewCell]
        for cell in visibleCells {
            //            prevent editing other cells when a cell is being editing.
            if cell !== editingCell {
                //                cell.shouldBeginEditing = false
                cell.textView.isEditable = false
            }
            UIView.animate(withDuration: 0.3, animations: {() in
                cell.transform = CGAffineTransform(translationX: 0, y: self.editingOffset!)
                if cell !== editingCell {
                    cell.alpha = 0.3
                }
            })
        }
    }
    
    func cellDidEndEditing(editingCell: TodoItemTableViewCell) {
        timesChangeHeight = 0
        
        let visibleCells = tableView.visibleCells as! [TodoItemTableViewCell]
        for cell: TodoItemTableViewCell in visibleCells {
            //resume the status: editable
            //            cell.shouldBeginEditing = true
            cell.textView.isEditable = true
            UIView.animate(withDuration: 0.5, animations: {() in
                cell.transform = CGAffineTransform.identity
                if cell !== editingCell {
                    cell.alpha = 1.0
                }
            })
        }
        if editingCell.todoItem?.name == "" {
//            planDeleted(plan: editingCell.plan!)
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
    let marginalHeight = CGFloat(40)
    var addClueLabel = UILabel()
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        clueView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        addClueLabel.font = UIFont(name: "ArialMT ", size: 8)
        addClueLabel.textColor = UIColor.black
        
        //        // this behavior starts when a user pulls down while at the top of the table
        pullDownInProgress = scrollView.contentOffset.y <= 0.0
        clueView!.backgroundColor = UIColor.clear
        if pullDownInProgress {
            tableView.insertSubview(clueView!, at: 0)
            clueView?.addSubview(addClueLabel)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollViewContentOffsetY = scrollView.contentOffset.y
        if pullDownInProgress && scrollViewContentOffsetY <= 0.0 {
            // maintain the location of the placeholder
            print(scrollViewContentOffsetY)
            addClueLabel.frame = CGRect(x: tableView.frame.size.width/2-30, y: -scrollViewContentOffsetY-25, width: 100, height: 30)
            clueView!.frame = CGRect(x: 0, y: scrollViewContentOffsetY,
                                     width: tableView.frame.size.width, height: -scrollViewContentOffsetY)
            if(scrollViewContentOffsetY <= -marginalHeight){
                addClueLabel.text = "Release"
            }
            else{
                addClueLabel.text = "Test"
            }
            //            addClueLabel!.alpha = min(1.0, -scrollViewContentOffsetY/marginalHeight)
            
        } else {
            pullDownInProgress = false
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        if pullDownInProgress && -scrollView.contentOffset.y > marginalHeight{
//            //            var cell = TodoItemTableViewCell()
//            tableView.beginUpdates()
//            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//            let newItem = TodoItem(context: context)
//            items.insert(newItem, at: 0)
//            tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
//            
//            let visibleCells = tableView.visibleCells as! [TodoItemTableViewCell]
//            for cell in visibleCells {
//                if (cell.todoItem === newItem) {
//                    cell.textView.becomeFirstResponder()
//                    break
//                }
//            }
//            
//            tableView.endUpdates()
//        }
        //        // check whether the user pulled down far enough
        //        if pullDownInProgress && -scrollView.contentOffset.y > marginalHeight{
        //            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        //
        //            let newItem = TodoItem(context: context)
        //            newItem.name = "new"
        //            newItem.isComplete = false
        //            items.insert(newItem, at: 0)
        //            tableView.reloadData()
        //            // enter edit mode
        //            var editCell: TodoItemTableViewCell
        //            let visibleCells = tableView.visibleCells as! [TodoItemTableViewCell]
        //            for cell in visibleCells {
        //                if (cell.todoItem === newItem) {
        //                    editCell = cell
        //                    editCell.textView.becomeFirstResponder()
        //                    break
        //                }
        //            }
        //
        //            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        //        }
    }
}
