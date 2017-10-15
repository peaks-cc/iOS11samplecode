//
//  ViewController.swift
//  UpdateModel
//
//  Created by sonson on 2017/09/18.
//  Copyright © 2017年 sonson. All rights reserved.
//

import UIKit
import CoreML

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        do {
            guard let url = Bundle.main.url(forResource: "KerasMNIST", withExtension: "bin") else { return }
            let compiledURL = try MLModel.compileModel(at: url)
            print(compiledURL)
            
            let model = try MLModel(contentsOf: compiledURL)
            print(model)
        } catch {
            print(error)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

