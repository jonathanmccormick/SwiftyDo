//
//  ViewController.swift
//  Todo List
//
//  Created by Jonathan McCormick on 1/26/19.
//  Copyright © 2019 Jonathan McCormick. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    var dataSource: [TodoItem] = [TodoItem(title: "Thing one"), TodoItem(title: "Thing two")]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as! TodoItemTableViewCell
        let idx = indexPath.row
        cell.title?.text = dataSource[idx].title
        return cell;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
}
