//
//  ViewController.swift
//  AR_Pokemon
//
//  Created by Bing Xiong on 12/6/20.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // 添加默认环境光
        sceneView.autoenablesDefaultLighting = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
//        let configuration = ARWorldTrackingConfiguration()
        let configuration = ARWorldTrackingConfiguration()
        
        if let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "Pokemon Cards", bundle: Bundle.main){
            configuration.detectionImages = imageToTrack
            
            configuration.maximumNumberOfTrackedImages = 2
            
            print("Images Successfully Added!")
        }
        

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }


    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        let node = SCNNode()
        
        // 检测检测到的anchor是否是ARImageAnchor 因为还有可能是个plane或者point
        if let imageAnchor = anchor as? ARImageAnchor {
            print(imageAnchor.referenceImage.name)
            print("detected")
            // 设置一个平面长宽与图片一致
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            
            // 添加一个透明度
            plane.firstMaterial?.diffuse.contents = UIColor(white: 1, alpha: 0.5)
            
            let planeNode = SCNNode(geometry: plane)
            
            // 绕x轴旋转90度
            planeNode.eulerAngles.x = -.pi / 2
            node.addChildNode(planeNode)
            
            // 将pokemon的模型添加到场景
            if imageAnchor.referenceImage.name == "eevee-card"{
                if let pokeScene = SCNScene(named: "art.scnassets/eevee.scn"){
                    if let pokeNode = pokeScene.rootNode.childNodes.first{
                        planeNode.addChildNode(pokeNode)
                        pokeNode.eulerAngles.x = Float.pi / 2
                    }
                }
            }
            
            if imageAnchor.referenceImage.name == "oddish-card" {
                if let pokeScene = SCNScene(named: "art.scnassets/oddish.scn"){
                    if let pokeNode = pokeScene.rootNode.childNodes.first{
                        planeNode.addChildNode(pokeNode)
                        pokeNode.eulerAngles.x = Float.pi / 2
                    }
                }
            }

        }
        
        return node
    }

}
