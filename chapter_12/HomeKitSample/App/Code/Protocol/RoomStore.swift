//
//  RoomStore.swift
//
//  Created by ToKoRo on 2017-08-27.
//

import HomeKit

protocol RoomStore {
    var roomStoreKind: RoomStoreKind { get }
    var rooms: [HMRoom] { get }
}

enum RoomStoreKind {
    case home(HMHome)
    case zone(HMZone)
}

// MARK: - HMHome

extension HMHome: RoomStore {
    var roomStoreKind: RoomStoreKind { return .home(self) }
}

// MARK: - HMZone

extension HMZone: RoomStore {
    var roomStoreKind: RoomStoreKind { return .zone(self) }
}
