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
        
        let objectNode = contact.bodyA.categoryBitMask == objectGroup ? contact.bodyA.node : contact.bodyB.node
        
        if score > highScore {
            highScore = score
        }
        UserDefaults.standard.set(highScore, forKey: "highScore")
        
        if contact.bodyA.categoryBitMask == objectGroup || contact.bodyB.categoryBitMask == objectGroup {
            death = true
            hero.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            
            if !shieldBool {
                animations.shakeAndFlashAnimation(view: self.view!)
                            
                if sound {
                    run(batDeadPreload)
                }
                            
                hero.physicsBody?.allowsRotation = false
                            
                heroemitterObject.removeAllChildren()
                shieldObject.removeAllChildren()
                shieldItemObject.removeAllChildren()
                            
                timerAddBoneTimer.invalidate()
                timerAddCoin.invalidate()
                timerAddRedCoin.invalidate()
                timerAddSpiderTimer.invalidate()
                timerAddBee.invalidate()
                timerAddShieldItem.invalidate()
                            
                heroDeathTexturesArray = [
                            SKTexture(imageNamed: "ko_000.png"), SKTexture(imageNamed: "ko_001.png"), SKTexture(imageNamed: "ko_002.png"), SKTexture(imageNamed: "ko_003.png"), SKTexture(imageNamed: "ko_004.png"), SKTexture(imageNamed: "ko_005.png"), SKTexture(imageNamed: "ko_006.png"), SKTexture(imageNamed: "ko_007.png"), SKTexture(imageNamed: "ko_008.png"), SKTexture(imageNamed: "ko_009.png"), SKTexture(imageNamed: "ko_010.png"), SKTexture(imageNamed: "ko_011.png"), SKTexture(imageNamed: "ko_012.png"), SKTexture(imageNamed: "ko_013.png"), SKTexture(imageNamed: "ko_014.png"), SKTexture(imageNamed: "ko_015.png"), SKTexture(imageNamed: "ko_016.png"), SKTexture(imageNamed: "ko_017.png"), SKTexture(imageNamed: "ko_018.png"), SKTexture(imageNamed: "ko_019.png"), SKTexture(imageNamed: "ko_020.png"), SKTexture(imageNamed: "ko_021.png"), SKTexture(imageNamed: "ko_022.png"), SKTexture(imageNamed: "ko_023.png"), SKTexture(imageNamed: "ko_024.png"), SKTexture(imageNamed: "ko_025.png"), SKTexture(imageNamed: "ko_026.png"), SKTexture(imageNamed: "ko_027.png"), SKTexture(imageNamed: "ko_028.png"), SKTexture(imageNamed: "ko_029.png")
                ]
                hero.size.height = 120
                hero.size.width = 130
                hero.position = CGPoint(x: self.size.width - 100, y: 0)
                let heroDeathAnimation = SKAction.animate(with: heroDeathTexturesArray,
                                                          timePerFrame: 0.03)
                hero.run(heroDeathAnimation)
                
                showHighScore()
                gameOver = 1
                
                if death {
                    deathAction()
                                          
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.showHighScoreText()
                        self.gameViewControllerBridge.refreshGameButton.isHidden = false
                        self.stageLabel.isHidden = true
                        
                        if self.score > self.highScore {
                            self.highScore = self.score
                        }
                        
                        self.highScoreLabel.isHidden = false
                        self.highScoreTextLabel.isHidden = false
                        self.highScoreLabel.text = "\(self.highScore)"
                    }
                }
            } else {
                death = false
                objectNode?.removeFromParent()
                shieldObject.removeAllChildren()
                shieldBool = false
//                if sound {
//                    run(shieldOffPreload)
//                }
            }
        }
        
        if contact.bodyA.categoryBitMask == shieldGroup || contact.bodyB.categoryBitMask == shieldGroup {
            let shieldNode = contact.bodyA.categoryBitMask == shieldGroup ? contact.bodyA.node : contact.bodyB.node
            if !shieldBool {
                if sound { run(pickCoinPreload) }
                shieldNode?.removeFromParent()
                addShield()
                shieldBool = true
            }
        }
        
        if contact.bodyA.categoryBitMask == groundGroup || contact.bodyB.categoryBitMask == groundGroup {
            if gameOver == 0 {
                if death {
                    deathAction()
                } else {
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
        
        if contact.bodyA.categoryBitMask == coinGroup || contact.bodyB.categoryBitMask == coinGroup {
            let coinNode = contact.bodyA.categoryBitMask == coinGroup ? contact.bodyA.node : contact.bodyB.node
            
            if sound == true {
                run(pickCoinPreload)
            }
            
            score = score + 1
            scoreLabel.text = "\(score)"
            
            coinNode?.removeFromParent()
        }
        
        if contact.bodyA.categoryBitMask == redCoinGroup || contact.bodyB.categoryBitMask == redCoinGroup {
            let redCoinNode = contact.bodyA.categoryBitMask == redCoinGroup ? contact.bodyA.node : contact.bodyB.node
            
            if sound == true {
                run(pickCoinPreload)
            }
            
            score = score + 2
            scoreLabel.text = "\(score)"
            
            redCoinNode?.removeFromParent()
        }
    }
}
