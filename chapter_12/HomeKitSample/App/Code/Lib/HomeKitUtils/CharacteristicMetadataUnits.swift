//
//  CharacteristicMetadataUnits.swift
//
//  Created by ToKoRo on 2017-08-29.
//

import Foundation
import HomeKit

enum CharacteristicMetadataUnits {
    case unknown

    case celsius
    case fahrenheit
    case percentage
    case arcDegree
    case seconds
    case lux
    case partsPerMillion
    case microgramsPerCubicMeter

    static var all: [CharacteristicMetadataUnits] {
        return [
            .celsius,
            .fahrenheit,
            .percentage,
            .arcDegree,
            .seconds,
            .lux,
            .partsPerMillion,
            .microgramsPerCubicMeter
        ]
    }

    init(_ string: String) {
        switch string {
        case HMCharacteristicMetadataUnitsCelsius: self = .celsius
        case HMCharacteristicMetadataUnitsFahrenheit: self = .fahrenheit
        case HMCharacteristicMetadataUnitsPercentage: self = .percentage
        case HMCharacteristicMetadataUnitsArcDegree: self = .arcDegree
        case HMCharacteristicMetadataUnitsSeconds: self = .seconds
        case HMCharacteristicMetadataUnitsLux: self = .lux
        case HMCharacteristicMetadataUnitsPartsPerMillion: self = .partsPerMillion
        case HMCharacteristicMetadataUnitsMicrogramsPerCubicMeter: self = .microgramsPerCubicMeter
        default: self = .unknown
        }
    }
}

extension CharacteristicMetadataUnits: CustomStringConvertible {
    var description: String {
        switch self {
        case .unknown: return "UNKNOWN"
        case .celsius: return HMCharacteristicMetadataUnitsCelsius
        case .fahrenheit: return HMCharacteristicMetadataUnitsFahrenheit
        case .percentage: return HMCharacteristicMetadataUnitsPercentage
        case .arcDegree: return HMCharacteristicMetadataUnitsArcDegree
        case .seconds: return HMCharacteristicMetadataUnitsSeconds
        case .lux: return HMCharacteristicMetadataUnitsLux
        case .partsPerMillion: return HMCharacteristicMetadataUnitsPartsPerMillion
        case .microgramsPerCubicMeter: return HMCharacteristicMetadataUnitsMicrogramsPerCubicMeter
        }
    }
}
