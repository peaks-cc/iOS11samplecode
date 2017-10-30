//
//  HMCameraAudioStreamSetting+Description.swift
//
//  Created by ToKoRo on 2017-09-12.
//

import HomeKit

extension HMCameraAudioStreamSetting: CustomStringConvertible {
    public var description: String {
        switch self {
        case .bidirectionalAudioAllowed: return "bidirectionalAudioAllowed"
        case .incomingAudioAllowed: return "incomingAudioAllowed"
        case .muted: return "muted"
        }
    }

    static var all: [HMCameraAudioStreamSetting] {
        return [
            .bidirectionalAudioAllowed,
            .incomingAudioAllowed,
            .muted
        ]
    }
}
