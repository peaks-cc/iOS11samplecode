//
//  HMAccessory+Utils.swift
//
//  Created by ToKoRo on 2017-09-02.
//

import HomeKit

extension HMAccessory {
    var home: HMHome? {
        let homeManager = HMHomeManager.shared
        for home in homeManager.homes where home.accessories.contains(self) {
            return home
        }
        return nil
    }

    var allCharacteristics: [HMCharacteristic] {
        return services.flatMap { $0.characteristics }
    }

    var allReadableCharacteristics: [HMCharacteristic] {
        return allCharacteristics.filter { $0.isReadable }
    }

    var allWritableCharacteristics: [HMCharacteristic] {
        return allCharacteristics.filter { $0.isWritable }
    }
}
