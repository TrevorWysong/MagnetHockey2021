//
//  GameScene.swift
//  Pong_TW
//
//  Created by Wysong, Trevor on 4/8/20.
//  Copyright © 2020 Wysong, Trevor. All rights reserved.
//
import SpriteKit
import GameplayKit
import GoogleMobileAds

enum BodyType:UInt32
{
    //powers of 2
    case player = 1
    case sideWalls = 2
    case topBottomWalls = 128
    case ball = 512
    case goals = 4
    case playerForceField = 8
    case leftMagnet = 16
    case centerMagnet = 32
    case rightMagnet = 64
    case topGoalZone = 1024
    case bottomGoalZone = 256
}

class GameScene: SKScene, SKPhysicsContactDelegate, BottomPlayerDelegate, NorthPlayerDelegate, GADInterstitialDelegate
{
    var frameCounter = 0
    var ball : SKShapeNode?
    var ballRadius = CGFloat(0.0)
    var maxBallSpeed = CGFloat(0.0)
    var maxMagnetSpeed = CGFloat(0.0)
    var leftMagnet = SKShapeNode()
    var rightMagnet = SKShapeNode()
    var centerMagnet = SKShapeNode()
    var southLeftMagnetX = SKSpriteNode()
    var southCenterMagnetX = SKSpriteNode()
    var southRightMagnetX = SKSpriteNode()
    var northLeftMagnetX = SKSpriteNode()
    var northCenterMagnetX = SKSpriteNode()
    var northRightMagnetX = SKSpriteNode()
    var centerCircle = SKSpriteNode()
    var playerLosesBackground = SKSpriteNode()
    var playerWinsBackground = SKSpriteNode()
    var xMark = SKSpriteNode()
    var checkMark = SKSpriteNode()
    var ballInSouthGoal = false
    var ballInNorthGoal = false
    var ballSoundControl = true
    var magnetBallSoundControl = true
    var magnetHitsMagnetSoundControl = true
    var topGoal = SKSpriteNode()
    var bottomGoal = SKSpriteNode()
    var topGoalPlus = SKSpriteNode()
    var bottomGoalPlus = SKSpriteNode()
    var pauseButton = SKSpriteNode()
    var touchedPauseButton = false
    var southPlayer : BottomPlayer?
    var northPlayer : NorthPlayer?
    let gameType = UserDefaults.standard.string(forKey: "GameType")!
    let springFieldSouthPlayer = SKFieldNode.springField()
    let springFieldNorthPlayer = SKFieldNode.springField()
    let electricFieldNorthPlayer = SKFieldNode.electricField()
    let electricFieldSouthPlayer = SKFieldNode.electricField()
    let listenerNode = SKNode()
    var southPlayerArea = CGRect()
    var northPlayerArea = CGRect()
    var southPlayerMagnetCount = 0
    var northPlayerMagnetCount = 0
    var southPlayerScore = 0
    var northPlayerScore = 0
    var bottomPlayerForceForCollision = CGVector()
    var northPlayerForceForCollision = CGVector()
    let northPlayerScoreText = SKLabelNode(fontNamed: "Helvetica Neue UltraLight")
    let southPlayerScoreText = SKLabelNode(fontNamed: "Helvetica Neue UltraLight")
    var whoWonGame = ""
    var topPlayerWinsRound = false
    var bottomPlayerWinsRound = false
    var leftMagnetIsActive = true
    var centerMagnetIsActive = true
    var rightMagnetIsActive = true
    var leftMagnetJustHitGoal = false
    var centerMagnetJustHitGoal = false
    var rightMagnetJustHitGoal = false
    var gameOver = false
    var bottomTouchForCollision = false
    var northTouchForCollision = false
    var repulsionMode = false
    var numberRounds = 0
    var ballColorGame = ""
    let magnetPlayerSound = SKAction.playSoundFileNamed("Magnet Click.mp3", waitForCompletion: false)
    let playerHitBallSound = SKAction.playSoundFileNamed("ballHitsWall2.mp3", waitForCompletion: false)
    let ballHitWallSound = SKAction.playSoundFileNamed("ballHitsWall.mp3", waitForCompletion: false)
    let magnetHitsWallSound = SKAction.playSoundFileNamed("ballHitMagnet.mp3", waitForCompletion: false)
    let magnetHitsGoalSound = SKAction.playSoundFileNamed("MagnetInGoal.mp3", waitForCompletion: false)
    let goalSound = SKAction.playSoundFileNamed("Goal3.mp3", waitForCompletion: false)
    let ballHitsMagnetSound = SKAction.playSoundFileNamed("magnetHitsWallFinal", waitForCompletion: false)
    let magnetHitsMagnetSound = SKAction.playSoundFileNamed("magnetHitsWallFinal", waitForCompletion: false)
    let buttonSound = SKAction.playSoundFileNamed("ChangeRounds.mp3", waitForCompletion: false)
    var interstitialAd: GADInterstitial?
    
    func bottomTouchIsActive(_ bottomTouchIsActive: Bool, fromBottomPlayer bottomPlayer: BottomPlayer)
    {
        bottomTouchForCollision = bottomTouchIsActive
    }
    
    func northTouchIsActive(_ northTouchIsActive: Bool, fromNorthPlayer northPlayer: NorthPlayer)
    {
        northTouchForCollision = northTouchIsActive
    }
    
    func createPlayers()
    {
        southPlayerArea = CGRect(x: 0, y: 0, width: frame.width, height: frame.height/2)
        northPlayerArea = CGRect(x: 0, y: frame.height/2, width: frame.width, height: frame.height)
        
        if frame.height >= 812 && frame.height <= 900 && frame.width < 500
        {
            let southPlayerStartPoint = CGPoint(x: frame.midX, y: frame.height * 0.25)
            let northPlayerStartPoint = CGPoint(x: frame.midX, y: frame.height * 0.75)
            southPlayer = bottomPlayer(at: southPlayerStartPoint, boundary: southPlayerArea)
            northPlayer = northPlayer(at: northPlayerStartPoint, boundary: northPlayerArea)
        }
        else if frame.height == 926 && frame.width < 500
        {
            let southPlayerStartPoint = CGPoint(x: frame.midX, y: frame.height * 0.2525)
            let northPlayerStartPoint = CGPoint(x: frame.midX, y: frame.height * 0.7475)
            southPlayer = bottomPlayer(at: southPlayerStartPoint, boundary: southPlayerArea)
            northPlayer = northPlayer(at: northPlayerStartPoint, boundary: northPlayerArea)
        }
        else
        {
            let southPlayerStartPoint = CGPoint(x: frame.midX, y: frame.height * 0.2325)
            let northPlayerStartPoint = CGPoint(x: frame.midX, y: frame.height * 0.7675)
            southPlayer = bottomPlayer(at: southPlayerStartPoint, boundary: southPlayerArea)
            northPlayer = northPlayer(at: northPlayerStartPoint, boundary: northPlayerArea)
        }

        southPlayer?.physicsBody?.categoryBitMask = BodyType.player.rawValue
        northPlayer?.physicsBody?.categoryBitMask = BodyType.player.rawValue
        southPlayer?.physicsBody?.contactTestBitMask = 25
        northPlayer?.physicsBody?.contactTestBitMask = 75
        southPlayer?.physicsBody?.fieldBitMask = 45
        southPlayer?.physicsBody?.usesPreciseCollisionDetection = true
        northPlayer?.physicsBody?.usesPreciseCollisionDetection = true
    }
    
    func bottomPlayer(at position: CGPoint, boundary:CGRect) -> BottomPlayer
    {
        let bottomPlayer = BottomPlayer(activeArea: boundary)
        bottomPlayer.position = position
        bottomPlayer.delegate = self
        addChild(bottomPlayer)
        return bottomPlayer;
    }
    
    func northPlayer(at position: CGPoint, boundary:CGRect) -> NorthPlayer
    {
        let northPlayer = NorthPlayer(activeArea: boundary)
        northPlayer.position = position
        northPlayer.delegate = self
        addChild(northPlayer)
        return northPlayer;
    }
    
    func createEdges()
    {
        let leftEdge = SKSpriteNode(color: UIColor.darkGray, size: CGSize(width: CGFloat(533/10000 * frame.width), height: size.height + ((35000/400000) * frame.height)))
        leftEdge.position = CGPoint(x: 0, y: frame.height/2)
        leftEdge.zPosition = 100
        //setup physics for this edge
        leftEdge.physicsBody = SKPhysicsBody(rectangleOf: leftEdge.size)
        leftEdge.physicsBody!.isDynamic = false
        leftEdge.physicsBody?.categoryBitMask = BodyType.sideWalls.rawValue
        leftEdge.physicsBody?.contactTestBitMask = 512
        leftEdge.physicsBody?.fieldBitMask = 30
        leftEdge.physicsBody?.restitution = 1.0
        leftEdge.physicsBody?.friction = 0.0
        leftEdge.physicsBody?.linearDamping = 0.0
        leftEdge.physicsBody?.angularDamping = 0.0
        leftEdge.blendMode = .replace
        addChild(leftEdge)
        
        //copy the left edge and position it as the right edge
        let rightEdge = SKSpriteNode(color: UIColor.darkGray, size: CGSize(width: CGFloat(20/75 * frame.width), height: size.height + ((35000/400000) * frame.height)))
        rightEdge.position = CGPoint(x: size.width + (6.85/65 * (frame.width)), y: frame.height/2)
        rightEdge.zPosition = 100
        rightEdge.physicsBody = SKPhysicsBody(rectangleOf: rightEdge.size)
        rightEdge.physicsBody!.isDynamic = false
        rightEdge.physicsBody?.categoryBitMask = BodyType.sideWalls.rawValue
        rightEdge.physicsBody?.contactTestBitMask = 512
        rightEdge.physicsBody?.restitution = 1.0
        rightEdge.physicsBody?.friction = 0.0
        rightEdge.physicsBody?.linearDamping = 0.0
        rightEdge.physicsBody?.angularDamping = 0.0
        rightEdge.blendMode = .replace
        addChild(rightEdge)
        
        let bottomEdge = SKSpriteNode(color: UIColor.darkGray, size: CGSize(width: frame.width*3, height: CGFloat(14/20 * frame.width)))
        if frame.height > 800 && frame.width < 500
        {
            bottomEdge.position = CGPoint(x: 0, y: -1 * frame.height/10)
        }
        else
        {
            bottomEdge.position = CGPoint(x: 0, y: 0 - (frame.width * 6.46/20))
        }
        bottomEdge.zPosition = -5
        //setup physics for this edge
        bottomEdge.physicsBody = SKPhysicsBody(rectangleOf: bottomEdge.size)
        bottomEdge.physicsBody!.isDynamic = false
        bottomEdge.physicsBody?.mass = 10000000
        bottomEdge.physicsBody?.categoryBitMask = BodyType.topBottomWalls.rawValue
        bottomEdge.physicsBody?.contactTestBitMask = 512
        bottomEdge.physicsBody?.restitution = 1.0
        bottomEdge.physicsBody?.friction = 0.0
        bottomEdge.physicsBody?.linearDamping = 0.0
        bottomEdge.physicsBody?.angularDamping = 0.0
        bottomEdge.blendMode = .replace
        addChild(bottomEdge)
        
        let topEdge = SKSpriteNode(color: UIColor.darkGray, size: CGSize(width: frame.width*3 + ((20/100) * frame.width), height: CGFloat(55.00/100) * frame.width))
        if frame.height > 800 && frame.width < 500
        {
            topEdge.position = CGPoint(x: -1 * frame.width/10, y: frame.height + (2.02/30 * frame.height))
        }
        else
        {
            topEdge.position = CGPoint(x: 0, y: frame.height + ((9.24/37.5) * frame.width))
        }
        topEdge.zPosition = -5
        //setup physics for this edge
        topEdge.physicsBody = SKPhysicsBody(rectangleOf: topEdge.size)
        bottomEdge.physicsBody?.usesPreciseCollisionDetection = false
        topEdge.physicsBody!.isDynamic = false
        topEdge.physicsBody?.categoryBitMask = BodyType.topBottomWalls.rawValue
        topEdge.physicsBody?.contactTestBitMask = 512
        topEdge.physicsBody?.restitution = 1.0
        topEdge.physicsBody?.friction = 0.0
        topEdge.physicsBody?.linearDamping = 0.0
        topEdge.physicsBody?.angularDamping = 0.0
        topEdge.blendMode = .replace
        addChild(topEdge)
    }
    
