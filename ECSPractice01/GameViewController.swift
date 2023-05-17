//
//  GameViewController.swift
//  ECSPractice01
//
//  Created by Luiz Araujo on 15/05/23.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {

    var camera: SCNNode!
    var ground: SCNNode!
    var scene: SCNScene!
    var sceneView: SCNView!
    
    var car:SCNNode!
    var onLeftLane:Bool = true
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        createScene()
        createCamera()
        createGround()
        
        createScenario()
        
        createPlayer()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(self.move(sender:)))
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.move(sender:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
        sceneView.addGestureRecognizer(swipeGestureRecognizer)
    }
    
    @objc func move(sender: UITapGestureRecognizer){
        let position = sender.location(in: self.view) //localizacao do gesto
        let right = position.x > self.view.frame.size.width/2 // foi na esquerda ou direita?
        if right == onLeftLane { // Pra onde vamos
            let moveSideways:SCNAction = SCNAction.moveBy(x: (right ? 8:-8), y: 0, z: 0, duration: 0.2)
            moveSideways.timingMode = SCNActionTimingMode.easeInEaseOut // suaviza a animacao
            car.runAction(moveSideways)
            onLeftLane = !right // atualiza a posicao do carro
        }
    }
    
    // MARK: - Methods
    private func createScene() {
        scene = SCNScene()
        sceneView = self.view as? SCNView
        sceneView.scene = scene
        sceneView.allowsCameraControl = true
        sceneView.showsStatistics = true
        sceneView.isPlaying = true
        sceneView.autoenablesDefaultLighting = true
    }
    private func createCamera() {
        camera = SCNNode()
        camera.camera = SCNCamera()
        camera.position = SCNVector3(x: 0, y: 25, z: -18)
        camera.eulerAngles = SCNVector3(x: -1, y: 0, z: 0)
        scene.rootNode.addChildNode(camera)
    }
    
    private func createGround() {
        let groundGeometry = SCNFloor()
        groundGeometry.reflectivity = 0.5
        
        let groundMaterial = SCNMaterial()
        groundMaterial.diffuse.contents = UIColor.yellow
        groundGeometry.materials = [groundMaterial]
        
        ground = SCNNode(geometry: groundGeometry)
        scene.rootNode.addChildNode(ground)
    }
    
    private func createScenario() {
        for i in 20...70 {
            let laneMaterial = SCNMaterial()
            if i%5<2 { // se a divisao de i por 5 for igual a 0 ou 1
              laneMaterial.diffuse.contents = UIColor.clear
            } else { // se a divisao de i por 5 for 2,3 ou 4
              laneMaterial.diffuse.contents = UIColor.black
            }
            let laneGeometry = SCNBox(width: 0.2, height: 0.1, length: 1, chamferRadius:0)
            laneGeometry.materials = [laneMaterial]
            let lane = SCNNode(geometry: laneGeometry)
            lane.position = SCNVector3(x: 0, y: 0, z: -Float(i))
            scene.rootNode.addChildNode(lane)
            let moveDown = SCNAction.moveBy(x: 0, y:0 , z: 5, duration: 0.3)
            let moveUp = SCNAction.moveBy(x: 0, y: 0, z: -5, duration: 0)
            let moveLoop = SCNAction.repeatForever(SCNAction.sequence([moveDown, moveUp]))
            lane.runAction(moveLoop)
        }
    }
    
    func createPlayer() {
      car = SCNNode(geometry: SCNBox(width: 3, height: 2, length: 3, chamferRadius: 0.2))
      let material = SCNMaterial()
      material.reflective.contents = UIColor.blue
      material.diffuse.contents = UIColor.lightGray
      car.geometry!.materials = [material]
      scene.rootNode.addChildNode(car)
        
        let particleSystem = SCNParticleSystem()
        let exausterNode = SCNNode(geometry: SCNBox(width: 0, height: 0, length: 0, chamferRadius: 1))
        exausterNode.position = SCNVector3(0,0,1.5)
        exausterNode.addParticleSystem(particleSystem)
        car.addChildNode(exausterNode)
        
        
      car.position = SCNVector3(-4,1,-25) // colocamos ele na frente da camera
    }
}


//
//
////
////  GameViewController.swift
////  ECSPractice01
////
////  Created by Luiz Araujo on 15/05/23.
////
//
//import UIKit
//import QuartzCore
//import SceneKit
//
//class GameViewController: UIViewController {
//
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // create a new scene
////        let scene = SCNScene(named: "MainScene.scn")!
//
//        // create and add a camera to the scene
//        let cameraNode = SCNNode()
//        cameraNode.camera = sceneCamera
//        scene.rootNode.addChildNode(cameraNode)
//
//        // place the camera
//        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
//
//        // create and add a light to the scene
//        let lightNode = SCNNode()
//        lightNode.light = SCNLight()
//        lightNode.light!.type = .omni
//        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
//        scene.rootNode.addChildNode(lightNode)
//
//        // create and add an ambient light to the scene
//        let ambientLightNode = SCNNode()
//        ambientLightNode.light = SCNLight()
//        ambientLightNode.light!.type = .ambient
//        ambientLightNode.light!.color = UIColor.darkGray
//        scene.rootNode.addChildNode(ambientLightNode)
//
//        // retrieve the SCNView
//        let scnView = self.view as! SCNView
//
//        // set the scene to the view
//        scnView.scene = scene
//
//        // allows the user to manipulate the camera
//        scnView.allowsCameraControl = true
//
//        // show statistics such as fps and timing information
//        scnView.showsStatistics = true
//
//        // configure the view
//        scnView.backgroundColor = UIColor.black
//
//        // add a tap gesture recognizer
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
//        scnView.addGestureRecognizer(tapGesture)
//    }
//
//    @objc
//    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
//        // retrieve the SCNView
//        let scnView = self.view as! SCNView
//
//        // check what nodes are tapped
//        let p = gestureRecognize.location(in: scnView)
//        let hitResults = scnView.hitTest(p, options: [:])
//        // check that we clicked on at least one object
//        if hitResults.count > 0 {
//            // retrieved the first clicked object
//            let result = hitResults[0]
//
//            // get its material
//            let material = result.node.geometry!.firstMaterial!
//
//            // highlight it
//            SCNTransaction.begin()
//            SCNTransaction.animationDuration = 0.5
//
//            // on completion - unhighlight
//            SCNTransaction.completionBlock = {
//                SCNTransaction.begin()
//                SCNTransaction.animationDuration = 0.5
//
//                material.emission.contents = UIColor.black
//
//                SCNTransaction.commit()
//            }
//
//            material.emission.contents = UIColor.red
//
//            SCNTransaction.commit()
//        }
//    }
//
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
//
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        if UIDevice.current.userInterfaceIdiom == .phone {
//            return .allButUpsideDown
//        } else {
//            return .all
//        }
//    }
//
//}
