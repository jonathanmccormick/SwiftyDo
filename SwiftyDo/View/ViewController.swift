//
//  ViewController.swift
//  Todo List
//
//  Created by Jonathan McCormick on 1/26/19.
//  Copyright © 2019 Jonathan McCormick. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    var dataSource: [TodoItem] = []
    
    override func viewWillAppear(_ animated: Bool) {
        dataSource = DataManager.instance.todos
        tableView.reloadData()
        
        super.viewWillAppear(animated)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as! TodoItemTableViewCell
        let idx = indexPath.row
        cell.title?.text = dataSource[idx].title
        return cell;
    }
    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
//    {
//        return true
//    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if (editingStyle == .delete) {
//            // handle delete (by removing the data from your array and updating the tableview)
//        }
//    }
    
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let closeAction = UIContextualAction(style: .normal, title:  "Close", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("OK, marked as Closed")
            success(true)
        })
        closeAction.title = "test"
        closeAction.backgroundColor = .purple
        
        return UISwipeActionsConfiguration(actions: [closeAction])
        
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let modifyAction = UIContextualAction(style: .normal, title:  "Update", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("Update action ...")
            success(true)
        })
        modifyAction.title = "test"
        modifyAction.backgroundColor = .blue
        
        return UISwipeActionsConfiguration(actions: [modifyAction])
    }
//
//    @available(iOS 11.0, *)
//    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
//    {
//        let deleteAction = UIContextualAction(style: .destructive, title: "Add") { (action, view, handler) in
//            print("Add Action Tapped")
//        }
//        deleteAction.backgroundColor = .green
//        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
//        return configuration
//    }
//
//    @available(iOS 11.0, *)
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
//    {
//        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
//            print("Delete Action Tapped")
//        }
//        deleteAction.backgroundColor = .red
//        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
//        return configuration
//    }
}
