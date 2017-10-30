//
//  TaskViewController.swift
//  ToDo
//
//  Created by Kishikawa Katsumi on 2017/09/03.
//  Copyright © 2017 Kishikawa Katsumi. All rights reserved.
//

import UIKit
import ToDoKit

class TaskViewController: UITableViewController {
    var taskList: TaskList!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = taskList.title
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTask(_:)))
        navigationItem.rightBarButtonItems = [addButton, editButtonItem]
    }

    @objc func addTask(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Add Task", message: nil, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Title"
        }
        alertController.addAction(UIAlertAction(title: "Add", style: .default) { (action) in
            if let textFields = alertController.textFields, let text = textFields[0].text {
                self.taskList.tasks.append(Task(title: text))
                self.tableView.reloadData()
            }
        })
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(alertController, animated: true, completion: nil)
    }

    private func completeTask(at indexPath: IndexPath) {
        let task = taskList.tasks[indexPath.row]
        taskList.tasks[indexPath.row].isCompleted = !task.isCompleted
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

    private func deleteTask(at indexPath: IndexPath) {
        taskList.tasks.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList.tasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = taskList.tasks[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let attributedText = NSMutableAttributedString(string: task.title)
        if task.isCompleted {
            attributedText.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: NSRange(location: 0, length: attributedText.length))
        }
        cell.textLabel?.attributedText = attributedText

        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if case .delete = editingStyle {
            deleteTask(at: indexPath)
        }
    }

    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        taskList.tasks.insert(taskList.tasks.remove(at: fromIndexPath.row), at: to.row)
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let task = taskList.tasks[indexPath.row]
        let swipeActionsConfiguration = UISwipeActionsConfiguration(actions: [
            UIContextualAction(style: .normal, title: task.isCompleted ? "Incomplete" : "Complete") { (action, sourceView, completionHandler) in
                self.completeTask(at: indexPath)
                completionHandler(true)
            }, UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
                self.deleteTask(at: indexPath)
                completionHandler(true)
            }
        ])
        return swipeActionsConfiguration
    }
}
