//
//  CreateTaskListHandler.swift
//  ToDoSiriKitExtension
//
//  Created by Kishikawa Katsumi on 2017/09/03.
//  Copyright © 2017 Kishikawa Katsumi. All rights reserved.
//

import Foundation
import Intents
import ToDoKit

class CreateTaskListHandler: NSObject, INCreateTaskListIntentHandling {
    func handle(intent: INCreateTaskListIntent, completion: @escaping (INCreateTaskListIntentResponse) -> Void) {
        guard let title = intent.title else {
            let response = INCreateTaskListIntentResponse(code: .failureRequiringAppLaunch, userActivity: nil)
            completion(response)
            return
        }
        if let taskTitles = intent.taskTitles, !taskTitles.isEmpty {
            Repository.shared.addTaskList(title: title.spokenPhrase, tasks: taskTitles.map { Task(title: $0.spokenPhrase) })
        } else {
            Repository.shared.addTaskList(title: title.spokenPhrase)
        }
        let response = INCreateTaskListIntentResponse(code: .success, userActivity: nil)
        completion(response)
    }

    func resolveTitle(for intent: INCreateTaskListIntent, with completion: @escaping (INSpeakableStringResolutionResult) -> Void) {
        if let title = intent.title {
            completion(.success(with: title))
        } else {
            completion(INSpeakableStringResolutionResult.needsValue())
        }
    }
}
