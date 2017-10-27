//
//  AirPlay.swift
//  AirPlay2Test
//
//  Created by 7gano on 2017/07/28.
//  Copyright © 2017 ROLLCAKE. All rights reserved.
//

import UIKit
import AVFoundation

func createFloat32CMAudioFormatDescription() -> CMAudioFormatDescription {
    var asbd = AudioStreamBasicDescription()
    asbd.mFormatID = kAudioFormatLinearPCM
    asbd.mFormatFlags = kAudioFormatFlagsNativeFloatPacked
    asbd.mSampleRate = 44100
    asbd.mBitsPerChannel = 32
    asbd.mFramesPerPacket = 1
    asbd.mChannelsPerFrame = 2
    asbd.mBytesPerFrame = asbd.mBitsPerChannel / 8 * asbd.mChannelsPerFrame
    asbd.mBytesPerPacket = asbd.mBytesPerFrame * asbd.mFramesPerPacket
    
    var formatDescription:CMAudioFormatDescription?
    CMAudioFormatDescriptionCreate(nil,
                                   &asbd,
                                   0,
                                   nil,
                                   0,
                                   nil,
                                   nil,
                                   &formatDescription)
    return formatDescription!
}

let processingFrameLength:UInt32 = 4096

class SampleBufferAudioPlayer: NSObject {
    let engine = AVAudioEngine()
    let player = AVAudioPlayerNode()
    let reverb = AVAudioUnitReverb()
    
    let audioRenderer = AVSampleBufferAudioRenderer()
    let renderSynchronizer = AVSampleBufferRenderSynchronizer()
    let serializationQueue = DispatchQueue(label: "serialization queue")
    
    var sourceFile: AVAudioFile!
    var format: AVAudioFormat!
    
    let sampleBufferformatDescription = createFloat32CMAudioFormatDescription()
    
    var currentFrame:AVAudioFrameCount = 0
    let sourceFileURL = Bundle.main.url(forResource: "mixLoop", withExtension: "caf")!
    
    var processingAudioBuffer:AudioBuffer = {
        var audioBuffer = AudioBuffer()
        audioBuffer.mDataByteSize = UInt32(Int(processingFrameLength * 2) * MemoryLayout<Float32>.stride)
        audioBuffer.mData = UnsafeMutableRawPointer.allocate(bytes: Int(audioBuffer.mDataByteSize), alignedTo: 1)
        audioBuffer.mNumberChannels = 2
        return audioBuffer
    } ()
    
    func convertToInterleaved(audioBufferList:UnsafeMutablePointer<AudioBufferList>) -> AudioBufferList{
        let mutableAudioBufferListPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)
        let audioBufferL =  mutableAudioBufferListPointer[0]
        let audioBufferR =  mutableAudioBufferListPointer[1]
        
        let p:UnsafeMutablePointer<Float32> = processingAudioBuffer.mData!.bindMemory(to: Float32.self, capacity: Int(processingFrameLength))
        let pL: UnsafeMutablePointer<Float32> = audioBufferL.mData!.bindMemory(to: Float32.self, capacity: Int(processingFrameLength))
        let pR: UnsafeMutablePointer<Float32> = audioBufferR.mData!.bindMemory(to: Float32.self, capacity: Int(processingFrameLength))
        
        memset(processingAudioBuffer.mData, 0, Int(processingAudioBuffer.mDataByteSize))
        
        var index = 0;
        for i in 0...processingFrameLength - 1 {
            p[index] = pL[Int(i)]
            index += 1
            p[index] = pR[Int(i)]
            index += 1
        }
        let audioBufferList = AudioBufferList(mNumberBuffers: 1, mBuffers: processingAudioBuffer)
        return audioBufferList
    }
    
    override init(){
        renderSynchronizer.addRenderer(audioRenderer)
        sourceFile = try! AVAudioFile(forReading: sourceFileURL,
                                      commonFormat: .pcmFormatFloat32,
                                      interleaved: false)
        format = sourceFile.processingFormat
        
        //以下追加
        engine.attach(player)
        engine.attach(reverb)
        
        reverb.loadFactoryPreset(.mediumHall)
        reverb.wetDryMix = 50
        
        try! engine.enableManualRenderingMode(.offline, format: format, maximumFrameCount: processingFrameLength)
        
        engine.connect(player, to: reverb, format: format)
        engine.connect(reverb, to: engine.mainMixerNode, format: format)
        
        try! engine.start()
        player.play()
    }
    
    deinit {
        player.stop()
        engine.stop()
    }
    
    func nextSampleBuffer() -> CMSampleBuffer?{
        let sourceBuffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity:processingFrameLength)!
        do{
            try sourceFile.read(into: sourceBuffer, frameCount: processingFrameLength)
        }catch {
            return nil
        }
        //bufferをschadule
        player.scheduleBuffer(sourceBuffer, completionHandler: nil)
        let resultBuffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity:processingFrameLength)!
        
        //レンダリングを実行
        //resultBufferはsourceBufferにリバーブがかかったバッファになる
        try! engine.renderOffline(processingFrameLength, to: resultBuffer)
        
        //以下、resultBufferをCMSampleBufferにセットして返す
        
        var timing = CMSampleTimingInfo(duration: CMTimeMake(1, Int32(format.sampleRate)),
                                        presentationTimeStamp: CMTimeMake(Int64(currentFrame), Int32(format.sampleRate)),
                                        decodeTimeStamp: kCMTimeInvalid)
        
        print(CMTimeGetSeconds(CMTimeMake(Int64(currentFrame), Int32(format.sampleRate))))
        
        currentFrame += resultBuffer.frameLength
        
        var audioBufferList = convertToInterleaved(audioBufferList: resultBuffer.mutableAudioBufferList)
        
        var sampleBuffer: CMSampleBuffer? = nil
        CMSampleBufferCreate(nil,nil,false,nil,nil,
                             sampleBufferformatDescription,
                             CMItemCount(resultBuffer.frameLength),
                             1,
                             &timing,
                             0,
                             nil,
                             &sampleBuffer)
        
        CMSampleBufferSetDataBufferFromAudioBufferList(sampleBuffer!,
                                                       kCFAllocatorDefault,
                                                       kCFAllocatorDefault,
                                                       0,
                                                       &audioBufferList)
        return sampleBuffer
    }
    
    func startEnqueueing() {
        self.audioRenderer.requestMediaDataWhenReady(on: serializationQueue) { [weak self] in
            guard let strongSelf = self else { return }
            let audioRenderer = strongSelf.audioRenderer
            
            while audioRenderer.isReadyForMoreMediaData {
                let sampleBuffer = strongSelf.nextSampleBuffer()
                
                if let sampleBuffer = sampleBuffer {
                    audioRenderer.enqueue(sampleBuffer)
                } else {
                    audioRenderer.stopRequestingMediaData()
                    print(audioRenderer.status.rawValue)
                    break
                }
            }
        }
    }
    
    func play(){
        serializationQueue.async {
            self.audioRenderer.flush()
            self.currentFrame = 0
            self.sourceFile.framePosition = 0
            
            self.startEnqueueing()
            
            self.renderSynchronizer.rate = 1.0
            self.audioRenderer.volume = 1.0
        }
    }
}
