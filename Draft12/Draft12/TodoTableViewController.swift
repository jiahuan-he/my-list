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
        
        //        tableView.register(TodoItemTableViewCell.self, forCellReuseIdentifier: "todoCell")
        tableView.register(UINib(nibName: "TodoItemTableViewCell", bundle: nil), forCellReuseIdentifier: "todoCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let item1 = TodoItem(context: context)
        item1.name = "item1"
        item1.isComplete = false

        let item2 = TodoItem(context: context)
        item2.name = "item1"
        item2.isComplete = false
        
        let item3 = TodoItem(context: context)
        item3.name = "item1"
        item3.isComplete = false
        
        let item4 = TodoItem(context: context)
        item4.name = "item1"
        item4.isComplete = false
        
        let item5 = TodoItem(context: context)
        item5.name = "item1"
        item5.isComplete = false
        
        let item6 = TodoItem(context: context)
        item6.name = "item1"
        item6.isComplete = false
        
        let item7 = TodoItem(context: context)
        item7.name = "item1"
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
    
    
    
    
}
