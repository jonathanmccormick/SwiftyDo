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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupManagedObjectContext()
        setupRemindersFetchResultsController()
    }
    
    private func setupManagedObjectContext() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        managedObjectContext = appDelegate.persistentContainer.viewContext
    }
    
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
        
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            print("!!!")
        }
    }
    
    private func delete(reminder: Reminder) {
        managedObjectContext.delete(reminder)
        
        do {
            try managedObjectContext.save()
        } catch {
            managedObjectContext.rollback()
        }
    }
}

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
        
        let reminder = fetchedResultsController.object(at: indexPath)
        
        cell.textLabel?.text = reminder.name
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }


    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            delete(reminder: fetchedResultsController.object(at: indexPath))
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewController = storyboard?.instantiateViewController(identifier: "ReminderViewController") as? ReminderViewController {
            tableView.deselectRow(at: indexPath, animated: true)
            viewController.reminder = fetchedResultsController.object(at: indexPath)
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let completeAction = UIContextualAction(style: .normal, title:  "Complete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                let reminder = self.fetchedResultsController.object(at: indexPath)
                reminder.setValue(true, forKey: "completed")
                do {
                    try self.managedObjectContext.save()
                    print(reminder)
                } catch let error as NSError {
                    print("Couldn't save: \(error)")
                }
                success(true)
            })
            completeAction.backgroundColor = .systemGreen
            return UISwipeActionsConfiguration(actions: [completeAction])
    }
}

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

