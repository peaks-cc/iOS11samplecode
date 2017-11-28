//
//  IntentHandler.swift
//  MyQRCodeSiriKitExtension
//
//  Created by Kishikawa Katsumi on 2017/09/04.
//  Copyright © 2017 Kishikawa Katsumi. All rights reserved.
//

import Intents
import MyQRCodeKit

class IntentHandler: INExtension, INGetVisualCodeIntentHandling {
    override func handler(for intent: INIntent) -> Any {
        return self
    }

    func resolveVisualCodeType(for intent: INGetVisualCodeIntent, with completion: @escaping (INVisualCodeTypeResolutionResult) -> Void) {
        switch intent.visualCodeType {
        case .unknown, .contact:
            completion(.success(with: .contact))
        default:
            completion(.unsupported())
        }
    }

    func confirm(intent: INGetVisualCodeIntent, completion: @escaping (INGetVisualCodeIntentResponse) -> Void) {
        let response = INGetVisualCodeIntentResponse(code: .ready, userActivity: nil)
        completion(response)
    }

    func handle(intent: INGetVisualCodeIntent, completion: @escaping (INGetVisualCodeIntentResponse) -> Void) {
        guard let me = Repository.shared.load() else {
            let response = INGetVisualCodeIntentResponse(code: .failureAppConfigurationRequired, userActivity: nil)
            completion(response)
            return
        }
        guard let image = me.generateVisualCode(), let imageData = UIImagePNGRepresentation(image) else {
            let response = INGetVisualCodeIntentResponse(code: .failure, userActivity: nil)
            completion(response)
            return
        }

        let response = INGetVisualCodeIntentResponse(code: .success, userActivity: nil)
        response.visualCodeImage = INImage(imageData: imageData)
        completion(response)
    }
}
