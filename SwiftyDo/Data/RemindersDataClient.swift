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
    
    func create(reminderDTO: ReminderDTO) {
        let entity = NSEntityDescription.entity(forEntityName: "Reminder", in: managedObjectContext)!
        let newReminder = NSManagedObject(entity: entity, insertInto: managedObjectContext)
        
        newReminder.setValue(reminderDTO.name, forKey: "name")
        newReminder.setValue(reminderDTO.completed, forKey: "completed")
        newReminder.setValue(reminderDTO.notes, forKey: "notes")
        newReminder.setValue(reminderDTO.dueDate, forKey: "dueDate")
        
        save()
    }
    
    func update(existingReminder: Reminder, reminderDTO: ReminderDTO) {
        existingReminder.setValue(reminderDTO.name, forKey: "name")
        existingReminder.setValue(reminderDTO.completed, forKey: "completed")
        existingReminder.setValue(reminderDTO.notes, forKey: "notes")
        existingReminder.setValue(reminderDTO.dueDate, forKey: "dueDate")
        
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
    
    func unComplete(reminder: NSManagedObject) {
        reminder.setValue(false, forKey: "completed")
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
