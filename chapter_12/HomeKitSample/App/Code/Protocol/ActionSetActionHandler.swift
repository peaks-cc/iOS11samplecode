//
//  ActionSetActionHandler.swift
//
//  Created by ToKoRo on 2017-09-03.
//

import HomeKit

protocol ActionSetActionHandler {
    func handleExecute(_ actionSet: HMActionSet)
    func handleRemove(_ actionSet: HMActionSet)
}
