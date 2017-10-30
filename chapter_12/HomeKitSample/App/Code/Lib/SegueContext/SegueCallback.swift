//
//  SegueCallback.swift
//
//  Created by ToKoRo on 2017-09-03.
//

import UIKit

// MARK: - HasCallback

protocol HasCallback {
    associatedtype CallbackType
    typealias Callback = (CallbackType) -> Void

    var callback: Callback? { get }
}

// MARK: - UIResponder

extension UIResponder {
    fileprivate var callbackKey: String { return #function }
}

extension HasCallback where Self: UIResponder {
    var callback: Callback? {
        return associatedObjects[callbackKey] as? Callback
    }
}

extension UIResponder {
    func bindCallback<V>(type: V.Type, to responder: UIResponder?, callback newCallback: @escaping (V) -> Void) {
        switch responder {
        case let navi as UINavigationController:
            for viewController in navi.viewControllers {
                bindCallback(type: type, to: viewController, callback: newCallback)
            }
        case let tab as UITabBarController:
            for viewController in tab.viewControllers ?? [] {
                bindCallback(type: type, to: viewController, callback: newCallback)
            }
        default:
            responder?.associatedObjects[callbackKey] = newCallback
        }
    }
}
