//
//  ServiceGroupActionHandler.swift
//
//  Created by ToKoRo on 2017-09-02.
//

import HomeKit

protocol ServiceGroupActionHandler {
    func handleRemove(_ serviceGroup: HMServiceGroup)
}
