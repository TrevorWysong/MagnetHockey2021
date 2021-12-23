//
//  AirHockey2P.swift
//  AirHockey2P
//
//  Created by Wysong, Trevor on 9/27/21.
//  Copyright © 2021 Wysong, Trevor. All rights reserved.
//

import SpriteKit
import GameplayKit
import GoogleMobileAds

class AirHockey2P: SKScene, SKPhysicsContactDelegate, BottomPlayerDelegate, NorthPlayerDelegate, GADInterstitialDelegate
{
    var frameCounter = 0
    var ball : SKShapeNode?
    var ballRadius = CGFloat(0.0)
    var playerRadius = CGFloat(0.0)
    var maxBallSpeed = CGFloat(0.0)
    var centerCircle = SKSpriteNode()
    var semiCircleBottom = SKSpriteNode()
    var semiCircleTop = SKSpriteNode()
    var playerLosesBackground = SKSpriteNode()
    var playerWinsBackground = SKSpriteNode()
    var pauseBackground = SKSpriteNode()
    var xMark = SKSpriteNode()
    var checkMark = SKSpriteNode()
    var ballInSouthGoal = false
    var ballInNorthGoal = false
    var ballSoundControl = true
    var pauseButton = SKSpriteNode()
    var pauseButtonSprite = SKSpriteNode()
    var backToMenuButton = SKSpriteNode()
    let backToMenuButtonLabel = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    let pauseTitleLabel1 = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    let pauseTitleLabel2 = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    var pauseTitleBackground1 = SKSpriteNode()
    var pauseTitleBackground2 = SKSpriteNode()
    var soundButton = SKSpriteNode()
    var soundButtonSprite = SKSpriteNode()
    var soundButtonOffSprite = SKSpriteNode()
    var playButtonSprite = SKSpriteNode()
    var touchedPauseButton = false
    var touchedBackToMenuButton = false
    var touchedSoundOff = false
    var southPlayer : BottomPlayer?
    var northPlayer : NorthPlayer?
    let gameType = UserDefaults.standard.string(forKey: "GameType")!
    let listenerNode = SKNode()
    var southPlayerArea = CGRect()
    var northPlayerArea = CGRect()
    var southPlayerScore = 0
    var northPlayerScore = 0
    var bottomPlayerForceForCollision = CGVector()
    var northPlayerForceForCollision = CGVector()
    let northPlayerScoreText = SKLabelNode(fontNamed: "Helvetica Neue UltraLight")
    let southPlayerScoreText = SKLabelNode(fontNamed: "Helvetica Neue UltraLight")
    var whoWonGame = ""
    var topPlayerWinsRound = false
    var bottomPlayerWinsRound = false
    var gameOver = false
    var bottomTouchForCollision = false
    var northTouchForCollision = false
    var repulsionMode = false
    var numberRounds = 0
    var numberGames = 0
    var tempBallVelocity = CGVector(dx: 0, dy: 0)
    var tempResetBallPosition = CGPoint(x: 0, y: 0)
    var topGoalEdgeBottom = CGFloat(0.0)
    var bottomGoalEdgeTop = CGFloat(0.0)
    var ballColorGame = ""
    let playerHitBallSound = SKAction.playSoundFileNamed("ballHitsWall2.mp3", waitForCompletion: false)
    let ballHitWallSound = SKAction.playSoundFileNamed("ballHitsWall.mp3", waitForCompletion: false)
    let goalSound = SKAction.playSoundFileNamed("Goal3.mp3", waitForCompletion: false)
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
        southPlayerArea = CGRect(x: 0, y: frame.height * 0.00, width: frame.width, height: frame.height * 0.50)
        northPlayerArea = CGRect(x: 0, y: frame.height/2, width: frame.width, height: frame.height * 0.50)
        
