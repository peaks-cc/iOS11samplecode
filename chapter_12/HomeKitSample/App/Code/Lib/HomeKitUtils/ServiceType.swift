//
//  ServiceType.swift
//
//  Created by ToKoRo on 2017-08-27.
//

import HomeKit

enum ServiceType {
    case unknown

    case lightbulb
    case `switch`
    case thermostat
    case garageDoorOpener
    case accessoryInformation
    case fan
    case outlet
    case lockMechanism
    case lockManagement
    case airQualitySensor
    case battery
    case carbonDioxideSensor
    case carbonMonoxideSensor
    case contactSensor
    case door
    case doorbell
    case humiditySensor
    case leakSensor
    case lightSensor
    case motionSensor
    case occupancySensor
    case securitySystem
    case statefulProgrammableSwitch
    case statelessProgrammableSwitch
    case smokeSensor
    case temperatureSensor
    case window
    case windowCovering
    case cameraRTPStreamManagement
    case cameraControl
    case microphone
    case speaker
    case airPurifier
    case ventilationFan
    case filterMaintenance
    case heaterCooler
    case humidifierDehumidifier
    case slats
    case label

    static var all: [ServiceType] {
        return [
            .lightbulb,
            .switch,
            .thermostat,
            .garageDoorOpener,
            .accessoryInformation,
            .fan,
            .outlet,
            .lockMechanism,
            .lockManagement,
            .airQualitySensor,
            .battery,
            .carbonDioxideSensor,
            .carbonMonoxideSensor,
            .contactSensor,
            .door,
            .doorbell,
            .humiditySensor,
            .leakSensor,
            .lightSensor,
            .motionSensor,
            .occupancySensor,
            .securitySystem,
            .statefulProgrammableSwitch,
            .statelessProgrammableSwitch,
            .smokeSensor,
            .temperatureSensor,
            .window,
            .windowCovering,
            .cameraRTPStreamManagement,
            .cameraControl,
            .microphone,
            .speaker,
            .airPurifier,
            .ventilationFan,
            .filterMaintenance,
            .heaterCooler,
            .humidifierDehumidifier,
            .slats,
            .label
        ]
    }

    init(typeString: String) {
        switch typeString {
        case HMServiceTypeLightbulb: self = .lightbulb
        case HMServiceTypeSwitch: self = .switch
        case HMServiceTypeThermostat: self = .thermostat
        case HMServiceTypeGarageDoorOpener: self = .garageDoorOpener
        case HMServiceTypeAccessoryInformation: self = .accessoryInformation
        case HMServiceTypeFan: self = .fan
        case HMServiceTypeOutlet: self = .outlet
        case HMServiceTypeLockMechanism: self = .lockMechanism
        case HMServiceTypeLockManagement: self = .lockManagement
        case HMServiceTypeAirQualitySensor: self = .airQualitySensor
        case HMServiceTypeBattery: self = .battery
        case HMServiceTypeCarbonDioxideSensor: self = .carbonDioxideSensor
        case HMServiceTypeCarbonMonoxideSensor: self = .carbonMonoxideSensor
        case HMServiceTypeContactSensor: self = .contactSensor
        case HMServiceTypeDoor: self = .door
        case HMServiceTypeDoorbell: self = .doorbell
        case HMServiceTypeHumiditySensor: self = .humiditySensor
        case HMServiceTypeLeakSensor: self = .leakSensor
        case HMServiceTypeLightSensor: self = .lightSensor
        case HMServiceTypeMotionSensor: self = .motionSensor
        case HMServiceTypeOccupancySensor: self = .occupancySensor
        case HMServiceTypeSecuritySystem: self = .securitySystem
        case HMServiceTypeStatefulProgrammableSwitch: self = .statefulProgrammableSwitch
        case HMServiceTypeStatelessProgrammableSwitch: self = .statelessProgrammableSwitch
        case HMServiceTypeSmokeSensor: self = .smokeSensor
        case HMServiceTypeTemperatureSensor: self = .temperatureSensor
        case HMServiceTypeWindow: self = .window
        case HMServiceTypeWindowCovering: self = .windowCovering
        case HMServiceTypeCameraRTPStreamManagement: self = .cameraRTPStreamManagement
        case HMServiceTypeCameraControl: self = .cameraControl
        case HMServiceTypeMicrophone: self = .microphone
        case HMServiceTypeSpeaker: self = .speaker
        case HMServiceTypeAirPurifier: self = .airPurifier
        case HMServiceTypeVentilationFan: self = .ventilationFan
        case HMServiceTypeFilterMaintenance: self = .filterMaintenance
        case HMServiceTypeHeaterCooler: self = .heaterCooler
        case HMServiceTypeHumidifierDehumidifier: self = .humidifierDehumidifier
        case HMServiceTypeSlats: self = .slats
        case HMServiceTypeLabel: self = .label
        default: self = .unknown
        }
    }

