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
    
    var todoItems = [TodoModel]()
    @IBOutlet var tableView: UITableView!
<<<<<<< HEAD
=======
    var items: [TodoItem] = []
    
>>>>>>> b2
    override func viewDidLoad() {
        
<<<<<<< HEAD
        super.viewDidLoad()                
=======
        //        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
>>>>>>> b2
        
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
<<<<<<< HEAD
        tableView.register(UINib(nibName: "TodoItemTableViewCell", bundle: nil), forCellReuseIdentifier: "todoCell")
=======
        
        //        tableView.register(TodoItemTableViewCell.self, forCellReuseIdentifier: "todoCell")
        tableView.register(UINib(nibName: "TodoItemTableViewCell", bundle: nil), forCellReuseIdentifier: "todoCell")

        // Do any additional setup after loading the view.
>>>>>>> b2
    }
    
    func getData(){
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
      
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as! TodoItemTableViewCell
        cell.delegate = self
<<<<<<< HEAD
        cell.selectionStyle = .none
        cell.item = todoItems[indexPath.row]
=======
        cell.textView.text = items[indexPath.row].name
>>>>>>> b2
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
<<<<<<< HEAD
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
=======
        return items.count;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    func cellHeightDidChange(cell: TodoItemTableViewCell) {
        //        self.tableView.reloadData()
        //        self.tableView.layoutIfNeeded()
>>>>>>> b2
        UIView.performWithoutAnimation {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
<<<<<<< HEAD
=======
    
    
>>>>>>> b2
}
