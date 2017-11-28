//
//  ServiceActionHandler.swift
//
//  Created by ToKoRo on 2017-09-02.
//

import HomeKit

protocol ServiceActionHandler {
    func handleRemove(_ service: HMService)
}
