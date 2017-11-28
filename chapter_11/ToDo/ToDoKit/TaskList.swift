//
//  TaskList.swift
//  ToDoKit
//
//  Created by Kishikawa Katsumi on 2017/09/03.
//  Copyright © 2017 Kishikawa Katsumi. All rights reserved.
//

import Foundation

public final class TaskList: Codable {
    public let title: String
    public var tasks: [Task]  {
        didSet {
            Repository.shared.save()
        }
    }

    public init(title: String, tasks: [Task] = [Task]()) {
        self.title = title
        self.tasks = tasks
    }
}
