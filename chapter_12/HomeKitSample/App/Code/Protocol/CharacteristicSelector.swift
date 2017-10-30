//
//  CharacteristicSelector.swift
//
//  Created by ToKoRo on 2017-09-02.
//

import HomeKit

protocol CharacteristicSelector {
    func selectCharacteristic(_ characteristic: HMCharacteristic)
}
