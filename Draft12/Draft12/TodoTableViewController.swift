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
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
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
//        
//        let item4 = TodoItem(context: context)
//        item4.name = "item1"
//        item4.isComplete = false
//        
//        let item5 = TodoItem(context: context)
//        item5.name = "item1"
//        item5.isComplete = false
//        
//        let item6 = TodoItem(context: context)
//        item6.name = "item1"
//        item6.isComplete = false
//        
//        let item7 = TodoItem(context: context)
//        item7.name = "item1"
//        item7.isComplete = false
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        getData()

        tableView.reloadData()
    }
    
    
    func getData(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
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
    
    func cellHeightDidChange(cell: TodoItemTableViewCell) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    //TodoItemTableViewCell delegate 
    func itemDeleted(item: TodoItem) {
        let itemIndex = (items as NSArray).index(of: item)
        items.remove(at: itemIndex)
        tableView.beginUpdates()
        let indexPathForRow = NSIndexPath(row: itemIndex, section: 0)
        tableView.deleteRows(at: [indexPathForRow as IndexPath], with: .fade)
        tableView.endUpdates()
    }
    
    
    func itemAdded() {
        let item = TodoItem()
        item.name = " "
        items.insert(item, at: 0)
        tableView.reloadData()
        // enter edit mode
        var editCell: TodoItemTableViewCell
        let visibleCells = tableView.visibleCells as! [TodoItemTableViewCell]
        for cell in visibleCells {
            if (cell.todoItem === item) {
                editCell = cell
                editCell.textView.becomeFirstResponder()
                break
            }
        }
    }
    
    // MARK: - UIScrollViewDelegate methods
    // contains scrollViewDidScroll, and other methods, to keep track of dragging the scrollView
    
    // a cell that is rendered as a placeholder to indicate where a new item is added
//    var placeHolderCell: TodoItemTableViewCell?
    // indicates the state of this behavior
//    var pullDownInProgress = false
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        var clueView = UIView(frame: CGRect(x: 0, y: -30, width: 300, height: 50))
        clueView.backgroundColor = UIColor.blue
        tableView.insertSubview(clueView, at: 0)
        
        
//        // this behavior starts when a user pulls down while at the top of the table
//        placeHolderCell = tableView.dequeueReusableCell(withIdentifier: "todoCell") as? TodoItemTableViewCell
//        pullDownInProgress = scrollView.contentOffset.y <= 0.0
//        placeHolderCell?.backgroundColor = UIColor.black
//        if pullDownInProgress {
//            // add the placeholder
////            placeHolderCell.awakeFromNib()
//            tableView.insertSubview(placeHolderCell!, at: 0)
//            
//        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let scrollViewContentOffsetY = scrollView.contentOffset.y
        print(scrollViewContentOffsetY)
////        print(scrollViewContentOffsetY)
//        
//        if pullDownInProgress && scrollView.contentOffset.y <= 0.0 {
//            // maintain the location of the placeholder
//            let testCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! TodoItemTableViewCell
////            print("w:", testCell.frame.size.width, "h:", testCell.frame.size.height)
//            print("x:", testCell.frame.origin.x, "y:", testCell.frame.origin.x)
//            
//            placeHolderCell?.frame = CGRect(x: 0, y: 0,
//                                           width: tableView.frame.size.width, height: -scrollViewContentOffsetY)
////            print(-scrollViewContentOffsetY)
////              print(tableView.frame.size.width)
//            
////            print("y: ", -tableView.rowHeight, " w: ", tableView.frame.size.width, "h: ", tableView.rowHeight)
//            placeHolderCell?.textView.text = -scrollViewContentOffsetY > 30 ?
//                "Release to add item" : "Pull to add item"
////            placeHolderCell?.alpha = min(1.0, -scrollViewContentOffsetY / 30)
//            placeHolderCell?.alpha = 0.5
//        } else {
//            pullDownInProgress = false
//        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        // check whether the user pulled down far enough
////        if pullDownInProgress && -scrollView.contentOffset.y > tableView.rowHeight
//        if pullDownInProgress && -scrollView.contentOffset.y > 30
//        {
//            itemAdded()
//        }
//        pullDownInProgress = false
//        placeHolderCell?.removeFromSuperview()
    }
}