        if frame.height >= 812 && frame.height <= 900 && frame.width < 500
        {
            let southPlayerStartPoint = CGPoint(x: frame.midX, y: frame.height * 0.22)
            let northPlayerStartPoint = CGPoint(x: frame.midX, y: frame.height * 0.78)
            southPlayer = bottomPlayer(at: southPlayerStartPoint, boundary: southPlayerArea)
            northPlayer = northPlayer(at: northPlayerStartPoint, boundary: northPlayerArea)
        }
        else if frame.height == 926 && frame.width < 500
        {
            let southPlayerStartPoint = CGPoint(x: frame.midX, y: frame.height * 0.225)
            let northPlayerStartPoint = CGPoint(x: frame.midX, y: frame.height * 0.775)
            southPlayer = bottomPlayer(at: southPlayerStartPoint, boundary: southPlayerArea)
            northPlayer = northPlayer(at: northPlayerStartPoint, boundary: northPlayerArea)
        }
        else
        {
            let southPlayerStartPoint = CGPoint(x: frame.midX, y: frame.height * 0.185)
            let northPlayerStartPoint = CGPoint(x: frame.midX, y: frame.height * 0.815)
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
        playerRadius = southPlayer!.radius
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
        let edgeWidth = frame.width * 0.03
        let notchOffset = frame.height * 0.0625

        let leftEdge = SKSpriteNode(color: UIColor.darkGray, size: CGSize(width: edgeWidth, height: frame.height))
        leftEdge.position = CGPoint(x: 0 + (edgeWidth/2), y: frame.height/2)
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
        let rightEdge = SKSpriteNode(color: UIColor.darkGray, size: CGSize(width: edgeWidth, height: frame.height))
        rightEdge.position = CGPoint(x: frame.width - (edgeWidth/2), y: frame.height/2)
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
        
        let bottomRightEdge = SKSpriteNode(color: UIColor.darkGray, size: CGSize(width: frame.width * 0.20, height: edgeWidth))
        if frame.height > 800 && frame.width < 500
        {
            bottomRightEdge.size.height = notchOffset
            bottomRightEdge.position = CGPoint(x: frame.width * 0.90, y: 0 + notchOffset/2)
        }
        else
        {
            bottomRightEdge.size.height = edgeWidth
            bottomRightEdge.position = CGPoint(x: frame.width * 0.90, y: 0 + edgeWidth/2)
        }
        bottomRightEdge.zPosition = -5
        //setup physics for this edge
        bottomRightEdge.physicsBody = SKPhysicsBody(rectangleOf: bottomRightEdge.size)
        bottomRightEdge.physicsBody!.isDynamic = false
        bottomRightEdge.physicsBody?.mass = 10000000
        bottomRightEdge.physicsBody?.categoryBitMask = BodyType.topBottomWalls.rawValue
        bottomRightEdge.physicsBody?.contactTestBitMask = 512
        bottomRightEdge.physicsBody?.restitution = 1.0
        bottomRightEdge.physicsBody?.friction = 0.0
        bottomRightEdge.physicsBody?.linearDamping = 0.0
        bottomRightEdge.physicsBody?.angularDamping = 0.0
        bottomRightEdge.blendMode = .replace
        addChild(bottomRightEdge)
        
        let bottomLeftEdge = SKSpriteNode(color: UIColor.darkGray, size: CGSize(width: frame.width * 0.20, height: edgeWidth))
        if frame.height > 800 && frame.width < 500
        {
            bottomLeftEdge.size.height = notchOffset
            bottomLeftEdge.position = CGPoint(x: frame.width * 0.10, y: 0 + notchOffset/2)
        }
        else
        {
            bottomLeftEdge.size.height = edgeWidth
            bottomLeftEdge.position = CGPoint(x: frame.width * 0.10, y: 0 + edgeWidth/2)
        }
        bottomLeftEdge.zPosition = -5
        //setup physics for this edge
        bottomLeftEdge.physicsBody = SKPhysicsBody(rectangleOf: bottomLeftEdge.size)
        bottomLeftEdge.physicsBody!.isDynamic = false
        bottomLeftEdge.physicsBody?.mass = 10000000
        bottomLeftEdge.physicsBody?.categoryBitMask = BodyType.topBottomWalls.rawValue
        bottomLeftEdge.physicsBody?.contactTestBitMask = 512
        bottomLeftEdge.physicsBody?.restitution = 1.0
        bottomLeftEdge.physicsBody?.friction = 0.0
        bottomLeftEdge.physicsBody?.linearDamping = 0.0
        bottomLeftEdge.physicsBody?.angularDamping = 0.0
        bottomLeftEdge.blendMode = .replace
        addChild(bottomLeftEdge)
        
        let topRightEdge = SKSpriteNode(color: UIColor.darkGray, size: CGSize(width: frame.width * 0.20, height: edgeWidth))
        if frame.height > 800 && frame.width < 500
        {
            topRightEdge.size.height = notchOffset
            topRightEdge.position = CGPoint(x: frame.width * 0.90, y: frame.height - notchOffset/2)
        }
        else
        {
            topRightEdge.size.height = edgeWidth
            topRightEdge.position = CGPoint(x: frame.width * 0.90, y: frame.height - edgeWidth/2)
        }
        topRightEdge.zPosition = -5
        //setup physics for this edge
        topRightEdge.physicsBody = SKPhysicsBody(rectangleOf: topRightEdge.size)
        topRightEdge.physicsBody!.isDynamic = false
        topRightEdge.physicsBody?.categoryBitMask = BodyType.topBottomWalls.rawValue
        topRightEdge.physicsBody?.contactTestBitMask = 512
        topRightEdge.physicsBody?.restitution = 1.0
        topRightEdge.physicsBody?.friction = 0.0
        topRightEdge.physicsBody?.linearDamping = 0.0
        topRightEdge.physicsBody?.angularDamping = 0.0
        topRightEdge.blendMode = .replace
        addChild(topRightEdge)
        
        let topLeftEdge = SKSpriteNode(color: UIColor.darkGray, size: CGSize(width: frame.width * 0.20, height: edgeWidth))
        if frame.height > 800 && frame.width < 500
        {
            topLeftEdge.size.height = notchOffset
            topLeftEdge.position = CGPoint(x: frame.width * 0.10, y: frame.height - notchOffset/2)
        }
        else
        {
            topLeftEdge.size.height = edgeWidth
            topLeftEdge.position = CGPoint(x: frame.width * 0.10, y: frame.height - edgeWidth/2)
        }
        topLeftEdge.zPosition = -5
        //setup physics for this edge
        topLeftEdge.physicsBody = SKPhysicsBody(rectangleOf: topLeftEdge.size)
        topLeftEdge.physicsBody!.isDynamic = false
        topLeftEdge.physicsBody?.categoryBitMask = BodyType.topBottomWalls.rawValue
        topLeftEdge.physicsBody?.contactTestBitMask = 512
        topLeftEdge.physicsBody?.restitution = 1.0
        topLeftEdge.physicsBody?.friction = 0.0
        topLeftEdge.physicsBody?.linearDamping = 0.0
        topLeftEdge.physicsBody?.angularDamping = 0.0
        topLeftEdge.blendMode = .replace
        addChild(topLeftEdge)
        
        let bottomGoalEdge = SKSpriteNode(imageNamed: "goalGradientBottom.png")
        bottomGoalEdge.color = .black
        if frame.height > 800 && frame.width < 500
        {
            bottomGoalEdge.scale(to: CGSize(width: frame.width * 0.60, height: notchOffset))
            bottomGoalEdge.position = CGPoint(x: frame.width * 0.5, y: 0 + notchOffset/2)
        }
        else
        {
            bottomGoalEdge.scale(to: CGSize(width: frame.width * 0.60, height: edgeWidth))
            bottomGoalEdge.position = CGPoint(x: frame.width * 0.5, y: 0 + edgeWidth)
        }
        bottomGoalEdge.zPosition = 100
        bottomGoalEdge.blendMode = .replace
        //setup physics for this edge
        bottomGoalEdge.physicsBody = SKPhysicsBody(rectangleOf: bottomGoalEdge.size)
        bottomGoalEdge.physicsBody!.isDynamic = false
        bottomGoalEdge.physicsBody?.mass = 10000000
        bottomGoalEdge.physicsBody?.categoryBitMask = 4
        bottomGoalEdge.physicsBody?.collisionBitMask = 256
        bottomGoalEdge.physicsBody?.restitution = 0.0
        bottomGoalEdge.physicsBody?.friction = 0.0
        bottomGoalEdge.physicsBody?.linearDamping = 0.0
        bottomGoalEdge.physicsBody?.angularDamping = 0.0
        addChild(bottomGoalEdge)
        
        let topGoalEdge = SKSpriteNode(imageNamed: "goalGradient.png")
        topGoalEdge.color = .black
        if frame.height > 800 && frame.width < 500
        {
            topGoalEdge.scale(to: CGSize(width: frame.width * 0.60, height: notchOffset))
            topGoalEdge.position = CGPoint(x: frame.width * 0.5, y: frame.height - notchOffset/2)
        }
        else
        {
            topGoalEdge.scale(to: CGSize(width: frame.width * 0.60, height: edgeWidth))
            topGoalEdge.position = CGPoint(x: frame.width * 0.5, y: frame.height - edgeWidth/2)
        }
        topGoalEdgeBottom = topGoalEdge.position.y - (topGoalEdge.size.height * 0.5)
        bottomGoalEdgeTop = bottomGoalEdge.position.y + (bottomGoalEdge.size.height * 0.5)
        
        topGoalEdge.zPosition = 100
        topGoalEdge.blendMode = .replace
        //setup physics for this edge
        topGoalEdge.physicsBody = SKPhysicsBody(rectangleOf: topGoalEdge.size)
        topGoalEdge.physicsBody!.isDynamic = false
        topGoalEdge.physicsBody?.mass = 10000000
        topGoalEdge.physicsBody?.categoryBitMask = 4
        topGoalEdge.physicsBody?.collisionBitMask = 256
        topGoalEdge.physicsBody?.restitution = 0.0
        topGoalEdge.physicsBody?.friction = 0.0
        topGoalEdge.physicsBody?.linearDamping = 0.0
        topGoalEdge.physicsBody?.angularDamping = 0.0
        addChild(topGoalEdge)
    }
    
