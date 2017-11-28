//
//  SafeCollection.swift
//
//  Created by ToKoRo on 2017-08-18.
//

/**
 * ref: https://medium.com/@jegnux/safe-collection-subsripting-in-swift-3771f16f883
 */

import Foundation

public struct SafeCollection<Base: Collection> {
    private var _base: Base

    public init(_ base: Base) {
        _base = base
    }

    private func distance(from startIndex: Base.Index) -> Base.IndexDistance {
        return _base.distance(from: startIndex, to: _base.endIndex)
    }

    private func distance(to endIndex: Base.Index) -> Base.IndexDistance {
        return _base.distance(from: _base.startIndex, to: endIndex)
    }

    public subscript(index: Base.Index) -> Base.Iterator.Element? {
        if distance(to: index) >= 0 && distance(from: index) > 0 {
            return _base[index]
        }
        return nil
    }

    public subscript(bounds: Range<Base.Index>) -> Base.SubSequence? {
        if distance(to: bounds.lowerBound) >= 0 && distance(from: bounds.upperBound) >= 0 {
            return _base[bounds]
        }
        return nil
    }

    public subscript(bounds: ClosedRange<Base.Index>) -> Base.SubSequence? {
        if distance(to: bounds.lowerBound) >= 0 && distance(from: bounds.upperBound) > 0 {
            return _base[bounds]
        }
        return nil
    }
}

public extension Collection {
    var safe: SafeCollection<Self> {
        return SafeCollection(self)
    }
}
