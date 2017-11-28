//
//  HomeActionHandler.swift
//
//  Created by ToKoRo on 2017-08-20.
//

import HomeKit

protocol HomeActionHandler {
    func handleRemove(_ home: HMHome)
    func handleMakePrimary(_ home: HMHome)
}
