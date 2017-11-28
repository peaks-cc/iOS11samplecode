//
//  HMHomeHubState+Description.swift
//
//  Created by ToKoRo on 2017-08-21.
//

import HomeKit

extension HMHomeHubState: CustomStringConvertible {
    public var description: String {
        switch self {
        case .connected: return "connected"
        case .disconnected: return "disconnected"
        case .notAvailable: return "notAvailable"
        }
    }
}
