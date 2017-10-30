//
//  HMCameraStreamState+Description.swift
//
//  Created by ToKoRo on 2017-09-12.
//

import HomeKit

extension HMCameraStreamState: CustomStringConvertible {
    public var description: String {
        switch self {
        case .notStreaming: return "notStreaming"
        case .starting: return "starting"
        case .stopping: return "stopping"
        case .streaming: return "streaming"
        }
    }
}
