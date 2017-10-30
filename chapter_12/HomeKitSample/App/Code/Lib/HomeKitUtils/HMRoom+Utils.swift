//
//  HMRoom+Utils.swift
//
//  Created by ToKoRo on 2017-08-27.
//

import HomeKit

extension HMRoom {
    var home: HMHome? {
        let homeManager = HMHomeManager.shared
        for home in homeManager.homes where home.rooms.contains(self) {
            return home
        }
        return nil
    }

    var zone: HMZone? {
        guard let home = home else {
            return nil
        }
        for zone in home.zones where zone.rooms.contains(self) {
            return zone
        }
        return nil
    }
}
