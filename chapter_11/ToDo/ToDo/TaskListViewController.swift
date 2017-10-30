//
//  TaskListViewController.swift
//  ToDo
//
//  Created by Kishikawa Katsumi on 2017/09/03.
//  Copyright © 2017 Kishikawa Katsumi. All rights reserved.
//

import UIKit
import ToDoKit

class TaskListViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = self.editButtonItem
    }

    @IBAction func addTaskList(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Add Task List", message: nil, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Title"
        }
        alertController.addAction(UIAlertAction(title: "Add", style: .default) { (action) in
            if let textFields = alertController.textFields, let text = textFields[0].text {
                Repository.shared.addTaskList(title: text)
                self.tableView.reloadData()
            }
        })
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alertController, animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? TaskViewController, let indexPath = tableView.indexPathForSelectedRow {
            controller.taskList = Repository.shared.taskLists[indexPath.row]
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Repository.shared.taskLists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let taskList = Repository.shared.taskLists[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = taskList.title

        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if case .delete = editingStyle {
            Repository.shared.taskLists.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        Repository.shared.taskLists.insert(Repository.shared.taskLists.remove(at: fromIndexPath.row), at: to.row)
    }
}