    func createCenterCircle()
    {
        semiCircleTop = SKSpriteNode(imageNamed: "semiCircleTop.png")
        semiCircleBottom = SKSpriteNode(imageNamed: "semiCircleBottom.png")
        semiCircleTop.zPosition = -15
        semiCircleTop.colorBlendFactor = 0.90
        semiCircleBottom.zPosition = -15
        semiCircleBottom.colorBlendFactor = 0.90

        if frame.width > 700
        {
            centerCircle = SKSpriteNode(imageNamed: "centerCircleAir.png")
            centerCircle.position = CGPoint(x: frame.width/2, y: frame.height/2)
            centerCircle.scale(to: CGSize(width: frame.width * 0.45, height: frame.width * 0.415))
        }
        else if frame.width < 700 && frame.height > 800
        {
            centerCircle = SKSpriteNode(imageNamed: "centerCircleAir.png")
            centerCircle.position = CGPoint(x: frame.width/2, y: frame.height/2)
            centerCircle.scale(to: CGSize(width: frame.width * 0.415, height: frame.width * 0.415))
        }
        else
        {
            centerCircle = SKSpriteNode(imageNamed: "centerCircleAir.png")
            centerCircle.position = CGPoint(x: frame.width/2, y: frame.height/2)
            centerCircle.scale(to: CGSize(width: frame.width * 0.415, height: frame.width * 0.415))
        }
        semiCircleTop.scale(to: CGSize(width: frame.width * 0.60, height: (frame.width * 0.60) * 0.48))
        semiCircleBottom.scale(to: CGSize(width: frame.width * 0.60, height: (frame.width * 0.60) * 0.48))
        semiCircleTop.position = CGPoint(x: frame.width/2, y: topGoalEdgeBottom - (semiCircleTop.size.height / 2))
        semiCircleBottom.position = CGPoint(x: frame.width/2, y: bottomGoalEdgeTop + (semiCircleBottom.size.height/2))
        centerCircle.zPosition = -100
        centerCircle.colorBlendFactor = 0.50
        addChild(centerCircle)
        addChild(semiCircleTop)
        addChild(semiCircleBottom)
    }
   
    func createPauseAndPlayButton()
    {
        pauseButton = SKSpriteNode(imageNamed: "pauseButtonBackground.png")
        pauseButton.position = CGPoint(x: frame.width * 0.90, y: frame.height * 0.50)
        pauseButton.scale(to: CGSize(width: frame.width * 0.09, height: frame.width * 0.09))
        pauseButton.colorBlendFactor = 0.40
        pauseButton.zPosition = 106
        addChild(pauseButton)
        
        playButtonSprite = SKSpriteNode(imageNamed: "playButtonSprite.png")
        playButtonSprite.position = CGPoint(x: frame.width * 0.90, y: frame.height * 0.50)
        playButtonSprite.scale(to: CGSize(width: frame.width * 0.08, height: frame.width * 0.08))
        playButtonSprite.colorBlendFactor = 0
        playButtonSprite.zPosition = 107
        playButtonSprite.isHidden = true
        addChild(playButtonSprite)
        
        pauseButtonSprite = SKSpriteNode(imageNamed: "pauseButtonVertical.png")
        pauseButtonSprite.position = CGPoint(x: frame.width * 0.90, y: frame.height * 0.50)
        pauseButtonSprite.scale(to: CGSize(width: frame.width * 0.08, height: frame.width * 0.08))
        pauseButtonSprite.colorBlendFactor = 0
        pauseButtonSprite.zPosition = 107
        addChild(pauseButtonSprite)
    }
    
