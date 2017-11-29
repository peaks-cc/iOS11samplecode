//
//  ViewController.swift
//  hogee
//
//  Created by sonson on 2017/07/26.
//  Copyright © 2017年 sonson. All rights reserved.
//

import UIKit
import CoreML

extension MLMultiArray {
    var maxIndex: Int {
        var max: Double = 0
        var index = -1
        for j in 0..<self.count {
            let x = self[[NSNumber(value: j)]]
            if max < x.doubleValue {
                max = x.doubleValue
                index = j
            }
        }
        return index
    }
    
    func imageAsString(width: Int, height: Int) -> String {
        var buffer = ""
        for x in 0..<width {
            for y in 0..<height {
                let xx = NSNumber(value: x)
                let yy = NSNumber(value: y)
                buffer = buffer.appendingFormat("%02x", Int(self[[0, xx, yy]].doubleValue*255))
            }
            buffer = buffer.appendingFormat("\n")
        }
        return buffer
    }
}

class ViewController: UIViewController {
    let model = KerasMNIST()
    
    static let width: Int = 28
    static let height: Int = 28
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var textLabel: UILabel!
    
    var pixelBuffer32bit: [CUnsignedChar] = [CUnsignedChar](repeating: 0, count: ViewController.width * ViewController.height * 4)
    
    private func creatCGImage(pointer: UnsafeMutableRawPointer?, width: Int, height: Int, bytesPerRow: Int) -> CGImage? {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
            .union(CGBitmapInfo.byteOrder32Little)
        guard let context = CGContext(data: pointer, width: (width), height: (height), bitsPerComponent: 8, bytesPerRow: (bytesPerRow), space: colorSpace, bitmapInfo: bitmapInfo.rawValue) else { return nil }
        return context.makeImage()
    }
    
    func updateImage() {
        guard let cgImage = creatCGImage(pointer: &pixelBuffer32bit, width: ViewController.width, height: ViewController.height, bytesPerRow: 4 * ViewController.width) else { return }
        imageView.image = UIImage(cgImage: cgImage)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for x in 0..<ViewController.width {
            for y in 0..<ViewController.height {
                pixelBuffer32bit[4 * y + 4 * x * ViewController.width + 0] = 255
                pixelBuffer32bit[4 * y + 4 * x * ViewController.width + 1] = 0
                pixelBuffer32bit[4 * y + 4 * x * ViewController.width + 2] = 0
                pixelBuffer32bit[4 * y + 4 * x * ViewController.width + 3] = 0
            }
        }
        updateImage()
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self.view)
        if imageView.frame.contains(location) {
            let locationInImageView = imageView.convert(location, from: self.view)
            
            let x = locationInImageView.x / imageView.frame.size.width
            let y = locationInImageView.y / imageView.frame.size.height
            
            let ix = Int(x * CGFloat(ViewController.width))
            let iy = Int(y * CGFloat(ViewController.height))
            
            let w = 1
            let l = ix - w > 0 ? ix - w : 0
            let r = ix + w < ViewController.width ? ix + w : ViewController.width - 1
            let t = iy - w > 0 ? iy - w : 0
            let b = iy + w < ViewController.height ? iy + w : ViewController.height - 1
            
            for xx in l..<r {
                for yy in t..<b {
                    pixelBuffer32bit[4 * xx + 4 * yy * ViewController.width + 0] = 255
                    pixelBuffer32bit[4 * xx + 4 * yy * ViewController.width + 1] = 255
                    pixelBuffer32bit[4 * xx + 4 * yy * ViewController.width + 2] = 255
                    pixelBuffer32bit[4 * xx + 4 * yy * ViewController.width + 3] = 255
                }
            }
            updateImage()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        do {
            let input = try MLMultiArray(shape: [1, NSNumber(value: ViewController.width), NSNumber(value: ViewController.height)], dataType: .double)
            for x in 0..<ViewController.width {
                for y in 0..<ViewController.height {
                    let xx = NSNumber(value: x)
                    let yy = NSNumber(value: y)
                    input[[0, xx, yy]] = NSNumber(value: Double(pixelBuffer32bit[4 * y + 4 * x * ViewController.width + 1]) / 255 )
                }
            }
            print(input.imageAsString(width: ViewController.width, height: ViewController.height))
            let result = try model.prediction(image: input)
            let index = result.digit.maxIndex
            textLabel.text = "\(index)"
        } catch {
            print(error)
        }
    }
    func testMNIST() {
        do {
            let count = 1000
            var trueCount = 0
            for i in 0..<count {
                let label = try loadLabel(index: i)
                let image = try loadImage(index: i)
                let result = try model.prediction(image: image)
                if label == result.digit.maxIndex {
                    trueCount += 1
                }
            }
            print("\(Double(trueCount) / Double(count) * 100)")
        } catch {
            print(error)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //testMNIST()
        
        for x in 0..<ViewController.width {
            for y in 0..<ViewController.height {
                pixelBuffer32bit[4 * y + 4 * x * ViewController.width + 0] = 255
                pixelBuffer32bit[4 * y + 4 * x * ViewController.width + 1] = 0
                pixelBuffer32bit[4 * y + 4 * x * ViewController.width + 2] = 0
                pixelBuffer32bit[4 * y + 4 * x * ViewController.width + 3] = 0
            }
        }
        updateImage()
    }
}

