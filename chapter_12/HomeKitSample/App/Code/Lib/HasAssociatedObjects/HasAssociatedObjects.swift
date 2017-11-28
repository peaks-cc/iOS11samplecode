//
//  HasAssociatedObjects.swift
//
//  Created by ToKoRo on 2017-08-18.
//

import Foundation

public class AssociatedObjects: NSObject {
    public var dictionary: [String: Any] = [:]

    public var value: Any? {
        get {
            return self.dictionary[""]
        }
        set {
            self.dictionary[""] = newValue ?? ""
        }
    }

    public subscript(key: String) -> Any? {
        get {
            return self.dictionary[key]
        }
        set {
            self.dictionary[key] = newValue
        }
    }

    public func removeAll() {
        self.dictionary.removeAll()
    }

}

public protocol HasAssociatedObjects {
    var associatedObjects: AssociatedObjects { get }
}

private var associatedObjectsKey: UInt8 = 0

public extension HasAssociatedObjects where Self: AnyObject {
    var associatedObjects: AssociatedObjects {
        guard let associatedObjects = objc_getAssociatedObject(self, &associatedObjectsKey) as? AssociatedObjects else {
            let associatedObjects = AssociatedObjects()
            objc_setAssociatedObject(self, &associatedObjectsKey, associatedObjects, .OBJC_ASSOCIATION_RETAIN)
            return associatedObjects
        }
        return associatedObjects
    }
}
