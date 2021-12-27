//
//  GameSceneOnePlayer.swift
//  MagnetHockey
//
//  Created by Wysong, Trevor on 6/8/20.
//  Copyright © 2020 Wysong, Trevor. All rights reserved.
//
import SpriteKit
import GameplayKit
import GoogleMobileAds

class GameSceneOnePlayer: SKScene, SKPhysicsContactDelegate, BottomPlayerDelegate, BotPlayerDelegate, GADInterstitialDelegate
{
    var ball : SKShapeNode?
    var leftMagnet = SKShapeNode()
    var rightMagnet = SKShapeNode()
    var centerMagnet = SKShapeNode()
//    var southPlayerGlow = SKShapeNode()
    var ballRadius = CGFloat()
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
    var botNearLeftMagnet = false
    var botNearCenterMagnet = false
    var botNearRightMagnet = false
    var topGoal = SKSpriteNode()
    var bottomGoal = SKSpriteNode()
    var topGoalPlus = SKSpriteNode()
    var bottomGoalPlus = SKSpriteNode()
    var southPlayer : BottomPlayer?
    var botPlayer : BotPlayer?
    let springFieldSouthPlayer = SKFieldNode.springField()
    let springFieldBotPlayer = SKFieldNode.springField()
//    let electricFieldNorthPlayer = SKFieldNode.electricField()
    let listenerNode = SKNode()
    var southPlayerArea = CGRect()
    var botPlayerArea = CGRect()
    var southPlayerMagnetCount = 0
    var botPlayerMagnetCount = 0
    var southPlayerScore = 0
    var botPlayerScore = 0
    var AIMagnetAvoidingSpeed = CGFloat(10.0)
    var bottomPlayerForceForCollision = CGVector()
    var botPlayerForceForCollision = CGVector()
    let botPlayerScoreText = SKLabelNode(fontNamed: "Helvetica Neue UltraLight")
    let southPlayerScoreText = SKLabelNode(fontNamed: "Helvetica Neue UltraLight")
    let botPlayerScoreTextRightSide = SKLabelNode(fontNamed: "Helvetica Neue UltraLight")
    let southPlayerScoreTextRightSide = SKLabelNode(fontNamed: "Helvetica Neue UltraLight")
    var whoWonGame = ""
    var topPlayerWinsRound = false
    var bottomPlayerWinsRound = false
    var leftMagnetIsActive = true
    var centerMagnetIsActive = true
    var rightMagnetIsActive = true
    var gameOver = false
    var bottomTouchForCollision = false
    var botTouchForCollision = false
    var numberRounds = 0
    var ballColorGame = ""
    let magnetPlayerSound = SKAction.playSoundFileNamed("Magnet Click.mp3", waitForCompletion: false)
    let playerHitBallSound = SKAction.playSoundFileNamed("PlayerHitBall2.mp3", waitForCompletion: false)
    let ballHitWallSound = SKAction.playSoundFileNamed("BallHitWall.wav", waitForCompletion: false)
    let goalSound = SKAction.playSoundFileNamed("Goal3.mp3", waitForCompletion: false)
    var interstitialAd: GADInterstitial?
    
    func createPlayers()
    {
        southPlayerArea = CGRect(x: 0, y: 0, width: frame.width, height: frame.height/2)
        botPlayerArea = CGRect(x: 0, y: frame.height/2, width: frame.width, height: frame.height)
        
        let southPlayerStartPoint = CGPoint(x: frame.midX, y: frame.height/4)
        let botPlayerStartPoint = CGPoint(x: frame.midX, y: frame.height * 0.75)
        
        southPlayer = bottomPlayer(at: southPlayerStartPoint, boundary: southPlayerArea)
        botPlayer = botPlayer(at: botPlayerStartPoint, boundary: botPlayerArea)
        southPlayer?.physicsBody?.categoryBitMask = BodyType.player.rawValue
        botPlayer?.physicsBody?.categoryBitMask = BodyType.player.rawValue
        southPlayer?.physicsBody?.contactTestBitMask = 25
        botPlayer?.physicsBody?.contactTestBitMask = 75
        southPlayer?.physicsBody?.fieldBitMask = 45
        southPlayer?.physicsBody?.usesPreciseCollisionDetection = true
        botPlayer?.physicsBody?.usesPreciseCollisionDetection = true
    }
    
    func bottomPlayer(at position: CGPoint, boundary:CGRect) -> BottomPlayer
    {
        let bottomPlayer = BottomPlayer(activeArea: boundary)
        bottomPlayer.position = position
        bottomPlayer.delegate = self
        addChild(bottomPlayer)
        return bottomPlayer;
    }
    
    func botPlayer(at position: CGPoint, boundary:CGRect) -> BotPlayer
    {
        let botPlayer = BotPlayer(activeArea: boundary)
        botPlayer.position = position
        botPlayer.delegate = self
        addChild(botPlayer)
        return botPlayer;
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
            bottomEdge.position = CGPoint(x: 0, y: 0 - (frame.width * 6.50/20))
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
            topEdge.position = CGPoint(x: -1 * frame.width/10, y: frame.height + (2/30 * frame.height))
        }
        else
        {
            topEdge.position = CGPoint(x: 0, y: frame.height + ((9.2/37.5) * frame.width))
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
        springFieldSouthPlayer.strength = 1
        springFieldSouthPlayer.position = CGPoint(x: southPlayer!.position.x, y: (southPlayer?.position.y)!)
        springFieldSouthPlayer.falloff = 0.0
        springFieldSouthPlayer.categoryBitMask = 5
        addChild(springFieldSouthPlayer)
        
        springFieldBotPlayer.strength = 1.5
        springFieldBotPlayer.position = CGPoint(x: botPlayer!.position.x, y: (botPlayer?.position.y)!)
        if frame.width > 700
        {
            springFieldSouthPlayer.region = SKRegion(size: CGSize(width: frame.width/4.5, height: frame.width/4.5))
            springFieldBotPlayer.region = SKRegion(size: CGSize(width: frame.width/4.5, height: frame.width/4.5))
        }
        else
        {
            springFieldSouthPlayer.region = SKRegion(size: CGSize(width: frame.width/3.6, height: frame.width/3.6))
            springFieldBotPlayer.region = SKRegion(size: CGSize(width: frame.width/3.6, height: frame.width/3.6))
        }
        springFieldBotPlayer.falloff = 0.0
        springFieldBotPlayer.categoryBitMask = 5
        addChild(springFieldBotPlayer)
    }
    
//    func createElectricFieldPlayer()
//    {
//        electricFieldNorthPlayer.strength = 1.5
//        electricFieldNorthPlayer.position = CGPoint(x: botPlayer!.position.x, y: (botPlayer?.position.y)!)
//        electricFieldNorthPlayer.falloff = 0.0
//        electricFieldNorthPlayer.isEnabled = true
//        electricFieldNorthPlayer.categoryBitMask = 5
//
//        if frame.width > 700
//        {
//            electricFieldNorthPlayer.region = SKRegion(size: CGSize(width: frame.width/4, height: frame.width/4))
//        }
//        else
//        {
//            electricFieldNorthPlayer.region = SKRegion(size: CGSize(width: frame.width/3.2, height: frame.width/3.2))
//        }
//        addChild(electricFieldNorthPlayer)
//    }
    
    func createCenterCircle()
    {
        centerCircle = SKSpriteNode(imageNamed: "centerCircleFixed.png")
        centerCircle.position = CGPoint(x: frame.width/2, y: frame.height/2)
        centerCircle.scale(to: CGSize(width: frame.width * 0.415, height: frame.width * 0.415))
        centerCircle.zPosition = -100
        centerCircle.colorBlendFactor = 0.50
        addChild(centerCircle)
    }
    
    func createPlayerLoseWinBackgrounds()
    {
        xMark = SKSpriteNode(imageNamed: "x.png")
        xMark.scale(to: CGSize(width: frame.width/4, height: frame.width/4))
        xMark.zPosition = 99
        
        checkMark = SKSpriteNode(imageNamed: "checkmark1.png")
        checkMark.scale(to: CGSize(width: frame.width/3.5, height: frame.width/3.5))
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
    }
    
    func updatePlayerLoseWinBackgroundsTopPlayerWinsRound()
    {
        playerWinsBackground.position = CGPoint(x: frame.width/2, y: frame.height * (3/4))
        playerLosesBackground.position = CGPoint(x: frame.width/2, y: frame.height/4)
        xMark.position = CGPoint(x: frame.width/2, y: frame.height * 0.30)
        checkMark.position = CGPoint(x: frame.width/2, y: frame.height * 0.70)
    }
    
