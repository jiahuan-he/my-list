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
    
    var initContentOffset: CGFloat = 0
    var blurView: UIVisualEffectView?
    
    @IBOutlet weak var tableView: UITableView!
    
    var items: [TodoItem] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //    var editingOffset: CGFloat?
    var offset: CGFloat?
    //    var headerView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blurView = UIVisualEffectView()
        tableView.addSubview(blurView!)
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
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
    
    
    func cellDidBeginEditing(editingCell: TodoItemTableViewCell) {
        offset = tableView.contentOffset.y - editingCell.frame.origin.y
        offset = initContentOffset + offset!
        
        self.blurView?.isHidden = false
        // Important feature: scrolview content offset !!
        print(tableView.contentOffset.y)
        let visibleCells = tableView.visibleCells as! [TodoItemTableViewCell]
        let blurEffect = UIBlurEffect(style: .dark)
        let y = editingCell.frame.origin.y + editingCell.frame.height
        blurView!.frame = CGRect(x: 0, y: y, width: editingCell.bounds.width, height: tableView.bounds.height - y)
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
        
        UIView.animate(withDuration: 0.8, animations: {() in
            self.blurView!.alpha = 0.9
        })
    }
    
    func cellDidEndEditing(editingCell: TodoItemTableViewCell) {
        let visibleCells = tableView.visibleCells as! [TodoItemTableViewCell]
        for cell: TodoItemTableViewCell in visibleCells {
            cell.textView.isEditable = true
            UIView.animate(withDuration: 0.3, animations: {() in
                cell.frame = cell.frame.offsetBy(dx: 0, dy: -self.offset!)
            })
        }
        UIView.animate(withDuration: 0.3, animations: {() in
            self.blurView!.frame = self.blurView!.frame.offsetBy(dx: 0, dy: -self.offset!)
        })
        
        UIView.animate(withDuration: 0.8, animations: {() in
            self.blurView!.alpha = 0
        }, completion: {(finished: Bool) in
            self.blurView?.isHidden = true
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
    let marginalHeight = CGFloat(40)
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
        
        let scrollViewContentOffsetY = scrollView.contentOffset.y + initContentOffset
        if pullDownInProgress && scrollViewContentOffsetY <= -marginalHeight{
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
