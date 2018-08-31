//
//  GlassesOverlay.swift
//  rakutencard-Man
//
//  Created by Yoshio on 2018/08/31.
//  Copyright © 2018年 tukuyo. All rights reserved.
//

import ARKit
import SceneKit

class GlassesOverlay: SCNNode {
    
    let occlusionNode: SCNNode
    
    init(geometry: ARSCNFaceGeometry) {
        
        geometry.firstMaterial!.colorBufferWriteMask = []
        occlusionNode = SCNNode(geometry: geometry)
        occlusionNode.renderingOrder = -1
        
        super.init()
        
        addChildNode(occlusionNode)
        
        // 3Dコンテンツを探してロード
        let url = Bundle.main.url(forResource: "rakutenCard", withExtension: "scn", subdirectory: "Models.scnassets")!
        let node = SCNReferenceNode(url:url)!
        node.load()
        // 3dコンテンツを目元に追加
        let faceOverlayContent = node
        addChildNode(faceOverlayContent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) has not been implemented")
    }
    
    
    func update(withFaceAnchor anchor: ARFaceAnchor) {
        let faceGeometry = occlusionNode.geometry as! ARSCNFaceGeometry
        faceGeometry.update(from: anchor.geometry)
    }
}
