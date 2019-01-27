//
//  DataManager.swift
//  SwiftyDo
//
//  Created by Jonathan McCormick on 1/26/19.
//  Copyright © 2019 Jonathan McCormick. All rights reserved.
//

import Foundation

class DataManager {
    static let instance = DataManager();
    
    var todos: [TodoItem] = []
}
