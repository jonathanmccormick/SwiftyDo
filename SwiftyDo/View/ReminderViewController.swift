//
//  AddReminderViewController.swift
//  CoreDataDemo
//
//  Created by Jonathan McCormick on 2/15/20.
//  Copyright © 2020 Jonathan McCormick. All rights reserved.
//

import Foundation
import UIKit

class ReminderViewController: UIViewController {
    
    // MARK: Fields
    private var reminder: Reminder!
    private let reminderDataClient = ReminderDataClient()
    
    //MARK: Outlets
    @IBOutlet weak var reminderTextField: UITextField!
    @IBOutlet weak var notesTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var cta: UIButton!
    
    //MARK: Actions
    @IBAction func addOrSave(_ sender: Any) {
        createOrUpdate(
            name: reminderTextField.text ?? "nil",
            completed: false,
            notes: notesTextField.text ?? "",
            dueDate: datePicker.date)
        dismissSelf()
    }
}

//MARK: - Lifecycle
extension ReminderViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // If a reminder was passed in, configure the UI to show it
        if let reminder = reminder {
            configureUiWithReminder(reminder)
        }
    }
}

// MARK: - Private methods
private extension ReminderViewController {
    // todo: refactor this paramater... seems like our concerns are starting to get mixed up.
    func configureUiWithReminder(_ reminder: Reminder) {
        
        // Populate fields with data
        reminderTextField.text = reminder.name
        notesTextField.text = reminder.notes
        datePicker.date = reminder.dueDate ?? Date.init(timeIntervalSinceNow: TimeInterval(0))
        
        // Change "Add" button to "Save"
        cta.setTitle("Save", for: .normal)
    }
    
    func createOrUpdate(name: String, completed: Bool, notes: String, dueDate: Date) {
        
        // Update: if we were passed a reminder, update it
        if (reminder != nil) {
            reminderDataClient.update(reminder: reminder, name: name, completed: completed, notes: notes, dueDate: dueDate)
            
        // Create: otherwise, create it
        } else {
            reminderDataClient.create(name: name, completed: completed, notes: notes, dueDate: dueDate)
        }
    }
    
    func dismissSelf() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Public Interface
extension ReminderViewController {
    public static let storyboardIdentifier = "ReminderViewController"
    
    public func configure(with reminder: Reminder) {
        self.reminder = reminder
    }
}
