//
//  AccessoryActionHandler.swift
//
//  Created by ToKoRo on 2017-09-02.
//

import HomeKit

protocol AccessoryActionHandler {
    func handleRemove(_ accessory: HMAccessory)
}