    func clearPauseButton()
    {
        pauseBackground.isHidden = true
        pauseButton.isHidden = true
        pauseButtonSprite.isHidden = true
        playButtonSprite.isHidden = true
    }
    
    func resetPauseButton()
    {
        pauseBackground.isHidden = false
        pauseButton.isHidden = false
        if GameIsPaused != true
        {
            pauseButtonSprite.isHidden = false
        }
        else
        {
            playButtonSprite.isHidden = true
        }
    }
    
    func createBackToMenuButton()
    {
        backToMenuButton = SKSpriteNode(imageNamed: "BlueButton.png")
        backToMenuButton.position = CGPoint(x: frame.width/2, y: frame.height * 0.20)
        backToMenuButton.scale(to: CGSize(width: frame.width * 0.60, height: frame.height * 0.1))
        backToMenuButton.isHidden = true
        backToMenuButton.zPosition = 125
        addChild(backToMenuButton)
        
        // set size, color, position and text of the tapStartLabel
        backToMenuButtonLabel.fontSize = frame.width/17.5
        backToMenuButtonLabel.fontColor = SKColor.white
        backToMenuButtonLabel.horizontalAlignmentMode = .center
        backToMenuButtonLabel.verticalAlignmentMode = .center
        backToMenuButtonLabel.position = CGPoint(x: backToMenuButton.position.x, y: backToMenuButton.position.y)
        backToMenuButtonLabel.zPosition = 126
        backToMenuButtonLabel.text = "Back to Menu"
        backToMenuButtonLabel.isHidden = true
        addChild(backToMenuButtonLabel)
    }
    
    func createSoundButton()
    {
        soundButton = SKSpriteNode(imageNamed: "SquareBlueButton.png")
        soundButton.position = CGPoint(x: frame.width * 0.50, y: frame.height * 0.35)
        soundButton.zPosition = 125
        if frame.height > 800 && frame.width < 600
        {
            soundButton.scale(to: CGSize(width: frame.width * 0.25, height: frame.width * 0.25))
        }
        else
        {
            soundButton.scale(to: CGSize(width: frame.width * 0.20, height: frame.width * 0.20))
        }
        soundButton.colorBlendFactor = 0
        soundButton.isHidden = true
        addChild(soundButton)
        
        soundButtonSprite = SKSpriteNode(imageNamed: "soundOn.png")
        soundButtonSprite.position = CGPoint(x: soundButton.position.x, y: soundButton.position.y)
        soundButtonSprite.zPosition = 126
        if frame.height > 800 && frame.width < 600
        {
            soundButtonSprite.scale(to: CGSize(width: frame.width * 0.1125, height: frame.width * 0.1125))
        }
        else
        {
            soundButtonSprite.scale(to: CGSize(width: frame.width * 0.09, height: frame.width * 0.09))
        }
        soundButtonSprite.colorBlendFactor = 0
        soundButtonSprite.isHidden = true
        addChild(soundButtonSprite)
        
        soundButtonOffSprite = SKSpriteNode(imageNamed: "soundOff.png")
        soundButtonOffSprite.position = CGPoint(x: soundButton.position.x, y: soundButton.position.y)
        soundButtonOffSprite.zPosition = 126
        if frame.height > 800 && frame.width < 600
        {
            soundButtonOffSprite.scale(to: CGSize(width: frame.width * 0.1125, height: frame.width * 0.1125))
        }
        else
        {
            soundButtonOffSprite.scale(to: CGSize(width: frame.width * 0.09, height: frame.width * 0.09))
        }
        soundButtonOffSprite.colorBlendFactor = 0
        soundButtonOffSprite.isHidden = true
        addChild(soundButtonOffSprite)
    }
    
    func showPauseMenuButton()
    {
        backToMenuButton.isHidden = false
        backToMenuButtonLabel.isHidden = false
        soundButton.isHidden = false
        pauseTitleBackground1.isHidden = false
        pauseTitleBackground2.isHidden = false
        pauseTitleLabel1.isHidden = false
        pauseTitleLabel2.isHidden = false
        
        if UserDefaults.standard.string(forKey: "Sound") == "On"
        {
            soundButtonSprite.isHidden = false
            soundButtonOffSprite.isHidden = true
        }
        else if UserDefaults.standard.string(forKey: "Sound") == "Off"
        {
            soundButtonSprite.isHidden = true
            soundButtonOffSprite.isHidden = false
        }
        else
        {
            let save = UserDefaults.standard
            save.set("On", forKey: "Sound")
            save.synchronize()
            soundButtonSprite.isHidden = false
            soundButtonOffSprite.isHidden = true
        }
    }
    
    func hidePauseMenuButtons()
    {
        backToMenuButton.isHidden = true
        backToMenuButtonLabel.isHidden = true
        soundButton.isHidden = true
        soundButtonSprite.isHidden = true
        soundButtonOffSprite.isHidden = true
        pauseTitleBackground1.isHidden = true
        pauseTitleBackground2.isHidden = true
        pauseTitleLabel1.isHidden = true
        pauseTitleLabel2.isHidden = true
    }
    