    var typeString: String? {
        switch self {
        case .unknown: return nil
        case .lightbulb: return HMServiceTypeLightbulb
        case .switch: return HMServiceTypeSwitch
        case .thermostat: return HMServiceTypeThermostat
        case .garageDoorOpener: return HMServiceTypeGarageDoorOpener
        case .accessoryInformation: return HMServiceTypeAccessoryInformation
        case .fan: return HMServiceTypeFan
        case .outlet: return HMServiceTypeOutlet
        case .lockMechanism: return HMServiceTypeLockMechanism
        case .lockManagement: return HMServiceTypeLockManagement
        case .airQualitySensor: return HMServiceTypeAirQualitySensor
        case .battery: return HMServiceTypeBattery
        case .carbonDioxideSensor: return HMServiceTypeCarbonDioxideSensor
        case .carbonMonoxideSensor: return HMServiceTypeCarbonMonoxideSensor
        case .contactSensor: return HMServiceTypeContactSensor
        case .door: return HMServiceTypeDoor
        case .doorbell: return HMServiceTypeDoorbell
        case .humiditySensor: return HMServiceTypeHumiditySensor
        case .leakSensor: return HMServiceTypeLeakSensor
        case .lightSensor: return HMServiceTypeLightSensor
        case .motionSensor: return HMServiceTypeMotionSensor
        case .occupancySensor: return HMServiceTypeOccupancySensor
        case .securitySystem: return HMServiceTypeSecuritySystem
        case .statefulProgrammableSwitch: return HMServiceTypeStatefulProgrammableSwitch
        case .statelessProgrammableSwitch: return HMServiceTypeStatelessProgrammableSwitch
        case .smokeSensor: return HMServiceTypeSmokeSensor
        case .temperatureSensor: return HMServiceTypeTemperatureSensor
        case .window: return HMServiceTypeWindow
        case .windowCovering: return HMServiceTypeWindowCovering
        case .cameraRTPStreamManagement: return HMServiceTypeCameraRTPStreamManagement
        case .cameraControl: return HMServiceTypeCameraControl
        case .microphone: return HMServiceTypeMicrophone
        case .speaker: return HMServiceTypeSpeaker
        case .airPurifier: return HMServiceTypeAirPurifier
        case .ventilationFan: return HMServiceTypeVentilationFan
        case .filterMaintenance: return HMServiceTypeFilterMaintenance
        case .heaterCooler: return HMServiceTypeHeaterCooler
        case .humidifierDehumidifier: return HMServiceTypeHumidifierDehumidifier
        case .slats: return HMServiceTypeSlats
        case .label: return HMServiceTypeLabel
        }
    }
}

extension ServiceType: CustomStringConvertible {
    var description: String {
        switch self {
        case .unknown: return "UNKNOWN"
        case .lightbulb: return "lightbulb"
        case .switch: return "switch"
        case .thermostat: return "thermostat"
        case .garageDoorOpener: return "garageDoorOpener"
        case .accessoryInformation: return "accessoryInformation"
        case .fan: return "fan"
        case .outlet: return "outlet"
        case .lockMechanism: return "lockMechanism"
        case .lockManagement: return "lockManagement"
        case .airQualitySensor: return "airQualitySensor"
        case .battery: return "battery"
        case .carbonDioxideSensor: return "carbonDioxideSensor"
        case .carbonMonoxideSensor: return "carbonMonoxideSensor"
        case .contactSensor: return "contactSensor"
        case .door: return "door"
        case .doorbell: return "doorbell"
        case .humiditySensor: return "humiditySensor"
        case .leakSensor: return "leakSensor"
        case .lightSensor: return "lightSensor"
        case .motionSensor: return "motionSensor"
        case .occupancySensor: return "occupancySensor"
        case .securitySystem: return "securitySystem"
        case .statefulProgrammableSwitch: return "statefulProgrammableSwitch"
        case .statelessProgrammableSwitch: return "statelessProgrammableSwitch"
        case .smokeSensor: return "smokeSensor"
        case .temperatureSensor: return "temperatureSensor"
        case .window: return "window"
        case .windowCovering: return "windowCovering"
        case .cameraRTPStreamManagement: return "cameraRTPStreamManagement"
        case .cameraControl: return "cameraControl"
        case .microphone: return "microphone"
        case .speaker: return "speaker"
        case .airPurifier: return "airPurifier"
        case .ventilationFan: return "ventilationFan"
        case .filterMaintenance: return "filterMaintenance"
        case .heaterCooler: return "heaterCooler"
        case .humidifierDehumidifier: return "humidifierDehumidifier"
        case .slats: return "slats"
        case .label: return "label"
        }
    }
}
