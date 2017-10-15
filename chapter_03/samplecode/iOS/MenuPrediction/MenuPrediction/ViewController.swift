//
//  ViewController.swift
//  MenuPrediction
//
//  Created by sonson on 2017/08/04.
//  Copyright © 2017年 sonson. All rights reserved.
//

import UIKit
import CoreML

class ViewController: UIViewController {
    let model = MenuPrediction()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        do {
            let x1 = Double(18);
            let x2 = x1 * x1;
            let x3 = x1 * x1 * x1;
            let result = try model.prediction(x1: x1, x2: x2, x3: x3)
            print(result)
            print(result.label)
            print(result.classProbability)
        } catch {
            print(error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

