//
//  CharacteristicType.swift
//
//  Created by ToKoRo on 2017-08-21.
//

import HomeKit

enum CharacteristicType {
    case unknown

    case powerState
    case hue
    case saturation
    case brightness
    case temperatureUnits
    case currentTemperature
    case targetTemperature
    case currentHeatingCooling
    case targetHeatingCooling
    case coolingThreshold
    case heatingThreshold
    case currentRelativeHumidity
    case targetRelativeHumidity
    case currentDoorState
    case targetDoorState
    case obstructionDetected
    case name
    case manufacturer
    case model
    case serialNumber
    case identify
    case rotationDirection
    case rotationSpeed
    case outletInUse
    case version
    case logs
    case audioFeedback
    case adminOnlyAccess
    case securitySystemAlarmType
    case motionDetected
    case currentLockMechanismState
    case targetLockMechanismState
    case lockMechanismLastKnownAction
    case lockManagementControlPoint
    case lockManagementAutoSecureTimeout
    case airParticulateDensity
    case airParticulateSize
    case airQuality
    case batteryLevel
    case carbonDioxideDetected
    case carbonDioxideLevel
    case carbonDioxidePeakLevel
    case carbonMonoxideDetected
    case carbonMonoxideLevel
    case carbonMonoxidePeakLevel
    case chargingState
    case contactState
    case currentHorizontalTilt
    case currentLightLevel
    case currentPosition
    case currentSecuritySystemState
    case currentVerticalTilt
    case firmwareVersion
    case hardwareVersion
    case holdPosition
    case inputEvent
    case leakDetected
    case occupancyDetected
    case outputState
    case positionState
    case smokeDetected
    case softwareVersion
    case statusActive
    case statusFault
    case statusJammed
    case statusLowBattery
    case statusTampered
    case targetHorizontalTilt
    case targetSecuritySystemState
    case targetPosition
    case targetVerticalTilt
    case streamingStatus
    case setupStreamEndpoint
    case supportedVideoStreamConfiguration
    case supportedAudioStreamConfiguration
    case supportedRTPConfiguration
    case selectedStreamConfiguration
    case volume
    case mute
    case nightVision
    case opticalZoom
    case digitalZoom
    case imageRotation
    case imageMirroring
    case labelNamespace
    case labelIndex
    case active
    case currentAirPurifierState
    case targetAirPurifierState
    case currentFanState
    case currentHeaterCoolerState
    case currentHumidifierDehumidifierState
    case currentSlatState
    case waterLevel
    case filterChangeIndication
    case filterLifeLevel
    case filterResetChangeIndication
    case lockPhysicalControls
    case swingMode
    case targetHeaterCoolerState
    case targetHumidifierDehumidifierState
    case targetFanState
    case slatType
    case currentTilt
    case targetTilt
    case ozoneDensity
    case nitrogenDioxideDensity
    case sulphurDioxideDensity
    case pm25Density
    case pm10Density
    case volatileOrganicCompoundDensity
    case dehumidifierThreshold
    case humidifierThreshold
    case colorTemperature

