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

// 再生を開始
try! engine.start()
player.play()

PlaygroundPage.current.needsIndefiniteExecution = true
