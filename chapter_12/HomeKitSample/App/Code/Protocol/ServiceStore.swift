//
//  ServiceStore.swift
//
//  Created by ToKoRo on 2017-09-02.
//

import HomeKit

protocol ServiceStore {
    var serviceStoreKind: ServiceStoreKind { get }
    var services: [HMService] { get }
    var isServiceAddable: Bool { get }
    var isServiceRemovable: Bool { get }
}

enum ServiceStoreKind {
    case accessory(HMAccessory)
    case serviceGroup(HMServiceGroup)
    case home(HMHome)
}

// MARK: - HMAccessory

extension HMAccessory: ServiceStore {
    var serviceStoreKind: ServiceStoreKind { return .accessory(self) }
    var isServiceAddable: Bool { return false }
    var isServiceRemovable: Bool { return false }
}

// MARK: - HMServiceGroup

extension HMServiceGroup: ServiceStore {
    var serviceStoreKind: ServiceStoreKind { return .serviceGroup(self) }
    var isServiceAddable: Bool { return true }
    var isServiceRemovable: Bool { return true }
}

// MARK: - HMHome

extension HMHome: ServiceStore {
    var serviceStoreKind: ServiceStoreKind { return .home(self) }
    var isServiceAddable: Bool { return false }
    var isServiceRemovable: Bool { return false }
    var services: [HMService] { return allServices }
}