    init(typeString: String) {
        switch typeString {
        case HMCharacteristicTypePowerState: self = .powerState
        case HMCharacteristicTypeHue: self = .hue
        case HMCharacteristicTypeSaturation: self = .saturation
        case HMCharacteristicTypeBrightness: self = .brightness
        case HMCharacteristicTypeTemperatureUnits: self = .temperatureUnits
        case HMCharacteristicTypeCurrentTemperature: self = .currentTemperature
        case HMCharacteristicTypeTargetTemperature: self = .targetTemperature
        case HMCharacteristicTypeCurrentHeatingCooling: self = .currentHeatingCooling
        case HMCharacteristicTypeTargetHeatingCooling: self = .targetHeatingCooling
        case HMCharacteristicTypeCoolingThreshold: self = .coolingThreshold
        case HMCharacteristicTypeHeatingThreshold: self = .heatingThreshold
        case HMCharacteristicTypeCurrentRelativeHumidity: self = .currentRelativeHumidity
        case HMCharacteristicTypeTargetRelativeHumidity: self = .targetRelativeHumidity
        case HMCharacteristicTypeCurrentDoorState: self = .currentDoorState
        case HMCharacteristicTypeTargetDoorState: self = .targetDoorState
        case HMCharacteristicTypeObstructionDetected: self = .obstructionDetected
        case HMCharacteristicTypeName: self = .name
        case HMCharacteristicTypeManufacturer: self = .manufacturer
        case HMCharacteristicTypeModel: self = .model
        case HMCharacteristicTypeSerialNumber: self = .serialNumber
        case HMCharacteristicTypeIdentify: self = .identify
        case HMCharacteristicTypeRotationDirection: self = .rotationDirection
        case HMCharacteristicTypeRotationSpeed: self = .rotationSpeed
        case HMCharacteristicTypeOutletInUse: self = .outletInUse
        case HMCharacteristicTypeVersion: self = .version
        case HMCharacteristicTypeLogs: self = .logs
        case HMCharacteristicTypeAudioFeedback: self = .audioFeedback
        case HMCharacteristicTypeAdminOnlyAccess: self = .adminOnlyAccess
        case HMCharacteristicTypeSecuritySystemAlarmType: self = .securitySystemAlarmType
        case HMCharacteristicTypeMotionDetected: self = .motionDetected
        case HMCharacteristicTypeCurrentLockMechanismState: self = .currentLockMechanismState
        case HMCharacteristicTypeTargetLockMechanismState: self = .targetLockMechanismState
        case HMCharacteristicTypeLockMechanismLastKnownAction: self = .lockMechanismLastKnownAction
        case HMCharacteristicTypeLockManagementControlPoint: self = .lockManagementControlPoint
        case HMCharacteristicTypeLockManagementAutoSecureTimeout: self = .lockManagementAutoSecureTimeout
        case HMCharacteristicTypeAirParticulateDensity: self = .airParticulateDensity
        case HMCharacteristicTypeAirParticulateSize: self = .airParticulateSize
        case HMCharacteristicTypeAirQuality: self = .airQuality
        case HMCharacteristicTypeBatteryLevel: self = .batteryLevel
        case HMCharacteristicTypeCarbonDioxideDetected: self = .carbonDioxideDetected
        case HMCharacteristicTypeCarbonDioxideLevel: self = .carbonDioxideLevel
        case HMCharacteristicTypeCarbonDioxidePeakLevel: self = .carbonDioxidePeakLevel
        case HMCharacteristicTypeCarbonMonoxideDetected: self = .carbonMonoxideDetected
        case HMCharacteristicTypeCarbonMonoxideLevel: self = .carbonMonoxideLevel
        case HMCharacteristicTypeCarbonMonoxidePeakLevel: self = .carbonMonoxidePeakLevel
        case HMCharacteristicTypeChargingState: self = .chargingState
        case HMCharacteristicTypeContactState: self = .contactState
        case HMCharacteristicTypeCurrentHorizontalTilt: self = .currentHorizontalTilt
        case HMCharacteristicTypeCurrentLightLevel: self = .currentLightLevel
        case HMCharacteristicTypeCurrentPosition: self = .currentPosition
        case HMCharacteristicTypeCurrentSecuritySystemState: self = .currentSecuritySystemState
        case HMCharacteristicTypeCurrentVerticalTilt: self = .currentVerticalTilt
        case HMCharacteristicTypeFirmwareVersion: self = .firmwareVersion
        case HMCharacteristicTypeHardwareVersion: self = .hardwareVersion
        case HMCharacteristicTypeHoldPosition: self = .holdPosition
        case HMCharacteristicTypeInputEvent: self = .inputEvent
        case HMCharacteristicTypeLeakDetected: self = .leakDetected
        case HMCharacteristicTypeOccupancyDetected: self = .occupancyDetected
        case HMCharacteristicTypeOutputState: self = .outputState
        case HMCharacteristicTypePositionState: self = .positionState
        case HMCharacteristicTypeSmokeDetected: self = .smokeDetected
        case HMCharacteristicTypeSoftwareVersion: self = .softwareVersion
        case HMCharacteristicTypeStatusActive: self = .statusActive
        case HMCharacteristicTypeStatusFault: self = .statusFault
        case HMCharacteristicTypeStatusJammed: self = .statusJammed
        case HMCharacteristicTypeStatusLowBattery: self = .statusLowBattery
        case HMCharacteristicTypeStatusTampered: self = .statusTampered
        case HMCharacteristicTypeTargetHorizontalTilt: self = .targetHorizontalTilt
        case HMCharacteristicTypeTargetSecuritySystemState: self = .targetSecuritySystemState
        case HMCharacteristicTypeTargetPosition: self = .targetPosition
        case HMCharacteristicTypeTargetVerticalTilt: self = .targetVerticalTilt
        case HMCharacteristicTypeStreamingStatus: self = .streamingStatus
        case HMCharacteristicTypeSetupStreamEndpoint: self = .setupStreamEndpoint
        case HMCharacteristicTypeSupportedVideoStreamConfiguration: self = .supportedVideoStreamConfiguration
        case HMCharacteristicTypeSupportedAudioStreamConfiguration: self = .supportedAudioStreamConfiguration
        case HMCharacteristicTypeSupportedRTPConfiguration: self = .supportedRTPConfiguration
        case HMCharacteristicTypeSelectedStreamConfiguration: self = .selectedStreamConfiguration
        case HMCharacteristicTypeVolume: self = .volume
        case HMCharacteristicTypeMute: self = .mute
        case HMCharacteristicTypeNightVision: self = .nightVision
        case HMCharacteristicTypeOpticalZoom: self = .opticalZoom
        case HMCharacteristicTypeDigitalZoom: self = .digitalZoom
        case HMCharacteristicTypeImageRotation: self = .imageRotation
        case HMCharacteristicTypeImageMirroring: self = .imageMirroring
        case HMCharacteristicTypeLabelNamespace: self = .labelNamespace
        case HMCharacteristicTypeLabelIndex: self = .labelIndex
        case HMCharacteristicTypeActive: self = .active
        case HMCharacteristicTypeCurrentAirPurifierState: self = .currentAirPurifierState
        case HMCharacteristicTypeTargetAirPurifierState: self = .targetAirPurifierState
        case HMCharacteristicTypeCurrentFanState: self = .currentFanState
        case HMCharacteristicTypeCurrentHeaterCoolerState: self = .currentHeaterCoolerState
        case HMCharacteristicTypeCurrentHumidifierDehumidifierState: self = .currentHumidifierDehumidifierState
        case HMCharacteristicTypeCurrentSlatState: self = .currentSlatState
        case HMCharacteristicTypeWaterLevel: self = .waterLevel
        case HMCharacteristicTypeFilterChangeIndication: self = .filterChangeIndication
        case HMCharacteristicTypeFilterLifeLevel: self = .filterLifeLevel
        case HMCharacteristicTypeFilterResetChangeIndication: self = .filterResetChangeIndication
        case HMCharacteristicTypeLockPhysicalControls: self = .lockPhysicalControls
        case HMCharacteristicTypeSwingMode: self = .swingMode
        case HMCharacteristicTypeTargetHeaterCoolerState: self = .targetHeaterCoolerState
        case HMCharacteristicTypeTargetHumidifierDehumidifierState: self = .targetHumidifierDehumidifierState
        case HMCharacteristicTypeTargetFanState: self = .targetFanState
        case HMCharacteristicTypeSlatType: self = .slatType
        case HMCharacteristicTypeCurrentTilt: self = .currentTilt
        case HMCharacteristicTypeTargetTilt: self = .targetTilt
        case HMCharacteristicTypeOzoneDensity: self = .ozoneDensity
        case HMCharacteristicTypeNitrogenDioxideDensity: self = .nitrogenDioxideDensity
        case HMCharacteristicTypeSulphurDioxideDensity: self = .sulphurDioxideDensity
        case HMCharacteristicTypePM2_5Density: self = .pm25Density
        case HMCharacteristicTypePM10Density: self = .pm10Density
        case HMCharacteristicTypeVolatileOrganicCompoundDensity: self = .volatileOrganicCompoundDensity
        case HMCharacteristicTypeDehumidifierThreshold: self = .dehumidifierThreshold
        case HMCharacteristicTypeHumidifierThreshold: self = .humidifierThreshold
        case HMCharacteristicTypeColorTemperature: self = .colorTemperature
        default: self = .unknown
        }
    }
}

