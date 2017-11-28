//
//  HMZone+Utils.swift
//
//  Created by ToKoRo on 2017-08-27.
//

import HomeKit

extension HMZone {
    var home: HMHome? {
        let homeManager = HMHomeManager.shared
        for home in homeManager.homes where home.zones.contains(self) {
            return home
        }
        return nil
    }
}
