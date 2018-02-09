//
//  ViewController.swift
//  ToDoListApp
//
//  Created by Imran Majid on 25/01/2018.
//  Copyright © 2018 Imran Majid. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var toDoListArray = [ToDoItem]()
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("ExistingToDoList.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    @IBOutlet weak var numberOfItems: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBAction func barAddButtonPressed(_ sender: UIBarButtonItem) {
        
        var addedItem = UITextField()
        
        let alert   = UIAlertController(title: "To Do App", message: "", preferredStyle: .alert)
        let action  = UIAlertAction(title: "Add", style: .default) { (action) in
            if addedItem.text != "" {
                let newItem = ToDoItem(context: self.context)
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

        context.delete(toDoListArray[indexPath.row])
        saveData()
        
        toDoListArray.remove(at: indexPath.row)
        tableView.reloadData()
        
        return swipe
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
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
    

    
    func loadData(with dateRequest : NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest()) {
        
        do {
            toDoListArray = try context.fetch(dateRequest)
        }
        catch {
            print("Loading Data Error: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func saveData() {
        
        do {
            try context.save()
        }
        catch {
            print("Saving Data Error: \(error)")
        }
    }
}

//MARK: - Search Bar Extension and Methods.

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request     : NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest()
        let filter      = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        let description = NSSortDescriptor(key: "title", ascending: true)
        
        request.predicate = filter
        request.sortDescriptors = [description]
        
        loadData(with: request)

    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
        else {
            searchBarSearchButtonClicked(searchBar)
        }
    }

    
}
