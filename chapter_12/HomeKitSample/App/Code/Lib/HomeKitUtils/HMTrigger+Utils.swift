//
//  HMTrigger+Utils.swift
//
//  Created by ToKoRo on 2017-09-03.
//

import HomeKit

extension HMTrigger {
    var home: HMHome? {
        let homeManager = HMHomeManager.shared
        for home in homeManager.homes where home.triggers.contains(self) {
            return home
        }
        return nil
    }
}
