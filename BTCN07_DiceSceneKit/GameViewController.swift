//
//  GameViewController.swift
//  BTCN07_DiceSceneKit
//
//  Created by Quach Ha Chan Thanh on 10/26/16.
//  Copyright © 2016 Quach Ha Chan Thanh. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit
import CoreMotion

class GameViewController: UIViewController {
    
    // create a new scene
    let scene = SCNScene()
    
    // create a camera
    let cameraNode = SCNNode()
    
    // create and add a light to the scene
    let lightNode = SCNNode()
    
    // create and add an ambient light to the scene
    let ambientLightNode = SCNNode()
    var dice: SCNNode!
    let motionManager = CMMotionManager()
    
    var lastVector3 = SCNVector3Zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create and add a camera to the scene
        
        cameraNode.camera = SCNCamera()
        cameraNode.camera?.xFov = 50
        cameraNode.camera?.yFov = 50
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
        scene.rootNode.addChildNode(cameraNode)
        
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
        
        
        // retrieve the SCNView
        let scnView = self.view as! JAQDiceView
        
//
//        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
//
//        self.setupDice()
        motionManager.accelerometerUpdateInterval = 0.5
        
        motionManager.startAccelerometerUpdates(to: OperationQueue.main) { (motion, error) in
          //  print(motion)
            
            if let motion = motion {
                let currentVector3 = SCNVector3Make(Float(motion.acceleration.x), Float(motion.acceleration.y), Float(motion.acceleration.z))
                
                let distance = SCNVector3.distance(v1: currentVector3, v2: self.lastVector3)
                if Int(distance * 100) != 0 {
                    self.lastVector3 = currentVector3
                    print(distance)
                    let scnView = self.view as! JAQDiceView
                    scnView.rollTheDice(distance)
                    
                }
                
            }
        }
        
        
    }
    
    func setupDice() {
        var size: CGFloat = 1.5
        let boxGeometry = SCNBox(width: size, height: size, length: size, chamferRadius: 0)
        
        boxGeometry.materials.removeFirst()
        
        for i in 1...6 {
            
            let mat = SCNMaterial()
            mat.locksAmbientWithDiffuse = true
            mat.diffuse.contents = UIImage(named: "x\(i)")!.xFlipped
            mat.blendMode = .multiply
           
        
            boxGeometry.materials.append(mat)
        }
        
        dice = SCNNode(geometry: boxGeometry)
        dice.position = SCNVector3(x: 0, y: 0, z: 0)
        
        scene.rootNode.addChildNode(dice)
    }
    
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        
        
        // check what nodes are tapped
//        let p = gestureRecognize.location(in: scnView)
//        let hitResults = scnView.hitTest(p, options: [:])
//        // check that we clicked on at least one object
//        if hitResults.count > 0 {
//           
//        }
//        
        
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}

extension UIImage {
    var xFlipped: UIImage {
        let tempImageView = UIImageView(frame: CGRect(x:0, y:0,width: self.size.width,height: self.size.height))
        tempImageView.image = self
        let viewTempImage = UIView(frame: tempImageView.frame)
        viewTempImage.addSubview(tempImageView)
        
        tempImageView.transform = CGAffineTransform(scaleX: -1, y: 1)
        let img = viewTempImage.screenshot
        
        return img
        
    }
}


extension UIView {
    var screenshot: UIImage{
        UIGraphicsBeginImageContext(self.bounds.size);
        let context = UIGraphicsGetCurrentContext();
        self.layer.render(in: context!)
        let screenShot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return screenShot!
    }
}

extension SCNVector3 {
    
    static func distance(v1: SCNVector3, v2: SCNVector3) -> CGFloat {
        var zD = Double((v1.z - v2.z) * (v1.z - v2.z))
        var yD = Double((v1.y - v2.y) * (v1.y - v2.y))
        var xD = Double((v1.x - v2.x) * (v1.x - v2.x))
        let v = xD + yD + zD
        
        return sqrt(CGFloat(v))
    }
}

