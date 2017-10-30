//
//  SandBoxViewController.swift
//
//  Created by ToKoRo on 2017-09-03.
//

import UIKit
import HomeKit

class SandBoxViewController: UIViewController {
    @IBOutlet weak var textView: UITextView?

    lazy var home: HMHome! = HMHomeManager.shared.primaryHome

    @IBAction func executeButtonDidTap(sender: AnyObject) {
        executeSandBox()
    }

    private func executeSandBox() {
        // let home = self.home!

        // sample
    }

    private func actionSet() -> HMActionSet {
        return home.actionSets.filter { $0.name == "ライトつける" }.first!
    }
}

/* 特定キャラクタの抽出
let service = home.servicesWithTypes([HMServiceTypeContactSensor])?.first
let candidates = service?.characteristics.filter { $0.characteristicType == HMCharacteristicTypeContactState }

guard let characteristic = candidates?.first else {
    return
}

let action = HMCharacteristicWriteAction(characteristic: brightness, targetValue: NSNumber(value: 100))
*/

/* イベントトリガの追加
let offset = DateComponents(minute: -30)
let event = HMSignificantTimeEvent(significantEvent: .sunset, offset: offset)
let trigger = HMEventTrigger(name: "日の入り30分前", events: [event], predicate: nil)

home.addTrigger(trigger) { [weak self] error in
    if error == nil {
        trigger.addActionSet(self!.actionSet()) { error in
            if error == nil {
                trigger.enable(true) { error in
                    if error == nil {
                        print("success")
                    }
                }
            }
        }
    }
}
*/
