//
//  AddReminderViewController.swift
//  CoreDataDemo
//
//  Created by Jonathan McCormick on 2/15/20.
//  Copyright © 2020 Jonathan McCormick. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ReminderViewController: UIViewController {
    
    @IBOutlet weak var reminderTextField: UITextField!
    @IBOutlet weak var notesTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var cta: UIButton!
    
    @IBAction func saveAndDismiss(_ sender: Any) {
        
        guard let appDelegete = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegete.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Reminder", in: managedContext)!
        
        setValuesOn(reminder ?? NSManagedObject(entity: entity, insertInto: managedContext))
        save(managedContext)
        
        navigationController?.popViewController(animated: true)
    }
    
    var reminder: Reminder!
    
    override func viewDidLoad() {
        
        // If a reminder was passed in, configure the UI to show it
        if let reminder = reminder {
            configureUiWithReminder(reminder)
        }
    }
}

private extension ReminderViewController {
    func configureUiWithReminder(_ reminder: Reminder) {
        
        // Populate fields with data
        reminderTextField.text = reminder.name
        notesTextField.text = reminder.notes
        datePicker.date = reminder.dueDate ?? Date.init(timeIntervalSinceNow: TimeInterval(0))
        
        // Change "Add" button to "Save"
        cta.setTitle("Save", for: .normal)
    }
    
    func setValuesOn(_ newReminder: NSManagedObject) {
        newReminder.setValue(reminderTextField.text ?? "nil", forKey: "name")
        newReminder.setValue(false, forKey: "completed")
        newReminder.setValue(notesTextField.text, forKey: "notes")
        newReminder.setValue(datePicker.date, forKey: "dueDate")
    }
    
    func save(_ managedContext: NSManagedObjectContext) {
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Couldn't save: \(error)")
        }
    }
}