    func createSpringFieldPlayer()
    {
        springFieldSouthPlayer.strength = 1.5
        springFieldSouthPlayer.position = CGPoint(x: southPlayer!.position.x, y: (southPlayer?.position.y)!)
        springFieldSouthPlayer.falloff = 0.0
        springFieldSouthPlayer.categoryBitMask = 5
        addChild(springFieldSouthPlayer)
        
        springFieldNorthPlayer.strength = 1.5
        springFieldNorthPlayer.position = CGPoint(x: northPlayer!.position.x, y: (northPlayer?.position.y)!)
        if frame.width > 700
        {
            springFieldSouthPlayer.region = SKRegion(size: CGSize(width: frame.width/4.5, height: frame.width/4.5))
            springFieldNorthPlayer.region = SKRegion(size: CGSize(width: frame.width/4.5, height: frame.width/4.5))
        }
        else
        {
            springFieldSouthPlayer.region = SKRegion(size: CGSize(width: frame.width/3.6, height: frame.width/3.6))
            springFieldNorthPlayer.region = SKRegion(size: CGSize(width: frame.width/3.6, height: frame.width/3.6))
        }
        springFieldNorthPlayer.falloff = 0.0
        springFieldNorthPlayer.categoryBitMask = 5
        addChild(springFieldNorthPlayer)
    }
    
    func createElectricFieldPlayer()
    {
        electricFieldNorthPlayer.strength = 1.5
        electricFieldNorthPlayer.position = CGPoint(x: northPlayer!.position.x, y: (northPlayer!.position.y))
        electricFieldNorthPlayer.falloff = 0.0
        electricFieldNorthPlayer.isEnabled = true
        electricFieldNorthPlayer.categoryBitMask = 5

        if frame.width > 700
        {
            electricFieldNorthPlayer.region = SKRegion(size: CGSize(width: frame.width/4, height: frame.width/4))
        }
        else
        {
            electricFieldNorthPlayer.region = SKRegion(size: CGSize(width: frame.width/3.2, height: frame.width/3.2))
        }
        addChild(electricFieldNorthPlayer)
        
        
        electricFieldSouthPlayer.strength = 1.5
        electricFieldSouthPlayer.position = CGPoint(x: southPlayer!.position.x, y: (southPlayer!.position.y))
        electricFieldSouthPlayer.falloff = 0.0
        electricFieldSouthPlayer.isEnabled = true
        electricFieldSouthPlayer.categoryBitMask = 5

        if frame.width > 700
        {
            electricFieldSouthPlayer.region = SKRegion(size: CGSize(width: frame.width/4, height: frame.width/4))
        }
        else
        {
            electricFieldSouthPlayer.region = SKRegion(size: CGSize(width: frame.width/3.2, height: frame.width/3.2))
        }
        addChild(electricFieldSouthPlayer)
    }
    
    func createSpringFieldTopGoal()
    {
        let springFieldTopGoal = SKFieldNode.springField()
        springFieldTopGoal.strength = 0.2
        springFieldTopGoal.position = CGPoint(x: topGoal.position.x, y: topGoal.position.y)
        if frame.width > 700
        {
            springFieldTopGoal.region = SKRegion(size: CGSize(width: frame.width/10, height: frame.width/9.1))
        }
        else
        {
            springFieldTopGoal.region = SKRegion(size: CGSize(width: frame.width/8, height: frame.width/7.75))
        }
        springFieldTopGoal.falloff = 0
        springFieldTopGoal.physicsBody?.collisionBitMask = 3
        springFieldTopGoal.physicsBody?.fieldBitMask = 3
        springFieldTopGoal.physicsBody?.contactTestBitMask = 3
        springFieldTopGoal.categoryBitMask = 64
        addChild(springFieldTopGoal)
    }
    
    func createSpringFieldBottomGoal()
    {
        let springFieldBottomGoal = SKFieldNode.springField()
        springFieldBottomGoal.strength = 0.2
        
        springFieldBottomGoal.position = CGPoint(x: bottomGoal.position.x, y: bottomGoal.position.y)
        if frame.width > 700
        {
            springFieldBottomGoal.region = SKRegion(size: CGSize(width: frame.width/10, height: frame.width/9.1))
        }
        else
        {
            springFieldBottomGoal.region = SKRegion(size: CGSize(width: frame.width/8, height: frame.width/7.75))
        }
        springFieldBottomGoal.falloff = 0
        springFieldBottomGoal.physicsBody?.collisionBitMask = 3
        springFieldBottomGoal.physicsBody?.fieldBitMask = 3
        springFieldBottomGoal.physicsBody?.contactTestBitMask = 3
        springFieldBottomGoal.categoryBitMask = 64
        addChild(springFieldBottomGoal)
    }
    
    func createCenterCircle()
    {
        if frame.width > 700
        {
            centerCircle = SKSpriteNode(imageNamed: "centerCircleFixediPadFinal.png")
            centerCircle.position = CGPoint(x: frame.width/2, y: frame.height/2)
            centerCircle.scale(to: CGSize(width: frame.width * 0.415, height: frame.width * 0.415))
        }
        else
        {
            centerCircle = SKSpriteNode(imageNamed: "centerCircleFixed.png")
            centerCircle.position = CGPoint(x: frame.width/2, y: frame.height/2)
            centerCircle.scale(to: CGSize(width: frame.width * 0.415, height: frame.width * 0.415))
        }
        centerCircle.zPosition = -100
        centerCircle.colorBlendFactor = 0.50
        addChild(centerCircle)
    }
    
   
    func createPauseButton()
    {
        pauseButton = SKSpriteNode(imageNamed: "pauseButtonBackground.png")
        pauseButton.position = CGPoint(x: frame.width * 0.90, y: frame.height * 0.50)
        pauseButton.scale(to: CGSize(width: frame.width * 0.09, height: frame.width * 0.09))
        pauseButton.colorBlendFactor = 0.40
        addChild(pauseButton)
        
        let pauseButtonSprite:SKSpriteNode!
        pauseButtonSprite = SKSpriteNode(imageNamed: "pauseButtonVertical.png")
        pauseButtonSprite.position = CGPoint(x: frame.width * 0.90, y: frame.height * 0.50)
        pauseButtonSprite.scale(to: CGSize(width: frame.width * 0.08, height: frame.width * 0.08))
        pauseButtonSprite.colorBlendFactor = 0
        pauseButtonSprite.zPosition = 1
        addChild(pauseButtonSprite)
    }
    
    func getMaxBallAndMagnetSpeed()
    {
        if frame.width > 700
        {
            maxBallSpeed = (frame.height * frame.width) / 370
            maxMagnetSpeed = 1000
        }
        else if frame.width < 700 && frame.height > 800
        {
            maxBallSpeed = (frame.height * frame.width) / 222.5
            maxMagnetSpeed = 600
        }
        else
        {
            maxBallSpeed = (frame.height * frame.width) / 195
            maxMagnetSpeed = 600
        }
    }
    
    func createPlayerLoseWinBackgrounds()
    {
        xMark = SKSpriteNode(imageNamed: "x.png")
        xMark.scale(to: CGSize(width: frame.width/4.50, height: frame.width/4.50))
        xMark.zPosition = 99
        checkMark = SKSpriteNode(imageNamed: "checkmark1.png")
        checkMark.scale(to: CGSize(width: frame.width/3.25, height: frame.width/3.25))
        checkMark.zPosition = 99
        playerWinsBackground = SKSpriteNode(imageNamed: "roundWinnerGreen.png")
        playerWinsBackground.scale(to: CGSize(width: frame.width, height: frame.height/2))
        playerLosesBackground = SKSpriteNode(imageNamed: "roundLoserRed.png")
        playerLosesBackground.scale(to: CGSize(width: frame.width, height: frame.height/2))
        playerWinsBackground.zPosition = -10
        playerLosesBackground.zPosition = -10
        playerWinsBackground.position = CGPoint(x: -1000, y: -1000)
        playerLosesBackground.position = CGPoint(x: -1000, y: -1000)
        xMark.position = CGPoint(x: -1000, y: -1000)
        checkMark.position = CGPoint(x: -1000, y: -1000)
        addChild(xMark)
        addChild(checkMark)
        addChild(playerWinsBackground)
        addChild(playerLosesBackground)
    }
    
    func updatePlayerLoseWinBackgroundsBottomPlayerWinsRound()
    {
        playerLosesBackground.position = CGPoint(x: frame.width/2, y: frame.height * (3/4))
        playerWinsBackground.position = CGPoint(x: frame.width/2, y: frame.height/4)
        checkMark.position = CGPoint(x: frame.width/2, y: frame.height * 0.30)
        xMark.position = CGPoint(x: frame.width/2, y: frame.height * 0.70)
        checkMark.zRotation = 0

    }
    
    func updatePlayerLoseWinBackgroundsTopPlayerWinsRound()
    {
        playerWinsBackground.position = CGPoint(x: frame.width/2, y: frame.height * (3/4))
        playerLosesBackground.position = CGPoint(x: frame.width/2, y: frame.height/4)
        xMark.position = CGPoint(x: frame.width/2, y: frame.height * 0.30)
        checkMark.position = CGPoint(x: frame.width/2, y: frame.height * 0.70)
        checkMark.zRotation = .pi
    }
    
    func resetPlayerLoseWinBackground()
    {
        playerWinsBackground.position = CGPoint(x: -1000, y: -1000)
        playerLosesBackground.position = CGPoint(x: -1000, y: -1000)
        xMark.position = CGPoint(x: -1000, y: -1000)
        checkMark.position = CGPoint(x: -1000, y: -1000)
    }
    
    func createMagnets()
    {
        //create ball object
        leftMagnet = SKShapeNode()
        centerMagnet = SKShapeNode()
        rightMagnet = SKShapeNode()
        
        //draw left magnet
        let leftMagnetPath = CGMutablePath()
        let π = CGFloat.pi
        var leftMagnetRadius = CGFloat(0.0)
        var centerMagnetRadius = CGFloat(0.0)
        var rightMagnetRadius = CGFloat(0.0)
        if frame.width < 700
        {
            leftMagnetRadius = frame.width / 40
            centerMagnetRadius = frame.width / 40
            rightMagnetRadius = frame.width / 40
        }
        else if frame.width >= 700
        {
            
            leftMagnetRadius = frame.width / 50
            centerMagnetRadius = frame.width / 50
            rightMagnetRadius = frame.width / 50
        }

        leftMagnet.fillTexture = SKTexture(imageNamed: "newMagnetSmaller.png")
        leftMagnetPath.addArc(center: CGPoint(x: 0, y:0), radius: leftMagnetRadius, startAngle: 0, endAngle: π*2, clockwise: true)
        leftMagnet.path = leftMagnetPath
        leftMagnet.fillColor = UIColor.white
        //set ball physics properties
        leftMagnet.physicsBody = SKPhysicsBody(circleOfRadius: leftMagnetRadius)
        //how heavy it is
        leftMagnet.physicsBody!.mass = 0.04
        leftMagnet.physicsBody!.affectedByGravity = false
        leftMagnet.physicsBody?.allowsRotation = true
        //how much momentum is maintained after it hits somthing
        leftMagnet.physicsBody!.restitution = 1
        leftMagnet.position = CGPoint(x: frame.width * 1.5/5, y: frame.height/2)
        //how much friction affects it
        leftMagnet.physicsBody!.linearDamping = 0.85
        leftMagnet.physicsBody!.angularDamping = 0.85
        leftMagnet.physicsBody?.categoryBitMask = BodyType.leftMagnet.rawValue
        leftMagnet.physicsBody?.fieldBitMask = 4294967295
        leftMagnet.strokeColor = .black
        leftMagnet.lineWidth = 0.5
        //if not alreay in scene, add to scene
        if leftMagnet.parent == nil
        {
            addChild(leftMagnet)
        }
        
        //draw center magnet
        let centerMagnetPath = CGMutablePath()
        centerMagnet.fillTexture = SKTexture(imageNamed: "newMagnetSmaller.png")
        centerMagnetPath.addArc(center: CGPoint(x: 0, y:0), radius: centerMagnetRadius, startAngle: 0, endAngle: π*2, clockwise: true)
        centerMagnet.path = centerMagnetPath
        centerMagnet.fillColor = UIColor.white
        //set ball physics properties
        centerMagnet.physicsBody = SKPhysicsBody(circleOfRadius: centerMagnetRadius)
        //how heavy it is
        centerMagnet.physicsBody!.mass = 0.04
        centerMagnet.physicsBody!.affectedByGravity = false
        centerMagnet.physicsBody?.allowsRotation = true
        //how much momentum is maintained after it hits somthing
        centerMagnet.physicsBody!.restitution = 1.0
        centerMagnet.position = CGPoint(x: frame.width/2, y: frame.height/2)
        //how much friction affects it
        centerMagnet.physicsBody!.linearDamping = 0.85
        centerMagnet.physicsBody!.angularDamping = 0.85
        centerMagnet.physicsBody?.fieldBitMask = 4294967295
        centerMagnet.strokeColor = .black
        centerMagnet.lineWidth = 0.5
        //if not alreay in scene, add to scene
        if centerMagnet.parent == nil
        {
            addChild(centerMagnet)
        }
        
        //draw right magnet
        let rightMagnetPath = CGMutablePath()
        rightMagnet.fillTexture = SKTexture(imageNamed: "newMagnetSmaller.png")

        rightMagnetPath.addArc(center: CGPoint(x: 0, y:0), radius: rightMagnetRadius, startAngle: 0, endAngle: π*2, clockwise: true)
        rightMagnet.path = rightMagnetPath
        rightMagnet.fillColor = UIColor.white
        //set ball physics properties
        rightMagnet.physicsBody = SKPhysicsBody(circleOfRadius: rightMagnetRadius)
        //how heavy it is
        rightMagnet.physicsBody!.mass = 0.04
        rightMagnet.physicsBody!.affectedByGravity = false
        rightMagnet.physicsBody?.allowsRotation = true
        //how much momentum is maintained after it hits somthing
        rightMagnet.physicsBody!.restitution = 1.0
        rightMagnet.position = CGPoint(x: frame.width*(3.5/5), y: frame.height/2)
        //how much friction affects it
        rightMagnet.physicsBody!.linearDamping = 0.85
        rightMagnet.physicsBody!.angularDamping = 0.85
        rightMagnet.physicsBody?.fieldBitMask = 4294967295
        rightMagnet.strokeColor = .black
        rightMagnet.lineWidth = 0.5
        //if not alreay in scene, add to scene
        if rightMagnet.parent == nil
        {
            addChild(rightMagnet)
        }
        
        leftMagnet.physicsBody?.collisionBitMask = 4294967295
        centerMagnet.physicsBody?.collisionBitMask = 4294967295
        rightMagnet.physicsBody?.collisionBitMask = 4294967295
        leftMagnet.physicsBody?.contactTestBitMask = 4294967295
        centerMagnet.physicsBody?.contactTestBitMask = 4294967295
        rightMagnet.physicsBody?.contactTestBitMask = 4294967295
        leftMagnet.physicsBody?.categoryBitMask = BodyType.leftMagnet.rawValue
        centerMagnet.physicsBody?.categoryBitMask = BodyType.centerMagnet.rawValue
        rightMagnet.physicsBody?.categoryBitMask = BodyType.rightMagnet.rawValue
        
        if UserDefaults.standard.string(forKey: "GameType") == "RepulsionMode"
        {
            leftMagnet.physicsBody?.charge = 0.70
            centerMagnet.physicsBody?.charge = 0.70
            rightMagnet.physicsBody?.charge = 0.70
        }
    }
    
