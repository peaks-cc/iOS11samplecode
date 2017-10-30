//
//  SetTaskAttributeHandler.swift
//  ToDoSiriKitExtension
//
//  Created by Kishikawa Katsumi on 2017/09/04.
//  Copyright © 2017 Kishikawa Katsumi. All rights reserved.
//

import Foundation
import Intents
import ToDoKit

class SetTaskAttributeHandler: NSObject, INSetTaskAttributeIntentHandling {
    func handle(intent: INSetTaskAttributeIntent, completion: @escaping (INSetTaskAttributeIntentResponse) -> Void) {
        guard let title = intent.targetTask?.title else {
            let response = INSetTaskAttributeIntentResponse(code: .failureRequiringAppLaunch, userActivity: nil)
            completion(response)
            return
        }

        if Repository.shared.setComplete(for: title.spokenPhrase) {
            let response = INSetTaskAttributeIntentResponse(code: .success, userActivity: nil)
            completion(response)
        } else {
            let response = INSetTaskAttributeIntentResponse(code: .failureRequiringAppLaunch, userActivity: nil)
            completion(response)
        }
    }
}

