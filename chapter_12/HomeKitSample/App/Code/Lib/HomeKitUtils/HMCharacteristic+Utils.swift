//
//  HMCharacteristic+Utils.swift
//
//  Created by ToKoRo on 2017-09-02.
//

import HomeKit

extension HMCharacteristic {
    var isReadable: Bool {
        return properties.contains(HMCharacteristicPropertyReadable)
    }

    var isWritable: Bool {
        return properties.contains(HMCharacteristicPropertyWritable)
    }

    var isHidden: Bool {
        return properties.contains(HMCharacteristicPropertyHidden)
    }

    var supportsEvent: Bool {
        return properties.contains(Notification.Name.HMCharacteristicPropertySupportsEvent.rawValue)
    }
}