    func createMagnetHolders()
    {
        let leftMagnetHolder = SKSpriteNode(imageNamed: "magnetSpots.png")
        let rightMagnetHolder = SKSpriteNode(imageNamed: "magnetSpots.png")
        let centerMagnetHolder = SKSpriteNode(imageNamed: "magnetSpots.png")
        leftMagnetHolder.position = CGPoint(x: frame.width * (1.5/5), y: frame.height/2)
        centerMagnetHolder.position = CGPoint(x: frame.width/2, y: frame.height/2)
        rightMagnetHolder.position = CGPoint(x: frame.width*(3.5/5), y: frame.height/2)
        leftMagnetHolder.zPosition = -1
        centerMagnetHolder.zPosition = -1
        rightMagnetHolder.zPosition = -1
        if frame.width > 700
        {
            leftMagnetHolder.size = CGSize(width: 1/20 * frame.width, height: 1/20 * frame.width)
            centerMagnetHolder.size = CGSize(width: 1/20 * frame.width, height: 1/20 * frame.width)
            rightMagnetHolder.size = CGSize(width: 1/20 * frame.width, height: 1/20 * frame.width)
        }
        else
        {
            leftMagnetHolder.size = CGSize(width: 1/16 * frame.width, height: 1/16 * frame.width)
            centerMagnetHolder.size = CGSize(width: 1/16 * frame.width, height: 1/16 * frame.width)
            rightMagnetHolder.size = CGSize(width: 1/16 * frame.width, height: 1/16 * frame.width)
        }
        addChild(leftMagnetHolder)
        addChild(centerMagnetHolder)
        addChild(rightMagnetHolder)
    }
    
    func createMagnetXMarks()
    {
        southLeftMagnetX = SKSpriteNode(imageNamed: "magnetHitMarkerNew.png")
        southCenterMagnetX = SKSpriteNode(imageNamed: "magnetHitMarkerNew.png")
        southRightMagnetX = SKSpriteNode(imageNamed: "magnetHitMarkerNew.png")
        northLeftMagnetX = SKSpriteNode(imageNamed: "magnetHitMarkerNew.png")
        northCenterMagnetX = SKSpriteNode(imageNamed: "magnetHitMarkerNew.png")
        northRightMagnetX = SKSpriteNode(imageNamed: "magnetHitMarkerNew.png")
        
        southLeftMagnetX.zPosition = -1
        southCenterMagnetX.zPosition = -1
        southRightMagnetX.zPosition = -1
        northLeftMagnetX.zPosition = -1
        northCenterMagnetX.zPosition = -1
        northRightMagnetX.zPosition = -1

        if frame.height == 812 && frame.width < 500
        {
            southLeftMagnetX.size = CGSize(width: 1/16 * frame.width, height: 1/16 * frame.width)
            southCenterMagnetX.size = CGSize(width: 1/16 * frame.width, height: 1/16 * frame.width)
            southRightMagnetX.size = CGSize(width: 1/16 * frame.width, height: 1/16 * frame.width)
            northLeftMagnetX.size = CGSize(width: 1/16 * frame.width, height: 1/16 * frame.width)
            northCenterMagnetX.size = CGSize(width: 1/16 * frame.width, height: 1/16 * frame.width)
            northRightMagnetX.size = CGSize(width: 1/16 * frame.width, height: 1/16 * frame.width)
            southLeftMagnetX.position = CGPoint(x: frame.width * 1 / 11, y: frame.width/14)
            southCenterMagnetX.position = CGPoint(x: frame.width * 1.75 / 11, y: frame.width/14)
            southRightMagnetX.position = CGPoint(x: frame.width * 2.5 / 11, y: frame.width/14)
            northLeftMagnetX.position = CGPoint(x: frame.width*(10/11), y: frame.height - frame.width/17)
            northCenterMagnetX.position = CGPoint(x: frame.width * (9.25/11), y: frame.height - frame.width/17)
            northRightMagnetX.position = CGPoint(x: frame.width * 8 / 11, y: -200)
        }
        else
        {
            southLeftMagnetX.size = CGSize(width: 1/12 * frame.width, height: 1/12 * frame.width)
            southCenterMagnetX.size = CGSize(width: 1/12 * frame.width, height: 1/12 * frame.width)
            southRightMagnetX.size = CGSize(width: 1/12 * frame.width, height: 1/12 * frame.width)
            northLeftMagnetX.size = CGSize(width: 1/12 * frame.width, height: 1/12 * frame.width)
            northCenterMagnetX.size = CGSize(width: 1/12 * frame.width, height: 1/12 * frame.width)
            northRightMagnetX.size = CGSize(width: 1/12 * frame.width, height: 1/12 * frame.width)
            southLeftMagnetX.position = CGPoint(x: frame.width/11, y: frame.width/12)
            southCenterMagnetX.position = CGPoint(x: frame.width/5.5, y: frame.width/12)
            southRightMagnetX.position = CGPoint(x: frame.width/3.65, y: frame.width/12)
            northLeftMagnetX.position = CGPoint(x: frame.width*(10/11), y: frame.height - frame.width/12)
            northCenterMagnetX.position = CGPoint(x: frame.width * 4.5/5.5, y: frame.height - frame.width/12)
            northRightMagnetX.position = CGPoint(x: frame.width * 4/5.5, y: frame.height - frame.width/12)
        }
        southLeftMagnetX.isHidden = true
        southCenterMagnetX.isHidden = true
        southRightMagnetX.isHidden = true
        northLeftMagnetX.isHidden = true
        northCenterMagnetX.isHidden = true
        northRightMagnetX.isHidden = true
        
        addChild(southLeftMagnetX)
        addChild(southCenterMagnetX)
        addChild(southRightMagnetX)
        addChild(northLeftMagnetX)
        addChild(northCenterMagnetX)
        addChild(northRightMagnetX)
    }

    
    func placeMagnetXMarks()
    {
        if southPlayerMagnetCount >= 1
        {
            southLeftMagnetX.isHidden = false
        }
        if southPlayerMagnetCount >= 2
        {
            southCenterMagnetX.isHidden = false
        }
        if southPlayerMagnetCount == 3
        {
            southRightMagnetX.isHidden = false
        }
        
        if northPlayerMagnetCount >= 1
        {
            northLeftMagnetX.isHidden = false
        }
        if northPlayerMagnetCount >= 2
        {
            northCenterMagnetX.isHidden = false
        }
        if northPlayerMagnetCount == 3
        {
            northRightMagnetX.isHidden = false
        }
    }
    
    func createGoals()
    {
        topGoal = SKSpriteNode(imageNamed: "goal.png")
        bottomGoal = SKSpriteNode(imageNamed: "goal.png")
        if frame.height > 800 && frame.width < 500
        {
            topGoal.position = CGPoint(x: frame.width/2, y: frame.height * 0.84)
            bottomGoal.position = CGPoint(x: frame.width/2, y: frame.height * 0.16)
            topGoal.scale(to: CGSize(width: frame.width/6, height: frame.width/6))
            bottomGoal.scale(to: CGSize(width: frame.width/6, height: frame.width/6))
        }
        else if frame.width > 700
        {
            topGoal.position = CGPoint(x: frame.width/2, y: frame.height*(8.7/10))
            bottomGoal.position = CGPoint(x: frame.width/2, y: frame.height * 1.30/10)
            topGoal.scale(to: CGSize(width: frame.width/7.5, height: frame.width/7.5))
            bottomGoal.scale(to: CGSize(width: frame.width/7.5, height: frame.width/7.5))
        }
        else
        {
            topGoal.position = CGPoint(x: frame.width/2, y: frame.height * 0.87)
            bottomGoal.position = CGPoint(x: frame.width/2, y: frame.height * 0.13)
            topGoal.scale(to: CGSize(width: frame.width/6, height: frame.width/6))
            bottomGoal.scale(to: CGSize(width: frame.width/6, height: frame.width/6))
        }
        
        if frame.width > 700
        {
            topGoal.scale(to: CGSize(width: frame.width/7.5, height: frame.width/7.5))
            bottomGoal.scale(to: CGSize(width: frame.width/7.5, height: frame.width/7.5))
        }
        else
        {
            topGoal.scale(to: CGSize(width: frame.width/6, height: frame.width/6))
            bottomGoal.scale(to: CGSize(width: frame.width/6, height: frame.width/6))
        }
        
        topGoal.zPosition = -1
        bottomGoal.zPosition = -1
        //Plus is for the goal sprites detecting collision in the goal
        topGoalPlus = SKSpriteNode(imageNamed: "plus.png")
        bottomGoalPlus = SKSpriteNode(imageNamed: "plus.png")
        topGoalPlus.position = CGPoint(x: topGoal.position.x, y: topGoal.position.y)
        bottomGoalPlus.position = CGPoint(x: bottomGoal.position.x, y: bottomGoal.position.y)
        
        if frame.width > 700
        {
            topGoalPlus.scale(to: CGSize(width: frame.width/50, height: frame.width/50))
            bottomGoalPlus.scale(to: CGSize(width: frame.width/50, height: frame.width/50))
        }
        else
        {
            topGoalPlus.scale(to: CGSize(width: frame.width/40, height: frame.width/40))
            bottomGoalPlus.scale(to: CGSize(width: frame.width/40, height: frame.width/40))
        }
        
        // Set on same Z level as sprites
        topGoalPlus.zPosition = 0
        bottomGoalPlus.zPosition = 0
        // Assign Collision category masks
        topGoalPlus.physicsBody = SKPhysicsBody(circleOfRadius: max(topGoalPlus.size.width / 2, topGoalPlus.size.height / 2))
        bottomGoalPlus.physicsBody = SKPhysicsBody(circleOfRadius: max(bottomGoalPlus.size.width / 2, bottomGoalPlus.size.height / 2))
        topGoalPlus.physicsBody?.affectedByGravity = false
        bottomGoalPlus.physicsBody?.affectedByGravity = false
        topGoalPlus.physicsBody?.isDynamic = false
        bottomGoalPlus.physicsBody?.isDynamic = false
        topGoalPlus.physicsBody?.allowsRotation = false
        bottomGoalPlus.physicsBody?.allowsRotation = false

        topGoalPlus.physicsBody?.categoryBitMask = BodyType.topGoalZone.rawValue
        bottomGoalPlus.physicsBody?.categoryBitMask = BodyType.bottomGoalZone.rawValue
        topGoalPlus.physicsBody?.fieldBitMask = 4294967295
        bottomGoalPlus.physicsBody?.fieldBitMask = 4294967295
        bottomGoalPlus.physicsBody?.contactTestBitMask = BodyType.ball.rawValue
        topGoalPlus.physicsBody?.contactTestBitMask = BodyType.ball.rawValue
        bottomGoalPlus.physicsBody?.collisionBitMask = 4294967295
        topGoalPlus.physicsBody?.collisionBitMask = 4294967295
        
        addChild(topGoal)
        addChild(bottomGoal)
        addChild(topGoalPlus)
        addChild(bottomGoalPlus)
    }
    
