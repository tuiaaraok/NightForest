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
    var shieldBool = false
    var score = 0
    var highScore = 0
    var gameOver = 0
//    var gSceneDifficulty: DifficultyChoosing!
//    var gSceneBg: BGChoosing!
    
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
    var spiderTex: SKTexture!
    var beeTex: SKTexture!
    var shieldTexture: SKTexture!
    var shieldItemTexture: SKTexture!
    
    // Emitters Node
    var heroEmitter = SKEmitterNode()
    
    // Label Nodes
    var tabToPlayLabel = SKLabelNode()
    var scoreLabel = SKLabelNode()
    var highScoreLabel = SKLabelNode()
    var highScoreTextLabel = SKLabelNode()
    var stageLabel = SKLabelNode()
    
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
    var spider = SKSpriteNode()
    var bee = SKSpriteNode()
    var shield = SKSpriteNode()
    var shieldItem = SKSpriteNode()
    
    
    // Sprites Objects
    var bgObject = SKNode()
    var groundObject = SKNode()
    var heroObject = SKNode()
    var movingObject = SKNode()
    var heroemitterObject = SKNode()
    var coinObject = SKNode()
    var redCoinObject = SKNode()
    var shieldObject = SKNode()
    var shieldItemObject = SKNode()
    var labelObject = SKNode()
    
    // Bit masks
    var heroGroup: UInt32 = 0x1 << 1
    var groundGroup: UInt32 = 0x1 << 2
    var coinGroup: UInt32 = 0x1 << 3
    var redCoinGroup: UInt32 = 0x1 << 4
    var objectGroup: UInt32 = 0x1 << 5
    var shieldGroup: UInt32 = 0x1 << 6
    
    // Textures array for animateWithTexture
    var heroflyTexturesArray = [SKTexture]()
    var heroRunTexturesArray = [SKTexture]()
    var coinTexturesArray = [SKTexture]()
    var batTexturesArray = [SKTexture]()
    var heroDeathTexturesArray = [SKTexture]()
    var spiderTexturesArray = [SKTexture]()
    var beeTexturesArray = [SKTexture]()
    
    // Timers
    var timerAddCoin = Timer()
    var timerAddRedCoin = Timer()
    var timerAddBoneTimer = Timer()
    var timerAddSpiderTimer = Timer()
    var timerAddBee = Timer()
    var timerAddShieldItem = Timer()
    
    // Sounds
    var pickCoinPreload = SKAction()
    var batCreatePreload = SKAction()
    var batDeadPreload = SKAction()
    var spiderCreatePreload = SKAction()
    var beeCreatePreload = SKAction()
    var shieldOnPreload = SKAction()
    var shieldOffPreload = SKAction()
    
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
        
        // Enemies texture
        batTex = SKTexture(imageNamed: "bat-1.png")
        spiderTex = SKTexture(imageNamed: "SpiderW_000.png")
        beeTex = SKTexture(imageNamed: "bee_1.png")
        
        // shields and item texture
        shieldTexture = SKTexture(imageNamed: "shield1.png")
        shieldItemTexture = SKTexture(imageNamed: "shield.png")
        
        // Emitters
        heroEmitter = SKEmitterNode(fileNamed: "engine.sks")!
        
        self.physicsWorld.contactDelegate = self
        
        createObjects()
        
        if UserDefaults.standard.object(forKey: "highScore") != nil {
            highScore = UserDefaults.standard.object(forKey: "highScore") as! Int
            highScoreLabel.text = "\(highScore)"
        }
        
        if gameOver == 0 {
            createGame()
        }
        
        pickCoinPreload = SKAction.playSoundFileNamed("pickCoin.mp3", waitForCompletion: false)
        batCreatePreload = SKAction.playSoundFileNamed("bat.mp3", waitForCompletion: false)
        batDeadPreload = SKAction.playSoundFileNamed("batDeath2.mp3", waitForCompletion: false)
        spiderCreatePreload = SKAction.playSoundFileNamed("createSpider.mp3", waitForCompletion: false)
        beeCreatePreload = SKAction.playSoundFileNamed("bee.mp3", waitForCompletion: false)
