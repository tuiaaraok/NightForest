//
//  GameScene.swift
//  Night forest
//
//  Created by Айсен Шишигин on 10/11/2020.
//  Copyright © 2020 Туйаара Оконешникова. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // Variables
    var sound = true
    var moveBatY = SKAction()
    var gameViewControllerBridge: GameViewController!
    var death = false
    var animations = AnimationClass()
    
    // TEXTURES
    var bgTexture: SKTexture!
    var flyHeroTex: SKTexture!
    var runHeroTex: SKTexture!
    var coinTex: SKTexture!
    var redCoinTex: SKTexture!
    var coinHeroTex: SKTexture!
    var redCoinHeroTex: SKTexture!
    var batTex: SKTexture!
    var deadHeroTex: SKTexture!
    
    // Emitters Node
    var heroEmitter = SKEmitterNode()
    
    // emitter
    var haveEmitter = false
    
    // Sprite Nodes
    var bg = SKSpriteNode()
    var ground = SKSpriteNode()
    var sky = SKSpriteNode()
    var hero = SKSpriteNode()
    var coin = SKSpriteNode()
    var redCoin = SKSpriteNode()
    var bat = SKSpriteNode()
    
    
    // Sprites Objects
    var bgObject = SKNode()
    var groundObject = SKNode()
    var heroObject = SKNode()
    var movingObject = SKNode()
    var heroemitterObject = SKNode()
    var coinObject = SKNode()
    var redCoinObject = SKNode()
    
    // Bit masks
    var heroGroup: UInt32 = 0x1 << 1
    var groundGroup: UInt32 = 0x1 << 2
    var coinGroup: UInt32 = 0x1 << 3
    var redCoinGroup: UInt32 = 0x1 << 4
    var objectGroup: UInt32 = 0x1 << 5
    
    // Textures array for animateWithTexture
    var heroflyTexturesArray = [SKTexture]()
    var heroRunTexturesArray = [SKTexture]()
    var coinTexturesArray = [SKTexture]()
    var batTexturesArray = [SKTexture]()
    var heroDeathTexturesArray = [SKTexture]()
    
    // Timers
    var timerAddCoin = Timer()
    var timerAddRedCoin = Timer()
    var timerAddBoneTimer = Timer()
    
    // Sounds
    var pickCoinPreload = SKAction()
    var batCreatePreload = SKAction()
    var batDeadPreload = SKAction()
    
    override func didMove(to view: SKView) {
        // Background texture
        bgTexture = SKTexture(imageNamed: "bg01.png")
        
        // Hero texture
        flyHeroTex = SKTexture(imageNamed: "jump.png")
        runHeroTex = SKTexture(imageNamed: "r_000.png")
        
        // Coin texture
        coinTex = SKTexture(imageNamed: "coin.jpg")
        redCoinTex = SKTexture(imageNamed: "coin.jpg")
        coinHeroTex = SKTexture(imageNamed: "Coin0.png")
        redCoinHeroTex = SKTexture(imageNamed: "Coin0.jpg")
        
        // Bone texture
        batTex = SKTexture(imageNamed: "bat-1.png")
        
        // Emitters
        heroEmitter = SKEmitterNode(fileNamed: "engine.sks")!
        
        self.physicsWorld.contactDelegate = self
        
        createObjects()
        createGame()
        
        pickCoinPreload = SKAction.playSoundFileNamed("pickCoin.mp3", waitForCompletion: false)
        batCreatePreload = SKAction.playSoundFileNamed("bat.mp3", waitForCompletion: false)
        batDeadPreload = SKAction.playSoundFileNamed("batDeath2.mp3", waitForCompletion: false)
    }
    
    func createObjects() {
        self.addChild(bgObject)
        self.addChild(groundObject)
        self.addChild(movingObject)
        self.addChild(heroObject)
        self.addChild(heroemitterObject)
        self.addChild(coinObject)
        self.addChild(redCoinObject)
    }
    
    func createGame() {
        createBg()
        createGround()
        createSky()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            self.createHero()
            self.createHeroemitter()
            self.timerFunc()
            self.addBat()
        }
        
        gameViewControllerBridge.refreshGameButton.isHidden = true
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
        ground.position = CGPoint(x: 0, y: self.frame.minX)
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: self.frame.height / 4 + self.frame.height/8))
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = groundGroup
        ground.zPosition = 1
               
        groundObject.addChild(ground)
    }
    
    func createSky() {
        sky = SKSpriteNode()
        sky.position = CGPoint(x: 0, y: self.frame.maxX)
        sky.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.size.width + 100, height: self.frame.size.height - 50))
        sky.physicsBody?.isDynamic = false
        sky.zPosition = 1
        movingObject.addChild(sky)
    }
    
    func addHero(heroNode: SKSpriteNode, atPosition position: CGPoint) {
        hero = SKSpriteNode(texture: flyHeroTex)
        
        // Anim hero
        
        heroflyTexturesArray = [SKTexture(imageNamed: "jump.png")]
        let heroFlyAnimation = SKAction.animate(with: heroflyTexturesArray, timePerFrame: 0.02)
        let flyHero = SKAction.repeatForever(heroFlyAnimation)
        hero.run(flyHero)
        
        hero.position = position
        hero.size.height = 120
        hero.size.width = 85
        
        hero.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: hero.size.width - 40, height: hero.size.height - 30))
        
        hero.physicsBody?.categoryBitMask = heroGroup
        hero.physicsBody?.contactTestBitMask = groundGroup | coinGroup | redCoinGroup | objectGroup
        hero.physicsBody?.collisionBitMask = groundGroup
        
        hero.physicsBody?.isDynamic = true
        hero.physicsBody?.allowsRotation = false
        hero.zPosition = 1
        
        heroObject.addChild(hero)
    }
    
    func createHero() {
        addHero(heroNode: hero, atPosition: CGPoint(x: self.size.width / 4, y: 0 + flyHeroTex.size().height + 400))
    }
    
    func createHeroemitter() {
        heroEmitter = SKEmitterNode(fileNamed: "engine.sks")!
        heroemitterObject.zPosition = 1
        heroemitterObject.addChild(heroEmitter)
    }
    
    @objc func addCoin() {
        coin = SKSpriteNode(texture: coinTex)
        coinTexturesArray = [SKTexture(imageNamed: "Coin0.png"), SKTexture(imageNamed: "Coin1.png"), SKTexture(imageNamed: "Coin2.png"), SKTexture(imageNamed: "Coin3.png")]
        let coinAnimation = SKAction.animate(with: coinTexturesArray, timePerFrame: 0.1)
        let coinHero = SKAction.repeatForever(coinAnimation)
        coin.run(coinHero)
        
        let movementAmount = arc4random() % UInt32(self.frame.size.height / 2)
        let pipeOffset = CGFloat(movementAmount) - self.frame.size.height / 4
        coin.size.width = 40
        coin.size.height = 40
        coin.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: coin.size.width - 20, height: coin.size.height - 20))
        coin.physicsBody?.restitution = 0
        coin.position = CGPoint(x: self.size.width + 50, y: 0 + coinTex.size().height + 90 + pipeOffset)
        
        let moveCoin = SKAction.moveBy(x: -self.frame.size.width * 2, y: 0, duration: 5)
        let removeAction = SKAction.removeFromParent()
        let coinMoveBGForever = SKAction.repeatForever(SKAction.sequence([moveCoin, removeAction]))
        coin.run(coinMoveBGForever)
        
        coin.physicsBody?.isDynamic = false
        coin.physicsBody?.categoryBitMask = coinGroup
        coin.zPosition = 1
        coinObject.addChild(coin)
    }
    
    @objc func redCoinAdd() {
        redCoin = SKSpriteNode(texture: redCoinTex)
        coinTexturesArray = [SKTexture(imageNamed: "Coin0.png"), SKTexture(imageNamed: "Coin1.png"), SKTexture(imageNamed: "Coin2.png"), SKTexture(imageNamed: "Coin3.png")]
        let redCoinAnimation = SKAction.animate(with: coinTexturesArray, timePerFrame: 0.1)
        let redCoinHero = SKAction.repeatForever(redCoinAnimation)
        redCoin.run(redCoinHero)
        
        let movementAmount = arc4random() % UInt32(self.frame.size.height / 2)
        let pipeOffset = CGFloat(movementAmount) - self.frame.size.height / 4
        redCoin.size.width = 40
        redCoin.size.height = 40
        redCoin.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: redCoin.size.width - 10, height: redCoin.size.height - 10))
        redCoin.physicsBody?.restitution = 0
        redCoin.position = CGPoint(x: self.size.width + 50, y: 0 + redCoinTex.size().height + 90 + pipeOffset)
               
        let moveCoin = SKAction.moveBy(x: -self.frame.size.width * 2, y: 0, duration: 5)
        let removeAction = SKAction.removeFromParent()
        let coinMoveBGForever = SKAction.repeatForever(SKAction.sequence([moveCoin, removeAction]))
        redCoin.run(coinMoveBGForever)
               
        redCoin.setScale(1.3)
        redCoin.physicsBody?.isDynamic = false
        redCoin.physicsBody?.categoryBitMask = redCoinGroup
        redCoin.zPosition = 1
        redCoinObject.addChild(redCoin)
    }
    
    @objc func addBat() {
        if sound {
            run(batCreatePreload)
        }
        
        bat = SKSpriteNode(texture: batTex)
        batTexturesArray = [SKTexture(imageNamed: "bat-1.png"), SKTexture(imageNamed: "bat-2.png"), SKTexture(imageNamed: "bat-3.png"), SKTexture(imageNamed: "bat-4.png"), SKTexture(imageNamed: "bat-5.png")]
        let batAnimation = SKAction.animate(with: batTexturesArray, timePerFrame: 0.03)
        let batHero = SKAction.repeatForever(batAnimation)
        bat.run(batHero)
        
        let randomPosition = arc4random() % 2
        let movementAmount = arc4random() % UInt32(self.frame.size.height / 5)
        let pipeOffset = self.frame.size.height / 4 + 30 - CGFloat(movementAmount)
        
        if randomPosition == 0 {
            bat.position = CGPoint(x: self.size.width + 50, y: 0 + batTex.size().height / 2 + 90 + pipeOffset)
            bat.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: bat.size.width - 40, height: bat.size.height - 20))
        } else {
            bat.position = CGPoint(x: self.size.width + 50, y: self.frame.size.height - batTex.size().height / 2 - 90 - pipeOffset)
             bat.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: bat.size.width - 40, height: bat.size.height - 20))
        }
        
        // move
        let moveaction = SKAction.moveBy(x: -self.frame.width - 300, y: 0, duration: 6)
        bat.run(moveaction)
        
        // scale
        var scaleValue: CGFloat = 0.3
        
        let scaleRandom = arc4random() % UInt32(5)
        if scaleRandom == 1 { scaleValue = 0.9 }
        else  if scaleRandom == 2 { scaleValue = 0.6 }
        else if scaleRandom == 3 { scaleValue = 0.8 }
        else if scaleRandom == 4 { scaleValue = 0.7 }
        else if scaleRandom == 0 { scaleValue = 1.0 }
        
         bat.setScale(scaleValue)
        
        let movementRandom = arc4random() % 9
        if movementRandom == 0 {
            moveBatY = SKAction.moveTo(y: self.frame.height / 2 + 220, duration: 4)
        } else if movementRandom == 1 {
            moveBatY = SKAction.moveTo(y: self.frame.height / 2 - 220, duration: 5)
        } else if movementRandom == 2 {
            moveBatY = SKAction.moveTo(y: self.frame.height / 2 - 150, duration: 4)
        } else if movementRandom == 3 {
            moveBatY = SKAction.moveTo(y: self.frame.height / 2 + 150, duration: 5)
        } else if movementRandom == 4 {
            moveBatY = SKAction.moveTo(y: self.frame.height / 2 + 50, duration: 4)
        } else if movementRandom == 5 {
            moveBatY = SKAction.moveTo(y: self.frame.height / 2 - 50, duration: 5)
        } else {
            moveBatY = SKAction.moveTo(y: self.frame.height / 2, duration: 4)
        }
        
        bat.run(moveBatY)
        
        bat.physicsBody?.restitution = 0
        bat.physicsBody?.isDynamic = false
        bat.physicsBody?.categoryBitMask = objectGroup
        bat.zPosition = 1
        movingObject.addChild(bat)
    }
    
    func timerFunc() {
        timerAddCoin.invalidate()
        timerAddRedCoin.invalidate()
        timerAddBoneTimer.invalidate()
        
        timerAddCoin = Timer.scheduledTimer(timeInterval: 2.64, target: self, selector: #selector(GameScene.addCoin), userInfo: nil, repeats: true)
        timerAddRedCoin = Timer.scheduledTimer(timeInterval: 8.246, target: self, selector: #selector(GameScene.redCoinAdd), userInfo: nil, repeats: true)
        timerAddBoneTimer = Timer.scheduledTimer(timeInterval: 5.236, target: self, selector: #selector(GameScene.addBat), userInfo: nil, repeats: true)
    }
    
    func stopGameObject() {
        coinObject.speed = 0
        redCoinObject.speed = 0
        movingObject.speed = 0
        heroObject.speed = 0
    }
    
    func reloadGame() {
        death = false
        coinObject.removeAllChildren()
        redCoinObject.removeAllChildren()
        
        scene?.isPaused = false
        
        movingObject.removeAllChildren()
        heroObject.removeAllChildren()
        
        coinObject.speed = 1
        heroObject.speed = 1
        movingObject.speed = 1
        bgObject.isPaused = false
        self.scene?.speed = 1
        
        createGround()
        createSky()
        createHero()
        createHeroemitter()
        
        timerAddCoin.invalidate()
        timerAddRedCoin.invalidate()
        timerAddBoneTimer.invalidate()
        
        timerFunc()
    }
    
    override func didFinishUpdate() {
        heroEmitter.position = hero.position - CGPoint(x: 10, y: 60)
    }

}
