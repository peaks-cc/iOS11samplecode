//
//  Repository.swift
//  ToDoKit
//
//  Created by Kishikawa Katsumi on 2017/09/04.
//  Copyright © 2017 Kishikawa Katsumi. All rights reserved.
//

import Foundation

public final class Repository {
    public static let shared = Repository()
    public var taskLists = [TaskList]() {
        didSet {
            save()
        }
    }

    private var userDefaults: UserDefaults {
        get {
            return UserDefaults(suiteName: "group.com.kishikawakatsumi.todo")!
        }
    }
    private let key = "taskLists"

    private init() {
        if let data = userDefaults.object(forKey: key) as? Data,
            let savedTaskList = try? PropertyListDecoder().decode([TaskList].self, from: data) {
            taskLists = savedTaskList
        }
    }

    public func addTaskList(title: String) {
        taskLists.append(TaskList(title: title))
    }

    public func addTaskList(title: String, tasks: [Task]) {
        taskLists.append(TaskList(title: title, tasks: tasks))
    }

    public func taskList(for title: String) -> TaskList? {
        return taskLists.filter { $0.title == title }.first
    }

    public func setComplete(for targetTaskTitle: String) -> Bool {
        for taskList in taskLists {
            if let index = taskList.tasks.index(where: { $0.title == targetTaskTitle }) {
                taskList.tasks[index].isCompleted = true
                return true
            }
        }
        return false
    }

    func save() {
        userDefaults.set(try! PropertyListEncoder().encode(taskLists), forKey: key)
    }
}