    func createPauseGameTitle()
    {
        pauseTitleBackground1 = SKSpriteNode(imageNamed: "pauseTitleBackground.png")
        pauseTitleBackground1.scale(to: CGSize(width: frame.width * 0.29, height: frame.height/10))
        pauseTitleBackground1.zPosition = 125
        pauseTitleBackground1.isHidden = true
        addChild(pauseTitleBackground1)
        
        // set size, color, position and text of the tapStartLabel
        if frame.width < 600 && frame.height > 800
        {
            pauseTitleLabel1.fontSize = frame.width/6.5
            pauseTitleLabel1.position = CGPoint(x: frame.width * 0.50, y: frame.height * 0.79)
            pauseTitleBackground1.position = CGPoint(x: frame.width/2, y: frame.height * 0.79)
        }
        else
        {
            pauseTitleLabel1.fontSize = frame.width/7.5
            pauseTitleLabel1.position = CGPoint(x: frame.width * 0.49, y: frame.height * 0.80)
            pauseTitleBackground1.position = CGPoint(x: frame.width/2, y: frame.height * 0.80)
        }
        pauseTitleLabel1.fontName = "Futura"
        pauseTitleLabel1.fontColor = SKColor.white
        pauseTitleLabel1.horizontalAlignmentMode = .center
        pauseTitleLabel1.verticalAlignmentMode = .center
        pauseTitleLabel1.zPosition = 126
        pauseTitleLabel1.text = "AIR"
        pauseTitleLabel1.isHidden = true
        addChild(pauseTitleLabel1)
        
        pauseTitleBackground2 = SKSpriteNode(imageNamed: "pauseTitleBackground.png")
        pauseTitleBackground2.scale(to: CGSize(width: frame.width * 0.64, height: frame.height/10))
        pauseTitleBackground2.zPosition = 125
        pauseTitleBackground2.isHidden = true
        addChild(pauseTitleBackground2)
        
        // set size, color, position and text of the tapStartLabel
        if frame.width < 600 && frame.height > 800
        {
            pauseTitleLabel2.fontSize = frame.width/6.5
            pauseTitleLabel2.position = CGPoint(x: frame.width/2, y: frame.height * 0.68)
            pauseTitleBackground2.position = CGPoint(x: frame.width/2, y: frame.height * 0.68)
        }
        else
        {
            pauseTitleLabel2.fontSize = frame.width/7.5
            pauseTitleLabel2.position = CGPoint(x: frame.width/2, y: frame.height * 0.67)
            pauseTitleBackground2.position = CGPoint(x: frame.width/2, y: frame.height * 0.67)
        }
        pauseTitleLabel2.fontName = "Futura"
        pauseTitleLabel2.fontColor = SKColor.white
        pauseTitleLabel2.horizontalAlignmentMode = .center
        pauseTitleLabel2.verticalAlignmentMode = .center
        pauseTitleLabel2.zPosition = 126
        pauseTitleLabel2.text = "HOCKEY"
        pauseTitleLabel2.isHidden = true
        addChild(pauseTitleLabel2)
    }
    
    func getMaxBallSpeed()
    {
        if frame.width > 700
        {
            maxBallSpeed = (frame.height * frame.width) / 370
        }
        else if frame.width < 700 && frame.height > 800
        {
            maxBallSpeed = (frame.height * frame.width) / 222.5
        }
        else
        {
            maxBallSpeed = (frame.height * frame.width) / 195
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
    
    func createPauseBackground()
    {
        pauseBackground = SKSpriteNode(imageNamed: "blurryPauseBackground.png")
        pauseBackground.scale(to: CGSize(width: frame.width, height: frame.height))
        pauseBackground.zPosition = -10
        pauseBackground.colorBlendFactor = 0.05
        pauseBackground.position = CGPoint(x: -1000, y: -1000)
        addChild(pauseBackground)
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
        clearPauseButton()
    }
    
    func updatePauseBackground()
    {
        pauseBackground.position = CGPoint(x: frame.width/2, y: frame.height/2)
        pauseBackground.zPosition = 105
    }
    
    func resetPlayerLoseWinBackground()
    {
        playerWinsBackground.position = CGPoint(x: -1000, y: -1000)
        playerLosesBackground.position = CGPoint(x: -1000, y: -1000)
        xMark.position = CGPoint(x: -1000, y: -1000)
        checkMark.position = CGPoint(x: -1000, y: -1000)
        resetPauseButton()
    }
    
    func resetPauseBackground()
    {
        pauseBackground.position = CGPoint(x: -1000, y: -1000)
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
        GameIsPaused = false
        let bannerViewStartScene = self.view?.viewWithTag(100) as! GADBannerView?
        let bannerViewGameOverScene = self.view?.viewWithTag(101) as! GADBannerView?
        let bannerViewInfoScene = self.view?.viewWithTag(102) as! GADBannerView?
        let bannerViewSettingsScene = self.view?.viewWithTag(103) as! GADBannerView?
        bannerViewStartScene?.isHidden = true
        bannerViewGameOverScene?.isHidden = true
        bannerViewInfoScene?.isHidden = true
        bannerViewSettingsScene?.isHidden = true
        
        if UserDefaults.standard.integer(forKey: "MagnetHockeyGames") > 0
        {
            numberGames = UserDefaults.standard.integer(forKey: "MagnetHockeyGames") + 1
            UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "MagnetHockeyGames") + 1, forKey: "MagnetHockeyGames")
            UserDefaults.standard.synchronize()
        }
        else
        {
            numberGames = 1
            UserDefaults.standard.set(1, forKey: "MagnetHockeyGames")
            UserDefaults.standard.synchronize()
        }
        
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
            
        if KeychainWrapper.standard.string(forKey: "BallColor") == "Yellow Ball" || KeychainWrapper.standard.string(forKey: "BallColor") == "Black Ball" || KeychainWrapper.standard.string(forKey: "BallColor") == "Blue Ball" || KeychainWrapper.standard.string(forKey: "BallColor") == "Red Ball" || KeychainWrapper.standard.string(forKey: "BallColor") == "Orange Ball" ||
            KeychainWrapper.standard.string(forKey: "BallColor") == "Pink Ball" ||
            KeychainWrapper.standard.string(forKey: "BallColor") == "Purple Ball" ||
            KeychainWrapper.standard.string(forKey: "BallColor") == "Green Ball"
        {
            ballColorGame = KeychainWrapper.standard.string(forKey: "BallColor")!
        }
        else
        {
            ballColorGame = "Yellow Ball"
            KeychainWrapper.standard.set("Yellow", forKey: "BallColor")
        }

        if KeychainWrapper.standard.bool(forKey: "Purchase") != true
        {
            interstitialAd = createAndLoadInterstitial()
        }
        
        createEdges()
        drawCenterLine()
        getMaxBallSpeed()
        createPauseAndPlayButton()
        createPlayers()
        createBall()
        createPlayerLoseWinBackgrounds()
        createPauseBackground()
        createPauseGameTitle()
        createBackToMenuButton()
        createSoundButton()
        createCenterCircle()
        createNorthPlayerScore()
        createSouthPlayerScore()
        createPlayerLoseWinBackgrounds()
        if UserDefaults.standard.string(forKey: "GameType") == "RepulsionMode"
        {
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
        //setup physics for this edge
        centerLine.physicsBody = SKPhysicsBody(rectangleOf: centerLine.size)
        centerLine.physicsBody!.isDynamic = false
        centerLine.physicsBody?.mass = 10000000
        centerLine.physicsBody?.categoryBitMask = 4
        centerLine.physicsBody?.collisionBitMask = 256
        centerLine.physicsBody?.restitution = 0.0
        centerLine.physicsBody?.friction = 0.0
        centerLine.physicsBody?.linearDamping = 0.0
        centerLine.physicsBody?.angularDamping = 0.0
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
            ball?.physicsBody?.collisionBitMask = 1 | 2 | 128
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
        ball?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
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
            southPlayer?.position = CGPoint(x: self.frame.midX, y: self.size.height * 0.22)
            northPlayer?.position = CGPoint(x: self.frame.midX, y: self.size.height * 0.78)
        }
        else if frame.height == 926 && frame.width < 500
        {
            southPlayer?.position = CGPoint(x: self.frame.midX, y: self.size.height * 0.225)
            northPlayer?.position = CGPoint(x: self.frame.midX, y: self.size.height * 0.775)
        }
        else
        {
            southPlayer?.position = CGPoint(x: self.frame.midX, y: self.size.height * 0.185)
            northPlayer?.position = CGPoint(x: self.frame.midX, y: self.size.height * 0.815)
        }
        southPlayer?.isHidden = false
        northPlayer?.isHidden = false
    }
    
