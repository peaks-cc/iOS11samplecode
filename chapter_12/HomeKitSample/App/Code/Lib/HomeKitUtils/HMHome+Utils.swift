//
//  HMHome+Utils.swift
//
//  Created by ToKoRo on 2017-09-02.
//

import HomeKit

extension HMHome {
    var allServices: [HMService] {
        return accessories.flatMap { $0.services }
    }

    var allCharacteristics: [HMCharacteristic] {
        return allServices.flatMap { $0.characteristics }
    }

    var allReadableCharacteristics: [HMCharacteristic] {
        return allCharacteristics.filter { $0.isReadable }
    }

    var allWritableCharacteristics: [HMCharacteristic] {
        return allCharacteristics.filter { $0.isWritable }
    }
}
