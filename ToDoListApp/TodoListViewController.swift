//
//  ViewController.swift
//  ToDoListApp
//
//  Created by Imran Majid on 25/01/2018.
//  Copyright © 2018 Imran Majid. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var toDoListArray = ["Find House", "Arrange Viewing", "Market Current Property", "Arrange Move", "Complete School Forms"]
    
    
    @IBOutlet weak var numberOfItems: UIBarButtonItem!
    
    //MARK - 'Add' Button Function
    
    @IBAction func barAddButtonPressed(_ sender: UIBarButtonItem) {
        
        var addedItem = UITextField()
        
        let alert   = UIAlertController(title: "To Do App", message: "", preferredStyle: .alert)
        let action  = UIAlertAction(title: "Add", style: .default) { (action) in
            if addedItem.text != "" {
                self.toDoListArray.append(addedItem.text!)
                self.tableView.reloadData()
            }
        }
        
        alert.addTextField { (additionalItem) in
            additionalItem.placeholder = "Enter item..."
            addedItem = additionalItem
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func trashButtonPressed(_ sender: UIBarButtonItem) {
        
        
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        numberOfItems.title = String(toDoListArray.count)
        return toDoListArray.count

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = toDoListArray[indexPath.row]
        
        return cell
        
    }

    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
       
    }
    
}

