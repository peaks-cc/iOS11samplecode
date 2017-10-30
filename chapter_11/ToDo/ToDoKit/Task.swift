//
//  Task.swift
//  ToDoKit
//
//  Created by Kishikawa Katsumi on 2017/09/03.
//  Copyright © 2017 Kishikawa Katsumi. All rights reserved.
//

import Foundation

public struct Task: Codable {
    public let title: String
    public var isCompleted: Bool

    public init(title: String, isCompleted: Bool = false) {
        self.title = title
        self.isCompleted = isCompleted
    }
}
