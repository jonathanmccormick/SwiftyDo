//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by Jonathan McCormick on 2/15/20.
//  Copyright © 2020 Jonathan McCormick. All rights reserved.
//

import UIKit
import CoreData

class ReminderListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBAction func editTapped(_ sender: Any) {
        
        if (self.tableView.isEditing == true)
        {
            self.tableView.isEditing = false
            editButton.title = "Edit"
        }
        else
        {
            self.tableView.isEditing = true
            editButton.title = "Done"
        }
    }
    
    private var viewModel: ReminderListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = ReminderListViewModel(delegate: self)
    }
    
    // todo: not sure where this should go but it's not here... NavigationController?
    // edit: need a presentation layer. Or presenter.
    private func presentReminderViewController(indexPath: IndexPath) {
        let viewController = storyboard?.instantiateViewController(identifier: ReminderViewController.storyboardIdentifier) as! ReminderViewController
        viewController.configure(with: viewModel.fetchedResultsController.object(at: indexPath))
        navigationController?.pushViewController(viewController, animated: true)
    }
}

//MARK: - TableView DataSource
extension ReminderListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = viewModel.fetchedResultsController.sections {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        let reminder = viewModel.fetchedResultsController.object(at: indexPath)
        
        cell.reminderLabel.text = reminder.name
        cell.completedImage.isHidden = !reminder.completed
        
        return cell
    }
    
    // Reorder rows
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        tableView.moveRow(at: sourceIndexPath, to: destinationIndexPath)
    }
}

//MARK: - TableView Delegate
extension ReminderListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presentReminderViewController(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let swipeRightAction: UIContextualAction
        let actionTitle: String
        let actionBackgroundColor: UIColor
        let handler: UIContextualAction.Handler
        
        if (viewModel.fetchedResultsController.object(at: indexPath).completed) {
            actionTitle = "UnComplete"
            actionBackgroundColor = UIColor.systemOrange
            handler = { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                self.viewModel.unComplete(reminderAt: indexPath)
                success(true)
            }
        } else {
            actionTitle = "Complete"
            actionBackgroundColor = UIColor.systemGreen
            handler = { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                self.viewModel.complete(reminderAt: indexPath)
                success(true)
            }
        }
            
        swipeRightAction = UIContextualAction(style: .normal, title:  actionTitle, handler: handler)
        swipeRightAction.backgroundColor = actionBackgroundColor
        
        return UISwipeActionsConfiguration(actions: [swipeRightAction])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let modifyAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.viewModel.delete(reminderAt: indexPath)
            success(true)
        })
        
        modifyAction.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [modifyAction])
    }
}

//MARK: - Fetched Results Controller Delegate
extension ReminderListViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        case .update:
            let cell = tableView.cellForRow(at: indexPath!) as! TableViewCell
            cell.reminderLabel.text = viewModel.fetchedResultsController.object(at: indexPath!).name!
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            tableView.insertRows(at: [indexPath!], with: .fade)
        @unknown default:
            fatalError()
        }
        
        tableView.reloadData()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
}