    func createAndLoadInterstitial() -> GADInterstitial
    {
        let request = GADRequest()
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-9321678829614862/2075742650")
        interstitial.delegate = self
        interstitial.load(request)
        return interstitial
    }
    
    override func didMove(to view: SKView)
    {
        let bannerViewStartScene = self.view?.viewWithTag(100) as! GADBannerView?
        let bannerViewGameOverScene = self.view?.viewWithTag(101) as! GADBannerView?
        let bannerViewInfoScene = self.view?.viewWithTag(102) as! GADBannerView?
        let bannerViewSettingsScene = self.view?.viewWithTag(103) as! GADBannerView?
        bannerViewStartScene?.isHidden = true
        bannerViewGameOverScene?.isHidden = true
        bannerViewInfoScene?.isHidden = true
        bannerViewSettingsScene?.isHidden = true
        
        self.physicsWorld.contactDelegate = self
        backgroundColor = SKColor.systemTeal
 
        if UserDefaults.standard.integer(forKey: "Rounds") > 0
        {
            numberRounds = UserDefaults.standard.integer(forKey: "Rounds")
        }
        else
        {
            numberRounds = 9
            UserDefaults.standard.set(9, forKey: "Rounds")
            UserDefaults.standard.synchronize()
        }
        
        if UserDefaults.standard.string(forKey: "BallColor") == "Yellow Ball" || UserDefaults.standard.string(forKey: "BallColor") == "Black Ball" || UserDefaults.standard.string(forKey: "BallColor") == "Blue Ball" || UserDefaults.standard.string(forKey: "BallColor") == "Red Ball" || UserDefaults.standard.string(forKey: "BallColor") == "Orange Ball" ||
            UserDefaults.standard.string(forKey: "BallColor") == "Pink Ball" ||
            UserDefaults.standard.string(forKey: "BallColor") == "Purple Ball" ||
            UserDefaults.standard.string(forKey: "BallColor") == "Green Ball"
        {
            ballColorGame = UserDefaults.standard.string(forKey: "BallColor")!
        }
        else
        {
            ballColorGame = "Yellow Ball"
            UserDefaults.standard.set("Yellow", forKey: "BallColor")
            UserDefaults.standard.synchronize()
        }

        if UserDefaults.standard.bool(forKey: "Purchase") != true
        {
            interstitialAd = createAndLoadInterstitial()
        }
        
        drawCenterLine()
        getMaxBallAndMagnetSpeed()
        createCenterCircle()
        createPauseButton()
        createPlayers()
        createMagnets()
        createMagnetHolders()
        createGoals()
        createBall()
        createPlayerLoseWinBackgrounds()
        createNorthPlayerScore()
        createSouthPlayerScore()
        createEdges()
        createSpringFieldTopGoal()
        createMagnetXMarks()
        createSpringFieldBottomGoal()
        createSpringFieldPlayer()
        createPlayerLoseWinBackgrounds()
        if UserDefaults.standard.string(forKey: "GameType") == "RepulsionMode"
        {
            createElectricFieldPlayer()
            repulsionMode = true
        }
    }
    
    func drawCenterLine()
    {
        var centerLine = SKSpriteNode()
        if frame.width > 700
        {
            centerLine = SKSpriteNode(color: UIColor.black, size: CGSize(width: size.width, height: frame.width/102.5))
        }
        else
        {
            centerLine = SKSpriteNode(color: UIColor.black, size: CGSize(width: size.width, height: frame.width/82))
        }
        centerLine.position = CGPoint(x: size.width/2, y: size.height/2)
        centerLine.colorBlendFactor = 0.75;
        centerLine.zPosition = -2
        addChild(centerLine)
    }
    
    func createBall()
    {
        if  ball == nil
        {
            //create ball object
            ball = SKShapeNode()
            
            //draw ball
            let ballPath = CGMutablePath()
            let π = CGFloat.pi
            var ballRadius = CGFloat(0.0)
            if frame.width < 700
            {
                ballRadius = frame.width / 20
            }
            else if frame.width >= 700
            {
                ballRadius = frame.width / 25
            }
            ballPath.addArc(center: CGPoint(x: 0, y:0), radius: ballRadius, startAngle: 0, endAngle: π*2, clockwise: true)
            ball!.path = ballPath
            ball!.lineWidth = 0
            if ballColorGame == "Black Ball"
            {
                ball!.fillColor = UIColor.black
            }
            else if ballColorGame == "Blue Ball"
            {
                ball!.fillColor = UIColor.blue
            }
            else if ballColorGame == "Orange Ball"
            {
                ball!.fillColor = UIColor.orange
            }
            else if ballColorGame == "Pink Ball"
            {
                ball!.fillColor = UIColor.systemPink
            }
            else if ballColorGame == "Purple Ball"
            {
                ball!.fillColor = UIColor.purple
            }
            else if ballColorGame == "Green Ball"
            {
                ball!.fillColor = UIColor.green
            }
            else if ballColorGame == "Red Ball"
            {
                ball!.fillColor = UIColor.red
            }
            else
            {
                ball!.fillColor = UIColor.yellow
            }
            
            //set ball physics properties
            ball!.physicsBody = SKPhysicsBody(circleOfRadius: ballRadius)
            
            //how heavy it is
            ball!.physicsBody!.mass = 0.015
            ball?.physicsBody?.friction = 0.10
            ball!.physicsBody!.affectedByGravity = false
            
            //how much momentum is maintained after it hits somthing
            ball!.physicsBody!.restitution = 1.00
            
            //how much friction affects it
            ball!.physicsBody!.linearDamping = 0.90
            ball!.physicsBody!.angularDamping = 0.90

            ball?.physicsBody?.categoryBitMask = BodyType.ball.rawValue
            ball?.physicsBody?.fieldBitMask = 640
            ball?.physicsBody?.contactTestBitMask = BodyType.player.rawValue
            ball?.lineWidth = 2
            ball?.strokeColor = .black
        }
        
        
        
        let ySpawnsArray = [frame.height * 0.35, frame.height * 0.65]
        ball!.position = CGPoint(x: frame.width/2, y: ySpawnsArray.randomElement()!)
        ball!.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
        ball?.physicsBody?.affectedByGravity = false
        ball?.strokeColor = UIColor.black

        //if not alreay in scene, add to scene
        if ball!.parent == nil
        {
            addChild(ball!)
        }
    }
    
    func clearBall()
    {
        ball!.position = CGPoint(x: -200, y: -200)
        ball!.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
    }
    
    func resetBallTopPlayerBallStart()
    {
        ball!.position = CGPoint(x: frame.width/2, y: size.height * (0.65))
        ball!.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
    }
    
    func resetBallBottomPlayerBallStart()
    {
        ball!.position = CGPoint(x: frame.width/2, y: size.height * 0.35)
        ball!.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
    }
    
    func resetBallStart()
    {
        ball!.position = CGPoint(x: 50, y: size.height/2)
    }
    
    func clearMagnets()
    {
        leftMagnet.position = CGPoint(x: frame.width + 2/3 * frame.width, y: -200)
        leftMagnet.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        centerMagnet.position = CGPoint(x: frame.width + 2/3 * frame.width, y: -200)
        centerMagnet.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        rightMagnet.position = CGPoint(x: frame.width + 2/3 * frame.width, y: -200)
        rightMagnet.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
    }
    
    
    func resetMagnets()
    {
        leftMagnet.position = CGPoint(x: frame.width * (1.5/5), y: frame.height/2)
        leftMagnet.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        centerMagnet.position = CGPoint(x: frame.width/2, y: frame.height/2)
        centerMagnet.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        rightMagnet.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        rightMagnet.position = CGPoint(x: frame.width*(3.5/5), y: frame.height/2)
    }
    
    func clearPlayer()
    {
        southPlayer?.isHidden = true
        northPlayer?.isHidden = true
    }
     
    func resetPlayer()
    {
        
        if frame.height >= 812  && frame.height <= 900 && frame.width < 500
        {
            southPlayer?.position = CGPoint(x: self.frame.midX, y: self.size.height * 0.25)
            northPlayer?.position = CGPoint(x: self.frame.midX, y: self.size.height * 0.75)
        }
        else if frame.height == 926 && frame.width < 500
        {
            southPlayer?.position = CGPoint(x: self.frame.midX, y: self.size.height * 0.2525)
            northPlayer?.position = CGPoint(x: self.frame.midX, y: self.size.height * 0.7475)
        }
        else
        {
            southPlayer?.position = CGPoint(x: self.frame.midX, y: self.size.height * 0.2325)
            northPlayer?.position = CGPoint(x: self.frame.midX, y: self.size.height * 0.7675)
        }
        southPlayer?.isHidden = false
        northPlayer?.isHidden = false
    }
    
    func resetMagnetHitMarkers()
    {
        southLeftMagnetX.isHidden = true
        southCenterMagnetX.isHidden = true
        southRightMagnetX.isHidden = true
        northLeftMagnetX.isHidden = true
        northCenterMagnetX.isHidden = true
        northRightMagnetX.isHidden = true
    }
    
    func isOffScreen(node: SKShapeNode) -> Bool
    {
        return !frame.contains(node.position)
    }
    