extension CharacteristicType: CustomStringConvertible {
    var description: String {
        switch self {
        case .unknown: return "UNKNOWN"
        case .powerState: return "powerState"
        case .hue: return "hue"
        case .saturation: return "saturation"
        case .brightness: return "brightness"
        case .temperatureUnits: return "temperatureUnits"
        case .currentTemperature: return "currentTemperature"
        case .targetTemperature: return "targetTemperature"
        case .currentHeatingCooling: return "currentHeatingCooling"
        case .targetHeatingCooling: return "targetHeatingCooling"
        case .coolingThreshold: return "coolingThreshold"
        case .heatingThreshold: return "heatingThreshold"
        case .currentRelativeHumidity: return "currentRelativeHumidity"
        case .targetRelativeHumidity: return "targetRelativeHumidity"
        case .currentDoorState: return "currentDoorState"
        case .targetDoorState: return "targetDoorState"
        case .obstructionDetected: return "obstructionDetected"
        case .name: return "name"
        case .manufacturer: return "manufacturer"
        case .model: return "model"
        case .serialNumber: return "serialNumber"
        case .identify: return "identify"
        case .rotationDirection: return "rotationDirection"
        case .rotationSpeed: return "rotationSpeed"
        case .outletInUse: return "outletInUse"
        case .version: return "version"
        case .logs: return "logs"
        case .audioFeedback: return "audioFeedback"
        case .adminOnlyAccess: return "adminOnlyAccess"
        case .securitySystemAlarmType: return "securitySystemAlarmType"
        case .motionDetected: return "motionDetected"
        case .currentLockMechanismState: return "currentLockMechanismState"
        case .targetLockMechanismState: return "targetLockMechanismState"
        case .lockMechanismLastKnownAction: return "lockMechanismLastKnownAction"
        case .lockManagementControlPoint: return "lockManagementControlPoint"
        case .lockManagementAutoSecureTimeout: return "lockManagementAutoSecureTimeout"
        case .airParticulateDensity: return "airParticulateDensity"
        case .airParticulateSize: return "airParticulateSize"
        case .airQuality: return "airQuality"
        case .batteryLevel: return "batteryLevel"
        case .carbonDioxideDetected: return "carbonDioxideDetected"
        case .carbonDioxideLevel: return "carbonDioxideLevel"
        case .carbonDioxidePeakLevel: return "carbonDioxidePeakLevel"
        case .carbonMonoxideDetected: return "carbonMonoxideDetected"
        case .carbonMonoxideLevel: return "carbonMonoxideLevel"
        case .carbonMonoxidePeakLevel: return "carbonMonoxidePeakLevel"
        case .chargingState: return "chargingState"
        case .contactState: return "contactState"
        case .currentHorizontalTilt: return "currentHorizontalTilt"
        case .currentLightLevel: return "currentLightLevel"
        case .currentPosition: return "currentPosition"
        case .currentSecuritySystemState: return "currentSecuritySystemState"
        case .currentVerticalTilt: return "currentVerticalTilt"
        case .firmwareVersion: return "firmwareVersion"
        case .hardwareVersion: return "hardwareVersion"
        case .holdPosition: return "holdPosition"
        case .inputEvent: return "inputEvent"
        case .leakDetected: return "leakDetected"
        case .occupancyDetected: return "occupancyDetected"
        case .outputState: return "outputState"
        case .positionState: return "positionState"
        case .smokeDetected: return "smokeDetected"
        case .softwareVersion: return "softwareVersion"
        case .statusActive: return "statusActive"
        case .statusFault: return "statusFault"
        case .statusJammed: return "statusJammed"
        case .statusLowBattery: return "statusLowBattery"
        case .statusTampered: return "statusTampered"
        case .targetHorizontalTilt: return "targetHorizontalTilt"
        case .targetSecuritySystemState: return "targetSecuritySystemState"
        case .targetPosition: return "targetPosition"
        case .targetVerticalTilt: return "targetVerticalTilt"
        case .streamingStatus: return "streamingStatus"
        case .setupStreamEndpoint: return "setupStreamEndpoint"
        case .supportedVideoStreamConfiguration: return "supportedVideoStreamConfiguration"
        case .supportedAudioStreamConfiguration: return "supportedAudioStreamConfiguration"
        case .supportedRTPConfiguration: return "supportedRTPConfiguration"
        case .selectedStreamConfiguration: return "selectedStreamConfiguration"
        case .volume: return "volume"
        case .mute: return "mute"
        case .nightVision: return "nightVision"
        case .opticalZoom: return "opticalZoom"
        case .digitalZoom: return "digitalZoom"
        case .imageRotation: return "imageRotation"
        case .imageMirroring: return "imageMirroring"
        case .labelNamespace: return "labelNamespace"
        case .labelIndex: return "labelIndex"
        case .active: return "active"
        case .currentAirPurifierState: return "currentAirPurifierState"
        case .targetAirPurifierState: return "targetAirPurifierState"
        case .currentFanState: return "currentFanState"
        case .currentHeaterCoolerState: return "currentHeaterCoolerState"
        case .currentHumidifierDehumidifierState: return "currentHumidifierDehumidifierState"
        case .currentSlatState: return "currentSlatState"
        case .waterLevel: return "waterLevel"
        case .filterChangeIndication: return "filterChangeIndication"
        case .filterLifeLevel: return "filterLifeLevel"
        case .filterResetChangeIndication: return "filterResetChangeIndication"
        case .lockPhysicalControls: return "lockPhysicalControls"
        case .swingMode: return "swingMode"
        case .targetHeaterCoolerState: return "targetHeaterCoolerState"
        case .targetHumidifierDehumidifierState: return "targetHumidifierDehumidifierState"
        case .targetFanState: return "targetFanState"
        case .slatType: return "slatType"
        case .currentTilt: return "currentTilt"
        case .targetTilt: return "targetTilt"
        case .ozoneDensity: return "ozoneDensity"
        case .nitrogenDioxideDensity: return "nitrogenDioxideDensity"
        case .sulphurDioxideDensity: return "sulphurDioxideDensity"
        case .pm25Density: return "PM2_5Density"
        case .pm10Density: return "PM10Density"
        case .volatileOrganicCompoundDensity: return "volatileOrganicCompoundDensity"
        case .dehumidifierThreshold: return "dehumidifierThreshold"
        case .humidifierThreshold: return "humidifierThreshold"
        case .colorTemperature: return "colorTemperature"
        }
    }
}
