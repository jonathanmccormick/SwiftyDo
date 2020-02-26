//
//  RemindersDataClient.swift
//  SwiftyDo
//
//  Created by Jonathan McCormick on 2/25/20.
//  Copyright © 2020 Jonathan McCormick. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class ReminderDataClient {
    
    private var managedObjectContext: NSManagedObjectContext
    
    init() {
        guard let appDelegete = UIApplication.shared.delegate as? AppDelegate else {
            // Is there any meaning in the universe?!
            fatalError()
        }
        managedObjectContext = appDelegete.persistentContainer.viewContext
    }
    
    func create(name: String, completed: Bool, notes: String, dueDate: Date) {
        let entity = NSEntityDescription.entity(forEntityName: "Reminder", in: managedObjectContext)!
        let newReminder = NSManagedObject(entity: entity, insertInto: managedObjectContext)
        
        newReminder.setValue(name, forKey: "name")
        newReminder.setValue(completed, forKey: "completed")
        newReminder.setValue(notes, forKey: "notes")
        newReminder.setValue(dueDate, forKey: "dueDate")
        
        save()
    }
    
    func update(reminder: Reminder, name: String, completed: Bool, notes: String, dueDate: Date) {
        reminder.setValue(name, forKey: "name")
        reminder.setValue(completed, forKey: "completed")
        reminder.setValue(notes, forKey: "notes")
        reminder.setValue(dueDate, forKey: "dueDate")
        
        save()
    }
    
    func delete(reminder: Reminder) {
        managedObjectContext.delete(reminder)
        save()
    }
    
    func complete(reminder: NSManagedObject) {
        reminder.setValue(true, forKey: "completed")
        save()
    }
    
    private func save() {
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            print("Couldn't save: \(error)")
            managedObjectContext.rollback()
        }
    }
}