    func pausePhysics()
    {
        tempBallVelocity = ball!.physicsBody!.velocity
        ball?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
    }
    
    func resumePhysics()
    {
        ball?.physicsBody?.velocity = tempBallVelocity
        tempBallVelocity = CGVector(dx: 0, dy: 0)
    }
    
    func isOffScreen(node: SKShapeNode) -> Bool
    {
        return !frame.contains(node.position)
    }
    
    func didBegin(_ contact: SKPhysicsContact)
    {
        if (contact.bodyA.categoryBitMask == BodyType.ball.rawValue && contact.bodyB.categoryBitMask == BodyType.player.rawValue) && (contact.bodyA.contactTestBitMask == 25 || contact.bodyB.contactTestBitMask == 25) && bottomTouchForCollision == true && ((southPlayer!.position.y < (frame.height * 0.5) - playerRadius) || (ball!.position.y <= southPlayer!.position.y))
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
        if (contact.bodyA.categoryBitMask == BodyType.ball.rawValue && contact.bodyB.categoryBitMask == BodyType.player.rawValue) && (contact.bodyA.contactTestBitMask == 25 || contact.bodyB.contactTestBitMask == 25) && bottomTouchForCollision == false && ((southPlayer!.position.y < (frame.height * 0.5) - playerRadius) || (ball!.position.y <= southPlayer!.position.y))
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
        
        if (contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.ball.rawValue) && (contact.bodyA.contactTestBitMask == 25 || contact.bodyB.contactTestBitMask == 25) && bottomTouchForCollision == true && ((southPlayer!.position.y < (frame.height * 0.5) - playerRadius) || (ball!.position.y <= southPlayer!.position.y))
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
        
        if (contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.ball.rawValue) && (contact.bodyA.contactTestBitMask == 25 || contact.bodyB.contactTestBitMask == 25) && bottomTouchForCollision == false && ((southPlayer!.position.y < (frame.height * 0.5) - playerRadius) || (ball!.position.y <= southPlayer!.position.y))
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
        
        if (contact.bodyA.categoryBitMask == BodyType.ball.rawValue && contact.bodyB.categoryBitMask == BodyType.player.rawValue) && (contact.bodyA.contactTestBitMask == 75 || contact.bodyB.contactTestBitMask == 75) && northTouchForCollision == true && ((northPlayer!.position.y > (frame.height * 0.5) + playerRadius) || (ball!.position.y >= northPlayer!.position.y))
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
        if (contact.bodyA.categoryBitMask == BodyType.ball.rawValue && contact.bodyB.categoryBitMask == BodyType.player.rawValue) && (contact.bodyA.contactTestBitMask == 75 || contact.bodyB.contactTestBitMask == 75) && northTouchForCollision == false && ((northPlayer!.position.y > (frame.height * 0.5) + playerRadius) || (ball!.position.y >= northPlayer!.position.y))
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
        
        if (contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.ball.rawValue) && (contact.bodyA.contactTestBitMask == 75 || contact.bodyB.contactTestBitMask == 75) && northTouchForCollision == true && ((northPlayer!.position.y > (frame.height * 0.5) + playerRadius) || (ball!.position.y >= northPlayer!.position.y))
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
        if (contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.ball.rawValue) && (contact.bodyA.contactTestBitMask == 75 || contact.bodyB.contactTestBitMask == 75) && northTouchForCollision == false && ((northPlayer!.position.y > (frame.height * 0.5) + playerRadius) || (ball!.position.y >= northPlayer!.position.y))
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
            skView.isMultipleTouchEnabled = false


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
        skView.isMultipleTouchEnabled = false

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
            
            if KeychainWrapper.standard.bool(forKey: "Purchase") == true
            {
                if UserDefaults.standard.string(forKey: "Sound") != "Off"
                {
                    SKTAudio.sharedInstance().playBackgroundMusic2("MenuSong3.mp3")
                }
                
                let scene = GameOverScene(size: (view?.bounds.size)!)

                // Configure the view.
                let skView = self.view!
                skView.isMultipleTouchEnabled = false


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
            
            if KeychainWrapper.standard.bool(forKey: "Purchase") == true
            {
                if UserDefaults.standard.string(forKey: "Sound") != "Off"
                {
                    SKTAudio.sharedInstance().playBackgroundMusic2("MenuSong3.mp3")
                }
                
                let scene = GameOverScene(size: (view?.bounds.size)!)

                // Configure the view.
                let skView = self.view!
                skView.isMultipleTouchEnabled = false

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
            ball?.isHidden = true
            ball!.position = CGPoint(x: frame.width * 2, y: -frame.height)
            if UserDefaults.standard.string(forKey: "Sound") == "On" {run(goalSound)}
            else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
            else{run(goalSound)}
            ballInSouthGoal = false
            northPlayerScore += 1
            ball?.physicsBody?.isDynamic = false
            updatePlayerLoseWinBackgroundsTopPlayerWinsRound()
            updateNorthPlayerScore()
            clearPauseButton()
            clearPlayer()
            topPlayerWinsRound = true
            if (northPlayerScore * 2) < numberRounds
            {
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { timer in
                    self.resetBallBottomPlayerBallStart()
                    self.ball?.isHidden = false
                    self.resetPauseButton()
                    self.resetPlayer()
                    self.resetPlayerLoseWinBackground()
                    self.ball?.physicsBody?.isDynamic = true
                    self.topPlayerWinsRound = false
                })
            }
        }
            
        else if ballInNorthGoal == true
        {
            ball?.isHidden = true
            ball!.position = CGPoint(x: frame.width * 2, y: -frame.height)
            if UserDefaults.standard.string(forKey: "Sound") == "On" {run(goalSound)}
            else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
            else{run(goalSound)}
            ballInNorthGoal = false
            ball?.physicsBody?.isDynamic = false
            updatePlayerLoseWinBackgroundsBottomPlayerWinsRound()
            southPlayerScore += 1
            clearPauseButton()
            updateSouthPlayerScore()
            bottomPlayerWinsRound = true
            clearPlayer()
            if (southPlayerScore * 2) < numberRounds
            {
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { timer in
                    self.resetBallTopPlayerBallStart()
                    self.ball?.isHidden = false
                    self.resetPauseButton()
                    self.resetPlayer()
                    self.resetPlayerLoseWinBackground()
                    self.ball?.physicsBody?.isDynamic = true
                    self.bottomPlayerWinsRound = false
                })
            }
        }
        
