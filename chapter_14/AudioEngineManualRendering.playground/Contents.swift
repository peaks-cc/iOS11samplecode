import AVFoundation
import PlaygroundSupport

let sourceFileURL = Bundle.main.url(forResource: "source", withExtension: "caf")!
let sourceFile = try! AVAudioFile(forReading: sourceFileURL)
let format = sourceFile.processingFormat

let engine = AVAudioEngine()

//Nodeを準備する
let player = AVAudioPlayerNode()
let reverb = AVAudioUnitReverb()

//AVAudioEngineに関連付けする
engine.attach(player)
engine.attach(reverb)

// リバーブのパラメーターをセットする。ここでは中規模ホールの残響のプリセットを読み込んでいる
reverb.loadFactoryPreset(.mediumHall)
reverb.wetDryMix = 50

// Audio Unit（のNode）を接続する。
// player -> reverb -> mainMixer の順に接続している
engine.connect(player, to: reverb, format: format)
engine.connect(reverb, to: engine.mainMixerNode, format: format)

// 再生するオーディオファイルをセット
player.scheduleFile(sourceFile, at: nil)

let maxNumberOfFrames: AVAudioFrameCount = 4096 //一度に処理するフレーム数
try! engine.enableManualRenderingMode(.offline, format: format, maximumFrameCount: maxNumberOfFrames)

//処理を開始する
try! engine.start()
player.play()

//書きだすファイルを用意する
let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
let outputURL = URL(fileURLWithPath: documentsPath + "/output.caf")
let outputFile = try! AVAudioFile(forWriting: outputURL, settings: sourceFile.fileFormat.settings)

// レンダリング用のバッファを用意する
let buffer: AVAudioPCMBuffer = AVAudioPCMBuffer(pcmFormat: engine.manualRenderingFormat,
                                                frameCapacity: engine.manualRenderingMaximumFrameCount)!

//engine.manualRenderingSampleTimeを見て、ファイルの長さに達するまで繰り返し実行する
while engine.manualRenderingSampleTime < sourceFile.length {
    //ファイルの最後では、4096フレームに満たない場合があるので計算する
    let framesToRender = min(buffer.frameCapacity, AVAudioFrameCount(sourceFile.length - engine.manualRenderingSampleTime))

    //レンダリングを実行
    let status = try! engine.renderOffline(framesToRender, to: buffer)
    switch status {
    case .success:
        // レンダリングが成功したのでファイルにバッファを書き込む
        try outputFile.write(from: buffer)
    default:
        break
    }
}

player.stop()
engine.stop()

print("Output \(outputFile.url)")
