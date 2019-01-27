//
//  AddTodoViewController.swift
//  SwiftyDo
//
//  Created by Jonathan McCormick on 1/26/19.
//  Copyright © 2019 Jonathan McCormick. All rights reserved.
//

import UIKit

class AddTodoViewController: UIViewController {
    
    @IBOutlet weak var todoText: UITextField!
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        if let unwrapped = todoText.text {
            if validateInput(input: unwrapped) {
                let todo = TodoItem(title: unwrapped)
                DataManager.instance.todos.append(todo)
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    private func validateInput(input: String) -> Bool {
        if input.trimmingCharacters(in: .whitespaces).isEmpty {
            return false
        }
        else {
            return true
        }
    }
}
