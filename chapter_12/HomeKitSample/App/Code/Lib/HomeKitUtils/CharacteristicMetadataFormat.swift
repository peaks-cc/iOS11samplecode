//
//  CharacteristicMetadataFormat.swift
//
//  Created by ToKoRo on 2017-08-28.
//

import Foundation
import HomeKit

enum CharacteristicMetadataFormat {
    case unknown

    case bool
    case int
    case float
    case string
    case array
    case dictionary
    case uint8
    case uint16
    case uint32
    case uint64
    case data
    case tlv8

    static var all: [CharacteristicMetadataFormat] {
        return [
            .bool,
            .int,
            .float,
            .string,
            .array,
            .dictionary,
            .uint8,
            .uint16,
            .uint32,
            .uint64,
            .data,
            .tlv8
        ]
    }

    init(_ string: String) {
        switch string {
        case HMCharacteristicMetadataFormatBool: self = .bool
        case HMCharacteristicMetadataFormatInt: self = .int
        case HMCharacteristicMetadataFormatFloat: self = .float
        case HMCharacteristicMetadataFormatString: self = .string
        case HMCharacteristicMetadataFormatArray: self = .array
        case HMCharacteristicMetadataFormatDictionary: self = .dictionary
        case HMCharacteristicMetadataFormatUInt8: self = .uint8
        case HMCharacteristicMetadataFormatUInt16: self = .uint16
        case HMCharacteristicMetadataFormatUInt32: self = .uint32
        case HMCharacteristicMetadataFormatUInt64: self = .uint64
        case HMCharacteristicMetadataFormatData: self = .data
        case HMCharacteristicMetadataFormatTLV8: self = .tlv8
        default: self = .unknown
        }
    }

    func characteristicValue(fromString string: String) -> Any? {
        switch self {
        case .unknown:
            return nil
        case .bool:
            if let bool = Bool(string) {
                return bool
            } else if string == "1" {
                return true
            } else {
                return false
            }
        case .int:
            return Int(string)
        case .float:
            return Float(string)
        case .string:
            return string
        case .array:
            return [string]
        case .dictionary:
            assertionFailure("dictionary is not support")
            return NSDictionary()
        case .uint8:
            return UInt8(string)
        case .uint16:
            return UInt16(string)
        case .uint32:
            return UInt32(string)
        case .uint64:
            return UInt64(string)
        case .data:
            return string.data(using: .utf8)
        case .tlv8:
            assertionFailure("tlv8 is not support")
            return nil
        }
    }
}

extension CharacteristicMetadataFormat: CustomStringConvertible {
    var description: String {
        switch self {
        case .unknown: return "UNKNOWN"
        case .bool: return HMCharacteristicMetadataFormatBool
        case .int: return HMCharacteristicMetadataFormatInt
        case .float: return HMCharacteristicMetadataFormatFloat
        case .string: return HMCharacteristicMetadataFormatString
        case .array: return HMCharacteristicMetadataFormatArray
        case .dictionary: return HMCharacteristicMetadataFormatDictionary
        case .uint8: return HMCharacteristicMetadataFormatUInt8
        case .uint16: return HMCharacteristicMetadataFormatUInt16
        case .uint32: return HMCharacteristicMetadataFormatUInt32
        case .uint64: return HMCharacteristicMetadataFormatUInt64
        case .data: return HMCharacteristicMetadataFormatData
        case .tlv8: return HMCharacteristicMetadataFormatTLV8
        }
    }
}

// MARK: - Utils

extension HMCharacteristic {
    var metadataFormat: CharacteristicMetadataFormat {
        return CharacteristicMetadataFormat(metadata?.format ?? "")
    }
}

extension String {
    func characteristicValue(for formatString: String?) -> Any? {
        guard let formatString = formatString else {
            return nil
        }
        let format = CharacteristicMetadataFormat(formatString)
        return format.characteristicValue(fromString: self)
    }
}
