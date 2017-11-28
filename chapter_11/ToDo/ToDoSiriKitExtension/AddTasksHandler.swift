//
//  AddTasksHandler.swift
//  ToDoSiriKitExtension
//
//  Created by Kishikawa Katsumi on 2017/09/04.
//  Copyright © 2017 Kishikawa Katsumi. All rights reserved.
//

import Foundation
import Intents
import ToDoKit

class AddTasksHandler: NSObject, INAddTasksIntentHandling {
    func handle(intent: INAddTasksIntent, completion: @escaping (INAddTasksIntentResponse) -> Void) {
        guard let targetTaskList = intent.targetTaskList,
            let taskList = Repository.shared.taskList(for: targetTaskList.title.spokenPhrase),
            let taskTitles = intent.taskTitles else {
                let response = INAddTasksIntentResponse(code: .failureRequiringAppLaunch, userActivity: nil)
                completion(response)
                return
        }

        taskTitles.forEach { taskList.tasks.append(Task(title: $0.spokenPhrase)) }

        let response = INAddTasksIntentResponse(code: .success, userActivity: nil)
        completion(response)
    }
}
