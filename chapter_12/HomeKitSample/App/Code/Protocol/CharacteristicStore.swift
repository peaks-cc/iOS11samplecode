//
//  CharacteristicStore.swift
//
//  Created by ToKoRo on 2017-09-02.
//

import HomeKit

protocol CharacteristicStore {
    var characteristicStoreKind: CharacteristicStoreKind { get }
    var characteristics: [HMCharacteristic] { get }
}

enum CharacteristicStoreKind {
    case service(HMService)
    case accessory(HMAccessory)
    case home(HMHome)
}

// MARK: - HMService

extension HMService: CharacteristicStore {
    var characteristicStoreKind: CharacteristicStoreKind { return .service(self) }
}

// MARK: - HMAccessory

extension HMAccessory: CharacteristicStore {
    var characteristicStoreKind: CharacteristicStoreKind { return .accessory(self) }
    var characteristics: [HMCharacteristic] { return allWritableCharacteristics }
}

// MARK: - HMHome

extension HMHome: CharacteristicStore {
    var characteristicStoreKind: CharacteristicStoreKind { return .home(self) }
    var characteristics: [HMCharacteristic] { return allWritableCharacteristics }
}