//        shieldOnPreload = SKAction.playSoundFileNamed("", waitForCompletion: false)
    }
    
    func createObjects() {
        self.addChild(bgObject)
        self.addChild(groundObject)
        self.addChild(movingObject)
        self.addChild(heroObject)
        self.addChild(heroemitterObject)
        self.addChild(coinObject)
        self.addChild(redCoinObject)
        self.addChild(shieldObject)
        self.addChild(shieldItemObject)
        self.addChild(labelObject)
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
            self.addSpider()
        }
        showTapToPlay()
        showScore()
        showStage()
        highScoreTextLabel.isHidden = true
        
        gameViewControllerBridge.refreshGameButton.isHidden = true
        
        if labelObject.children.count != 0 {
            labelObject.removeAllChildren()
        }
    }
    
    func createBg() {
        bgTexture = SKTexture(imageNamed: "bg01.png")
        
        let moveBg = SKAction.moveBy(x: -bgTexture.size().width, y: 0, duration: 3)
        let replaceBg = SKAction.moveBy(x: bgTexture.size().width, y: 0,  duration: 0)
        let moveBgForever = SKAction.repeatForever(SKAction.sequence([moveBg, replaceBg]))
        
        for i in 0..<3 {
            bg = SKSpriteNode(texture: bgTexture)
            bg.position = CGPoint(x: size.width / 4 + bgTexture.size().width * CGFloat(i), y: size.height / 2.0)
            let screenSize = UIScreen.main.bounds
            if screenSize.width > 800 {
                bg.size.height = self.frame.height * 8 / 10
            } else {
                bg.size.height = self.frame.height
            }
            bg.run(moveBgForever)
            bg.zPosition = -1
            
            bgObject.addChild(bg)
        }
    }
    
    func createGround() {
        ground = SKSpriteNode()
        let screenSize = UIScreen.main.bounds
        if screenSize.width > 800 {
            ground.position = CGPoint(x: 0, y: self.frame.minX + 40)
        } else {
            ground.position = CGPoint(x: 0, y: self.frame.minX)
        }
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
        hero.physicsBody?.contactTestBitMask = groundGroup | coinGroup | redCoinGroup | objectGroup | shieldGroup
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
    
    @objc func addSpider() {
        if sound {
            run(spiderCreatePreload)
        }
               
        spider = SKSpriteNode(texture: spiderTex)
        spiderTexturesArray = [
            SKTexture(imageNamed: "spiderW_001.png"), SKTexture(imageNamed: "spiderW_000.png"),
            SKTexture(imageNamed: "spiderW_003.png"), SKTexture(imageNamed: "spiderW_000.png"), SKTexture(imageNamed: "spiderW_005.png"), SKTexture(imageNamed: "spiderW_000.png"), SKTexture(imageNamed: "spiderW_007.png"), SKTexture(imageNamed: "spiderW_000.png"), SKTexture(imageNamed: "spiderW_009.png"), SKTexture(imageNamed: "spiderW_010.png"),SKTexture(imageNamed: "spiderW_011.png"), SKTexture(imageNamed: "spiderW_012.png"), SKTexture(imageNamed: "spiderW_013.png"), SKTexture(imageNamed: "spiderW_014.png"), SKTexture(imageNamed: "spiderW_015.png"), SKTexture(imageNamed: "spiderW_016.png"), SKTexture(imageNamed: "spiderW_017.png"), SKTexture(imageNamed: "spiderW_018.png"), SKTexture(imageNamed: "spiderW_019.png"),SKTexture(imageNamed: "spiderW_020.png"), SKTexture(imageNamed: "spiderW_021.png"), SKTexture(imageNamed: "spiderW_022.png"), SKTexture(imageNamed: "spiderW_023.png"), SKTexture(imageNamed: "spiderW_024.png"), SKTexture(imageNamed: "spiderW_025.png"), SKTexture(imageNamed: "spiderW_026.png"), SKTexture(imageNamed: "spiderW_027.png"), SKTexture(imageNamed: "spiderW_028.png"),SKTexture(imageNamed: "spiderW_029.png"), SKTexture(imageNamed: "spiderW_030.png"), SKTexture(imageNamed: "spiderW_031.png"), SKTexture(imageNamed: "spiderW_032.png"), SKTexture(imageNamed: "spiderW_033.png"), SKTexture(imageNamed: "spiderW_034.png"), SKTexture(imageNamed: "spiderW_035.png"), SKTexture(imageNamed: "spiderW_036.png"),SKTexture(imageNamed: "spiderW_037.png"),SKTexture(imageNamed: "spiderW_038.png"), SKTexture(imageNamed: "spiderW_039.png"), SKTexture(imageNamed: "spiderW_040.png"), SKTexture(imageNamed: "spiderW_041.png"), SKTexture(imageNamed: "spiderW_042.png"), SKTexture(imageNamed: "spiderW_043.png"), SKTexture(imageNamed: "spiderW_044.png"), SKTexture(imageNamed: "spiderW_045.png"), SKTexture(imageNamed: "spiderW_046.png"),SKTexture(imageNamed: "spiderW_047.png")
        ]
        let spiderAnimation = SKAction.animate(with: spiderTexturesArray, timePerFrame: 0.03)
        let spiderHero = SKAction.repeatForever(spiderAnimation)
        spider.run(spiderHero)
        
        spider.size.width = 90
        spider.size.height = 62
        spider.speed  = 2.5
        
        var scaleValue: CGFloat = 0.3
               
        let scaleRandom = arc4random() % UInt32(5)
        if scaleRandom == 1 { scaleValue = 0.9 }
        else  if scaleRandom == 2 { scaleValue = 0.6 }
        else if scaleRandom == 3 { scaleValue = 0.8 }
        else if scaleRandom == 4 { scaleValue = 0.7 }
        else if scaleRandom == 0 { scaleValue = 1.0 }
               
        spider.setScale(scaleValue)
            
        let screenSize = UIScreen.main.bounds
        if screenSize.width > 800 {
             spider.position = CGPoint(x: self.frame.size.width + 150, y: self.frame.size.height / 4 - self.frame.size.height / 24 + 40)
        } else {
            spider.position = CGPoint(x: self.frame.size.width + 150, y: self.frame.size.height / 4 - self.frame.size.height / 24)
        }
               
        let moveSpiderX = SKAction.moveTo(x: -self.frame.size.width / 4, duration: 4)
        spider.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: spider.size.width - 40, height: spider.size.height - 30))
        spider.physicsBody?.categoryBitMask = objectGroup
        spider.physicsBody?.isDynamic = false
               
        let removeAction = SKAction.removeFromParent()
        let spiderMoveBgForever = SKAction.repeatForever(SKAction.sequence([moveSpiderX, removeAction]))
               
        spider.run(spiderMoveBgForever)
        spider.zPosition = 1
        movingObject.addChild(spider)
    }
    
    @objc func addBee() {
        if sound {
            run(beeCreatePreload)
        }
                  
        bee = SKSpriteNode(texture: beeTex)
        beeTexturesArray = [
            SKTexture(imageNamed: "bee_1.png"), SKTexture(imageNamed: "bee_2.png"), SKTexture(imageNamed: "bee_3.png"), SKTexture(imageNamed: "bee_4.png"), SKTexture(imageNamed: "bee_5.png"), SKTexture(imageNamed: "bee_6.png"),
           ]
           let beeAnimation = SKAction.animate(with: beeTexturesArray, timePerFrame: 0.03)
           let beeHero = SKAction.repeatForever(beeAnimation)
           bee.run(beeHero)
        
        let movementRandom = arc4random() % 9
        let movementAmount = arc4random() % UInt32(self.frame.size.height / 2)
        let pipeOffset = CGFloat(movementAmount) - self.frame.size.height / 4
              if movementRandom == 0 {
                  moveBatY = SKAction.moveTo(y: self.frame.height / 2 + 180, duration: 8)
              } else if movementRandom == 1 {
                  moveBatY = SKAction.moveTo(y: self.frame.height / 2 - 180, duration: 5)
              } else if movementRandom == 2 {
                  moveBatY = SKAction.moveTo(y: self.frame.height / 2 - 200, duration: 8)
              } else if movementRandom == 3 {
                  moveBatY = SKAction.moveTo(y: self.frame.height / 2 + 200, duration: 5)
              } else if movementRandom == 4 {
                  moveBatY = SKAction.moveTo(y: self.frame.height / 2 + 40, duration: 4)
              } else if movementRandom == 5 {
                  moveBatY = SKAction.moveTo(y: self.frame.height / 2 - 35, duration: 5)
              } else {
                  moveBatY = SKAction.moveTo(y: self.frame.height / 2, duration: 4)
              }
              
        bee.run(moveBatY)
           
        bee.size.width = 70
        bee.size.height = 50
        bee.speed  = 3.3
                  
        bee.position = CGPoint(x: self.frame.size.width + 150, y: self.frame.size.height / 4 - self.frame.size.height / 24 + pipeOffset)
                  
        let moveBeeX = SKAction.moveTo(x: -self.frame.size.width / 2, duration: 8)
        bee.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: bee.size.width - 43, height: bee.size.height - 27))
        bee.physicsBody?.categoryBitMask = objectGroup
        bee.physicsBody?.isDynamic = false
                  
        let removeAction = SKAction.removeFromParent()
        let beeMoveBgForever = SKAction.repeatForever(SKAction.sequence([moveBeeX, removeAction]))
                  
        bee.run(beeMoveBgForever)
        bee.zPosition = 1
        movingObject.addChild(bee)
    }
    
    func addShield() {
        shield = SKSpriteNode(texture: shieldTexture)
        if sound == true { run(shieldOnPreload) }
        shield.zPosition = 1
        shieldObject.addChild(shield)
    }
    
    @objc func addShieldItem() {
        shieldItem = SKSpriteNode(texture: shieldItemTexture)
        
        let movementAmount = arc4random() % UInt32(self.frame.size.height / 2)
        let pipeOffset = CGFloat(movementAmount) - self.frame.size.height / 4
        
        shieldItem.size.width = 50
        shieldItem.size.height = 65
        
        shieldItem.position = CGPoint(x: self.size.width + 50, y: 0 + shieldItemTexture.size().height + self.size.height / 45 + pipeOffset)
        shieldItem.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: shieldItem.size.width - 20, height: shieldItem.size.height - 20))
        shieldItem.physicsBody?.restitution = 0
        
        let moveShield = SKAction.moveBy(x: -self.size.width * 2, y: 0, duration: 5)
        let removeAction = SKAction.removeFromParent()
        let shieldItemMoveBgForever = SKAction.repeatForever(SKAction.sequence([moveShield, removeAction]))
        shieldItem.run(shieldItemMoveBgForever)
        
        shieldItem.setScale(1.1)
        
        shieldItem.physicsBody?.isDynamic = false
        shieldItem.physicsBody?.categoryBitMask = shieldGroup
        shieldItem.zPosition = 1
        shieldItemObject.addChild(shieldItem)
    }
    
    func showTapToPlay() {
        tabToPlayLabel.text = "Tap to fly!"
        tabToPlayLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        tabToPlayLabel.fontSize = 50
        tabToPlayLabel.fontColor = .white
        tabToPlayLabel.fontName = "Chalkduster"
        tabToPlayLabel.zPosition = 1
        self.addChild(tabToPlayLabel)
    }
    
    func showScore() {
        scoreLabel.fontName = "Chalkduster"
        scoreLabel.text = "0"
        scoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.maxY - 200)
        scoreLabel.fontSize = 60
        scoreLabel.fontColor = .white
        scoreLabel.zPosition = 1
        self.addChild(scoreLabel)
    }
    
    func showHighScore() {
        highScoreLabel = SKLabelNode()
        highScoreLabel.position = CGPoint(x: self.frame.maxX - 100, y: self.frame.maxY - 210)
        highScoreLabel.fontSize = 50
        highScoreLabel.fontName = "Chalkduster"
        highScoreLabel.fontColor = .white
        highScoreLabel.isHidden = true
        highScoreLabel.zPosition = 1
        labelObject.addChild(highScoreLabel)
    }
    
    func showHighScoreText() {
        highScoreTextLabel = SKLabelNode()
        highScoreTextLabel.position = CGPoint(x: self.frame.maxX - 100, y: self.frame.maxY - 150)
        highScoreTextLabel.fontSize = 30
        highScoreTextLabel.fontName = "Chalkduster"
        highScoreTextLabel.fontColor = .white
        highScoreTextLabel.text = "HighScore"
        highScoreTextLabel.zPosition = 1
        labelObject.addChild(highScoreTextLabel)
    }
    
    func showStage() {
        stageLabel.position = CGPoint(x: self.frame.maxX - 60, y: self.frame.maxY - 140)
        stageLabel.fontSize = 30
        stageLabel.fontName = "Chalkduster"
        stageLabel.fontColor = .white
        stageLabel.text = "Stage 1"
        stageLabel.zPosition = 1
        self.addChild(stageLabel)
    }
    
    func timerFunc() {
        timerAddCoin.invalidate()
        timerAddRedCoin.invalidate()
        timerAddBoneTimer.invalidate()
        timerAddSpiderTimer.invalidate()
        timerAddBee.invalidate()
        timerAddShieldItem.invalidate()
        
        timerAddCoin = Timer.scheduledTimer(timeInterval: 2.64, target: self, selector: #selector(GameScene.addCoin), userInfo: nil, repeats: true)
        timerAddRedCoin = Timer.scheduledTimer(timeInterval: 8.246, target: self, selector: #selector(GameScene.redCoinAdd), userInfo: nil, repeats: true)
        timerAddBoneTimer = Timer.scheduledTimer(timeInterval: 5.236, target: self, selector: #selector(GameScene.addBat), userInfo: nil, repeats: true)
        timerAddSpiderTimer = Timer.scheduledTimer(timeInterval: 4.275, target: self, selector: #selector(GameScene.addSpider), userInfo: nil, repeats: true)
        timerAddBee = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(GameScene.addBee), userInfo: nil, repeats: true)
        timerAddShieldItem = Timer.scheduledTimer(timeInterval: 20.45, target: self, selector: #selector(GameScene.addShieldItem), userInfo: nil, repeats: true)
    }
    
    func stopGameObject() {
        coinObject.speed = 0
        redCoinObject.speed = 0
        movingObject.speed = 0
        heroObject.speed = 0
    }
    
    func deathAction() {
        
        bgObject.isPaused = true
        hero.texture = SKTexture(imageNamed: "ko_029.png")
        hero.speed = 0
        hero.removeAllChildren()
    }
    
    func reloadGame() {
        death = false
        coinObject.removeAllChildren()
        redCoinObject.removeAllChildren()
        
        stageLabel.text = "Stage 1"
        gameOver = 0
        scene?.isPaused = false
        
        movingObject.removeAllChildren()
        heroObject.removeAllChildren()
        
        coinObject.speed = 1
        heroObject.speed = 1
        movingObject.speed = 1
        bgObject.isPaused = false
        self.scene?.speed = 1
        
        if labelObject.children.count != 0 {
            labelObject.removeAllChildren()
        }
        
        createGround()
        createSky()
        createHero()
        createHeroemitter()
        
        score = 0
        scoreLabel.text = "0"
        stageLabel.isHidden = false
        highScoreTextLabel.isHidden = true
        showHighScore()
        
        timerAddCoin.invalidate()
        timerAddRedCoin.invalidate()
        timerAddBoneTimer.invalidate()
        timerAddSpiderTimer.invalidate()
        timerAddBee.invalidate()
        timerAddShieldItem.invalidate()
        
        timerFunc()
    }
    
    override func didFinishUpdate() {
        heroEmitter.position = hero.position - CGPoint(x: 10, y: 60)
        shield.position = hero.position + CGPoint(x: 0, y: 0)
    }

}
