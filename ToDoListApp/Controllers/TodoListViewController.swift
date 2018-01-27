//
//  ViewController.swift
//  ToDoListApp
//
//  Created by Imran Majid on 25/01/2018.
//  Copyright © 2018 Imran Majid. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var toDoListArray = [DataModel]()
    let defaultSave = UserDefaults.standard
    let saveKey = "ExistingToDoList"
    
    
    @IBOutlet weak var numberOfItems: UIBarButtonItem!
    
    //MARK - 'Add' Button Function
    
    @IBAction func barAddButtonPressed(_ sender: UIBarButtonItem) {
        
        var addedItem = UITextField()
        
        let alert   = UIAlertController(title: "To Do App", message: "", preferredStyle: .alert)
        let action  = UIAlertAction(title: "Add", style: .default) { (action) in
            if addedItem.text != "" {
                let newItem = DataModel()
                newItem.title = addedItem.text!
                self.toDoListArray.append(newItem)
                self.defaultSave.set(self.toDoListArray, forKey: self.saveKey)
                print("Item saved to memory")
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

    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let swipe = UISwipeActionsConfiguration.init()
        
        toDoListArray.remove(at: indexPath.row)
        tableView.reloadData()
        print("Hi")
        return swipe
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let items = defaultSave.array(forKey: saveKey) as? [DataModel] {
            toDoListArray = items
            print("Items loaded into memory.")
        }
        
    }
    
    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        numberOfItems.title = String(toDoListArray.count)
        return toDoListArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = toDoListArray[indexPath.row].title
        
        cell.accessoryType = (toDoListArray[indexPath.row].done ? .checkmark : .none)
        
        //Ternary Operator
        // Value = Condtion <?> ValueifTrue : ValueifFalse
        
        return cell
        
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        toDoListArray[indexPath.row].done = !toDoListArray[indexPath.row].done
        tableView.reloadData()
        
    }
    
    
    
}

