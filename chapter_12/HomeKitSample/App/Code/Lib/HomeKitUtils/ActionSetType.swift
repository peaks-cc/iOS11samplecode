//
//  ActionSetType.swift
//
//  Created by ToKoRo on 2017-08-22.
//

import HomeKit

enum ActionSetType {
    case unknown

    case homeArrival
    case homeDeparture
    case sleep
    case triggerOwned
    case userDefined
    case wakeUp

    init(typeString: String) {
        switch typeString {
        case HMActionSetTypeHomeArrival: self = .homeArrival
        case HMActionSetTypeHomeDeparture: self = .homeDeparture
        case HMActionSetTypeSleep: self = .sleep
        case HMActionSetTypeTriggerOwned: self = .triggerOwned
        case HMActionSetTypeUserDefined: self = .userDefined
        case HMActionSetTypeWakeUp: self = .wakeUp
        default: self = .unknown
        }
    }
}

extension ActionSetType: CustomStringConvertible {
    var description: String {
        switch self {
        case .unknown: return "UNKNOWN"
        case .homeArrival: return "homeArrival"
        case .homeDeparture: return "homeDeparture"
        case .sleep: return "sleep"
        case .triggerOwned: return "triggerOwned"
        case .userDefined: return "userDefined"
        case .wakeUp: return "wakeUp"
        }
    }
}
