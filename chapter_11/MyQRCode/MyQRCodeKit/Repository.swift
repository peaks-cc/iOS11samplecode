//
//  Repository.swift
//  MyQRCodeKit
//
//  Created by Kishikawa Katsumi on 2017/09/04.
//  Copyright © 2017 Kishikawa Katsumi. All rights reserved.
//

import Foundation

public final class Repository {
    public static let shared = Repository()

    private var userDefaults: UserDefaults {
        get {
            return UserDefaults(suiteName: "group.com.kishikawakatsumi.myqrcode")!
        }
    }
    private let key = "me"

    public func save(me: Me) {
        userDefaults.set(try! PropertyListEncoder().encode(me), forKey: key)
    }

    public func load() -> Me? {
        if let data = userDefaults.object(forKey: key) as? Data {
            return try? PropertyListDecoder().decode(Me.self, from: data)
        }
        return nil
    }
}
