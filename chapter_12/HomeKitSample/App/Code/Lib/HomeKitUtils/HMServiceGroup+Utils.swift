//
//  HMServiceGroup+Utils.swift
//
//  Created by ToKoRo on 2017-09-02.
//

import HomeKit

extension HMServiceGroup {
    var home: HMHome? {
        let homeManager = HMHomeManager.shared
        for home in homeManager.homes where home.serviceGroups.contains(self) {
            return home
        }
        return nil
    }
}
