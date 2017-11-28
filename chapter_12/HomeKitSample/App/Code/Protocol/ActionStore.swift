//
//  ActionStore.swift
//
//  Created by ToKoRo on 2017-09-02.
//

import HomeKit

protocol ActionStore {
    var actionStoreKind: ActionStoreKind { get }
    var actions: Set<HMAction> { get }
}

enum ActionStoreKind {
    case actionSet(HMActionSet)
}

// MARK: - HMActionSet

extension HMActionSet: ActionStore {
    var actionStoreKind: ActionStoreKind { return .actionSet(self) }
}
