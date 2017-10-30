//
//  HMEventTriggerActivationState+Description.swift
//
//  Created by ToKoRo on 2017-09-04.
//

import HomeKit

extension HMEventTriggerActivationState: CustomStringConvertible {
    public var description: String {
        switch self {
        case .disabled: return "disabled"
        case .disabledNoCompatibleHomeHub: return "disabledNoCompatibleHomeHub"
        case .disabledNoHomeHub: return "disabledNoHomeHub"
        case .disabledNoLocationServicesAuthorization: return "disabledNoLocationServicesAuthorization"
        case .enabled: return "enabled"
        }
    }
}
