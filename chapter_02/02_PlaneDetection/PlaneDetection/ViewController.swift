//
//  ViewController.swift
//  PlaneDetection
//
//  Created by Shuichi Tsutsumi on 2017/07/17.
//  Copyright © 2017 Shuichi Tsutsumi. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.session.delegate = self
        
        // シーンを生成してARSCNViewにセット
        sceneView.scene = SCNScene()
        
        // セッションのコンフィギュレーションを生成
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        // セッション開始
        sceneView.session.run(configuration)
    }
    
    private func loadModel() -> SCNNode {
        guard let scene = SCNScene(named: "duck.scn", inDirectory: "models.scnassets/duck") else {fatalError()}
        
        let modelNode = SCNNode()
        
        for child in scene.rootNode.childNodes {
            modelNode.addChildNode(child)
        }
        
        // .dae等のフォーマットからモデルを読み込む場合
//        let url = Bundle.main.url(forResource: "filename", withExtension: "dae")!
//        let sceneSource = SCNSceneSource(url: url, options: nil)!
//        guard let modelNode = sceneSource.entryWithIdentifier("modelId", withClass: SCNNode.self) else {fatalError()}

        return modelNode
    }
    
    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {fatalError()}
        print("anchor:\(anchor), node: \(node), node geometry: \(String(describing: node.geometry))")
        
        // 平面ジオメトリを作成
        let geometry = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
        geometry.materials.first?.diffuse.contents = UIColor.yellow.withAlphaComponent(0.5)
        
        // 平面ジオメトリを持つノードを作成
        let planeNode = SCNNode(geometry: geometry)
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2.0, 1, 0, 0)

        // 仮想オブジェクトのノードを作成
        let virtualObjectNode = loadModel()
        
        DispatchQueue.main.async(execute: {
            // 検出したアンカーに対応するノードに子ノードとして持たせる
            node.addChildNode(planeNode)

            // 仮想オブジェクトを乗せる
            node.addChildNode(virtualObjectNode)
        })
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {fatalError()}

        DispatchQueue.main.async(execute: {
            // 平面ジオメトリのサイズを更新
            for childNode in node.childNodes {
                guard let plane = childNode.geometry as? SCNPlane else {continue}
                plane.width = CGFloat(planeAnchor.extent.x)
                plane.height = CGFloat(planeAnchor.extent.z)
                break
            }
        })
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        print("\(self.classForCoder)/" + #function)
    }

    // MARK: - ARSessionDelegate
    
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        print("\(self.classForCoder)/" + #function)
        // 平面検出時はARPlaneAnchor型のアンカーが得られる
//        guard let planeAnchors = anchors as? [ARPlaneAnchor] else {return}
//        print("平面を検出: \(planeAnchors)")
    }
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        print("\(self.classForCoder)/" + #function)
    }
    
    func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {
        print("\(self.classForCoder)/" + #function)
    }
}

