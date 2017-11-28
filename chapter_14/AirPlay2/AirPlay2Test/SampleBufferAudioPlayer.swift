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
    //audioRendererとrenderSynchronizerをインスタンス変数として用意しておく
    let audioRenderer = AVSampleBufferAudioRenderer()
    let renderSynchronizer = AVSampleBufferRenderSynchronizer()
    
    //オーディオ・レンダリング処理はサブスレッド内で行う必要があるため、専用のserializationQueueを用意しておく
    let serializationQueue = DispatchQueue(label: "serialization queue")
    
    //AVAudioFileを使ってバッファを読み込む
    var sourceFile: AVAudioFile!
    //再生するオーディオのフォーマット情報。たとえばCDクオリティの場合16bit/44.1kHzのような情報を持つ。
    var readingFormat: AVAudioFormat!
    
    //最終的にAudioRendererに渡すCMSampleBufferのオーディオフォーマット。
    let sampleBufferformatDescription = createFloat32CMAudioFormatDescription()
    
    //現在オーディオファイルのどの位置を読み込んでいるかを保持
    var currentFrame:AVAudioFrameCount = 0
    
    //このファイルを読み込む
    let sourceFileURL = Bundle.main.url(forResource: "source", withExtension: "caf")!
    //let sourceFileURL = Bundle.main.url(forResource: "podcast #012", withExtension: "m4a")!
    
    var processingAudioBuffer:AudioBuffer = {
        var audioBuffer = AudioBuffer()
        audioBuffer.mDataByteSize = UInt32(Int(processingFrameLength * 2) * MemoryLayout<Float32>.stride)
        audioBuffer.mData = UnsafeMutableRawPointer.allocate(bytes: Int(audioBuffer.mDataByteSize), alignedTo: 1)
        audioBuffer.mNumberChannels = 2
        return audioBuffer
    } ()
    
    func convertToInterleaved(audioBufferList:UnsafeMutablePointer<AudioBufferList>, frameLength:UInt32) -> AudioBufferList{
        let mutableAudioBufferListPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)
        let audioBufferL =  mutableAudioBufferListPointer[0]
        let audioBufferR =  mutableAudioBufferListPointer[1]
        
        let p:UnsafeMutablePointer<Float32> = processingAudioBuffer.mData!.bindMemory(to: Float32.self, capacity: Int(frameLength))
        let pL: UnsafeMutablePointer<Float32> = audioBufferL.mData!.bindMemory(to: Float32.self, capacity: Int(frameLength))
        let pR: UnsafeMutablePointer<Float32> = audioBufferR.mData!.bindMemory(to: Float32.self, capacity: Int(frameLength))
        
        processingAudioBuffer.mDataByteSize = UInt32(Int(frameLength * 2) * MemoryLayout<Float32>.stride)
        memset(processingAudioBuffer.mData, 0, Int(processingAudioBuffer.mDataByteSize))
        
        var index = 0;
        for i in 0...frameLength - 1 {
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
        //AVAudioFileを使う場合、Interleavedでバッファを読み込むとBuffer数=1, チャンネル数1のバッファになってしまうので
        //interleaved: false = Non Interleavedで読み込む
        sourceFile = try! AVAudioFile(forReading: sourceFileURL,
                                      commonFormat: .pcmFormatFloat32,
                                      interleaved: false)
        readingFormat = sourceFile.processingFormat
    }
    
    
    func nextSampleBuffer() -> CMSampleBuffer?{
        let buffer = AVAudioPCMBuffer(pcmFormat: readingFormat, frameCapacity:processingFrameLength)!
        do{
            //オーディオファイルからAVAudioPCMBufferにデータを読み込みます。
            try sourceFile.read(into: buffer, frameCount: processingFrameLength)
        }catch {
            return nil
        }
        
        //audioStreamBasicDescription.mSampleRate = 再生するサンプリングレートとcurrentFrame = 現在位置を考慮してCMSampleTimingInfoを作成します。
        var timing = CMSampleTimingInfo(duration: CMTimeMake(1, Int32(readingFormat.sampleRate)),
                                        presentationTimeStamp: CMTimeMake(Int64(currentFrame), Int32(readingFormat.sampleRate)),
                                        decodeTimeStamp: kCMTimeInvalid)
        
        print(CMTimeGetSeconds(CMTimeMake(Int64(currentFrame), Int32(readingFormat.sampleRate))))
        
        currentFrame += buffer.frameLength
        
        //Non Interleavedで読み込んだがAVSampleBufferAudioRendererはInterleavedのCMSampleBufferを渡すと
        //レンダリングエラーになるのでInterleavedに変換します
        var audioBufferList = convertToInterleaved(audioBufferList: buffer.mutableAudioBufferList, frameLength: buffer.frameLength)
        
        //CMSampleBufferを作成します
        var sampleBuffer: CMSampleBuffer? = nil
        CMSampleBufferCreate(nil,nil,false,nil,nil,
                             sampleBufferformatDescription,
                             CMItemCount(buffer.frameLength),
                             1,
                             &timing,
                             0,
                             nil,
                             &sampleBuffer)
        //CMSampleBufferにオーディオファイルから読み込んだバッファをセットします
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
            self.startEnqueueing()
            self.renderSynchronizer.rate = 1.0
            self.audioRenderer.volume = 1.0
        }
    }
}
