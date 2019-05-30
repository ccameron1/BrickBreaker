//
//  GameViewController.swift
//  BrickBreaker
//
//  Created by Carly Cameron on 5/30/19.
//  Copyright © 2019 Carly Cameron. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = GameScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
        
    }


    override var prefersStatusBarHidden: Bool {
        return true
    }
}