        if ((southPlayerScore * 2 >= numberRounds) || northPlayerScore * 2 >= numberRounds) && (gameOver == false)
        {
            gameOver = true
            clearPauseButton()
            DBHelper.shared.createDatabase()
            DBHelper.shared.createTable(game: "AirHockey2P")
            DBHelper.shared.createTable(game: "All")
            DBHelper.shared.insertGame(game: "AirHockey2P", topScoreGame: northPlayerScore, bottomScoreGame: southPlayerScore, magnetGoalsOrderGameTop: 3, magnetGoalsOrderGameBottom: 3)
            DBHelper.shared.insertGame(game: "All", topScoreGame: northPlayerScore, bottomScoreGame: southPlayerScore, magnetGoalsOrderGameTop: 3, magnetGoalsOrderGameBottom: 3)
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { timer in
                self.gameOverIsTrue()
            })
        }
    }
    
    override func update(_ currentTime: TimeInterval)
    {
        if (ball!.position.x <= frame.width * 0.2 || ball!.position.x >= frame.width * 0.8) && isOffScreen(node: ball!) && (bottomPlayerWinsRound != true && topPlayerWinsRound != true)
        {
            ball?.position = tempResetBallPosition
        }
        else
        {
            tempResetBallPosition = ball!.position
        }
        
        if GameIsPaused == true
        {
            ball?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        }
        if topGoalEdgeBottom != 0 && bottomGoalEdgeTop != 0
        {
            if (((ball!.position.x > frame.width * 0.2) && (ball!.position.x < frame.width * 0.8)) && ball!.position.y > topGoalEdgeBottom)
            {
                ballInNorthGoal = true
            }
            
            if (((ball!.position.x > frame.width * 0.2) && (ball!.position.x < frame.width * 0.8)) && ball!.position.y < bottomGoalEdgeTop)
            {
                ballInSouthGoal = true
            }
        }
        else
        {
            if frame.height > 800 && frame.width < 500
            {
                if (((ball!.position.x > frame.width * 0.2) && (ball!.position.x < frame.width * 0.8)) && ball!.position.y > frame.height * 0.93)
                {
                    ballInNorthGoal = true
                }
            }
            else
            {
                if (((ball!.position.x > frame.width * 0.2) && (ball!.position.x < frame.width * 0.8)) && ball!.position.y > frame.height)
                {
                    ballInNorthGoal = true
                }
            }
            
            if frame.height > 800 && frame.width < 500
            {
                if (((ball!.position.x > frame.width * 0.2) && (ball!.position.x < frame.width * 0.8)) && ball!.position.y < frame.height * 0.045)
                {
                    ballInSouthGoal = true
                }
            }
            else
            {
                if (((ball!.position.x > frame.width * 0.2) && (ball!.position.x < frame.width * 0.8)) && ball!.position.y < 0)
                {
                    ballInSouthGoal = true
                }
            }
        }
        scoring()
        
        if sqrt(pow((ball?.physicsBody?.velocity.dx)!, 2) + pow((ball?.physicsBody?.velocity.dy)!, 2)) > CGFloat(maxBallSpeed)
        {
            ball?.physicsBody?.velocity.dx = (ball?.physicsBody?.velocity.dx)! * (maxBallSpeed / (sqrt(pow((ball?.physicsBody?.velocity.dx)!, 2) + pow((ball?.physicsBody?.velocity.dy)!, 2))))
            ball?.physicsBody?.velocity.dy = (ball?.physicsBody?.velocity.dy)! * (maxBallSpeed / (sqrt(pow((ball?.physicsBody?.velocity.dx)!, 2) + pow((ball?.physicsBody?.velocity.dy)!, 2))))
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
                pauseButton.colorBlendFactor = 0
                touchedPauseButton = true
            }
            else if nodesArray.contains(backToMenuButton)
            {
                backToMenuButton.colorBlendFactor = 0.50
                touchedBackToMenuButton = true
            }
            else if nodesArray.contains(soundButton)
            {
                soundButton.colorBlendFactor = 0.5
                touchedSoundOff = true
            }
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touch = touches.first
        
        if let location = touch?.location(in: self)
        {
            let nodesArray = self.nodes(at: location)
            
            if nodesArray.contains(pauseButton) && touchedPauseButton == true && GameIsPaused == false
            {
                touchedPauseButton = false
                pauseButton.colorBlendFactor = 0.40
                if UserDefaults.standard.string(forKey: "Sound") == "On"
                {
                    run(buttonSound)
                    SKTAudio.sharedInstance().playBackgroundMusic("MenuSong2.mp3")
                }
                else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                else{run(buttonSound)}
                updatePauseBackground()
                pauseButtonSprite.isHidden = true
                playButtonSprite.isHidden = false
                pausePhysics()
                showPauseMenuButton()
                // Configure the view.
                let skView = self.view!
                skView.isMultipleTouchEnabled = false
                GameIsPaused = true
            }
            else if nodesArray.contains(pauseButton) && touchedPauseButton == true && GameIsPaused == true
            {
                touchedPauseButton = false
                pauseButton.colorBlendFactor = 0.40
                if UserDefaults.standard.string(forKey: "Sound") == "On" {run(buttonSound)}
                else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                else{run(buttonSound)}
                resetPauseBackground()
                pauseButtonSprite.isHidden = false
                playButtonSprite.isHidden = true
                resumePhysics()
                hidePauseMenuButtons()
                SKTAudio.sharedInstance().pauseBackgroundMusic()
                // Configure the view.
                let skView = self.view!
                skView.isMultipleTouchEnabled = true
                GameIsPaused = false
            }
            else if nodesArray.contains(backToMenuButton) && touchedBackToMenuButton == true
            {
                if UserDefaults.standard.string(forKey: "Sound") == "On"
                {
                    run(buttonSound)
                }
                else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                else{run(buttonSound)}
                backToMenuButton.colorBlendFactor = 0
                touchedBackToMenuButton = false
                let scene = StartScene(size: (view?.bounds.size)!)

                // Configure the view.
                let skView = self.view!

                /* Sprite Kit applies additional optimizations to improve rendering performance */
                skView.ignoresSiblingOrder = true

                /* Set the scale mode to scale to fit the window */
                scene.scaleMode = .resizeFill
                let transition = SKTransition.doorsCloseHorizontal(withDuration: 0.75)
                skView.presentScene(scene, transition: transition)
            }
            else if nodesArray.contains(soundButton) && touchedSoundOff == true && UserDefaults.standard.string(forKey: "Sound") == "On"
            {
                soundButtonSprite.isHidden = true
                soundButtonOffSprite.isHidden = false
                let save = UserDefaults.standard
                save.set("Off", forKey: "Sound")
                SKTAudio.sharedInstance().pauseBackgroundMusic()
                save.synchronize()
                touchedSoundOff = false
                soundButton.colorBlendFactor = 0

                if UserDefaults.standard.string(forKey: "Sound") == "On" {run(buttonSound)}
                else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                else{run(buttonSound)}
            }
            else if nodesArray.contains(soundButton) && touchedSoundOff == true && UserDefaults.standard.string(forKey: "Sound") == "Off"
            {
                soundButtonSprite.isHidden = false
                soundButtonOffSprite.isHidden = true
                let save = UserDefaults.standard
                save.set("On", forKey: "Sound")
                save.synchronize()
                touchedSoundOff = false
                soundButton.colorBlendFactor = 0
                if UserDefaults.standard.string(forKey: "Sound") == "On"
                {
                    run(buttonSound)
                    SKTAudio.sharedInstance().playBackgroundMusic("MenuSong2.mp3")
                }
                else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                else{run(buttonSound)}
            }
            else
            {
                if touchedPauseButton == true
                {
                    touchedPauseButton = false
                    pauseButton.colorBlendFactor = 0.40
                }
                if touchedBackToMenuButton == true
                {
                    touchedBackToMenuButton = false
                    backToMenuButton.colorBlendFactor = 0
                }
                if touchedSoundOff == true
                {
                    touchedSoundOff = false
                    soundButton.colorBlendFactor = 0
                }
            }
        }
    }
}


