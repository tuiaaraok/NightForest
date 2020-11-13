//
//  GameScene_Physics.swift
//  Night forest
//
//  Created by Айсен Шишигин on 13/11/2020.
//  Copyright © 2020 Туйаара Оконешникова. All rights reserved.
//

import Foundation
import  SpriteKit

extension GameScene {
    func didBegin(_ contact: SKPhysicsContact) {
        
        
        if contact.bodyA.categoryBitMask == groundGroup || contact.bodyB.categoryBitMask == groundGroup {
            
            heroEmitter.isHidden = true
            heroRunTexturesArray = [
            SKTexture(imageNamed: "r_000.png"), SKTexture(imageNamed: "r_001.png"), SKTexture(imageNamed: "r_002.png"), SKTexture(imageNamed: "r_003.png"), SKTexture(imageNamed: "r_004.png"), SKTexture(imageNamed: "r_005.png"), SKTexture(imageNamed: "r_006.png"), SKTexture(imageNamed: "r_007.png"), SKTexture(imageNamed: "r_008.png"), SKTexture(imageNamed: "r_009.png"), SKTexture(imageNamed: "r_010.png"), SKTexture(imageNamed: "r_011.png"), SKTexture(imageNamed: "r_012.png"), SKTexture(imageNamed: "r_013.png"), SKTexture(imageNamed: "r_014.png"), SKTexture(imageNamed: "r_015.png"), SKTexture(imageNamed: "r_016.png"), SKTexture(imageNamed: "r_017.png"), SKTexture(imageNamed: "r_018.png"), SKTexture(imageNamed: "r_019.png"), SKTexture(imageNamed: "r_020.png"), SKTexture(imageNamed: "r_021.png"), SKTexture(imageNamed: "r_022.png"), SKTexture(imageNamed: "r_023.png"), SKTexture(imageNamed: "r_024.png"), SKTexture(imageNamed: "r_025.png"), SKTexture(imageNamed: "r_026.png"), SKTexture(imageNamed: "r_027.png"), SKTexture(imageNamed: "r_028.png"), SKTexture(imageNamed: "r_029.png"), SKTexture(imageNamed: "r_030.png"), SKTexture(imageNamed: "r_031.png"), SKTexture(imageNamed: "r_032.png"), SKTexture(imageNamed: "r_033.png"), SKTexture(imageNamed: "r_034.png"), SKTexture(imageNamed: "r_035.png"), SKTexture(imageNamed: "r_036.png"), SKTexture(imageNamed: "r_037.png"), SKTexture(imageNamed: "r_038.png"), SKTexture(imageNamed: "r_039.png"), SKTexture(imageNamed: "r_040.png"), SKTexture(imageNamed: "r_041.png"), SKTexture(imageNamed: "r_042.png")
            ]
            let heroRunAnimation = SKAction.animate(with: heroRunTexturesArray, timePerFrame: 0.018)
            let heroRun = SKAction.repeatForever(heroRunAnimation)
            
            hero.run(heroRun)
            
        }
    }
}
