//
//  IntentHandler.swift
//  ToDoSiriKitExtension
//
//  Created by Kishikawa Katsumi on 2017/09/03.
//  Copyright © 2017 Kishikawa Katsumi. All rights reserved.
//

import Intents

class IntentHandler: INExtension {
    override func handler(for intent: INIntent) -> Any? {
        switch intent {
        case is INCreateTaskListIntent:
            return CreateTaskListHandler()
        case is INAddTasksIntent:
            return AddTasksHandler()
        case is INSetTaskAttributeIntent:
            return SetTaskAttributeHandler()
        default:
            return nil
        }
    }
}
