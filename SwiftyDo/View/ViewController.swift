//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by Jonathan McCormick on 2/15/20.
//  Copyright © 2020 Jonathan McCormick. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var fetchedResultsController: NSFetchedResultsController<Reminder>!
    var managedObjectContext: NSManagedObjectContext!
    var reminderDataClient = ReminderDataClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupManagedObjectContext()
        setupRemindersFetchResultsController()
        fetchReminders()
    }
    
    // todo managed object context doesn't belong in the view
    private func setupManagedObjectContext() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        managedObjectContext = appDelegate.persistentContainer.viewContext
    }
    
    // Fetch request doesn't belong in the view controller
    private func setupRemindersFetchResultsController() {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Reminder")
        let ascendingByNameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [ascendingByNameSortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil) as? NSFetchedResultsController<Reminder>
        fetchedResultsController.delegate = self
    }
    
    private func fetchReminders() {
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            print("!!!")
        }
    }
    
    // todo: not sure where this should go but it's not here... NavigationController?
    private func presentReminderViewController(indexPath: IndexPath) {
        let viewController = storyboard?.instantiateViewController(identifier: ReminderViewController.storyboardIdentifier) as! ReminderViewController
        viewController.configure(with: fetchedResultsController.object(at: indexPath))
        navigationController?.pushViewController(viewController, animated: true)
    }
}

//MARK: - TableView DataSource
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        // todo: move this to VM/presenter?
        let reminder = fetchedResultsController.object(at: indexPath)
        
        cell.textLabel?.text = reminder.name
        return cell
    }
}

//MARK: - TableView Delegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presentReminderViewController(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let completeAction = UIContextualAction(style: .normal, title:  "Complete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.reminderDataClient.complete(reminder: self.fetchedResultsController.object(at: indexPath))
                success(true)
            })
        
        completeAction.backgroundColor = .systemGreen
        return UISwipeActionsConfiguration(actions: [completeAction])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let modifyAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.reminderDataClient.delete(reminder: self.fetchedResultsController.object(at: indexPath))
            success(true)
        })
        
        modifyAction.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [modifyAction])
    }
}

//MARK: - Fetched Results Controller Delegate
extension ViewController: NSFetchedResultsControllerDelegate {
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
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            let cell = tableView.cellForRow(at: indexPath!)
            cell?.textLabel?.text = fetchedResultsController.object(at: indexPath!).name!
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

