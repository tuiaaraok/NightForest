//
//  GameSceneTouches.swift
//  Night forest
//
//  Created by Айсен Шишигин on 12/11/2020.
//  Copyright © 2020 Туйаара Оконешникова. All rights reserved.
//

import Foundation
import SpriteKit

extension GameScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        heroEmitter.isHidden = false
        
        if gameOver == 0 {
            if !tabToPlayLabel.isHidden {
                tabToPlayLabel.isHidden = true
            }
            
            if gameOver == 0{
                hero.physicsBody?.velocity = CGVector.zero
                hero.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 180))
                                  
                heroflyTexturesArray = [SKTexture(imageNamed: "jump.png")]
                let heroFlyAnimation = SKAction.animate(with: heroflyTexturesArray, timePerFrame: 0.02)
                let flyHero = SKAction.repeatForever(heroFlyAnimation)
                hero.run(flyHero)
            }
        }
    }
}
