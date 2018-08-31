//
//  ViewController.swift
//  rakutencard-Man
//
//  Created by Yoshio on 2018/08/30.
//  Copyright © 2018年 tukuyo. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSessionDelegate, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    private var faceNode = SCNNode()
    
    private var virtualFaceNode = SCNNode()
    
    private let serialQueue = DispatchQueue(label: "com.example.apple-samplecode.ARKitFaceExample.serialSceneKitQueue")
    
    var session: ARSession {
        return sceneView.session
    }
    // 起動時に一度だけ実行される
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.session.delegate = self
        sceneView.automaticallyUpdatesLighting = true
        
        // 下の一行は、ARFaceTrackingがXcodeで有効なデバイスが選択されていなければエラーが出る
        let device = sceneView.device!
        
        let glassesGeometry = ARSCNFaceGeometry(device: device)!
        glassesGeometry.firstMaterial!.colorBufferWriteMask = []
        virtualFaceNode.geometry = glassesGeometry
 
        // 3Dコンテンツを探してロード
        let url = Bundle.main.url(forResource: "rakutenCard", withExtension: "scn", subdirectory: "Models.scnassets")!
        let node = SCNReferenceNode(url:url)!
        node.load()
        // 3dコンテンツを目元に追加
        let faceOverlayContent = node
        
        
        virtualFaceNode.addChildNode(faceOverlayContent)

        resetTracking()
    }
    // 画面が表示された直後に実行される
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // スリープに入らないようにする
        UIApplication.shared.isIdleTimerDisabled = true
        // トラッキングの初期化をする
        resetTracking()
    }
    
    // 画面が非表示になったら実行される
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    
    func resetTracking() {
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    private func setupFaceNodeContent() {
        for child in faceNode.childNodes {
            child.removeFromParentNode()
        }
        faceNode.addChildNode(virtualFaceNode)
    }
    
    
    // トラッキング開始
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        print("トラッキング開始")
        faceNode = node
        serialQueue.async {
            self.setupFaceNodeContent()
        }
    }
    // 更新
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        
        //virtualFaceNode.update(withFaceAnchor: faceAnchor)
        let geometry = virtualFaceNode.geometry as! ARSCNFaceGeometry
        geometry.update(from: faceAnchor.geometry)
    }
    
    // エラー処理
    func session(_ session: ARSession, didFailWithError error: Error) {
        guard error is ARError else { return }
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        DispatchQueue.main.async {
            self.resetTracking()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

