//
//  SegueContext.swift
//
//  Created by ToKoRo on 2017-08-18.
//

import UIKit

// MARK: - ContextHandler

protocol ContextHandler {
    associatedtype ContextType

    var context: ContextType? { get }
    var contextSender: UIResponder? { get }
}

// MARK: - UIResponder

extension UIResponder: HasAssociatedObjects {
    fileprivate var contextKey: String { return #function }
    fileprivate var contextSenderKey: String { return #function }
}

extension ContextHandler where Self: UIResponder {
    var context: ContextType? {
        return associatedObjects[contextKey] as? ContextType
    }

    var contextSender: UIResponder? {
        return associatedObjects[contextSenderKey] as? UIResponder
    }
}

extension UIResponder {
    func sendContext(_ context: Any?, to handler: UIResponder?) {
        switch handler {
        case let navi as UINavigationController:
            for viewController in navi.viewControllers {
                sendContext(context, to: viewController)
            }
        case let tab as UITabBarController:
            for viewController in tab.viewControllers ?? [] {
                sendContext(context, to: viewController)
            }
        default:
            handler?.associatedObjects[contextSenderKey] = self
            handler?.associatedObjects[contextKey] = context
        }
    }
}