    func resetPlayerLoseWinBackground()
    {
        playerWinsBackground.position = CGPoint(x: -1000, y: -1000)
        playerLosesBackground.position = CGPoint(x: -1000, y: -1000)
        xMark.position = CGPoint(x: -1000, y: -1000)
        checkMark.position = CGPoint(x: -1000, y: -1000)
    }
    
//    func createGlow()
//    {
//        southPlayerGlow = SKShapeNode()
//        //draw left magnet
//        let southPlayerGlowPath = CGMutablePath()
//        let π = CGFloat.pi
//        var southPlayerGlowRadius = CGFloat(0.0)
//        if frame.width < 700
//        {
//            southPlayerGlowRadius = frame.width / 20
//        }
//        else if frame.width >= 700
//        {
//            southPlayerGlowRadius = frame.width / 16
//        }
//
//        southPlayerGlowPath.addArc(center: CGPoint(x: 0, y:0), radius: southPlayerGlowRadius, startAngle: 0, endAngle: π*2, clockwise: true)
//        southPlayerGlow.path = southPlayerGlowPath
//        southPlayerGlow.lineWidth = 0
//        southPlayerGlow.fillColor = UIColor.white
//        southPlayerGlow.zPosition = -10
//        southPlayerGlow.lineWidth = 1
//        southPlayerGlow.strokeColor = UIColor.white
//        southPlayerGlow.glowWidth = 15
//        if southPlayerGlow.parent == nil
//        {
//            addChild(southPlayerGlow)
//        }
//    }
    
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
        leftMagnet.physicsBody!.linearDamping = 0.6
        leftMagnet.physicsBody!.angularDamping = 0.6
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
        centerMagnet.physicsBody!.linearDamping = 0.6
        centerMagnet.physicsBody!.angularDamping = 0.6
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
        rightMagnet.physicsBody!.linearDamping = 0.6
        rightMagnet.physicsBody!.angularDamping = 0.6
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
        leftMagnet.physicsBody?.charge = 0.6
        centerMagnet.physicsBody?.charge = 0.6
        rightMagnet.physicsBody?.charge = 0.6
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
        southLeftMagnetX = SKSpriteNode(imageNamed: "magnetCount.png")
        southCenterMagnetX = SKSpriteNode(imageNamed: "magnetCount.png")
        southRightMagnetX = SKSpriteNode(imageNamed: "magnetCount.png")
        northLeftMagnetX = SKSpriteNode(imageNamed: "magnetCount.png")
        northCenterMagnetX = SKSpriteNode(imageNamed: "magnetCount.png")
        northRightMagnetX = SKSpriteNode(imageNamed: "magnetCount.png")
        
        southLeftMagnetX.zPosition = -1
        southCenterMagnetX.zPosition = -1
        southRightMagnetX.zPosition = -1
        northLeftMagnetX.zPosition = -1
        northCenterMagnetX.zPosition = -1
        northRightMagnetX.zPosition = -1

        southLeftMagnetX.size = CGSize(width: 1/12 * frame.width, height: 1/12 * frame.width)
        southCenterMagnetX.size = CGSize(width: 1/12 * frame.width, height: 1/12 * frame.width)
        southRightMagnetX.size = CGSize(width: 1/12 * frame.width, height: 1/12 * frame.width)
        northLeftMagnetX.size = CGSize(width: 1/12 * frame.width, height: 1/12 * frame.width)
        northCenterMagnetX.size = CGSize(width: 1/12 * frame.width, height: 1/12 * frame.width)
        northRightMagnetX.size = CGSize(width: 1/12 * frame.width, height: 1/12 * frame.width)

        if frame.height > 800 && frame.width < 500
        {
            southLeftMagnetX.position = CGPoint(x: frame.width/11, y: frame.width/14)
            southCenterMagnetX.position = CGPoint(x: frame.width/5.5, y: frame.width/14)
            southRightMagnetX.position = CGPoint(x: frame.width/3.65, y: frame.width/14)
            northLeftMagnetX.position = CGPoint(x: frame.width*(10/11), y: frame.height - frame.width/17)
            northCenterMagnetX.position = CGPoint(x: frame.width * 4.5/5.5, y: frame.height - frame.width/17)
            northRightMagnetX.position = CGPoint(x: frame.width * 4/5.5, y: -200)
        }
        else
        {
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
        
        if botPlayerMagnetCount >= 1
        {
            northLeftMagnetX.isHidden = false
        }
        if botPlayerMagnetCount >= 2
        {
            northCenterMagnetX.isHidden = false
        }
        if botPlayerMagnetCount == 3
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
            topGoal.position = CGPoint(x: frame.width/2, y: frame.height * 0.87)
            bottomGoal.position = CGPoint(x: frame.width/2, y: frame.height * 0.13)
        }
        else if frame.width > 700
        {
            topGoal.position = CGPoint(x: frame.width/2, y: frame.height*(8.7/10))
            bottomGoal.position = CGPoint(x: frame.width/2, y: frame.height * 1.30/10)
        }
        else
        {
            topGoal.position = CGPoint(x: frame.width/2, y: frame.height * 0.87)
            bottomGoal.position = CGPoint(x: frame.width/2, y: frame.height * 0.13)
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
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        interstitial.delegate = self
        interstitial.load(request)
        return interstitial
    }
    
    override func didMove(to view: SKView)
    {
        self.physicsWorld.contactDelegate = self
        backgroundColor = SKColor.systemTeal
        let bannerViewStartScene = self.view?.viewWithTag(100) as! GADBannerView?
        bannerViewStartScene?.isHidden = true
        let bannerViewGameOverScene = self.view?.viewWithTag(101) as! GADBannerView?
        bannerViewGameOverScene?.isHidden = true
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
        
        if UserDefaults.standard.string(forKey: "BallColor") == "Yellow" || UserDefaults.standard.string(forKey: "BallColor") == "Black" || UserDefaults.standard.string(forKey: "BallColor") == "Blue" || UserDefaults.standard.string(forKey: "BallColor") == "Red" || UserDefaults.standard.string(forKey: "BallColor") == "Orange" ||
            UserDefaults.standard.string(forKey: "BallColor") == "Pink" ||
            UserDefaults.standard.string(forKey: "BallColor") == "Purple" ||
            UserDefaults.standard.string(forKey: "BallColor") == "Green"
        {
            ballColorGame = UserDefaults.standard.string(forKey: "BallColor")!
        }
        else
        {
            ballColorGame = "Yellow"
            UserDefaults.standard.set("Yellow", forKey: "BallColor")
            UserDefaults.standard.synchronize()
        }

        interstitialAd = createAndLoadInterstitial()
//        createBackground()
        drawCenterLine()
        createCenterCircle()
        createPlayers()
        createMagnets()
        createMagnetHolders()
        createGoals()
        createBall()
        createPlayerLoseWinBackgrounds()
        createBotPlayerScore()
        createSouthPlayerScore()
        createEdges()
        createMagnetXMarks()
        createSpringFieldPlayer()
//        createElectricFieldPlayer()
        createPlayerLoseWinBackgrounds()
    }
    
    func bottomForce(_ force: CGVector, fromBottomPlayer bottomPlayer: BottomPlayer)
    {
        let collisionDistanceSquared = (bottomPlayer.radius * bottomPlayer.radius) + (ballRadius * ballRadius)
        
        let actualDistanceX = bottomPlayer.position.x - ball!.position.x
        let actualDistanceY = bottomPlayer.position.y - ball!.position.y
        
        let actualDistanceSquared = (actualDistanceX * actualDistanceX) + (actualDistanceY * actualDistanceY)
        
        if  actualDistanceSquared <= collisionDistanceSquared
        {
            ball!.physicsBody!.applyImpulse(force)
        }
        bottomPlayerForceForCollision = force
    }
    
    func botForce(_ force: CGVector, fromBotPlayer botPlayer: BotPlayer)
    {
        let collisionDistanceSquared = (botPlayer.radius * botPlayer.radius) + (ballRadius * ballRadius)
        
        let actualDistanceX = botPlayer.position.x - ball!.position.x
        let actualDistanceY = botPlayer.position.y - ball!.position.y
        
        let actualDistanceSquared = (actualDistanceX * actualDistanceX) + (actualDistanceY * actualDistanceY)
        
        if  actualDistanceSquared <= collisionDistanceSquared
        {
            ball!.physicsBody!.applyImpulse(force)
        }
        botPlayerForceForCollision = force
    }
    
    func bottomTouchIsActive(_ bottomTouchIsActive: Bool, fromBottomPlayer bottomPlayer: BottomPlayer)
    {
        bottomTouchForCollision = bottomTouchIsActive
    }
    
    func botTouchIsActive(_ botTouchIsActive: Bool, fromBotPlayer botPlayer: BotPlayer)
    {
        botTouchForCollision = botTouchIsActive
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
            if frame.width < 700
            {
                ballRadius = frame.width / 24
            }
            else if frame.width >= 700
            {
                ballRadius = frame.width / 30
            }
            ballPath.addArc(center: CGPoint(x: 0, y:0), radius: ballRadius, startAngle: 0, endAngle: π*2, clockwise: true)
            ball!.path = ballPath
            ball!.lineWidth = 0
            if ballColorGame == "Black"
            {
                ball!.fillColor = UIColor.black
            }
            else if ballColorGame == "Blue"
            {
                ball!.fillColor = UIColor.blue
            }
            else if ballColorGame == "Orange"
            {
                ball!.fillColor = UIColor.orange
            }
            else if ballColorGame == "Pink"
            {
                ball!.fillColor = UIColor.systemPink
            }
            else if ballColorGame == "Purple"
            {
                ball!.fillColor = UIColor.purple
            }
            else if ballColorGame == "Green"
            {
                ball!.fillColor = UIColor.green
            }
            else if ballColorGame == "Red"
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
        
        
        
        let ySpawnsArray = [frame.height * 1/3, frame.height * 2/3]
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
        ball!.position = CGPoint(x: frame.width/2, y: size.height * (2/3))
        ball!.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
    }
    
