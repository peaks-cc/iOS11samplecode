//
//  HMActionSet+Utils.swift
//
//  Created by ToKoRo on 2017-09-02.
//

import HomeKit

extension HMActionSet {
    var home: HMHome? {
        let homeManager = HMHomeManager.shared
        for home in homeManager.homes where home.actionSets.contains(self) {
            return home
        }
        return nil
    }
}
