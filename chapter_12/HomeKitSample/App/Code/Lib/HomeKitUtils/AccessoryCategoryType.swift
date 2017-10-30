//
//  AccessoryCategoryType.swift
//
//  Created by ToKoRo on 2017-09-05.
//

import HomeKit

enum AccessoryCategoryType {
    case unknown

    case other
    case securitySystem
    case bridge
    case door
    case doorLock
    case fan
    case garageDoorOpener
    case ipCamera
    case lightbulb
    case outlet
    case programmableSwitch
    case rangeExtender
    case sensor
    case `switch`
    case thermostat
    case videoDoorbell
    case window
    case windowCovering
    case airPurifier
    case airHeater
    case airConditioner
    case airHumidifier
    case airDehumidifier

    init(typeString: String) {
        switch typeString {
        case HMAccessoryCategoryTypeOther: self = .other
        case HMAccessoryCategoryTypeSecuritySystem: self = .securitySystem
        case HMAccessoryCategoryTypeBridge: self = .bridge
        case HMAccessoryCategoryTypeDoor: self = .door
        case HMAccessoryCategoryTypeDoorLock: self = .doorLock
        case HMAccessoryCategoryTypeFan: self = .fan
        case HMAccessoryCategoryTypeGarageDoorOpener: self = .garageDoorOpener
        case HMAccessoryCategoryTypeIPCamera: self = .ipCamera
        case HMAccessoryCategoryTypeLightbulb: self = .lightbulb
        case HMAccessoryCategoryTypeOutlet: self = .outlet
        case HMAccessoryCategoryTypeProgrammableSwitch: self = .programmableSwitch
        case HMAccessoryCategoryTypeRangeExtender: self = .rangeExtender
        case HMAccessoryCategoryTypeSensor: self = .sensor
        case HMAccessoryCategoryTypeSwitch: self = .switch
        case HMAccessoryCategoryTypeThermostat: self = .thermostat
        case HMAccessoryCategoryTypeVideoDoorbell: self = .videoDoorbell
        case HMAccessoryCategoryTypeWindow: self = .window
        case HMAccessoryCategoryTypeWindowCovering: self = .windowCovering
        case HMAccessoryCategoryTypeAirPurifier: self = .airPurifier
        case HMAccessoryCategoryTypeAirHeater: self = .airHeater
        case HMAccessoryCategoryTypeAirConditioner: self = .airConditioner
        case HMAccessoryCategoryTypeAirHumidifier: self = .airHumidifier
        case HMAccessoryCategoryTypeAirDehumidifier: self = .airDehumidifier
        default: self = .unknown
        }
    }
}

extension AccessoryCategoryType: CustomStringConvertible {
    var description: String {
        switch self {
        case .unknown: return "UNKNOWN"
        case .other: return "other"
        case .securitySystem: return "securitySystem"
        case .bridge: return "bridge"
        case .door: return "door"
        case .doorLock: return "doorLock"
        case .fan: return "fan"
        case .garageDoorOpener: return "garageDoorOpener"
        case .ipCamera: return "ipCamera"
        case .lightbulb: return "lightbulb"
        case .outlet: return "outlet"
        case .programmableSwitch: return "programmableSwitch"
        case .rangeExtender: return "rangeExtender"
        case .sensor: return "sensor"
        case .switch: return "switch"
        case .thermostat: return "thermostat"
        case .videoDoorbell: return "videoDoorbell"
        case .window: return "window"
        case .windowCovering: return "windowCovering"
        case .airPurifier: return "airPurifier"
        case .airHeater: return "airHeater"
        case .airConditioner: return "airConditioner"
        case .airHumidifier: return "airHumidifier"
        case .airDehumidifier: return "airDehumidifier"
        }
    }
}
