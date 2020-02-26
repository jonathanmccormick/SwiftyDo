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
    
    static let storyboardIdentifier = "ReminderViewController"
    
    private var reminder: Reminder!
    private let reminderDataClient = ReminderDataClient()
    
    public func configure(with reminder: Reminder) {
        self.reminder = reminder
    }
    
    @IBOutlet weak var reminderTextField: UITextField!
    @IBOutlet weak var notesTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var cta: UIButton!
    
    @IBAction func saveAndDismiss(_ sender: Any) {
        
        // If we were passed an existing reminder, update it's data with the user's changes
        // otherwise, create a new one and configure it with the data the user entered.
        if (reminder == nil) {
            reminderDataClient.create(name: reminderTextField.text ?? "nil", completed: false, notes: notesTextField.text ?? "", dueDate: datePicker.date)
        } else {
            reminderDataClient.update(reminder: reminder, name: reminderTextField.text ?? "nil", completed: false, notes: notesTextField.text ?? "", dueDate: datePicker.date)
        }
        
        navigationController?.popViewController(animated: true)
    }
}

//MARK: Lifecycle
extension ReminderViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // If a reminder was passed in, configure the UI to show it
        if let reminder = reminder {
            configureUiWithReminder(reminder)
        }
    }
}

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
}
