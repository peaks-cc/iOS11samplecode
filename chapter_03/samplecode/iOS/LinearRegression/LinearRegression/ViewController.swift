//
//  ViewController.swift
//  CoreMLExamples
//
//  Created by sonson on 2017/06/29.
//  Copyright © 2017年 sonson. All rights reserved.
//

import UIKit
import Charts
import CoreML

class ViewController: UIViewController {
    @IBOutlet var scatterChartView: ScatterChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var entries: [BarChartDataEntry] = []
        
        let model = linear_model()
        print(model)
        for i in -10..<10 {
            do {
                let x = Double(i)
                let results = try model.prediction(x1: x, x2: x*x, x3: x*x*x, x4: x*x*x*x)
                print(results)
                results.prediction
                
                entries.append(BarChartDataEntry(x: x, y: results.prediction))
                
                print(results.prediction)
            } catch {
                print(error)
            }
        }
        
        var exampleSet = ScatterChartDataSet(values: entries, label: "entries")
        
        let data = ScatterChartData(dataSet: exampleSet)
        scatterChartView.data = data
        
        //        scatterChartView.data = exampleSet
        //
        //        ScatterChartDataSet(values: <#T##[ChartDataEntry]?#>, label: <#T##String?#>)
        //        var data = [ScatterChartData]()
        //
        //        for x in 0..<20 {
        //            let dataEntry = BarChartDataEntry(x: Double(x), y: cos(Double(x)))
        //            data.append(dataEntry)
        //        }
        //        // グラフをセット
        //        let DataSet = BarChartDataSet(values: data, label: "test_charts")
        //        scatterChartView.data = BarChartData(dataSet: DataSet)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

