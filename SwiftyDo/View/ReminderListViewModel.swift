//
//  ReminderListViewModel.swift
//  SwiftyDo
//
//  Created by Jonathan McCormick on 2/29/20.
//  Copyright © 2020 Jonathan McCormick. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class ReminderListViewModel {
    var fetchedResultsController: NSFetchedResultsController<Reminder>!
    private var managedObjectContext: NSManagedObjectContext!
    private var reminderDataClient = ReminderDataClient()
    
    init(delegate: NSFetchedResultsControllerDelegate) {
        setupManagedObjectContext()
        setupRemindersFetchResultsController()
        fetchReminders()
        fetchedResultsController.delegate = delegate
    }
    
// MARK: - Setup
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
    }
    
    private func fetchReminders() {
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            print("!!!")
        }
    }
    
// MARK: - Public Interface
    func complete(reminderAt indexPath: IndexPath) {
        reminderDataClient.complete(reminder: fetchedResultsController.object(at: indexPath))
    }
    
    func delete(reminderAt indexPath: IndexPath) {
        reminderDataClient.delete(reminder: fetchedResultsController.object(at: indexPath))
    }
}
