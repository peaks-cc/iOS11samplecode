//
//  ViewController.swift
//  AirPlay2Test
//
//  Created by 7gano on 2017/07/25.
//  Copyright © 2017 ROLLCAKE. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController {
    
    let sampleBufferAudioPlayer = SampleBufferAudioPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(AVAudioSessionCategoryPlayback,
                                         mode: AVAudioSessionModeDefault,
                                         routeSharingPolicy: .longForm)
            
            try audioSession.setActive(true)
        } catch {
            fatalError("\(error)")
        }
        
        let routePickerView = AVRoutePickerView()
        self.view.addSubview(routePickerView)
        routePickerView.translatesAutoresizingMaskIntoConstraints = false
        routePickerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        routePickerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        sampleBufferAudioPlayer.play()
    }
}

