//
//  TodoTableViewController.swift
//  Draft11
//
//  Created by LMAO on 28/02/2017.
//  Copyright © 2017 Jiahuan He. All rights reserved.
//

import UIKit

class TodoTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TodoItemTableViewCellDelegate {
    
    var todoItems = [TodoModel]()
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        
        super.viewDidLoad()                
        
        todoItems.append(TodoModel(content: "Have supper with friends"))
        todoItems.append(TodoModel(content: "By some milk"))
        todoItems.append(TodoModel(content: "Watch movies"))
        todoItems.append(TodoModel(content: "Study for courses, and pick up a parcel. Then walk the dog and buy some dog food."))
        todoItems.append(TodoModel(content: "Have supper with friends"))
        todoItems.append(TodoModel(content: "By some milk"))
        todoItems.append(TodoModel(content: "Watch movies"))
        todoItems.append(TodoModel(content: "Study for courses, and pick up a parcel. Then walk the dog and buy some dog food."))
        
        tableView.showsVerticalScrollIndicator = false        
        tableView.estimatedRowHeight = 44
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "TodoItemTableViewCell", bundle: nil), forCellReuseIdentifier: "todoCell")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as! TodoItemTableViewCell
        cell.delegate = self
        cell.selectionStyle = .none
        cell.item = todoItems[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let c = cell as? TodoItemTableViewCell{
            // Adjust row height with predefined text.
            c.adjustHeightConstrant()
        }
    }
    
    //TodoitemTableViewCell delegate
    func deleteToDoItem(item: TodoModel) {
        let index = (todoItems as NSArray).index(of: item)
        todoItems.remove(at: index)
        let indexPath = IndexPath(row: index, section: 0)
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
    
    func completeToDoItem(item: TodoModel) {
        let index = (todoItems as NSArray).index(of: item)
        let indexPath = IndexPath(row: index, section: 0)
        let c = tableView.cellForRow(at: indexPath) as! TodoItemTableViewCell
        if item.completed{
            c.textView.backgroundColor = UIColor(red: 220/255, green: 237/255, blue: 200/255, alpha: 1)
        }
        else{
            c.textView.backgroundColor = UIColor.clear
        }
        tableView.beginUpdates()
        tableView.endUpdates()
        
    }

    
    func cellHeightDidChange(cell: TodoItemTableViewCell) {
        UIView.performWithoutAnimation {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
}
