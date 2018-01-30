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
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("ExistingToDoList.plist")
    
    @IBOutlet weak var numberOfItems: UIBarButtonItem!
    
    
    @IBAction func barAddButtonPressed(_ sender: UIBarButtonItem) {
        
        var addedItem = UITextField()
        
        let alert   = UIAlertController(title: "To Do App", message: "", preferredStyle: .alert)
        let action  = UIAlertAction(title: "Add", style: .default) { (action) in
            if addedItem.text != "" {
                let newItem = DataModel()
                newItem.title = addedItem.text!
                self.toDoListArray.append(newItem)
                self.tableView.reloadData()
                self.saveData()
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
        return swipe
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        numberOfItems.title = String(toDoListArray.count)
        return toDoListArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = toDoListArray[indexPath.row].title
        cell.accessoryType = (toDoListArray[indexPath.row].done ? .checkmark : .none)
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        toDoListArray[indexPath.row].done = !toDoListArray[indexPath.row].done
        tableView.reloadData()
        
        saveData()
    }
    
    func loadData() {
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                toDoListArray = try decoder.decode([DataModel].self, from: data)
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    func saveData() {
        
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(self.toDoListArray)
            try data.write(to: self.dataFilePath!)
        }
        catch {
            print("Error Saving items: \(error)")
        }
    }
    
}

