//
//  MNISTLoader.swift
//  hogee
//
//  Created by sonson on 2017/07/26.
//  Copyright © 2017年 sonson. All rights reserved.
//

import Foundation
import CoreML

func loadImage(index: Int) throws -> MLMultiArray {
    do {
        let path = Bundle.main.path(forResource: "t10k-images-idx3-ubyte", ofType: "")
        guard let handle: UnsafeMutablePointer<FILE> = fopen(path, "r")
            else { throw NSError(domain: "", code: 1, userInfo: nil) }
        let _: UInt32 = try read(from: handle).bigEndian
        let count: UInt32 = try read(from: handle).bigEndian
        let width: Int = Int(try read(from: handle).bigEndian as UInt32)
        let height: Int = Int(try read(from: handle).bigEndian as UInt32)
        
        guard index < count else { throw NSError(domain: "", code: 1, userInfo: nil) }
        
        let input = try MLMultiArray(shape: [1, NSNumber(value: width), NSNumber(value: height)], dataType: .double)
        
        fseek(handle, index * width * height, SEEK_CUR)
        
        var buffer = ""
        for x in 0..<width {
            for y in 0..<height {
                let label: UInt8 = try read(from: handle).bigEndian
                let value = Double(label) / 255.0
                buffer = buffer.appendingFormat("%02x", label)
                let xx = NSNumber(value: x)
                let yy = NSNumber(value: y)
                input[[0, xx, yy]] = NSNumber(value: value)
            }
            buffer = buffer.appendingFormat("\n")
        }
        print(buffer)
        fclose(handle)
        return input
    } catch {
        throw error
    }
}

func loadLabel(index: Int) throws -> UInt8  {
    do {
        let path = Bundle.main.path(forResource: "t10k-labels-idx1-ubyte", ofType: "")
        guard let handle: UnsafeMutablePointer<FILE> = fopen(path, "r")
            else { throw NSError(domain: "", code: 1, userInfo: nil) }
        let _: UInt32 = try read(from: handle).bigEndian
        let count: UInt32 = try read(from: handle).bigEndian
        
        guard index < count else { throw NSError(domain: "", code: 1, userInfo: nil) }
        
        fseek(handle, index, SEEK_CUR)
        
        let label: UInt8 = try read(from: handle).bigEndian
        fclose(handle)
        return label
    } catch {
        throw error
    }
}

func read(from handle: UnsafeMutablePointer<FILE>) throws -> UInt8 {
    var buffer: [UInt8] = [UInt8](repeating: 0, count: 1)
    guard fread(&buffer, Int(MemoryLayout<UInt8>.size), 1, handle) == 1 else {
        throw NSError(domain: "", code: 0, userInfo: nil)
    }
    return buffer[0]
}

func read(from handle: UnsafeMutablePointer<FILE>) throws -> UInt32 {
    var buffer: [UInt32] = [UInt32](repeating: 0, count: 1)
    guard fread(&buffer, Int(MemoryLayout<UInt32>.size), 1, handle) == 1 else {
        throw NSError(domain: "", code: 0, userInfo: nil)
    }
    return buffer[0]
}