    func resetBallBottomPlayerBallStart()
    {
        ball!.position = CGPoint(x: frame.width/2, y: size.height/3)
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
        botPlayer?.isHidden = true
    }
     
    func resetPlayer()
    {
        southPlayer?.position = CGPoint(x: self.frame.midX, y: self.size.height/4)
        botPlayer?.position = CGPoint(x: self.frame.midX, y: self.size.height * 0.75)
        southPlayer?.isHidden = false
        botPlayer?.isHidden = false
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
        if (contact.bodyA.categoryBitMask == BodyType.ball.rawValue && contact.bodyB.categoryBitMask == BodyType.player.rawValue) && (contact.bodyA.contactTestBitMask == 25 || contact.bodyB.contactTestBitMask == 25)
        {
            if bottomTouchForCollision == true
            {
                ball!.physicsBody!.applyImpulse(bottomPlayerForceForCollision)
            }
            if ballSoundControl == true && topPlayerWinsRound == false && bottomPlayerWinsRound == false
            {
                ballSoundControl = false
                run(playerHitBallSound)
                Timer.scheduledTimer(withTimeInterval: 0.05, repeats: false, block: { timer in
                    self.ballSoundControl = true
                })
            }
        }
        else if (contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.ball.rawValue) && (contact.bodyA.contactTestBitMask == 25 || contact.bodyB.contactTestBitMask == 25)
        {
            if bottomTouchForCollision == true
            {
                ball!.physicsBody!.applyImpulse(bottomPlayerForceForCollision)
            }
            if ballSoundControl == true && topPlayerWinsRound == false && bottomPlayerWinsRound == false
            {
                ballSoundControl = false
                run(playerHitBallSound)
                Timer.scheduledTimer(withTimeInterval: 0.05, repeats: false, block: { timer in
                    self.ballSoundControl = true
                })
            }
        }
        
        if (contact.bodyA.categoryBitMask == BodyType.ball.rawValue && contact.bodyB.categoryBitMask == BodyType.player.rawValue) && (contact.bodyA.contactTestBitMask == 75 || contact.bodyB.contactTestBitMask == 75)
        {
            if botTouchForCollision == true
            {
                ball!.physicsBody!.applyImpulse(botPlayerForceForCollision)
            }
            if ballSoundControl == true && topPlayerWinsRound == false && bottomPlayerWinsRound == false
            {
                ballSoundControl = false
                run(playerHitBallSound)
                Timer.scheduledTimer(withTimeInterval: 0.05, repeats: false, block: { timer in
                    self.ballSoundControl = true
                })
            }
        }
        else if (contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.ball.rawValue) && (contact.bodyA.contactTestBitMask == 75 || contact.bodyB.contactTestBitMask == 75)
        {
            if botTouchForCollision == true
            {
                ball!.physicsBody!.applyImpulse(botPlayerForceForCollision)
            }
            if ballSoundControl == true && topPlayerWinsRound == false && bottomPlayerWinsRound == false
            {
                ballSoundControl = false
                run(playerHitBallSound)
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
            run(ballHitWallSound)
        }
        else if (contact.bodyA.categoryBitMask == BodyType.sideWalls.rawValue && contact.bodyB.categoryBitMask == BodyType.ball.rawValue)
        {
            let strength = 1.0 * ((ball?.position.x)! < frame.width / 2 ? 1 : -1)
            let body = ball?.physicsBody
            body!.applyImpulse(CGVector(dx: strength, dy: 0))
            run(ballHitWallSound)
        }
        
        if (contact.bodyA.categoryBitMask == BodyType.ball.rawValue && contact.bodyB.categoryBitMask == BodyType.topBottomWalls.rawValue)
        {
            let strength = 1.0 * ((ball?.position.y)! < frame.height / 2 ? 1 : -1)
            let body = ball?.physicsBody
            body!.applyImpulse(CGVector(dx: 0, dy: strength))
            run(ballHitWallSound)
        }
        else if (contact.bodyA.categoryBitMask == BodyType.topBottomWalls.rawValue && contact.bodyB.categoryBitMask == BodyType.ball.rawValue)
        {
            let strength = 1.0 * ((ball?.position.y)! < frame.height / 2 ? 1 : -1)
            let body = ball?.physicsBody
            body!.applyImpulse(CGVector(dx: 0, dy: strength))
            run(ballHitWallSound)
        }
        
        // Left magnet Collision detect with wall to prevent sticking (SpriteKit Issue)
        if (contact.bodyB.categoryBitMask == BodyType.sideWalls.rawValue && contact.bodyA.categoryBitMask == BodyType.leftMagnet.rawValue)
        {
            let strength = 1.0 * ((leftMagnet.position.x) < frame.width / 2 ? 1 : -1)
            let body = leftMagnet.physicsBody
            body!.applyImpulse(CGVector(dx: strength, dy: 0))
        }
        else if (contact.bodyA.categoryBitMask == BodyType.sideWalls.rawValue && contact.bodyB.categoryBitMask == BodyType.leftMagnet.rawValue)
        {
            let strength = 1.0 * ((leftMagnet.position.x) < frame.width / 2 ? 1 : -1)
            let body = leftMagnet.physicsBody
            body!.applyImpulse(CGVector(dx: strength, dy: 0))
        }
        
        if (contact.bodyA.categoryBitMask == BodyType.leftMagnet.rawValue && contact.bodyB.categoryBitMask == BodyType.topBottomWalls.rawValue)
        {
            let strength = 1.0 * ((leftMagnet.position.x) < frame.height / 2 ? 1 : -1)
            let body = leftMagnet.physicsBody
            body!.applyImpulse(CGVector(dx: 0, dy: strength))
        }
        else if (contact.bodyA.categoryBitMask == BodyType.topBottomWalls.rawValue && contact.bodyB.categoryBitMask == BodyType.leftMagnet.rawValue)
        {
            let strength = 1.0 * ((leftMagnet.position.y) < frame.height / 2 ? 1 : -1)
            let body = leftMagnet.physicsBody
            body!.applyImpulse(CGVector(dx: 0, dy: strength))
        }
        
        // Center magnet Collision detect with wall to prevent sticking (SpriteKit Issue)
        if (contact.bodyB.categoryBitMask == BodyType.sideWalls.rawValue && contact.bodyA.categoryBitMask == BodyType.centerMagnet.rawValue)
        {
            let strength = 1.0 * ((centerMagnet.position.x) < frame.width / 2 ? 1 : -1)
            let body = centerMagnet.physicsBody
            body!.applyImpulse(CGVector(dx: strength, dy: 0))
        }
        else if (contact.bodyA.categoryBitMask == BodyType.sideWalls.rawValue && contact.bodyB.categoryBitMask == BodyType.centerMagnet.rawValue)
        {
            let strength = 1.0 * ((centerMagnet.position.x) < frame.width / 2 ? 1 : -1)
            let body = centerMagnet.physicsBody
            body!.applyImpulse(CGVector(dx: strength, dy: 0))
        }
        
        if (contact.bodyA.categoryBitMask == BodyType.centerMagnet.rawValue && contact.bodyB.categoryBitMask == BodyType.topBottomWalls.rawValue)
        {
            let strength = 1.0 * ((centerMagnet.position.x) < frame.height / 2 ? 1 : -1)
            let body = centerMagnet.physicsBody
            body!.applyImpulse(CGVector(dx: 0, dy: strength))
        }
        else if (contact.bodyA.categoryBitMask == BodyType.topBottomWalls.rawValue && contact.bodyB.categoryBitMask == BodyType.centerMagnet.rawValue)
        {
            let strength = 1.0 * ((centerMagnet.position.y) < frame.height / 2 ? 1 : -1)
            let body = centerMagnet.physicsBody
            body!.applyImpulse(CGVector(dx: 0, dy: strength))
        }
        
        // Right magnet Collision detect with wall to prevent sticking (SpriteKit Issue)
        if (contact.bodyB.categoryBitMask == BodyType.sideWalls.rawValue && contact.bodyA.categoryBitMask == BodyType.rightMagnet.rawValue)
        {
            let strength = 1.0 * ((rightMagnet.position.x) < frame.width / 2 ? 1 : -1)
            let body = rightMagnet.physicsBody
            body!.applyImpulse(CGVector(dx: strength, dy: 0))
        }
        else if (contact.bodyA.categoryBitMask == BodyType.sideWalls.rawValue && contact.bodyB.categoryBitMask == BodyType.rightMagnet.rawValue)
        {
            let strength = 1.0 * ((rightMagnet.position.x) < frame.width / 2 ? 1 : -1)
            let body = rightMagnet.physicsBody
            body!.applyImpulse(CGVector(dx: strength, dy: 0))
        }
        
        if (contact.bodyA.categoryBitMask == BodyType.rightMagnet.rawValue && contact.bodyB.categoryBitMask == BodyType.topBottomWalls.rawValue)
        {
            let strength = 1.0 * ((rightMagnet.position.x) < frame.height / 2 ? 1 : -1)
            let body = rightMagnet.physicsBody
            body!.applyImpulse(CGVector(dx: 0, dy: strength))
        }
        else if (contact.bodyA.categoryBitMask == BodyType.topBottomWalls.rawValue && contact.bodyB.categoryBitMask == BodyType.rightMagnet.rawValue)
        {
            let strength = 1.0 * ((rightMagnet.position.y) < frame.height / 2 ? 1 : -1)
            let body = rightMagnet.physicsBody
            body!.applyImpulse(CGVector(dx: 0, dy: strength))
        }
        
        if (contact.bodyA.categoryBitMask == BodyType.ball.rawValue && contact.bodyB.categoryBitMask == BodyType.bottomGoalZone.rawValue)
        {
            ballInSouthGoal = true
            run(goalSound)
        }
            
        else if (contact.bodyA.categoryBitMask == BodyType.bottomGoalZone.rawValue && contact.bodyB.categoryBitMask == BodyType.ball.rawValue)
        {
            ballInSouthGoal = true
            run(goalSound)
        }
        
        if (contact.bodyA.categoryBitMask == BodyType.ball.rawValue && contact.bodyB.categoryBitMask == BodyType.topGoalZone.rawValue)
        {
            ballInNorthGoal = true
            run(goalSound)
        }
        else if (contact.bodyA.categoryBitMask == BodyType.topGoalZone.rawValue && contact.bodyB.categoryBitMask == BodyType.ball.rawValue)
        {
            ballInNorthGoal = true
            run(goalSound)
        }
        
        if ((contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.leftMagnet.rawValue) && (contact.bodyA.fieldBitMask != 45 && contact.bodyB.fieldBitMask != 45) && (leftMagnetIsActive == true))
        {
            leftMagnetIsActive = false
            run(magnetPlayerSound)
            Timer.scheduledTimer(withTimeInterval: 0.02, repeats: false, block: { timer in
                self.leftMagnet.position = CGPoint(x: -100, y: -100)
                self.leftMagnet.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                self.botPlayerMagnetCount += 1
            })
        }
        else if (contact.bodyB.categoryBitMask == BodyType.player.rawValue && contact.bodyA.categoryBitMask == BodyType.leftMagnet.rawValue && (contact.bodyA.fieldBitMask != 45 && contact.bodyB.fieldBitMask != 45) && (leftMagnetIsActive == true))
        {
//            magnetClickSoundPlayer.play()
            leftMagnetIsActive = false
            run(magnetPlayerSound)
            Timer.scheduledTimer(withTimeInterval: 0.02, repeats: false, block: { timer in
                self.leftMagnet.position = CGPoint(x: -100, y: -100)
                self.leftMagnet.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                self.botPlayerMagnetCount += 1
            })
        }
        
        if (contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.leftMagnet.rawValue && (contact.bodyA.fieldBitMask == 45 || contact.bodyB.fieldBitMask == 45) && (leftMagnetIsActive == true))
        {
            leftMagnetIsActive = false
            run(magnetPlayerSound)
            Timer.scheduledTimer(withTimeInterval: 0.02, repeats: false, block: { timer in
                self.leftMagnet.position = CGPoint(x: -100, y: -100)
                self.leftMagnet.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                self.southPlayerMagnetCount += 1
            })
        }
        else if (contact.bodyB.categoryBitMask == BodyType.player.rawValue && contact.bodyA.categoryBitMask == BodyType.leftMagnet.rawValue && (contact.bodyA.fieldBitMask == 45 || contact.bodyB.fieldBitMask == 45) && (leftMagnetIsActive == true))
        {
            leftMagnetIsActive = false
            run(magnetPlayerSound)
            Timer.scheduledTimer(withTimeInterval: 0.02, repeats: false, block: { timer in
                self.leftMagnet.position = CGPoint(x: -100, y: -100)
                self.leftMagnet.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                self.southPlayerMagnetCount += 1
            })
        }

        if (contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.centerMagnet.rawValue && (contact.bodyA.fieldBitMask != 45 && contact.bodyB.fieldBitMask != 45) && (centerMagnetIsActive == true))
        {
            centerMagnetIsActive = false
            run(magnetPlayerSound)
            Timer.scheduledTimer(withTimeInterval: 0.02, repeats: false, block: { timer in
                self.centerMagnet.position = CGPoint(x: -100, y: -100)
                self.centerMagnet.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                self.botPlayerMagnetCount += 1
            })
        }
        else if (contact.bodyB.categoryBitMask == BodyType.player.rawValue && contact.bodyA.categoryBitMask == BodyType.centerMagnet.rawValue && (contact.bodyA.fieldBitMask != 45 && contact.bodyB.fieldBitMask != 45) && (centerMagnetIsActive == true))
        {
            centerMagnetIsActive = false
            run(magnetPlayerSound)
            Timer.scheduledTimer(withTimeInterval: 0.02, repeats: false, block: { timer in
                self.centerMagnet.position = CGPoint(x: -100, y: -100)
                self.centerMagnet.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                self.botPlayerMagnetCount += 1
            })
        }
        
        if (contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.centerMagnet.rawValue && (contact.bodyA.fieldBitMask == 45 || contact.bodyB.fieldBitMask == 45) && (centerMagnetIsActive == true))
        {
            centerMagnetIsActive = false
            run(magnetPlayerSound)
            Timer.scheduledTimer(withTimeInterval: 0.02, repeats: false, block: { timer in
                self.centerMagnet.position = CGPoint(x: -100, y: -100)
                self.centerMagnet.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                self.southPlayerMagnetCount += 1
            })
        }
        else if (contact.bodyB.categoryBitMask == BodyType.player.rawValue && contact.bodyA.categoryBitMask == BodyType.centerMagnet.rawValue && (contact.bodyA.fieldBitMask == 45 || contact.bodyB.fieldBitMask == 45) && (centerMagnetIsActive == true))
        {
            centerMagnetIsActive = false
            run(magnetPlayerSound)
            Timer.scheduledTimer(withTimeInterval: 0.02, repeats: false, block: { timer in
                self.centerMagnet.position = CGPoint(x: -100, y: -100)
                self.centerMagnet.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                self.southPlayerMagnetCount += 1

            })
        }

        if (contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.rightMagnet.rawValue && (contact.bodyA.fieldBitMask != 45 && contact.bodyB.fieldBitMask != 45) && (rightMagnetIsActive == true))
        {
            rightMagnetIsActive = false
            run(magnetPlayerSound)
            Timer.scheduledTimer(withTimeInterval: 0.02, repeats: false, block: { timer in
                self.rightMagnet.position = CGPoint(x: -100, y: -100)
                self.rightMagnet.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                self.botPlayerMagnetCount += 1
            })
        }
        
        else if (contact.bodyB.categoryBitMask == BodyType.player.rawValue && contact.bodyA.categoryBitMask == BodyType.rightMagnet.rawValue && (contact.bodyA.fieldBitMask != 45 && contact.bodyB.fieldBitMask != 45) && (rightMagnetIsActive == true))
        {
            rightMagnetIsActive = false
            run(magnetPlayerSound)
            Timer.scheduledTimer(withTimeInterval: 0.02, repeats: false, block: { timer in
                self.rightMagnet.position = CGPoint(x: -100, y: -100)
                self.rightMagnet.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                self.botPlayerMagnetCount += 1
            })
        }

        if (contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.rightMagnet.rawValue && (contact.bodyA.fieldBitMask == 45 || contact.bodyB.fieldBitMask == 45) && rightMagnetIsActive == true)
        {
            rightMagnetIsActive = false
            run(magnetPlayerSound)
            Timer.scheduledTimer(withTimeInterval: 0.02, repeats: false, block: { timer in
                self.rightMagnet.position = CGPoint(x: -100, y: -100)
                self.rightMagnet.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                self.southPlayerMagnetCount += 1

            })
        }
        
        else if (contact.bodyB.categoryBitMask == BodyType.player.rawValue && contact.bodyA.categoryBitMask == BodyType.rightMagnet.rawValue && (contact.bodyA.fieldBitMask == 45 || contact.bodyB.fieldBitMask == 45) && (rightMagnetIsActive == true))
        {
            rightMagnetIsActive = false
            run(magnetPlayerSound)
            Timer.scheduledTimer(withTimeInterval: 0.02, repeats: false, block: { timer in
                self.rightMagnet.position = CGPoint(x: -100, y: -100)
                self.rightMagnet.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                self.southPlayerMagnetCount += 1
            })
        }
    }
    
    func createBotPlayerScore()
    {
        botPlayerScoreText.text = String(botPlayerScore)
        botPlayerScoreText.zRotation =  .pi / 2
        botPlayerScoreTextRightSide.text = String(botPlayerScore)
        botPlayerScoreTextRightSide.zRotation = (3 * .pi) / 2


        if frame.width > 700
        {
            botPlayerScoreText.position = CGPoint(x: frame.width/12, y: frame.height/2 + frame.height/30)
            botPlayerScoreTextRightSide.position = CGPoint(x: frame.width * 18.25/20, y: frame.height/2 + frame.height/30)
            botPlayerScoreText.fontSize = 50
            botPlayerScoreTextRightSide.fontSize = 50
        }
        else
        {
            botPlayerScoreText.position = CGPoint(x: frame.width/10, y: frame.height/2 + frame.height/30)
            botPlayerScoreTextRightSide.position = CGPoint(x: frame.width * 17.85/20, y: frame.height/2 + frame.height/30)
            botPlayerScoreText.fontSize = 32
            botPlayerScoreTextRightSide.fontSize = 32
        }
        addChild(botPlayerScoreText)
        addChild(botPlayerScoreTextRightSide)
        addChild(southPlayerScoreText)
        addChild(southPlayerScoreTextRightSide)
    }
    func updateBotPlayerScore()
    {
        botPlayerScoreText.text = String(botPlayerScore)
        botPlayerScoreTextRightSide.text = String(botPlayerScore)
    }
    
    func createSouthPlayerScore()
    {
        southPlayerScoreText.text = String(southPlayerScore)
        southPlayerScoreText.zRotation = .pi / 2
        southPlayerScoreTextRightSide.text = String(southPlayerScore)
        southPlayerScoreTextRightSide.zRotation = (3 * .pi) / 2


        if frame.width > 700
        {
            southPlayerScoreText.position = CGPoint(x: frame.width/12, y: frame.height/2 - frame.height/30)
            southPlayerScoreTextRightSide.position = CGPoint(x: frame.width * 18.25/20, y: frame.height/2 - frame.height/30)
            southPlayerScoreText.fontSize = 50
            southPlayerScoreTextRightSide.fontSize = 50
        }
        else
        {
            southPlayerScoreText.position = CGPoint(x: frame.width/10, y: frame.height/2 - frame.height/30)
            southPlayerScoreTextRightSide.position = CGPoint(x: frame.width * 17.90/20, y: frame.height/2 - frame.height/30)
            southPlayerScoreText.fontSize = 32
            southPlayerScoreTextRightSide.fontSize = 32
        }
    }
    
    func updateSouthPlayerScore()
    {
        southPlayerScoreText.text = String(southPlayerScore)
        southPlayerScoreTextRightSide.text = String(southPlayerScore)
    }
    
    func adMobShowInterAd()
    {
        guard interstitialAd != nil && interstitialAd!.isReady else
        { // calls interDidReceiveAd
//            print("AdMob inter is not ready, reloading")
            interstitialAd = createAndLoadInterstitial()
            return
        }
//        print("AdMob inter showing...")
        interstitialAd?.present(fromRootViewController: (self.view?.window?.rootViewController)!)
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial)
    {
        interstitialAd = createAndLoadInterstitial()
    }
    
    func gameOverIsTrue()
    {
        if UserDefaults.standard.bool(forKey: "Purchase") == true
        {
        }
        else
        {
            adMobShowInterAd()
        }
        
        if southPlayerScore > botPlayerScore
        {
            whoWonGame = "south player"
        }
        else
        {
            whoWonGame = "bot player"
        }
        
        let scene = GameOverScene(size: (view?.bounds.size)!)
        
        // Configure the view.
        let skView = self.view as! SKView
//        skView.showsFPS = true
//        skView.showsNodeCount = true
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
    
    func scoring()
    {
        if ballInSouthGoal == true
        {
            ballInSouthGoal = false
            botPlayerScore += 1
            ball?.physicsBody?.isDynamic = false
            ball?.position = CGPoint(x: bottomGoal.position.x, y: bottomGoal.position.y)
            updatePlayerLoseWinBackgroundsTopPlayerWinsRound()
            updateBotPlayerScore()
            clearMagnets()
            clearPlayer()
            southPlayerMagnetCount = 0
            botPlayerMagnetCount = 0
            topPlayerWinsRound = true
            if (botPlayerScore * 2) < numberRounds
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
            botPlayerMagnetCount = 0
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
            botPlayerScore += 1
            updateBotPlayerScore()
            topPlayerWinsRound = true
            clearMagnets()
            ball?.physicsBody?.isDynamic = false
            ball?.isHidden = true
            southPlayerMagnetCount = 0
            botPlayerMagnetCount = 0
            clearPlayer()
            if (botPlayerScore * 2) < numberRounds
            {
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { timer in
                    self.southPlayerMagnetCount = 0
                    self.botPlayerMagnetCount = 0
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
            
        else if botPlayerMagnetCount >= 2
        {
            updatePlayerLoseWinBackgroundsBottomPlayerWinsRound()
            southPlayerScore += 1
            updateSouthPlayerScore()
            bottomPlayerWinsRound = true
            clearMagnets()
            ball?.physicsBody?.isDynamic = false
            ball?.isHidden = true
            southPlayerMagnetCount = 0
            botPlayerMagnetCount = 0
            clearPlayer()
            if (southPlayerScore * 2) < numberRounds
            {
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { timer in
                    self.southPlayerMagnetCount = 0
                    self.botPlayerMagnetCount = 0
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
        
        if ((southPlayerScore * 2 >= numberRounds) || botPlayerScore * 2 >= numberRounds) && (gameOver == false)
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
        
        springFieldSouthPlayer.position = CGPoint(x: southPlayer!.position.x, y: (southPlayer?.position.y)!)
        springFieldBotPlayer.position = CGPoint(x: botPlayer!.position.x, y: (botPlayer?.position.y)!)
//        electricFieldNorthPlayer.position = CGPoint(x: botPlayer!.position.x, y: (botPlayer?.position.y)!)
        
        placeMagnetXMarks()
        scoring()
        if (ball?.physicsBody?.velocity.dx)! > CGFloat(800)
        {
            ball?.physicsBody?.velocity.dx = 800
        }
        else if (ball?.physicsBody?.velocity.dx)! < CGFloat(-800)
        {
            ball?.physicsBody?.velocity.dx = -800
        }
        if (ball?.physicsBody?.velocity.dy)! > CGFloat(800)
        {
            ball?.physicsBody?.velocity.dy = 800
        }
        else if (ball?.physicsBody?.velocity.dy)! < CGFloat(-800)
        {
            ball?.physicsBody?.velocity.dy = -800
        }
        
        var botPlayerPosition = CGPoint()
        botPlayerPosition = CGPoint(x: botPlayer!.position.x, y: botPlayer!.position.y)
        
//        if botPlayerPosition.distanceFromCGPoint(point: leftMagnet.position) < 150 || botPlayerPosition.distanceFromCGPoint(point: centerMagnet.position) < 150 || botPlayerPosition.distanceFromCGPoint(point: rightMagnet.position) < 150
//        {
//            if botPlayerPosition.distanceFromCGPoint(point: leftMagnet.position) < 150
//            {
//                botPlayer?.physicsBody?.velocity = CGVector(dx: -leftMagnet.physicsBody!.velocity.dy, dy: -leftMagnet.physicsBody!.velocity.dx)
//            }
//            if botPlayerPosition.distanceFromCGPoint(point: centerMagnet.position) < 150
//            {
//                botPlayer?.physicsBody?.velocity = CGVector(dx: -centerMagnet.physicsBody!.velocity.dy, dy: -centerMagnet.physicsBody!.velocity.dx)
//            }
//            if botPlayerPosition.distanceFromCGPoint(point: rightMagnet.position) < 150
//            {
//                botPlayer?.physicsBody?.velocity = CGVector(dx: -rightMagnet.physicsBody!.velocity.dy, dy: -rightMagnet.physicsBody!.velocity.dx)
//            }
//        }
        let botDistanceFromLeftMagnet = botPlayerPosition.distanceFromCGPoint(point: leftMagnet.position)
        let botDistanceFromCenterMagnet = botPlayerPosition.distanceFromCGPoint(point: centerMagnet.position)
        let botDistanceFromRightMagnet = botPlayerPosition.distanceFromCGPoint(point: rightMagnet.position)
        

        if botDistanceFromLeftMagnet < 100 && botDistanceFromLeftMagnet < botDistanceFromCenterMagnet && botDistanceFromLeftMagnet < botDistanceFromRightMagnet
        {
            botNearCenterMagnet = false
            botNearRightMagnet = false
            botNearLeftMagnet = true
            if leftMagnet.physicsBody!.velocity.dx < 0 && leftMagnet.physicsBody!.velocity.dy < 0
            {
                //Magnet in 3rd quadrant
                if leftMagnet.position.x < botPlayer!.position.x && leftMagnet.position.y < botPlayer!.position.y
                {
                    botPlayer?.physicsBody!.velocity.dx += AIMagnetAvoidingSpeed
                    botPlayer?.physicsBody!.velocity.dy += AIMagnetAvoidingSpeed
                }
                //Magnet in 2nd quadrant
                else if leftMagnet.position.x > botPlayer!.position.x && leftMagnet.position.y > botPlayer!.position.y
                {
                    if abs(leftMagnet.physicsBody!.velocity.dy) / abs(leftMagnet.physicsBody!.velocity.dx) > 2.0
                    {
                        print("here")
                        botPlayer?.physicsBody?.velocity = CGVector(dx: leftMagnet.physicsBody!.velocity.dy, dy: -1)
                    }
                    else
                    {
                        botPlayer?.physicsBody!.velocity.dx -= AIMagnetAvoidingSpeed
                        botPlayer?.physicsBody!.velocity.dy -= AIMagnetAvoidingSpeed
                    }

                }
                    
                //Magnet in 4th quadrant
                else if leftMagnet.position.x > botPlayer!.position.x && leftMagnet.position.y < botPlayer!.position.y
                {
                    botPlayer?.physicsBody!.velocity.dx += AIMagnetAvoidingSpeed
                    botPlayer?.physicsBody!.velocity.dy += AIMagnetAvoidingSpeed
                }
                //Magnet in 1st quadrant
                else if leftMagnet.position.x < botPlayer!.position.x && leftMagnet.position.y > botPlayer!.position.y
                {
                    botPlayer?.physicsBody!.velocity.dx += AIMagnetAvoidingSpeed
                    botPlayer?.physicsBody!.velocity.dy -= AIMagnetAvoidingSpeed
                }
            }
            else if leftMagnet.physicsBody!.velocity.dx > 0 && leftMagnet.physicsBody!.velocity.dy > 0
            {
                //Magnet in 3rd quadrant
                if leftMagnet.position.x < botPlayer!.position.x && leftMagnet.position.y < botPlayer!.position.y
                {
                    if abs(leftMagnet.physicsBody!.velocity.dy) / abs(leftMagnet.physicsBody!.velocity.dx) > 2.0
                    {
                        print("here")
                        botPlayer?.physicsBody?.velocity = CGVector(dx: leftMagnet.physicsBody!.velocity.dy, dy: 1)
                    }
                    else
                    {
                        botPlayer?.physicsBody!.velocity.dx += AIMagnetAvoidingSpeed
                        botPlayer?.physicsBody!.velocity.dy -= AIMagnetAvoidingSpeed
                    }
                }
                //Magnet in 2nd quadrant
                else if leftMagnet.position.x > botPlayer!.position.x && leftMagnet.position.y > botPlayer!.position.y
                {
                    botPlayer?.physicsBody!.velocity.dx -= AIMagnetAvoidingSpeed
                    botPlayer?.physicsBody!.velocity.dy -= AIMagnetAvoidingSpeed
                }

                //Magnet in 4th quadrant
                else if leftMagnet.position.x > botPlayer!.position.x && leftMagnet.position.y < botPlayer!.position.y
                {
                    if abs(leftMagnet.physicsBody!.velocity.dy) / abs(leftMagnet.physicsBody!.velocity.dx) > 2.0
                    {
                        print("here")
                        botPlayer?.physicsBody?.velocity = CGVector(dx: -leftMagnet.physicsBody!.velocity.dy, dy: 1)
                    }
                    else
                    {
                        botPlayer?.physicsBody!.velocity.dx -= AIMagnetAvoidingSpeed
                        botPlayer?.physicsBody!.velocity.dy += AIMagnetAvoidingSpeed
                    }
                }
                //Magnet in 1st quadrant
                else if leftMagnet.position.x < botPlayer!.position.x && leftMagnet.position.y > botPlayer!.position.y
                {
                    botPlayer?.physicsBody!.velocity.dx += AIMagnetAvoidingSpeed
                    botPlayer?.physicsBody!.velocity.dy -= AIMagnetAvoidingSpeed
                }
            }
            else if leftMagnet.physicsBody!.velocity.dx > 0 && leftMagnet.physicsBody!.velocity.dy < 0
            {
                //Magnet in 3rd quadrant
                if leftMagnet.position.x < botPlayer!.position.x && leftMagnet.position.y < botPlayer!.position.y
                {
                    botPlayer?.physicsBody!.velocity.dx += AIMagnetAvoidingSpeed
                    botPlayer?.physicsBody!.velocity.dy += AIMagnetAvoidingSpeed
                }
                //Magnet in 2nd quadrant
                else if leftMagnet.position.x > botPlayer!.position.x && leftMagnet.position.y > botPlayer!.position.y
                {
                    botPlayer?.physicsBody!.velocity.dx -= AIMagnetAvoidingSpeed
                    botPlayer?.physicsBody!.velocity.dy -= AIMagnetAvoidingSpeed
                }

                //Magnet in 4th quadrant
                else if leftMagnet.position.x > botPlayer!.position.x && leftMagnet.position.y < botPlayer!.position.y
                {
                    botPlayer?.physicsBody!.velocity.dx -= AIMagnetAvoidingSpeed
                    botPlayer?.physicsBody!.velocity.dy += AIMagnetAvoidingSpeed
                }
                //Magnet in 1st quadrant
                else if leftMagnet.position.x < botPlayer!.position.x && leftMagnet.position.y > botPlayer!.position.y
                {
                    if abs(leftMagnet.physicsBody!.velocity.dy) / abs(leftMagnet.physicsBody!.velocity.dx) > 2.0
                    {
                        print("here")
                        botPlayer?.physicsBody?.velocity = CGVector(dx: -leftMagnet.physicsBody!.velocity.dy, dy: -1)
                    }
                    else
                    {
                        botPlayer?.physicsBody!.velocity.dx -= AIMagnetAvoidingSpeed
                        botPlayer?.physicsBody!.velocity.dy -= AIMagnetAvoidingSpeed
                    }
                }
            }
            else if leftMagnet.physicsBody!.velocity.dx < 0 && leftMagnet.physicsBody!.velocity.dy > 0
            {
                //Magnet in 3rd quadrant
                if leftMagnet.position.x < botPlayer!.position.x && leftMagnet.position.y < botPlayer!.position.y
                {
                    if abs(leftMagnet.physicsBody!.velocity.dy) / abs(leftMagnet.physicsBody!.velocity.dx) > 2.0
                    {
                        print("here")
                        botPlayer?.physicsBody?.velocity = CGVector(dx: leftMagnet.physicsBody!.velocity.dy, dy: 1)
                    }
                    else
                    {
                        botPlayer?.physicsBody!.velocity.dx += AIMagnetAvoidingSpeed
                        botPlayer?.physicsBody!.velocity.dy += AIMagnetAvoidingSpeed
                    }
                }
                //Magnet in 2nd quadrant
                else if leftMagnet.position.x > botPlayer!.position.x && leftMagnet.position.y > botPlayer!.position.y
                {
                    botPlayer?.physicsBody!.velocity.dx -= AIMagnetAvoidingSpeed
                    botPlayer?.physicsBody!.velocity.dy -= AIMagnetAvoidingSpeed
                }

                //Magnet in 4th quadrant
                else if leftMagnet.position.x > botPlayer!.position.x && leftMagnet.position.y < botPlayer!.position.y
                {
                    if abs(leftMagnet.physicsBody!.velocity.dy) / abs(leftMagnet.physicsBody!.velocity.dx) > 2.0
                    {
                        print("here")
                        botPlayer?.physicsBody?.velocity = CGVector(dx: -leftMagnet.physicsBody!.velocity.dy, dy: 1)
                    }
                    else
                    {
                        botPlayer?.physicsBody!.velocity.dx -= AIMagnetAvoidingSpeed
                        botPlayer?.physicsBody!.velocity.dy += AIMagnetAvoidingSpeed
                    }
                }
                //Magnet in 1st quadrant
                else if leftMagnet.position.x < botPlayer!.position.x && leftMagnet.position.y > botPlayer!.position.y
                {
                    botPlayer?.physicsBody!.velocity.dx += AIMagnetAvoidingSpeed
                    botPlayer?.physicsBody!.velocity.dy -= AIMagnetAvoidingSpeed
                }
            }
        }
        
        else
        {
            botNearLeftMagnet = false
        }

        
        
        if botDistanceFromCenterMagnet < 100 && botDistanceFromCenterMagnet < botDistanceFromLeftMagnet && botDistanceFromCenterMagnet < botDistanceFromRightMagnet
        {
            botNearCenterMagnet = true
            botNearRightMagnet = false
            botNearLeftMagnet = false
            
            if centerMagnet.physicsBody!.velocity.dx < 0 && centerMagnet.physicsBody!.velocity.dy < 0
            {
                //Magnet in 3rd quadrant
                if centerMagnet.position.x < botPlayer!.position.x && centerMagnet.position.y < botPlayer!.position.y
                {
                    botPlayer?.physicsBody!.velocity.dx += AIMagnetAvoidingSpeed
                    botPlayer?.physicsBody!.velocity.dy += AIMagnetAvoidingSpeed
                }
                //Magnet in 2nd quadrant
                else if centerMagnet.position.x > botPlayer!.position.x && centerMagnet.position.y > botPlayer!.position.y
                {
                    if abs(centerMagnet.physicsBody!.velocity.dy) / abs(centerMagnet.physicsBody!.velocity.dx) > 2.0
                    {
                        print("here")
                        botPlayer?.physicsBody?.velocity = CGVector(dx: centerMagnet.physicsBody!.velocity.dy, dy: -1)
                    }
                    else
                    {
                        botPlayer?.physicsBody!.velocity.dx -= AIMagnetAvoidingSpeed
                        botPlayer?.physicsBody!.velocity.dy -= AIMagnetAvoidingSpeed
                    }
                }

                //Magnet in 4th quadrant
                else if centerMagnet.position.x > botPlayer!.position.x && centerMagnet.position.y < botPlayer!.position.y
                {
                    botPlayer?.physicsBody!.velocity.dx += AIMagnetAvoidingSpeed
                    botPlayer?.physicsBody!.velocity.dy += AIMagnetAvoidingSpeed
                }
                //Magnet in 1st quadrant
                else if centerMagnet.position.x < botPlayer!.position.x && centerMagnet.position.y > botPlayer!.position.y
                {
                    botPlayer?.physicsBody!.velocity.dx += AIMagnetAvoidingSpeed
                    botPlayer?.physicsBody!.velocity.dy -= AIMagnetAvoidingSpeed
                }
            }
            else if centerMagnet.physicsBody!.velocity.dx > 0 && centerMagnet.physicsBody!.velocity.dy > 0
            {
                //Magnet in 3rd quadrant
                if centerMagnet.position.x < botPlayer!.position.x && centerMagnet.position.y < botPlayer!.position.y
                {
                    if abs(centerMagnet.physicsBody!.velocity.dy) / abs(centerMagnet.physicsBody!.velocity.dx) > 2.0
                    {
                        print("here")
                        botPlayer?.physicsBody?.velocity = CGVector(dx: centerMagnet.physicsBody!.velocity.dy, dy: 1)
                    }
                    else
                    {
                        botPlayer?.physicsBody!.velocity.dx += AIMagnetAvoidingSpeed
                        botPlayer?.physicsBody!.velocity.dy += AIMagnetAvoidingSpeed
                    }
                }
                //Magnet in 2nd quadrant
                else if centerMagnet.position.x > botPlayer!.position.x && centerMagnet.position.y > botPlayer!.position.y
                {
                    botPlayer?.physicsBody!.velocity.dx -= AIMagnetAvoidingSpeed
                    botPlayer?.physicsBody!.velocity.dy -= AIMagnetAvoidingSpeed
                }

                //Magnet in 4th quadrant
                else if centerMagnet.position.x > botPlayer!.position.x && centerMagnet.position.y < botPlayer!.position.y
                {
                    if abs(centerMagnet.physicsBody!.velocity.dy) / abs(centerMagnet.physicsBody!.velocity.dx) > 2.0
                    {
                        print("here")
                        botPlayer?.physicsBody?.velocity = CGVector(dx: -centerMagnet.physicsBody!.velocity.dy, dy: 1)
                    }
                    else
                    {
                        botPlayer?.physicsBody!.velocity.dx -= AIMagnetAvoidingSpeed
                        botPlayer?.physicsBody!.velocity.dy += AIMagnetAvoidingSpeed
                    }
                }
                //Magnet in 1st quadrant
                else if centerMagnet.position.x < botPlayer!.position.x && centerMagnet.position.y > botPlayer!.position.y
                {
                    botPlayer?.physicsBody!.velocity.dx += AIMagnetAvoidingSpeed
                    botPlayer?.physicsBody!.velocity.dy -= AIMagnetAvoidingSpeed
                }
            }
            else if centerMagnet.physicsBody!.velocity.dx > 0 && centerMagnet.physicsBody!.velocity.dy < 0
            {
                //Magnet in 3rd quadrant
                if centerMagnet.position.x < botPlayer!.position.x && centerMagnet.position.y < botPlayer!.position.y
                {
                    botPlayer?.physicsBody!.velocity.dx += AIMagnetAvoidingSpeed
                    botPlayer?.physicsBody!.velocity.dy += AIMagnetAvoidingSpeed
                }
                //Magnet in 2nd quadrant
                else if centerMagnet.position.x > botPlayer!.position.x && centerMagnet.position.y > botPlayer!.position.y
                {
                    botPlayer?.physicsBody!.velocity.dx -= AIMagnetAvoidingSpeed
                    botPlayer?.physicsBody!.velocity.dy -= AIMagnetAvoidingSpeed
                }

                //Magnet in 4th quadrant
                else if centerMagnet.position.x > botPlayer!.position.x && centerMagnet.position.y < botPlayer!.position.y
                {
                    botPlayer?.physicsBody!.velocity.dx -= AIMagnetAvoidingSpeed
                    botPlayer?.physicsBody!.velocity.dy += AIMagnetAvoidingSpeed
                }
                //Magnet in 1st quadrant
                else if centerMagnet.position.x < botPlayer!.position.x && centerMagnet.position.y > botPlayer!.position.y
                {
                    if abs(centerMagnet.physicsBody!.velocity.dy) / abs(centerMagnet.physicsBody!.velocity.dx) > 2.0
                    {
                        print("here")
                        botPlayer?.physicsBody?.velocity = CGVector(dx: -centerMagnet.physicsBody!.velocity.dy, dy: -1)
                    }
                    else
                    {
                        botPlayer?.physicsBody!.velocity.dx -= AIMagnetAvoidingSpeed
                        botPlayer?.physicsBody!.velocity.dy -= AIMagnetAvoidingSpeed
                    }
                }
            }
            else if centerMagnet.physicsBody!.velocity.dx < 0 && centerMagnet.physicsBody!.velocity.dy > 0
            {
                //Magnet in 3rd quadrant
                if centerMagnet.position.x < botPlayer!.position.x && centerMagnet.position.y < botPlayer!.position.y
                {
                    if abs(centerMagnet.physicsBody!.velocity.dy) / abs(centerMagnet.physicsBody!.velocity.dx) > 2.0
                    {
                        print("here")
                        botPlayer?.physicsBody?.velocity = CGVector(dx: centerMagnet.physicsBody!.velocity.dy, dy: 1)
                    }
                    else
                    {
                        botPlayer?.physicsBody!.velocity.dx += AIMagnetAvoidingSpeed
                        botPlayer?.physicsBody!.velocity.dy += AIMagnetAvoidingSpeed
                    }
                }
                //Magnet in 2nd quadrant
                else if centerMagnet.position.x > botPlayer!.position.x && centerMagnet.position.y > botPlayer!.position.y
                {
                    botPlayer?.physicsBody!.velocity.dx -= AIMagnetAvoidingSpeed
                    botPlayer?.physicsBody!.velocity.dy -= AIMagnetAvoidingSpeed
                }

                //Magnet in 4th quadrant
                else if centerMagnet.position.x > botPlayer!.position.x && centerMagnet.position.y < botPlayer!.position.y
                {
                    if abs(centerMagnet.physicsBody!.velocity.dy) / abs(centerMagnet.physicsBody!.velocity.dx) > 2.0
                    {
                        print("here")
                        botPlayer?.physicsBody?.velocity = CGVector(dx: -centerMagnet.physicsBody!.velocity.dy, dy: 1)
                    }
                    else
                    {
                        botPlayer?.physicsBody!.velocity.dx -= AIMagnetAvoidingSpeed
                        botPlayer?.physicsBody!.velocity.dy += AIMagnetAvoidingSpeed
                    }
                }
                //Magnet in 1st quadrant
                else if centerMagnet.position.x < botPlayer!.position.x && centerMagnet.position.y > botPlayer!.position.y
                {
                    botPlayer?.physicsBody!.velocity.dx += AIMagnetAvoidingSpeed
                    botPlayer?.physicsBody!.velocity.dy -= AIMagnetAvoidingSpeed
                }
            }
        }
            
        else
        {
            botNearCenterMagnet = false
        }
            
        if botDistanceFromRightMagnet < 100 && botDistanceFromRightMagnet < botDistanceFromLeftMagnet && botDistanceFromRightMagnet < botDistanceFromCenterMagnet
        {
            botNearCenterMagnet = false
            botNearRightMagnet = true
            botNearLeftMagnet = false
            if rightMagnet.physicsBody!.velocity.dx < 0 && rightMagnet.physicsBody!.velocity.dy < 0
            {
                //Magnet in 3rd quadrant
                if rightMagnet.position.x < botPlayer!.position.x && rightMagnet.position.y < botPlayer!.position.y
                {
                    botPlayer?.physicsBody!.velocity.dx += AIMagnetAvoidingSpeed
                    botPlayer?.physicsBody!.velocity.dy += AIMagnetAvoidingSpeed
                }
                //Magnet in 2nd quadrant
                else if rightMagnet.position.x > botPlayer!.position.x && rightMagnet.position.y > botPlayer!.position.y
                {
                    if abs(rightMagnet.physicsBody!.velocity.dy) / abs(rightMagnet.physicsBody!.velocity.dx) > 2.0
                    {
                        print("here")
                        botPlayer?.physicsBody?.velocity = CGVector(dx: rightMagnet.physicsBody!.velocity.dy, dy: -1)
                    }
                    else
                    {
                        botPlayer?.physicsBody!.velocity.dx -= AIMagnetAvoidingSpeed
                        botPlayer?.physicsBody!.velocity.dy -= AIMagnetAvoidingSpeed
                    }
                }

                //Magnet in 4th quadrant
                else if rightMagnet.position.x > botPlayer!.position.x && rightMagnet.position.y < botPlayer!.position.y
                {
                    botPlayer?.physicsBody!.velocity.dx += AIMagnetAvoidingSpeed
                    botPlayer?.physicsBody!.velocity.dy += AIMagnetAvoidingSpeed
                }
                //Magnet in 1st quadrant
                else if rightMagnet.position.x < botPlayer!.position.x && rightMagnet.position.y > botPlayer!.position.y
                {
                    botPlayer?.physicsBody!.velocity.dx += AIMagnetAvoidingSpeed
                    botPlayer?.physicsBody!.velocity.dy -= AIMagnetAvoidingSpeed
                }
            }
            else if rightMagnet.physicsBody!.velocity.dx > 0 && rightMagnet.physicsBody!.velocity.dy > 0
            {
                //Magnet in 3rd quadrant
                if rightMagnet.position.x < botPlayer!.position.x && rightMagnet.position.y < botPlayer!.position.y
                {
                    if abs(rightMagnet.physicsBody!.velocity.dy) / abs(rightMagnet.physicsBody!.velocity.dx) > 2.0
                    {
                        print("here")
                        botPlayer?.physicsBody?.velocity = CGVector(dx: rightMagnet.physicsBody!.velocity.dy, dy: 1)
                    }
                    else
                    {
                        botPlayer?.physicsBody!.velocity.dx += AIMagnetAvoidingSpeed
                        botPlayer?.physicsBody!.velocity.dy += AIMagnetAvoidingSpeed
                    }
                }
                //Magnet in 2nd quadrant
                else if rightMagnet.position.x > botPlayer!.position.x && rightMagnet.position.y > botPlayer!.position.y
                {
                    botPlayer?.physicsBody!.velocity.dx -= AIMagnetAvoidingSpeed
                    botPlayer?.physicsBody!.velocity.dy += AIMagnetAvoidingSpeed
                }

                //Magnet in 4th quadrant
                else if rightMagnet.position.x > botPlayer!.position.x && rightMagnet.position.y < botPlayer!.position.y
                {
                    if abs(rightMagnet.physicsBody!.velocity.dy) / abs(rightMagnet.physicsBody!.velocity.dx) > 2.0
                    {
                        print("here")
                        botPlayer?.physicsBody?.velocity = CGVector(dx: -rightMagnet.physicsBody!.velocity.dy, dy: 1)
                    }
                    else
                    {
                        botPlayer?.physicsBody!.velocity.dx -= AIMagnetAvoidingSpeed
                        botPlayer?.physicsBody!.velocity.dy += AIMagnetAvoidingSpeed
                    }
                }
                //Magnet in 1st quadrant
                else if rightMagnet.position.x < botPlayer!.position.x && rightMagnet.position.y > botPlayer!.position.y
                {
                    botPlayer?.physicsBody!.velocity.dx += AIMagnetAvoidingSpeed
                    botPlayer?.physicsBody!.velocity.dy -= AIMagnetAvoidingSpeed
                }
            }
            else if rightMagnet.physicsBody!.velocity.dx > 0 && rightMagnet.physicsBody!.velocity.dy < 0
            {
                //Magnet in 3rd quadrant
                if rightMagnet.position.x < botPlayer!.position.x && rightMagnet.position.y < botPlayer!.position.y
                {
                    botPlayer?.physicsBody!.velocity.dx += AIMagnetAvoidingSpeed
                    botPlayer?.physicsBody!.velocity.dy += AIMagnetAvoidingSpeed
                }
                //Magnet in 2nd quadrant
                else if rightMagnet.position.x > botPlayer!.position.x && rightMagnet.position.y > botPlayer!.position.y
                {
                    botPlayer?.physicsBody!.velocity.dx -= AIMagnetAvoidingSpeed
                    botPlayer?.physicsBody!.velocity.dy -= AIMagnetAvoidingSpeed
                }

                //Magnet in 4th quadrant
                else if rightMagnet.position.x > botPlayer!.position.x && rightMagnet.position.y < botPlayer!.position.y
                {
                    botPlayer?.physicsBody!.velocity.dx -= AIMagnetAvoidingSpeed
                    botPlayer?.physicsBody!.velocity.dy += AIMagnetAvoidingSpeed
                }
                //Magnet in 1st quadrant
                else if rightMagnet.position.x < botPlayer!.position.x && rightMagnet.position.y > botPlayer!.position.y
                {
                    if abs(rightMagnet.physicsBody!.velocity.dy) / abs(rightMagnet.physicsBody!.velocity.dx) > 2.0
                    {
                        print("here")
                        botPlayer?.physicsBody?.velocity = CGVector(dx: -rightMagnet.physicsBody!.velocity.dy, dy: -1)
                    }
                    else
                    {
                        botPlayer?.physicsBody!.velocity.dx -= AIMagnetAvoidingSpeed
                        botPlayer?.physicsBody!.velocity.dy -= AIMagnetAvoidingSpeed
                    }
                }
            }
            else if rightMagnet.physicsBody!.velocity.dx < 0 && rightMagnet.physicsBody!.velocity.dy > 0
            {
                //Magnet in 3rd quadrant
                if rightMagnet.position.x < botPlayer!.position.x && rightMagnet.position.y < botPlayer!.position.y
                {
                    if abs(rightMagnet.physicsBody!.velocity.dy) / abs(rightMagnet.physicsBody!.velocity.dx) > 2.0
                    {
                        print("here")
                        botPlayer?.physicsBody?.velocity = CGVector(dx: rightMagnet.physicsBody!.velocity.dy, dy: 1)
                    }
                    else
                    {
                        botPlayer?.physicsBody!.velocity.dx += AIMagnetAvoidingSpeed
                        botPlayer?.physicsBody!.velocity.dy += AIMagnetAvoidingSpeed
                    }
                }
                //Magnet in 2nd quadrant
                else if rightMagnet.position.x > botPlayer!.position.x && rightMagnet.position.y > botPlayer!.position.y
                {
                    botPlayer?.physicsBody!.velocity.dx -= AIMagnetAvoidingSpeed
                    botPlayer?.physicsBody!.velocity.dy -= AIMagnetAvoidingSpeed
                }

                //Magnet in 4th quadrant
                else if rightMagnet.position.x > botPlayer!.position.x && rightMagnet.position.y < botPlayer!.position.y
                {
                    if abs(rightMagnet.physicsBody!.velocity.dy) / abs(rightMagnet.physicsBody!.velocity.dx) > 2.0
                    {
                        print("here")
                        botPlayer?.physicsBody?.velocity = CGVector(dx: -rightMagnet.physicsBody!.velocity.dy, dy: 1)
                    }
                    else
                    {
                        botPlayer?.physicsBody!.velocity.dx -= AIMagnetAvoidingSpeed
                        botPlayer?.physicsBody!.velocity.dy += AIMagnetAvoidingSpeed
                    }
                }
                //Magnet in 1st quadrant
                else if rightMagnet.position.x < botPlayer!.position.x && rightMagnet.position.y > botPlayer!.position.y
                {
                    botPlayer?.physicsBody!.velocity.dx += AIMagnetAvoidingSpeed
                    botPlayer?.physicsBody!.velocity.dy -= AIMagnetAvoidingSpeed
                }
            }
        }
            
        else
        {
            botNearRightMagnet = false
        }
        
        if ball!.position.y < frame.height/2 && botNearLeftMagnet == false && botNearCenterMagnet == false && botNearRightMagnet == false
        {
            botNearLeftMagnet = false
            botPlayer?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            if botPlayer!.position.y < frame.height * 0.75
            {
                botPlayer?.physicsBody!.velocity.dy += 60
            }
            else if botPlayer!.position.y > frame.height * 0.75
            {
                botPlayer?.physicsBody!.velocity.dy -= 60
            }
            if botPlayer!.position.x < frame.width * 0.50
            {
                botPlayer?.physicsBody!.velocity.dx += 60
            }
            else if botPlayer!.position.x > frame.width * 0.50
            {
                botPlayer?.physicsBody!.velocity.dx -= 60
            }
        }
        
        else if ball!.position.y > frame.height/2 && botNearLeftMagnet == false && botNearCenterMagnet == false && botNearRightMagnet == false
        {
            botPlayer?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        }
            
        if botPlayer!.position.y < frame.height/2 + 1
        {
            botPlayer?.position.y = frame.height/2 + 1
        }
        
//        print("CM DX: ", centerMagnet.physicsBody?.velocity.dx)
//        print("CM DY: ", centerMagnet.physicsBody?.velocity.dy)
    }
}

extension CGPoint
{
    func distanceFromCGPoint(point:CGPoint)->CGFloat
    {
        return sqrt(pow(self.x - point.x,2) + pow(self.y - point.y,2))
    }
}
