//
//  ActionSetStore.swift
//
//  Created by ToKoRo on 2017-09-03.
//

import HomeKit

protocol ActionSetStore {
    var actionSetStoreKind: ActionSetStoreKind { get }
    var actionSets: [HMActionSet] { get }
}

enum ActionSetStoreKind {
    case home(HMHome)
    case trigger(HMTrigger)
}

// MARK: - HMHome

extension HMHome: ActionSetStore {
    var actionSetStoreKind: ActionSetStoreKind { return .home(self) }
}

// MARK: - HMTrigger

extension HMTrigger: ActionSetStore {
    var actionSetStoreKind: ActionSetStoreKind { return .trigger(self) }
}
