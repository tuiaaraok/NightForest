//
//  GameScene.swift
//  Night forest
//
//  Created by Айсен Шишигин on 10/11/2020.
//  Copyright © 2020 Туйаара Оконешникова. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    // TEXTURES
    var bgTexture: SKTexture!
    var flyHeroTex: SKTexture!
    
    // Sprite Nodes
    var bg = SKSpriteNode()
    var ground = SKSpriteNode()
    var sky = SKSpriteNode()
    var hero = SKSpriteNode()
    
    
    // Sprites Objects
    var bgObject = SKNode()
    var groundObject = SKNode()
    var heroObject = SKNode()
    var skyObject = SKNode()
    
    // Bit masks
    var heroGroup: UInt32 = 0x1 << 1
    var groundGroup: UInt32 = 0x1 << 2
    
    // Textures array for animateWithTexture
    var heroflyTexturesArray = [SKTexture]()
    
    override func didMove(to view: SKView) {
        // Background texture
        bgTexture = SKTexture(imageNamed: "bg01.png")
        
        // Hero texture
        flyHeroTex = SKTexture(imageNamed: "r_000.png")
        
        createObjects()
        createGame()
    }
    
    func createObjects() {
        self.addChild(bgObject)
        self.addChild(groundObject)
        self.addChild(skyObject)
        self.addChild(heroObject)
    }
    
    func createGame() {
        createBg()
        createGround()
        createSky()
        createHero()
    }
    
    func createBg() {
        bgTexture = SKTexture(imageNamed: "bg01.png")
        
        let moveBg = SKAction.moveBy(x: -bgTexture.size().width, y: 0, duration: 3)
        let replaceBg = SKAction.moveBy(x: bgTexture.size().width, y: 0,  duration: 0)
        let moveBgForever = SKAction.repeatForever(SKAction.sequence([moveBg, replaceBg]))
        
        for i in 0..<3 {
            bg = SKSpriteNode(texture: bgTexture)
            bg.position = CGPoint(x: size.width / 4 + bgTexture.size().width * CGFloat(i), y: size.height / 2.0)
            bg.size.height = self.frame.height
            bg.run(moveBgForever)
            bg.zPosition = -1
            
            bgObject.addChild(bg)
        }
    }
    
    func createGround() {
        ground = SKSpriteNode()
        ground.position = CGPoint.zero
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: self.frame.height/50))
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = groundGroup
        ground.zPosition = 1
               
        groundObject.addChild(ground)
    }
    
    func createSky() {
        sky = SKSpriteNode()
        sky.position = CGPoint(x: 0, y: self.frame.maxX)
        sky.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.size.width + 100, height: self.frame.size.height - 100))
        sky.physicsBody?.isDynamic = false
        sky.zPosition = 1
        skyObject.addChild(sky)
    }
    
    func addHero(heroNode: SKSpriteNode, atPosition position: CGPoint) {
        hero = SKSpriteNode(texture: flyHeroTex)
        
        // Anim hero
//        heroflyTexturesArray = [
//                   SKTexture(imageNamed: "rj_000.png")]
        heroflyTexturesArray = [
        SKTexture(imageNamed: "j_000.png"), SKTexture(imageNamed: "j_001.png"), SKTexture(imageNamed: "j_002.png"), SKTexture(imageNamed: "j_003.png"), SKTexture(imageNamed: "j_004.png"), SKTexture(imageNamed: "j_005.png"), SKTexture(imageNamed: "j_006.png"), SKTexture(imageNamed: "j_007.png"), SKTexture(imageNamed: "j_008.png"), SKTexture(imageNamed: "j_009.png"), SKTexture(imageNamed: "j_010.png"), SKTexture(imageNamed: "j_011.png"), SKTexture(imageNamed: "j_012.png"), SKTexture(imageNamed: "j_013.png"), SKTexture(imageNamed: "j_014.png"), SKTexture(imageNamed: "j_015.png"), SKTexture(imageNamed: "j_016.png"), SKTexture(imageNamed: "j_017.png"), SKTexture(imageNamed: "j_018.png"), SKTexture(imageNamed: "j_019.png"), SKTexture(imageNamed: "j_020.png"), SKTexture(imageNamed: "j_021.png"), SKTexture(imageNamed: "j_022.png"), SKTexture(imageNamed: "j_023.png"), SKTexture(imageNamed: "j_024.png")
        ]
        let heroFlyAnimation = SKAction.animate(with: heroflyTexturesArray, timePerFrame: 0.02)
        let flyHero = SKAction.repeatForever(heroFlyAnimation)
        hero.run(flyHero)
        
        hero.position = position
        hero.size.height = 120
        hero.size.width = 78
        
        hero.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: hero.size.width - 40, height: hero.size.height - 30))
        
        hero.physicsBody?.collisionBitMask = heroGroup
        hero.physicsBody?.contactTestBitMask = groundGroup
        hero.physicsBody?.contactTestBitMask = groundGroup
        
        hero.physicsBody?.isDynamic = true
        hero.physicsBody?.allowsRotation = false
        hero.zPosition = 1
        
        heroObject.addChild(hero)
    }
    
    func createHero() {
        addHero(heroNode: hero, atPosition: CGPoint(x: self.size.width / 4, y: 0 + flyHeroTex.size().height + 400))
    }

}