    func didBegin(_ contact: SKPhysicsContact)
    {
        if (contact.bodyA.categoryBitMask == BodyType.ball.rawValue && contact.bodyB.categoryBitMask == BodyType.player.rawValue) && (contact.bodyA.contactTestBitMask == 25 || contact.bodyB.contactTestBitMask == 25) && bottomTouchForCollision == true
        {
            let vmallet = CGVector(dx: CGFloat(UserDefaults.standard.float(forKey: "BottomForceDX")), dy: CGFloat(UserDefaults.standard.float(forKey: "BottomForceDY")))
//            let vball = ball!.physicsBody!.velocity
            let vball = CGVector(dx: 0, dy: 0)
            let vrelativedx = vball.dx - vmallet.dx
            let vrelativedy = vball.dy - vmallet.dy
            let vrelative = CGVector(dx: vrelativedx, dy: vrelativedy)
            let c = (vrelative.dx * contact.contactNormal.dx) + (vrelative.dy * contact.contactNormal.dy)
            let vperpendicular = CGVector(dx: contact.contactNormal.dx * c, dy: contact.contactNormal.dy * c)
            let vtangential = CGVector(dx: vrelative.dx - vperpendicular.dx, dy: vrelative.dy - vperpendicular.dy)
            // vtangential is unchanged in the collision, vperpendicular reflects
            let newvrelative = CGVector(dx: vtangential.dx - vperpendicular.dx, dy: vtangential.dy - vperpendicular.dy)
            let newvball = CGVector(dx: newvrelative.dx + vmallet.dx, dy: newvrelative.dy + vmallet.dy)
            
            ball!.physicsBody!.applyImpulse(newvball)
            
            if ballSoundControl == true && topPlayerWinsRound == false && bottomPlayerWinsRound == false
            {
                ballSoundControl = false
                if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(playerHitBallSound)}
                Timer.scheduledTimer(withTimeInterval: 0.05, repeats: false, block: { timer in
                    self.ballSoundControl = true
                })
            }
        }
        if (contact.bodyA.categoryBitMask == BodyType.ball.rawValue && contact.bodyB.categoryBitMask == BodyType.player.rawValue) && (contact.bodyA.contactTestBitMask == 25 || contact.bodyB.contactTestBitMask == 25) && bottomTouchForCollision == false
        {
            if ballSoundControl == true && topPlayerWinsRound == false && bottomPlayerWinsRound == false
            {
                ballSoundControl = false
                if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(playerHitBallSound)}
                Timer.scheduledTimer(withTimeInterval: 0.05, repeats: false, block: { timer in
                    self.ballSoundControl = true
                })
            }
        }
        
        if (contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.ball.rawValue) && (contact.bodyA.contactTestBitMask == 25 || contact.bodyB.contactTestBitMask == 25) && bottomTouchForCollision == true
        {
            let vmallet = CGVector(dx: CGFloat(UserDefaults.standard.float(forKey: "BottomForceDX")), dy: CGFloat(UserDefaults.standard.float(forKey: "BottomForceDY")))
            let vball = CGVector(dx: 0, dy: 0)
            let vrelativedx = vball.dx - vmallet.dx
            let vrelativedy = vball.dy - vmallet.dy
            let vrelative = CGVector(dx: vrelativedx, dy: vrelativedy)
            let c = (vrelative.dx * contact.contactNormal.dx) + (vrelative.dy * contact.contactNormal.dy)
            let vperpendicular = CGVector(dx: contact.contactNormal.dx * c, dy: contact.contactNormal.dy * c)
            let vtangential = CGVector(dx: vrelative.dx - vperpendicular.dx, dy: vrelative.dy - vperpendicular.dy)
            // vtangential is unchanged in the collision, vperpendicular reflects
            let newvrelative = CGVector(dx: vtangential.dx - vperpendicular.dx, dy: vtangential.dy - vperpendicular.dy)
            let newvball = CGVector(dx: newvrelative.dx + vmallet.dx, dy: newvrelative.dy + vmallet.dy)
            // set ball velocity to newvball
            ball!.physicsBody!.applyImpulse(newvball)
            
            if ballSoundControl == true && topPlayerWinsRound == false && bottomPlayerWinsRound == false
            {
                ballSoundControl = false
                if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(playerHitBallSound)}
                Timer.scheduledTimer(withTimeInterval: 0.05, repeats: false, block: { timer in
                    self.ballSoundControl = true
                })
            }
        }
        
        if (contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.ball.rawValue) && (contact.bodyA.contactTestBitMask == 25 || contact.bodyB.contactTestBitMask == 25) && bottomTouchForCollision == false
        {
            if ballSoundControl == true && topPlayerWinsRound == false && bottomPlayerWinsRound == false
            {
                ballSoundControl = false
                if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(playerHitBallSound)}
                Timer.scheduledTimer(withTimeInterval: 0.05, repeats: false, block: { timer in
                    self.ballSoundControl = true
                })
            }
        }
        
        if (contact.bodyA.categoryBitMask == BodyType.ball.rawValue && contact.bodyB.categoryBitMask == BodyType.player.rawValue) && (contact.bodyA.contactTestBitMask == 75 || contact.bodyB.contactTestBitMask == 75) && northTouchForCollision == true
        {
            let vmallet = CGVector(dx: CGFloat(UserDefaults.standard.float(forKey: "NorthForceDX")), dy: CGFloat(UserDefaults.standard.float(forKey: "NorthForceDY")))
            let vball = CGVector(dx: 0, dy: 0)
            let vrelativedx = vball.dx - vmallet.dx
            let vrelativedy = vball.dy - vmallet.dy
            let vrelative = CGVector(dx: vrelativedx, dy: vrelativedy)
            let c = (vrelative.dx * contact.contactNormal.dx) + (vrelative.dy * contact.contactNormal.dy)
            let vperpendicular = CGVector(dx: contact.contactNormal.dx * c, dy: contact.contactNormal.dy * c)
            let vtangential = CGVector(dx: vrelative.dx - vperpendicular.dx, dy: vrelative.dy - vperpendicular.dy)
            // vtangential is unchanged in the collision, vperpendicular reflects
            let newvrelative = CGVector(dx: vtangential.dx - vperpendicular.dx, dy: vtangential.dy - vperpendicular.dy)
            let newvball = CGVector(dx: newvrelative.dx + vmallet.dx, dy: newvrelative.dy + vmallet.dy)
            // set ball velocity to newvball
            ball!.physicsBody!.applyImpulse(newvball)
            
            if ballSoundControl == true && topPlayerWinsRound == false && bottomPlayerWinsRound == false
            {
                ballSoundControl = false
                if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(playerHitBallSound)}
                Timer.scheduledTimer(withTimeInterval: 0.05, repeats: false, block: { timer in
                    self.ballSoundControl = true
                })
            }
        }
        if (contact.bodyA.categoryBitMask == BodyType.ball.rawValue && contact.bodyB.categoryBitMask == BodyType.player.rawValue) && (contact.bodyA.contactTestBitMask == 75 || contact.bodyB.contactTestBitMask == 75) && northTouchForCollision == false
        {
            if ballSoundControl == true && topPlayerWinsRound == false && bottomPlayerWinsRound == false
            {
                ballSoundControl = false
                if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(playerHitBallSound)}
                Timer.scheduledTimer(withTimeInterval: 0.05, repeats: false, block: { timer in
                    self.ballSoundControl = true
                })
            }
        }
        
        if (contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.ball.rawValue) && (contact.bodyA.contactTestBitMask == 75 || contact.bodyB.contactTestBitMask == 75) && northTouchForCollision == true
        {
            let vmallet = CGVector(dx: CGFloat(UserDefaults.standard.float(forKey: "NorthForceDX")), dy: CGFloat(UserDefaults.standard.float(forKey: "NorthForceDY")))
//            let vball = ball!.physicsBody!.velocity
            let vball = CGVector(dx: 0, dy: 0)
            let vrelativedx = vball.dx - vmallet.dx
            let vrelativedy = vball.dy - vmallet.dy
            let vrelative = CGVector(dx: vrelativedx, dy: vrelativedy)
            let c = (vrelative.dx * contact.contactNormal.dx) + (vrelative.dy * contact.contactNormal.dy)
            let vperpendicular = CGVector(dx: contact.contactNormal.dx * c, dy: contact.contactNormal.dy * c)
            let vtangential = CGVector(dx: vrelative.dx - vperpendicular.dx, dy: vrelative.dy - vperpendicular.dy)
            // vtangential is unchanged in the collision, vperpendicular reflects
            let newvrelative = CGVector(dx: vtangential.dx - vperpendicular.dx, dy: vtangential.dy - vperpendicular.dy)
            let newvball = CGVector(dx: newvrelative.dx + vmallet.dx, dy: newvrelative.dy + vmallet.dy)
            // set ball velocity to newvball
            ball!.physicsBody!.applyImpulse(newvball)
            
            if ballSoundControl == true && topPlayerWinsRound == false && bottomPlayerWinsRound == false
            {
                ballSoundControl = false
                if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(playerHitBallSound)}
                Timer.scheduledTimer(withTimeInterval: 0.05, repeats: false, block: { timer in
                    self.ballSoundControl = true
                })
            }
        }
        if (contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.ball.rawValue) && (contact.bodyA.contactTestBitMask == 75 || contact.bodyB.contactTestBitMask == 75) && northTouchForCollision == false
        {
            if ballSoundControl == true && topPlayerWinsRound == false && bottomPlayerWinsRound == false
            {
                ballSoundControl = false
                if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(playerHitBallSound)}
                Timer.scheduledTimer(withTimeInterval: 0.05, repeats: false, block: { timer in
                    self.ballSoundControl = true
                })
            }
        }
        
        // Ball Collision detect with wall to prevent sticking (SpriteKit Issue)
        if (contact.bodyA.categoryBitMask == BodyType.ball.rawValue && contact.bodyB.categoryBitMask == BodyType.sideWalls.rawValue)
        {
            let strength = 1.0 * ((ball?.position.x)! < frame.width / 2 ? 1 : -1)
            let body = ball?.physicsBody
            body!.applyImpulse(CGVector(dx: strength, dy: 0))
            if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(ballHitWallSound)}
        }
        else if (contact.bodyA.categoryBitMask == BodyType.sideWalls.rawValue && contact.bodyB.categoryBitMask == BodyType.ball.rawValue)
        {
            let strength = 1.0 * ((ball?.position.x)! < frame.width / 2 ? 1 : -1)
            let body = ball?.physicsBody
            body!.applyImpulse(CGVector(dx: strength, dy: 0))
            if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(ballHitWallSound)}
        }
        
        if (contact.bodyA.categoryBitMask == BodyType.ball.rawValue && contact.bodyB.categoryBitMask == BodyType.topBottomWalls.rawValue)
        {
            let strength = 1.0 * ((ball?.position.y)! < frame.height / 2 ? 1 : -1)
            let body = ball?.physicsBody
            body!.applyImpulse(CGVector(dx: 0, dy: strength))
            if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(ballHitWallSound)}
        }
        else if (contact.bodyA.categoryBitMask == BodyType.topBottomWalls.rawValue && contact.bodyB.categoryBitMask == BodyType.ball.rawValue)
        {
            let strength = 1.0 * ((ball?.position.y)! < frame.height / 2 ? 1 : -1)
            let body = ball?.physicsBody
            body!.applyImpulse(CGVector(dx: 0, dy: strength))
            if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(ballHitWallSound)}
        }
        
        // Left magnet Collision detect with wall to prevent sticking (SpriteKit Issue)
        if (contact.bodyB.categoryBitMask == BodyType.sideWalls.rawValue && contact.bodyA.categoryBitMask == BodyType.leftMagnet.rawValue) && leftMagnetIsActive == true
        {
            let strength = 1.0 * ((leftMagnet.position.x) < frame.width / 2 ? 1 : -1)
            let body = leftMagnet.physicsBody
            body!.applyImpulse(CGVector(dx: strength, dy: 0))
            if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(magnetHitsWallSound)}
        }
        else if (contact.bodyA.categoryBitMask == BodyType.sideWalls.rawValue && contact.bodyB.categoryBitMask == BodyType.leftMagnet.rawValue) && leftMagnetIsActive == true
        {
            let strength = 1.0 * ((leftMagnet.position.x) < frame.width / 2 ? 1 : -1)
            let body = leftMagnet.physicsBody
            body!.applyImpulse(CGVector(dx: strength, dy: 0))
            if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(magnetHitsWallSound)}
        }
        
        if (contact.bodyA.categoryBitMask == BodyType.leftMagnet.rawValue && contact.bodyB.categoryBitMask == BodyType.topBottomWalls.rawValue) && leftMagnetIsActive == true
        {
            let strength = 1.0 * ((leftMagnet.position.x) < frame.height / 2 ? 1 : -1)
            let body = leftMagnet.physicsBody
            body!.applyImpulse(CGVector(dx: 0, dy: strength))
            if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(magnetHitsWallSound)}
        }
        else if (contact.bodyA.categoryBitMask == BodyType.topBottomWalls.rawValue && contact.bodyB.categoryBitMask == BodyType.leftMagnet.rawValue) && leftMagnetIsActive == true
        {
            let strength = 1.0 * ((leftMagnet.position.y) < frame.height / 2 ? 1 : -1)
            let body = leftMagnet.physicsBody
            body!.applyImpulse(CGVector(dx: 0, dy: strength))
            if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(magnetHitsWallSound)}
        }
        
        // Center magnet Collision detect with wall to prevent sticking (SpriteKit Issue)
        if (contact.bodyB.categoryBitMask == BodyType.sideWalls.rawValue && contact.bodyA.categoryBitMask == BodyType.centerMagnet.rawValue) && centerMagnetIsActive == true
        {
            let strength = 1.0 * ((centerMagnet.position.x) < frame.width / 2 ? 1 : -1)
            let body = centerMagnet.physicsBody
            body!.applyImpulse(CGVector(dx: strength, dy: 0))
            if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(magnetHitsWallSound)}
        }
        else if (contact.bodyA.categoryBitMask == BodyType.sideWalls.rawValue && contact.bodyB.categoryBitMask == BodyType.centerMagnet.rawValue) && centerMagnetIsActive == true
        {
            let strength = 1.0 * ((centerMagnet.position.x) < frame.width / 2 ? 1 : -1)
            let body = centerMagnet.physicsBody
            body!.applyImpulse(CGVector(dx: strength, dy: 0))
            if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(magnetHitsWallSound)}
        }
        
        if (contact.bodyA.categoryBitMask == BodyType.centerMagnet.rawValue && contact.bodyB.categoryBitMask == BodyType.topBottomWalls.rawValue) && centerMagnetIsActive == true
        {
            let strength = 1.0 * ((centerMagnet.position.x) < frame.height / 2 ? 1 : -1)
            let body = centerMagnet.physicsBody
            body!.applyImpulse(CGVector(dx: 0, dy: strength))
            if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(magnetHitsWallSound)}
        }
        else if (contact.bodyA.categoryBitMask == BodyType.topBottomWalls.rawValue && contact.bodyB.categoryBitMask == BodyType.centerMagnet.rawValue) && centerMagnetIsActive == true
        {
            let strength = 1.0 * ((centerMagnet.position.y) < frame.height / 2 ? 1 : -1)
            let body = centerMagnet.physicsBody
            body!.applyImpulse(CGVector(dx: 0, dy: strength))
            if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(magnetHitsWallSound)}
        }
        
        // Right magnet Collision detect with wall to prevent sticking (SpriteKit Issue)
        if (contact.bodyB.categoryBitMask == BodyType.sideWalls.rawValue && contact.bodyA.categoryBitMask == BodyType.rightMagnet.rawValue) && rightMagnetIsActive == true
        {
            let strength = 1.0 * ((rightMagnet.position.x) < frame.width / 2 ? 1 : -1)
            let body = rightMagnet.physicsBody
            body!.applyImpulse(CGVector(dx: strength, dy: 0))
            if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(magnetHitsWallSound)}
        }
        else if (contact.bodyA.categoryBitMask == BodyType.sideWalls.rawValue && contact.bodyB.categoryBitMask == BodyType.rightMagnet.rawValue) && rightMagnetIsActive == true
        {
            let strength = 1.0 * ((rightMagnet.position.x) < frame.width / 2 ? 1 : -1)
            let body = rightMagnet.physicsBody
            body!.applyImpulse(CGVector(dx: strength, dy: 0))
            if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(magnetHitsWallSound)}
        }
        
        if (contact.bodyA.categoryBitMask == BodyType.rightMagnet.rawValue && contact.bodyB.categoryBitMask == BodyType.topBottomWalls.rawValue) && rightMagnetIsActive == true
        {
            let strength = 1.0 * ((rightMagnet.position.x) < frame.height / 2 ? 1 : -1)
            let body = rightMagnet.physicsBody
            body!.applyImpulse(CGVector(dx: 0, dy: strength))
            if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(magnetHitsWallSound)}
        }
        else if (contact.bodyA.categoryBitMask == BodyType.topBottomWalls.rawValue && contact.bodyB.categoryBitMask == BodyType.rightMagnet.rawValue) && rightMagnetIsActive == true
        {
            let strength = 1.0 * ((rightMagnet.position.y) < frame.height / 2 ? 1 : -1)
            let body = rightMagnet.physicsBody
            body!.applyImpulse(CGVector(dx: 0, dy: strength))
            if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(magnetHitsWallSound)}
        }
        
        if (contact.bodyA.categoryBitMask == BodyType.leftMagnet.rawValue && contact.bodyB.categoryBitMask == BodyType.topGoalZone.rawValue)
        {
            if UserDefaults.standard.string(forKey: "Sound") != "Off" && (leftMagnet.physicsBody!.velocity.dy < -100 || leftMagnet.physicsBody!.velocity.dy > 100 || leftMagnet.physicsBody!.velocity.dx < -100 || leftMagnet.physicsBody!.velocity.dx > 100) && (leftMagnetJustHitGoal == false)
            {
                run(magnetHitsGoalSound)
                leftMagnetJustHitGoal = true
                Timer.scheduledTimer(withTimeInterval: 0.50, repeats: false, block: { timer in
                    self.leftMagnetJustHitGoal = false
                })
            }
            leftMagnet.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        }
        else if (contact.bodyA.categoryBitMask == BodyType.topGoalZone.rawValue && contact.bodyB.categoryBitMask == BodyType.leftMagnet.rawValue)
        {
            if UserDefaults.standard.string(forKey: "Sound") != "Off" && (leftMagnet.physicsBody!.velocity.dy < -100 || leftMagnet.physicsBody!.velocity.dy > 100 || leftMagnet.physicsBody!.velocity.dx < -100 || leftMagnet.physicsBody!.velocity.dx > 100) && (leftMagnetJustHitGoal == false)
            {
                run(magnetHitsGoalSound)
                leftMagnetJustHitGoal = true
                Timer.scheduledTimer(withTimeInterval: 0.50, repeats: false, block: { timer in
                    self.leftMagnetJustHitGoal = false
                })
            }
            leftMagnet.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        }
        if (contact.bodyA.categoryBitMask == BodyType.centerMagnet.rawValue && contact.bodyB.categoryBitMask == BodyType.topGoalZone.rawValue)
        {
            if UserDefaults.standard.string(forKey: "Sound") != "Off" && (centerMagnet.physicsBody!.velocity.dy < -100 || centerMagnet.physicsBody!.velocity.dy > 100 || centerMagnet.physicsBody!.velocity.dx < -100 || centerMagnet.physicsBody!.velocity.dx > 100) && centerMagnetJustHitGoal == false
            {
                run(magnetHitsGoalSound)
                centerMagnetJustHitGoal = true
                Timer.scheduledTimer(withTimeInterval: 0.50, repeats: false, block: { timer in
                    self.centerMagnetJustHitGoal = false
                })
            }
            centerMagnet.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        }
        else if (contact.bodyA.categoryBitMask == BodyType.topGoalZone.rawValue && contact.bodyB.categoryBitMask == BodyType.centerMagnet.rawValue)
        {
            if UserDefaults.standard.string(forKey: "Sound") != "Off" && (centerMagnet.physicsBody!.velocity.dy < -100 || centerMagnet.physicsBody!.velocity.dy > 100 || centerMagnet.physicsBody!.velocity.dx < -100 || centerMagnet.physicsBody!.velocity.dx > 100) && centerMagnetJustHitGoal == false
            {
                run(magnetHitsGoalSound)
                centerMagnetJustHitGoal = true
                Timer.scheduledTimer(withTimeInterval: 0.50, repeats: false, block: { timer in
                    self.centerMagnetJustHitGoal = false
                })
            }
            centerMagnet.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        }
        if (contact.bodyA.categoryBitMask == BodyType.rightMagnet.rawValue && contact.bodyB.categoryBitMask == BodyType.topGoalZone.rawValue)
        {
            if UserDefaults.standard.string(forKey: "Sound") != "Off" && (rightMagnet.physicsBody!.velocity.dy < -100 || rightMagnet.physicsBody!.velocity.dy > 100 || rightMagnet.physicsBody!.velocity.dx < -100 || rightMagnet.physicsBody!.velocity.dx > 100) && rightMagnetJustHitGoal == false
            {
                run(magnetHitsGoalSound)
                rightMagnetJustHitGoal = true
                Timer.scheduledTimer(withTimeInterval: 0.50, repeats: false, block: { timer in
                    self.rightMagnetJustHitGoal = false
                })
            }
            rightMagnet.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        }
        else if (contact.bodyA.categoryBitMask == BodyType.topGoalZone.rawValue && contact.bodyB.categoryBitMask == BodyType.rightMagnet.rawValue)
        {
            if UserDefaults.standard.string(forKey: "Sound") != "Off" && (rightMagnet.physicsBody!.velocity.dy < -100 || rightMagnet.physicsBody!.velocity.dy > 100 || rightMagnet.physicsBody!.velocity.dx < -100 || rightMagnet.physicsBody!.velocity.dx > 100) && rightMagnetJustHitGoal == false
            {
                run(magnetHitsGoalSound)
                rightMagnetJustHitGoal = true
                Timer.scheduledTimer(withTimeInterval: 0.50, repeats: false, block: { timer in
                    self.rightMagnetJustHitGoal = false
                })
            }
            rightMagnet.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        }
        
        if (contact.bodyA.categoryBitMask == BodyType.leftMagnet.rawValue && contact.bodyB.categoryBitMask == BodyType.bottomGoalZone.rawValue)
        {
            if UserDefaults.standard.string(forKey: "Sound") != "Off" && (leftMagnet.physicsBody!.velocity.dy < -100 || leftMagnet.physicsBody!.velocity.dy > 100 || leftMagnet.physicsBody!.velocity.dx < -100 || leftMagnet.physicsBody!.velocity.dx > 100) && (leftMagnetJustHitGoal == false)
            {
                run(magnetHitsGoalSound)
                leftMagnetJustHitGoal = true
                Timer.scheduledTimer(withTimeInterval: 0.50, repeats: false, block: { timer in
                    self.leftMagnetJustHitGoal = false
                })
            }
            leftMagnet.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        }
        else if (contact.bodyA.categoryBitMask == BodyType.bottomGoalZone.rawValue && contact.bodyB.categoryBitMask == BodyType.leftMagnet.rawValue)
        {
            if UserDefaults.standard.string(forKey: "Sound") != "Off" && (leftMagnet.physicsBody!.velocity.dy < -100 || leftMagnet.physicsBody!.velocity.dy > 100 || leftMagnet.physicsBody!.velocity.dx < -100 || leftMagnet.physicsBody!.velocity.dx > 100) && (leftMagnetJustHitGoal == false)
            {
                run(magnetHitsGoalSound)
                leftMagnetJustHitGoal = true
                Timer.scheduledTimer(withTimeInterval: 0.50, repeats: false, block: { timer in
                    self.leftMagnetJustHitGoal = false
                })
            }
            leftMagnet.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        }
        if (contact.bodyA.categoryBitMask == BodyType.centerMagnet.rawValue && contact.bodyB.categoryBitMask == BodyType.bottomGoalZone.rawValue)
        {
            if UserDefaults.standard.string(forKey: "Sound") != "Off" && (centerMagnet.physicsBody!.velocity.dy < -100 || centerMagnet.physicsBody!.velocity.dy > 100 || centerMagnet.physicsBody!.velocity.dx < -100 || centerMagnet.physicsBody!.velocity.dx > 100) && centerMagnetJustHitGoal == false
            {
                run(magnetHitsGoalSound)
                centerMagnetJustHitGoal = true
                Timer.scheduledTimer(withTimeInterval: 0.50, repeats: false, block: { timer in
                    self.centerMagnetJustHitGoal = false
                })
            }
            centerMagnet.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        }
        else if (contact.bodyA.categoryBitMask == BodyType.bottomGoalZone.rawValue && contact.bodyB.categoryBitMask == BodyType.centerMagnet.rawValue)
        {
            if UserDefaults.standard.string(forKey: "Sound") != "Off" && (centerMagnet.physicsBody!.velocity.dy < -100 || centerMagnet.physicsBody!.velocity.dy > 100 || centerMagnet.physicsBody!.velocity.dx < -100 || centerMagnet.physicsBody!.velocity.dx > 100) && centerMagnetJustHitGoal == false
            {
                run(magnetHitsGoalSound)
                centerMagnetJustHitGoal = true
                Timer.scheduledTimer(withTimeInterval: 0.50, repeats: false, block: { timer in
                    self.centerMagnetJustHitGoal = false
                })
            }
            centerMagnet.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        }
        if (contact.bodyA.categoryBitMask == BodyType.rightMagnet.rawValue && contact.bodyB.categoryBitMask == BodyType.bottomGoalZone.rawValue)
        {
            if UserDefaults.standard.string(forKey: "Sound") != "Off" && (rightMagnet.physicsBody!.velocity.dy < -100 || rightMagnet.physicsBody!.velocity.dy > 100 || rightMagnet.physicsBody!.velocity.dx < -100 || rightMagnet.physicsBody!.velocity.dx > 100) && rightMagnetJustHitGoal == false
            {
                run(magnetHitsGoalSound)
                rightMagnetJustHitGoal = true
                Timer.scheduledTimer(withTimeInterval: 0.50, repeats: false, block: { timer in
                    self.rightMagnetJustHitGoal = false
                })
            }
            rightMagnet.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        }
        else if (contact.bodyA.categoryBitMask == BodyType.bottomGoalZone.rawValue && contact.bodyB.categoryBitMask == BodyType.rightMagnet.rawValue)
        {
            if UserDefaults.standard.string(forKey: "Sound") != "Off" && (rightMagnet.physicsBody!.velocity.dy < -100 || rightMagnet.physicsBody!.velocity.dy > 100 || rightMagnet.physicsBody!.velocity.dx < -100 || rightMagnet.physicsBody!.velocity.dx > 100) && rightMagnetJustHitGoal == false
            {
                run(magnetHitsGoalSound)
                rightMagnetJustHitGoal = true
                Timer.scheduledTimer(withTimeInterval: 0.50, repeats: false, block: { timer in
                    self.rightMagnetJustHitGoal = false
                })
            }
            rightMagnet.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        }
        
        if (contact.bodyA.categoryBitMask == BodyType.ball.rawValue && contact.bodyB.categoryBitMask == BodyType.bottomGoalZone.rawValue)
        {
            ballInSouthGoal = true
            if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(goalSound)}
        }
        else if (contact.bodyA.categoryBitMask == BodyType.bottomGoalZone.rawValue && contact.bodyB.categoryBitMask == BodyType.ball.rawValue)
        {
            ballInSouthGoal = true
            if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(goalSound)}
        }
        if (contact.bodyA.categoryBitMask == BodyType.ball.rawValue && contact.bodyB.categoryBitMask == BodyType.topGoalZone.rawValue)
        {
            ballInNorthGoal = true
            if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(goalSound)}
        }
        else if (contact.bodyA.categoryBitMask == BodyType.topGoalZone.rawValue && contact.bodyB.categoryBitMask == BodyType.ball.rawValue)
        {
            ballInNorthGoal = true
            if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(goalSound)}
        }
        
        if ((contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.leftMagnet.rawValue) && (contact.bodyA.fieldBitMask != 45 && contact.bodyB.fieldBitMask != 45) && (leftMagnetIsActive == true))
        {
            leftMagnetIsActive = false
            if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(magnetPlayerSound)}
            Timer.scheduledTimer(withTimeInterval: 0.02, repeats: false, block: { timer in
                self.leftMagnet.position = CGPoint(x: -100, y: -100)
                self.leftMagnet.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                self.northPlayerMagnetCount += 1
            })
        }
        else if (contact.bodyB.categoryBitMask == BodyType.player.rawValue && contact.bodyA.categoryBitMask == BodyType.leftMagnet.rawValue && (contact.bodyA.fieldBitMask != 45 && contact.bodyB.fieldBitMask != 45) && (leftMagnetIsActive == true))
        {
            leftMagnetIsActive = false
            if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(magnetPlayerSound)}
            Timer.scheduledTimer(withTimeInterval: 0.02, repeats: false, block: { timer in
                self.leftMagnet.position = CGPoint(x: -100, y: -100)
                self.leftMagnet.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                self.northPlayerMagnetCount += 1
            })
        }
        
        if (contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.leftMagnet.rawValue && (contact.bodyA.fieldBitMask == 45 || contact.bodyB.fieldBitMask == 45) && (leftMagnetIsActive == true))
        {
            leftMagnetIsActive = false
            if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(magnetPlayerSound)}
            Timer.scheduledTimer(withTimeInterval: 0.02, repeats: false, block: { timer in
                self.leftMagnet.position = CGPoint(x: -100, y: -100)
                self.leftMagnet.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                self.southPlayerMagnetCount += 1
            })
        }
        else if (contact.bodyB.categoryBitMask == BodyType.player.rawValue && contact.bodyA.categoryBitMask == BodyType.leftMagnet.rawValue && (contact.bodyA.fieldBitMask == 45 || contact.bodyB.fieldBitMask == 45) && (leftMagnetIsActive == true))
        {
            leftMagnetIsActive = false
            if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(magnetPlayerSound)}
            Timer.scheduledTimer(withTimeInterval: 0.02, repeats: false, block: { timer in
                self.leftMagnet.position = CGPoint(x: -100, y: -100)
                self.leftMagnet.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                self.southPlayerMagnetCount += 1
            })
        }

        if (contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.centerMagnet.rawValue && (contact.bodyA.fieldBitMask != 45 && contact.bodyB.fieldBitMask != 45) && (centerMagnetIsActive == true))
        {
            centerMagnetIsActive = false
            if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(magnetPlayerSound)}
            Timer.scheduledTimer(withTimeInterval: 0.02, repeats: false, block: { timer in
                self.centerMagnet.position = CGPoint(x: -100, y: -100)
                self.centerMagnet.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                self.northPlayerMagnetCount += 1
            })
        }
        else if (contact.bodyB.categoryBitMask == BodyType.player.rawValue && contact.bodyA.categoryBitMask == BodyType.centerMagnet.rawValue && (contact.bodyA.fieldBitMask != 45 && contact.bodyB.fieldBitMask != 45) && (centerMagnetIsActive == true))
        {
            centerMagnetIsActive = false
            if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(magnetPlayerSound)}
            Timer.scheduledTimer(withTimeInterval: 0.02, repeats: false, block: { timer in
                self.centerMagnet.position = CGPoint(x: -100, y: -100)
                self.centerMagnet.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                self.northPlayerMagnetCount += 1
            })
        }
        
        if (contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.centerMagnet.rawValue && (contact.bodyA.fieldBitMask == 45 || contact.bodyB.fieldBitMask == 45) && (centerMagnetIsActive == true))
        {
            centerMagnetIsActive = false
            if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(magnetPlayerSound)}
            Timer.scheduledTimer(withTimeInterval: 0.02, repeats: false, block: { timer in
                self.centerMagnet.position = CGPoint(x: -100, y: -100)
                self.centerMagnet.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                self.southPlayerMagnetCount += 1
            })
        }
        else if (contact.bodyB.categoryBitMask == BodyType.player.rawValue && contact.bodyA.categoryBitMask == BodyType.centerMagnet.rawValue && (contact.bodyA.fieldBitMask == 45 || contact.bodyB.fieldBitMask == 45) && (centerMagnetIsActive == true))
        {
            centerMagnetIsActive = false
            if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(magnetPlayerSound)}
            Timer.scheduledTimer(withTimeInterval: 0.02, repeats: false, block: { timer in
                self.centerMagnet.position = CGPoint(x: -100, y: -100)
                self.centerMagnet.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                self.southPlayerMagnetCount += 1
            })
        }

        if (contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.rightMagnet.rawValue && (contact.bodyA.fieldBitMask != 45 && contact.bodyB.fieldBitMask != 45) && (rightMagnetIsActive == true))
        {
            rightMagnetIsActive = false
            if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(magnetPlayerSound)}
            Timer.scheduledTimer(withTimeInterval: 0.02, repeats: false, block: { timer in
                self.rightMagnet.position = CGPoint(x: -100, y: -100)
                self.rightMagnet.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                self.northPlayerMagnetCount += 1
            })
        }
        
        else if (contact.bodyB.categoryBitMask == BodyType.player.rawValue && contact.bodyA.categoryBitMask == BodyType.rightMagnet.rawValue && (contact.bodyA.fieldBitMask != 45 && contact.bodyB.fieldBitMask != 45) && (rightMagnetIsActive == true))
        {
            rightMagnetIsActive = false
            if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(magnetPlayerSound)}
            Timer.scheduledTimer(withTimeInterval: 0.02, repeats: false, block: { timer in
                self.rightMagnet.position = CGPoint(x: -100, y: -100)
                self.rightMagnet.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                self.northPlayerMagnetCount += 1
            })
        }

        if (contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.rightMagnet.rawValue && (contact.bodyA.fieldBitMask == 45 || contact.bodyB.fieldBitMask == 45) && rightMagnetIsActive == true)
        {
            rightMagnetIsActive = false
            if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(magnetPlayerSound)}
            Timer.scheduledTimer(withTimeInterval: 0.02, repeats: false, block: { timer in
                self.rightMagnet.position = CGPoint(x: -100, y: -100)
                self.rightMagnet.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                self.southPlayerMagnetCount += 1

            })
        }
        
        else if (contact.bodyB.categoryBitMask == BodyType.player.rawValue && contact.bodyA.categoryBitMask == BodyType.rightMagnet.rawValue && (contact.bodyA.fieldBitMask == 45 || contact.bodyB.fieldBitMask == 45) && (rightMagnetIsActive == true))
        {
            rightMagnetIsActive = false
            if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(magnetPlayerSound)}
            Timer.scheduledTimer(withTimeInterval: 0.02, repeats: false, block: { timer in
                self.rightMagnet.position = CGPoint(x: -100, y: -100)
                self.rightMagnet.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                self.southPlayerMagnetCount += 1
            })
        }
        
        if (contact.bodyA.categoryBitMask == BodyType.ball.rawValue && contact.bodyB.categoryBitMask == BodyType.leftMagnet.rawValue) || (contact.bodyA.categoryBitMask == BodyType.ball.rawValue && contact.bodyB.categoryBitMask == BodyType.centerMagnet.rawValue) || (contact.bodyA.categoryBitMask == BodyType.ball.rawValue && contact.bodyB.categoryBitMask == BodyType.rightMagnet.rawValue) ||
            (contact.bodyA.categoryBitMask == BodyType.leftMagnet.rawValue && contact.bodyB.categoryBitMask == BodyType.ball.rawValue) ||
            (contact.bodyA.categoryBitMask == BodyType.centerMagnet.rawValue && contact.bodyB.categoryBitMask == BodyType.ball.rawValue) ||
            (contact.bodyA.categoryBitMask == BodyType.rightMagnet.rawValue && contact.bodyB.categoryBitMask == BodyType.ball.rawValue)
        {
            if magnetBallSoundControl == true && topPlayerWinsRound == false && bottomPlayerWinsRound == false
            {
                magnetBallSoundControl = false
                if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(ballHitsMagnetSound)}
                Timer.scheduledTimer(withTimeInterval: 0.05, repeats: false, block: { timer in
                    self.magnetBallSoundControl = true
                })
            }
        }
        if (contact.bodyA.categoryBitMask == BodyType.leftMagnet.rawValue && contact.bodyB.categoryBitMask == BodyType.centerMagnet.rawValue) || (contact.bodyA.categoryBitMask == BodyType.centerMagnet.rawValue && contact.bodyB.categoryBitMask == BodyType.leftMagnet.rawValue) || (contact.bodyA.categoryBitMask == BodyType.leftMagnet.rawValue && contact.bodyB.categoryBitMask == BodyType.rightMagnet.rawValue) ||
            (contact.bodyA.categoryBitMask == BodyType.rightMagnet.rawValue && contact.bodyB.categoryBitMask == BodyType.leftMagnet.rawValue) ||
            (contact.bodyA.categoryBitMask == BodyType.centerMagnet.rawValue && contact.bodyB.categoryBitMask == BodyType.rightMagnet.rawValue) ||
            (contact.bodyA.categoryBitMask == BodyType.rightMagnet.rawValue && contact.bodyB.categoryBitMask == BodyType.centerMagnet.rawValue)
        {
            if magnetHitsMagnetSoundControl == true && topPlayerWinsRound == false && bottomPlayerWinsRound == false
            {
                magnetHitsMagnetSoundControl = false
                if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(magnetHitsMagnetSound)}
                Timer.scheduledTimer(withTimeInterval: 0.05, repeats: false, block: { timer in
                    self.magnetHitsMagnetSoundControl = true
                })
            }
        }
    }
    
    func createNorthPlayerScore()
    {
        northPlayerScoreText.text = String(northPlayerScore)
        northPlayerScoreText.zRotation =  .pi / 2

        if frame.width > 700
        {
            northPlayerScoreText.position = CGPoint(x: frame.width/12, y: frame.height/2 + frame.height/30)
            northPlayerScoreText.fontSize = 50
        }
        else
        {
            northPlayerScoreText.position = CGPoint(x: frame.width/10, y: frame.height/2 + frame.height/30)
            northPlayerScoreText.fontSize = 32
        }
        addChild(northPlayerScoreText)
        addChild(southPlayerScoreText)
    }
    func updateNorthPlayerScore()
    {
        northPlayerScoreText.text = String(northPlayerScore)
    }
    
    func createSouthPlayerScore()
    {
        southPlayerScoreText.text = String(southPlayerScore)
        southPlayerScoreText.zRotation = .pi / 2
        
        if frame.width > 700
        {
            southPlayerScoreText.position = CGPoint(x: frame.width/12, y: frame.height/2 - frame.height/30)
            southPlayerScoreText.fontSize = 50
        }
        else
        {
            southPlayerScoreText.position = CGPoint(x: frame.width/10, y: frame.height/2 - frame.height/30)
            southPlayerScoreText.fontSize = 32
        }
    }
    
    func updateSouthPlayerScore()
    {
        southPlayerScoreText.text = String(southPlayerScore)
    }
    
    func adMobShowInterAd()
    {
        guard interstitialAd != nil && interstitialAd!.isReady else
        {
            if UserDefaults.standard.string(forKey: "Sound") != "Off"
            {
                SKTAudio.sharedInstance().playBackgroundMusic2("MenuSong3.mp3")
            }
            
            let scene = GameOverScene(size: (view?.bounds.size)!)

            // Configure the view.
            let skView = self.view!

            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true

            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .resizeFill
            scene.userData = NSMutableDictionary()
            scene.userData?.setObject(numberRounds, forKey: "gameInfo" as NSCopying)
            scene.userData?.setObject(whoWonGame, forKey: "gameWinner" as NSCopying)
            let transition = SKTransition.flipVertical(withDuration: 1)
            skView.presentScene(scene, transition: transition)
            return
        }
        interstitialAd?.present(fromRootViewController: (self.view?.window?.rootViewController)!)
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial)
    {
        if UserDefaults.standard.string(forKey: "Sound") != "Off"
        {
            SKTAudio.sharedInstance().playBackgroundMusic2("MenuSong3.mp3")
        }
        let scene = GameOverScene(size: (view?.bounds.size)!)
        
        // Configure the view.
        let skView = self.view!


        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true

        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .resizeFill
        scene.userData = NSMutableDictionary()
        scene.userData?.setObject(numberRounds, forKey: "gameInfo" as NSCopying)
        scene.userData?.setObject(whoWonGame, forKey: "gameWinner" as NSCopying)
        let transition = SKTransition.flipVertical(withDuration: 1)
        skView.presentScene(scene, transition: transition)
    }
    
    func gameOverIsTrue()
    {
        if southPlayerScore > northPlayerScore
        {
            whoWonGame = "BOTTOM"
            
            if UserDefaults.standard.bool(forKey: "Purchase") == true
            {
                if UserDefaults.standard.string(forKey: "Sound") != "Off"
                {
                    SKTAudio.sharedInstance().playBackgroundMusic2("MenuSong3.mp3")
                }
                
                let scene = GameOverScene(size: (view?.bounds.size)!)

                // Configure the view.
                let skView = self.view!

                /* Sprite Kit applies additional optimizations to improve rendering performance */
                skView.ignoresSiblingOrder = true

                /* Set the scale mode to scale to fit the window */
                scene.scaleMode = .resizeFill
                scene.userData = NSMutableDictionary()
                scene.userData?.setObject(numberRounds, forKey: "gameInfo" as NSCopying)
                scene.userData?.setObject(whoWonGame, forKey: "gameWinner" as NSCopying)
                let transition = SKTransition.flipVertical(withDuration: 1)
                skView.presentScene(scene, transition: transition)
            }
            else
            {
                adMobShowInterAd()
            }
        }
        else
        {
            whoWonGame = "TOP"
            
            if UserDefaults.standard.bool(forKey: "Purchase") == true
            {
                if UserDefaults.standard.string(forKey: "Sound") != "Off"
                {
                    SKTAudio.sharedInstance().playBackgroundMusic2("MenuSong3.mp3")
                }
                
                let scene = GameOverScene(size: (view?.bounds.size)!)

                // Configure the view.
                let skView = self.view!

                /* Sprite Kit applies additional optimizations to improve rendering performance */
                skView.ignoresSiblingOrder = true

                /* Set the scale mode to scale to fit the window */
                scene.scaleMode = .resizeFill
                scene.userData = NSMutableDictionary()
                scene.userData?.setObject(numberRounds, forKey: "gameInfo" as NSCopying)
                scene.userData?.setObject(whoWonGame, forKey: "gameWinner" as NSCopying)
                let transition = SKTransition.flipVertical(withDuration: 1)
                skView.presentScene(scene, transition: transition)
            }
            else
            {
                adMobShowInterAd()
            }
        }
    }
    
    func scoring()
    {
        if ballInSouthGoal == true
        {
            ballInSouthGoal = false
            northPlayerScore += 1
            ball?.physicsBody?.isDynamic = false
            ball?.position = CGPoint(x: bottomGoal.position.x, y: bottomGoal.position.y)
            updatePlayerLoseWinBackgroundsTopPlayerWinsRound()
            updateNorthPlayerScore()
            clearMagnets()
            clearPlayer()
            southPlayerMagnetCount = 0
            northPlayerMagnetCount = 0
            topPlayerWinsRound = true
            if (northPlayerScore * 2) < numberRounds
            {
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { timer in
                    self.resetBallBottomPlayerBallStart()
                    self.resetMagnets()
                    self.resetPlayer()
                    self.resetMagnetHitMarkers()
                    self.resetPlayerLoseWinBackground()
                    self.leftMagnetIsActive = true
                    self.centerMagnetIsActive = true
                    self.rightMagnetIsActive = true
                    self.ball?.physicsBody?.isDynamic = true
                    self.topPlayerWinsRound = false
                })
            }
        }
            
        else if ballInNorthGoal == true
        {
            ballInNorthGoal = false
            ball?.physicsBody?.isDynamic = false
            ball?.position = CGPoint(x: topGoal.position.x, y: topGoal.position.y)
            updatePlayerLoseWinBackgroundsBottomPlayerWinsRound()
            southPlayerScore += 1
            clearMagnets()
            updateSouthPlayerScore()
            bottomPlayerWinsRound = true
            southPlayerMagnetCount = 0
            northPlayerMagnetCount = 0
            clearPlayer()
            if (southPlayerScore * 2) < numberRounds
            {
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { timer in
                    self.resetBallTopPlayerBallStart()
                    self.resetMagnets()
                    self.resetPlayer()
                    self.resetMagnetHitMarkers()
                    self.resetPlayerLoseWinBackground()
                    self.ball?.physicsBody?.isDynamic = true
                    self.leftMagnetIsActive = true
                    self.centerMagnetIsActive = true
                    self.rightMagnetIsActive = true
                    self.bottomPlayerWinsRound = false
                })
            }
        }
        
        if southPlayerMagnetCount >= 2
        {
            updatePlayerLoseWinBackgroundsTopPlayerWinsRound()
            northPlayerScore += 1
            updateNorthPlayerScore()
            topPlayerWinsRound = true
            clearMagnets()
            ball?.physicsBody?.isDynamic = false
            ball?.isHidden = true
            southPlayerMagnetCount = 0
            northPlayerMagnetCount = 0
            clearPlayer()
            if (northPlayerScore * 2) < numberRounds
            {
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { timer in
                    self.southPlayerMagnetCount = 0
                    self.northPlayerMagnetCount = 0
                    self.resetBallBottomPlayerBallStart()
                    self.ball?.isHidden = false
                    self.resetMagnetHitMarkers()
                    self.resetMagnets()
                    self.resetPlayer()
                    self.resetPlayerLoseWinBackground()
                    self.topPlayerWinsRound = false
                    self.leftMagnetIsActive = true
                    self.centerMagnetIsActive = true
                    self.rightMagnetIsActive = true
                    self.ball?.physicsBody?.isDynamic = true
                })
            }
        }
            
        else if northPlayerMagnetCount >= 2
        {
            updatePlayerLoseWinBackgroundsBottomPlayerWinsRound()
            southPlayerScore += 1
            updateSouthPlayerScore()
            bottomPlayerWinsRound = true
            clearMagnets()
            ball?.physicsBody?.isDynamic = false
            ball?.isHidden = true
            southPlayerMagnetCount = 0
            northPlayerMagnetCount = 0
            clearPlayer()
            if (southPlayerScore * 2) < numberRounds
            {
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { timer in
                    self.southPlayerMagnetCount = 0
                    self.northPlayerMagnetCount = 0
                    self.resetBallTopPlayerBallStart()
                    self.ball?.isHidden = false
                    self.resetMagnetHitMarkers()
                    self.resetMagnets()
                    self.resetPlayer()
                    self.resetPlayerLoseWinBackground()
                    self.bottomPlayerWinsRound = false
                    self.leftMagnetIsActive = true
                    self.centerMagnetIsActive = true
                    self.rightMagnetIsActive = true
                    self.ball?.physicsBody?.isDynamic = true
                })
            }
        }
        
        if ((southPlayerScore * 2 >= numberRounds) || northPlayerScore * 2 >= numberRounds) && (gameOver == false)
        {
            gameOver = true
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { timer in
                self.gameOverIsTrue()
            })
        }
    }
    
    override func update(_ currentTime: TimeInterval)
    {

        if  isOffScreen(node: ball!)
        {
            resetBallStart()
        }
        
        springFieldSouthPlayer.position = CGPoint(x: southPlayer!.position.x, y: (southPlayer!.position.y))
        springFieldNorthPlayer.position = CGPoint(x: northPlayer!.position.x, y: (northPlayer!.position.y))
        if repulsionMode == true
        {
            electricFieldSouthPlayer.position = CGPoint(x: southPlayer!.position.x, y: (southPlayer!.position.y))
            electricFieldNorthPlayer.position = CGPoint(x: northPlayer!.position.x, y: (northPlayer!.position.y))
        }
        placeMagnetXMarks()
        scoring()
        
        if sqrt(pow((ball?.physicsBody?.velocity.dx)!, 2) + pow((ball?.physicsBody?.velocity.dy)!, 2)) > CGFloat(maxBallSpeed)
        {
            ball?.physicsBody?.velocity.dx = (ball?.physicsBody?.velocity.dx)! * (maxBallSpeed / (sqrt(pow((ball?.physicsBody?.velocity.dx)!, 2) + pow((ball?.physicsBody?.velocity.dy)!, 2))))
            ball?.physicsBody?.velocity.dy = (ball?.physicsBody?.velocity.dy)! * (maxBallSpeed / (sqrt(pow((ball?.physicsBody?.velocity.dx)!, 2) + pow((ball?.physicsBody?.velocity.dy)!, 2))))
        }
        
        if sqrt(pow((leftMagnet.physicsBody?.velocity.dx)!, 2) + pow((leftMagnet.physicsBody?.velocity.dy)!, 2)) > CGFloat(maxMagnetSpeed)
        {
            leftMagnet.physicsBody?.velocity.dx = (leftMagnet.physicsBody?.velocity.dx)! * (maxMagnetSpeed / (sqrt(pow((leftMagnet.physicsBody?.velocity.dx)!, 2) + pow((leftMagnet.physicsBody?.velocity.dy)!, 2))))
            leftMagnet.physicsBody?.velocity.dy = (leftMagnet.physicsBody?.velocity.dy)! * (maxMagnetSpeed / (sqrt(pow((leftMagnet.physicsBody?.velocity.dx)!, 2) + pow((leftMagnet.physicsBody?.velocity.dy)!, 2))))
        }
        
        if sqrt(pow((centerMagnet.physicsBody?.velocity.dx)!, 2) + pow((centerMagnet.physicsBody?.velocity.dy)!, 2)) > CGFloat(maxMagnetSpeed)
        {
            centerMagnet.physicsBody?.velocity.dx = (centerMagnet.physicsBody?.velocity.dx)! * (maxMagnetSpeed / (sqrt(pow((centerMagnet.physicsBody?.velocity.dx)!, 2) + pow((centerMagnet.physicsBody?.velocity.dy)!, 2))))
            centerMagnet.physicsBody?.velocity.dy = (centerMagnet.physicsBody?.velocity.dy)! * (maxMagnetSpeed / (sqrt(pow((centerMagnet.physicsBody?.velocity.dx)!, 2) + pow((centerMagnet.physicsBody?.velocity.dy)!, 2))))
        }
        
        if sqrt(pow((rightMagnet.physicsBody?.velocity.dx)!, 2) + pow((rightMagnet.physicsBody?.velocity.dy)!, 2)) > CGFloat(maxMagnetSpeed)
        {
            rightMagnet.physicsBody?.velocity.dx = (rightMagnet.physicsBody?.velocity.dx)! * (maxMagnetSpeed / (sqrt(pow((rightMagnet.physicsBody?.velocity.dx)!, 2) + pow((rightMagnet.physicsBody?.velocity.dy)!, 2))))
            rightMagnet.physicsBody?.velocity.dy = (rightMagnet.physicsBody?.velocity.dy)! * (maxMagnetSpeed / (sqrt(pow((rightMagnet.physicsBody?.velocity.dx)!, 2) + pow((rightMagnet.physicsBody?.velocity.dy)!, 2))))
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touch = touches.first
        if let location = touch?.location(in: self)
        {
            let nodesArray = self.nodes(at: location)

            if nodesArray.contains(pauseButton)
            {
                pauseButton.colorBlendFactor = 0.5
                touchedPauseButton = true
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touch = touches.first
        
        if let location = touch?.location(in: self)
        {
            let nodesArray = self.nodes(at: location)
            
            if nodesArray.contains(pauseButton) && touchedPauseButton == true
            {
                touchedPauseButton = false
                pauseButton.colorBlendFactor = 0
                if UserDefaults.standard.string(forKey: "Sound") == "On" {run(buttonSound)}
                else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                else{run(buttonSound)}
            }
            else if nodesArray.contains(pauseButton) && touchedPauseButton == true
            {
                touchedPauseButton = false
                pauseButton.colorBlendFactor = 0.5
                if UserDefaults.standard.string(forKey: "Sound") == "On" {run(buttonSound)}
                else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                else{run(buttonSound)}
            }
        }
    }
}


