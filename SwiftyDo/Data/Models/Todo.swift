//
//  Todo.swift
//  Todo List
//
//  Created by Jonathan McCormick on 1/26/19.
//  Copyright © 2019 Jonathan McCormick. All rights reserved.
//

import Foundation

class TodoItem {
    var title: String
    var completed: Bool?
    var dateCreated: Date?
    var dateCompleted: Date?
    
    init(title: String) {
        self.title = title
    }
}
