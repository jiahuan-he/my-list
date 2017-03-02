//
//  TodoTableViewController.swift
//  Draft11
//
//  Created by LMAO on 28/02/2017.
//  Copyright © 2017 Jiahuan He. All rights reserved.
//

import UIKit

class TodoTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TodoItemTableViewCellDelegate {
    
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        
        
        tableView.dataSource = self
        tableView.delegate = self
        
//        tableView.register(TodoItemTableViewCell.self, forCellReuseIdentifier: "todoCell")
        tableView.register(UINib(nibName: "TodoItemTableViewCell", bundle: nil), forCellReuseIdentifier: "todoCell")
        
        

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as! TodoItemTableViewCell
        cell.delegate = self
        print("cell for row at")
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2;
    }
    
    
    
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            
            return UITableViewAutomaticDimension
        }
    
    
    
    
    func cellHeightDidChange(cell: TodoItemTableViewCell) {
//        self.tableView.reloadData()
//        self.tableView.layoutIfNeeded()
        UIView.performWithoutAnimation {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
        
    }
 
    
}
