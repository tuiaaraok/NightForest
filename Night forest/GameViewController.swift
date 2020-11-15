//
//  GameViewController.swift
//  Night forest
//
//  Created by Айсен Шишигин on 10/11/2020.
//  Copyright © 2020 Туйаара Оконешникова. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    var scene = GameScene(size: CGSize(width: 1024, height: 768))
    let textureAtlas = SKTextureAtlas(named: "scene.atlas")
    
    @IBOutlet weak var refreshGameButton: UIButton!
    @IBOutlet weak var loadingView: UIView!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingView.isHidden = false
        
        refreshGameButton.isHidden = true
        
        let view = self.view as! SKView
        view.ignoresSiblingOrder = true
        
        scene.scaleMode = .aspectFill
        scene.gameViewControllerBridge = self
        
        textureAtlas.preload {
            
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.loadingView.isHidden = true
                view.presentScene(self.scene)
            }
        }
    }
    
    @IBAction func reloadGameButton(_ sender: UIButton) {
        scene.reloadGame()
        scene.gameViewControllerBridge = self
        refreshGameButton.isHidden = true
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
