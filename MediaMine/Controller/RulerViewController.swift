//
//  RulerViewController.swift
//  MediaMine
//
//  Created by Christopher Chu on 9/17/19.
//  Copyright © 2019 NoOrg. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import FirebaseAuth

//protocol declaration
protocol GetCalcDelegate{
    func userEnteredDimensions(length: String, width: String)
}


class RulerViewController: UIViewController,ARSCNViewDelegate {
    
    //declare te delegate variable here
    var delegate : GetCalcDelegate?
    
    @IBOutlet weak var sceneView: ARSCNView!
    var dotNodes = [SCNNode]()
    @IBOutlet weak var length: UILabel!
    @IBOutlet weak var width: UILabel!
    
    //String width and string to send w/ delegate
    var sendLength = ""
    var sendWidth = ""
    
    
    //var lastNode : SCNNode?
    var lastNodes = [SCNNode]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //set view's delegate
        sceneView.delegate = self
        
        //debug options
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //create session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        //run the views session
        sceneView.session.run(configuration)
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //pause the view's session
        sceneView.session.pause()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touchLocation = touches.first?.location(in: sceneView){
            //hittestresult, a location in 3d space
            //get2d and convert it to 3d by performing hitest
            //.FEATUREPOINT- a point on a surface detected by ARKit
            let hitTestResults = sceneView.hitTest(touchLocation, types: .featurePoint)
            
            if let hitResult = hitTestResults.first{
                addMark(at: hitResult)
            }
        
        }
    }
    func addMark(at hitResult : ARHitTestResult){
        
        guard lastNodes.count < 6 else{
            return
        }
        
        //create dot geometry and its going to be a scene sphere(3d sphere)
        //dotGeometry, SCNSphere
        let dotGeometry = SCNSphere(radius: 0.010)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        dotGeometry.materials = [material]
        
        let dotNode = SCNNode(geometry: dotGeometry)
        //specify dotnodes. position property
        dotNode.position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y, hitResult.worldTransform.columns.3.z)
        
        lastNodes.append(dotNode)
        sceneView.scene.rootNode.addChildNode(lastNodes.last!)
        
        dotNodes.append(dotNode)
        
        if dotNodes.count >= 2{
            calculate()
            dotNodes.removeAll()
        }
    }
    func calculate(){
        let start = dotNodes[0]
        let end = dotNodes[1]
        
        let a = end.position.x - start.position.x
        let b = end.position.y  - start.position.y
        let c = end.position.z - start.position.z
        let distance = sqrt(pow(a,2) + pow(b,2) + pow(c,2))
        let centDistance = distance * 100
        let inchesDistance = centDistance / 2.54
        let ftDistance = inchesDistance / 12
//        print(start.position)
//        print(end.position)
//        print(centDistance)
//        print(inchesDistance)
//        print(ftDistance)
        
        createText(text: "\(ftDistance)", atPosition: end.position)
        
        
        //show length and width
        if lastNodes.count == 3{
            //sendLength = ("\(ftDistance)")
            sendLength = String(ftDistance)
            //print(sendLength)
            length.text = "L = \(ftDistance) ft"
        }else{
            sendWidth = ("\(ftDistance)")
            width.text = "W = \(ftDistance) ft"
        }
        
    }
    //create 3d text to display in AR
    func createText(text: String, atPosition: SCNVector3){
        let textGeometry = SCNText(string: text, extrusionDepth: 1.0)
        textGeometry.firstMaterial?.diffuse.contents = UIColor.white
        let textNode = SCNNode(geometry: textGeometry)
        textNode.position = SCNVector3(atPosition.x, atPosition.y, atPosition.z)
        textNode.scale = SCNVector3(0.01, 0.01, 0.01)
        
       // lastNode = textNode
        lastNodes.append(textNode)
        sceneView.scene.rootNode.addChildNode(lastNodes.last!)
        
       

    }
    
    
    @IBAction func removeMeasurement(_ sender: Any) {
       // sceneView.scene.rootNode.removeFromParentNode()
       // dotNodes.removeFromParentNode()
       // lastNode?.removeFromParentNode()
        if lastNodes.count > 0{
            print(lastNodes.count)
            //if count modulo 3 == 0, then remove 3
            if lastNodes.count % 3 == 0{
                lastNodes.last?.removeFromParentNode()
                lastNodes.removeLast()
                lastNodes.last?.removeFromParentNode()
                lastNodes.removeLast()
                lastNodes.last?.removeFromParentNode()
                lastNodes.removeLast()
                
                //if textfields
                if lastNodes.count == 3{
                    width.text = "W = "
                }
                else{
                    length.text = "L = "
                }
            }
                
            else{
                //if count modulo 3 == 1, then remove 1
                lastNodes.last?.removeFromParentNode()
                lastNodes.removeLast()
                dotNodes.removeAll()
            }
        }
    }
    func displayAlert(msg: String){
               let alert = UIAlertController(title: "Wait", message: msg, preferredStyle: .alert)
               alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
               self.present(alert, animated: true, completion: nil)
           }
    
    @IBAction func saveResults(_ sender: Any) {
        //if user is not loggined in, go to
        guard (Auth.auth().currentUser?.uid) != nil else{
            print("no user is logged in")
            displayAlert(msg: "User is not logged in")
            self.performSegue(withIdentifier: "goToFirst", sender: self)
            
            return
        }
        
        //get the dimensions
//        let lengthDim = length.text!
//        let widthDim = width.text!
        let lengthDim = sendLength
        let widthDim = sendWidth
        //if we have delegate set call the userEntereddime method
       // print(lengthDim)
        //print(widthDim)
        delegate?.userEnteredDimensions(length: lengthDim, width: widthDim)
        self.dismiss(animated: true, completion: nil)
        
        
        
       
    }
    
}
