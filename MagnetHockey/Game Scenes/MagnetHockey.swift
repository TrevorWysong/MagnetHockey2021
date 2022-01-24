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
import SQLite

class MagnetHockey: SKScene, SKPhysicsContactDelegate, BottomPlayerDelegate, NorthPlayerDelegate, GADInterstitialDelegate
{
    var frameCounter = 0
    var ball : SKShapeNode?
    var leftMagnetGlow = SKShapeNode()
    var centerMagnetGlow = SKShapeNode()
    var rightMagnetGlow = SKShapeNode()
    var southPlayerGlow = SKShapeNode()
    var northPlayerGlow = SKShapeNode()
    var topGoalGlow = SKShapeNode()
    var bottomGoalGlow = SKShapeNode()
    var ballGlow = SKShapeNode()
    var leftMagnetPosition = CGPoint()
    var centerMagnetPosition = CGPoint()
    var rightMagnetPosition = CGPoint()
    var ballRadius = CGFloat(0.0)
    var maxBallSpeed = CGFloat(0.0)
    var maxMagnetSpeed = CGFloat(0.0)
    var leftMagnetHolder = SKSpriteNode()
    var centerMagnetHolder = SKSpriteNode()
    var rightMagnetHolder = SKSpriteNode()
    var southLeftMagnetX = SKSpriteNode()
    var southCenterMagnetX = SKSpriteNode()
    var southRightMagnetX = SKSpriteNode()
    var northLeftMagnetX = SKSpriteNode()
    var northCenterMagnetX = SKSpriteNode()
    var northRightMagnetX = SKSpriteNode()
    var centerCircle = SKSpriteNode()
    var playerLosesBackground = SKSpriteNode()
    var playerWinsBackground = SKSpriteNode()
    var pauseBackground = SKSpriteNode()
    var tutorialBackground = SKSpriteNode()
    var blockGameTouchesSprite = SKSpriteNode()
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
    var pauseButtonWhite = SKSpriteNode()
    var pauseButtonSprite = SKSpriteNode()
    var pauseButtonSpriteBlack = SKSpriteNode()
    var backToMenuButton = SKSpriteNode()
    let backToMenuButtonLabel = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    var gameInstructionsButton = SKSpriteNode()
    let gameInstructionsButtonLabel = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    let gameInstructionsButtonLabel2 = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    var tutorialDoneButton = SKSpriteNode()
    let doneButtonLabel = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    var backButton = SKSpriteNode()
    var forwardButton = SKSpriteNode()
    var backButtonSprite = SKSpriteNode()
    var forwardButtonSprite = SKSpriteNode()
    var touchedBackButton = false
    var touchedForwardButton = false
    var touchedDoneButton = false
    let pauseTitleLabel1 = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    let pauseTitleLabel2 = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    var pauseTitleBackground1 = SKSpriteNode()
    var pauseTitleBackground2 = SKSpriteNode()
    var soundButton = SKSpriteNode()
    var soundButtonSprite = SKSpriteNode()
    var tutorialButton = SKSpriteNode()
    var tutorialButtonSprite = SKSpriteNode()
    var soundButtonOffSprite = SKSpriteNode()
    var playButtonSprite = SKSpriteNode()
    var touchedPauseButton = false
    var touchedBackToMenuButton = false
    var touchedSoundOff = false
    var touchedTutorial = false
    var southPlayer : BottomPlayer?
    var northPlayer : NorthPlayer?
    var leftMagnet : Magnet?
    var centerMagnet : Magnet?
    var rightMagnet : Magnet?
    let gameType = UserDefaults.standard.string(forKey: "GameType")!
    let springFieldSouthPlayer = SKFieldNode.springField()
    let springFieldNorthPlayer = SKFieldNode.springField()
    let electricFieldNorthPlayer = SKFieldNode.electricField()
    let electricFieldSouthPlayer = SKFieldNode.electricField()
    let listenerNode = SKNode()
    var southPlayerArea = CGRect()
    var northPlayerArea = CGRect()
    var tutorialArrowCounter = 0
    var southPlayerMagnetCount = 0
    var northPlayerMagnetCount = 0
    var southPlayerScore = 0
    var northPlayerScore = 0
    var northPlayerPointOrder = ""
    var southPlayerPointOrder = ""
    var tempResetBallPosition = CGPoint(x: 0, y: 0)
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
    var tutorialModeIsActive = false
    var bottomTouchForCollision = false
    var northTouchForCollision = false
    var repulsionMode = false
    var downSwitchLeftMagnet = false
    var downSwitchCenterMagnet = false
    var downSwitchRightMagnet = false
    var downSwitchSouthPlayer = false
    var downSwitchNorthPlayer = false
    var downSwitchBall = false
    var downSwitchTopGoal = false
    var downSwitchBottomGoal = false
    var tutorialMagnetStage = false
    var tutorialPlayerStage = false
    var tutorialBallStage = false
    var tutorialGoalStage = false
    var tutorialScoreStage = false
    var numberRounds = 0
    var numberGames = 0
    var tempLeftMagnetVelocity = CGVector(dx: 0, dy: 0)
    var tempCenterMagnetVelocity = CGVector(dx: 0, dy: 0)
    var tempRightMagnetVelocity = CGVector(dx: 0, dy: 0)
    var tempBallVelocity = CGVector(dx: 0, dy: 0)
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
   
    func createPauseAndPlayButton()
    {
        pauseButton = SKSpriteNode(imageNamed: "pauseButtonBackground.png")
        pauseButton.position = CGPoint(x: frame.width * 0.90, y: frame.height * 0.50)
        pauseButton.scale(to: CGSize(width: frame.width * 0.09, height: frame.width * 0.09))
        pauseButton.colorBlendFactor = 0.40
        pauseButton.zPosition = 106
        addChild(pauseButton)
        
        pauseButtonWhite = SKSpriteNode(imageNamed: "pauseButtonBackgroundWhite.png")
        pauseButtonWhite.position = CGPoint(x: frame.width * 0.90, y: frame.height * 0.50)
        pauseButtonWhite.scale(to: CGSize(width: frame.width * 0.09, height: frame.width * 0.09))
        pauseButtonWhite.colorBlendFactor = 0.30
        pauseButtonWhite.zPosition = 106
        pauseButtonWhite.isHidden = true
        addChild(pauseButtonWhite)
        
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
        
        pauseButtonSpriteBlack = SKSpriteNode(imageNamed: "pauseButtonVerticalBlack.png")
        pauseButtonSpriteBlack.position = CGPoint(x: frame.width * 0.90, y: frame.height * 0.50)
        pauseButtonSpriteBlack.scale(to: CGSize(width: frame.width * 0.08, height: frame.width * 0.08))
        pauseButtonSpriteBlack.colorBlendFactor = 0
        pauseButtonSpriteBlack.zPosition = 107
        pauseButtonSpriteBlack.isHidden = true
        addChild(pauseButtonSpriteBlack)
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
    
    func createSoundAndTutorialButton()
    {
        tutorialButton = SKSpriteNode(imageNamed: "SquareBlueButton.png")
        tutorialButton.position = CGPoint(x: frame.width * 0.65, y: frame.height * 0.35)
        tutorialButton.zPosition = 125
        if frame.height > 800 && frame.width < 600
        {
            tutorialButton.scale(to: CGSize(width: frame.width * 0.25, height: frame.width * 0.25))
        }
        else
        {
            tutorialButton.scale(to: CGSize(width: frame.width * 0.20, height: frame.width * 0.20))
        }
        tutorialButton.colorBlendFactor = 0
        tutorialButton.isHidden = true
        addChild(tutorialButton)
        
        tutorialButtonSprite = SKSpriteNode(imageNamed: "questionMark.png")
        tutorialButtonSprite.position = CGPoint(x: tutorialButton.position.x, y: tutorialButton.position.y)
        tutorialButtonSprite.zPosition = 126
        if frame.height > 800 && frame.width < 600
        {
            tutorialButtonSprite.scale(to: CGSize(width: frame.width * 0.14, height: frame.width * 0.14))
        }
        else
        {
            tutorialButtonSprite.scale(to: CGSize(width: frame.width * 0.11, height: frame.width * 0.11))
        }
        tutorialButtonSprite.colorBlendFactor = 0
        tutorialButtonSprite.isHidden = true
        addChild(tutorialButtonSprite)
        
        soundButton = SKSpriteNode(imageNamed: "SquareBlueButton.png")
        soundButton.position = CGPoint(x: frame.width * 0.35, y: frame.height * 0.35)
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
        tutorialButton.isHidden = false
        tutorialButtonSprite.isHidden = false
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
        tutorialButton.isHidden = true
        tutorialButtonSprite.isHidden = true
        pauseTitleBackground1.isHidden = true
        pauseTitleBackground2.isHidden = true
        pauseTitleLabel1.isHidden = true
        pauseTitleLabel2.isHidden = true
    }
    
    func createPauseGameTitle()
    {
        pauseTitleBackground1 = SKSpriteNode(imageNamed: "pauseTitleBackground.png")
        pauseTitleBackground1.scale(to: CGSize(width: frame.width * 0.67, height: frame.height/10))
        pauseTitleBackground1.zPosition = 125
        pauseTitleBackground1.isHidden = true
        addChild(pauseTitleBackground1)
        
        // set size, color, position and text of the tapStartLabel
        if frame.width < 600 && frame.height > 800
        {
            pauseTitleLabel1.fontSize = frame.width/6.5
            pauseTitleLabel1.position = CGPoint(x: frame.width/2, y: frame.height * 0.79)
            pauseTitleBackground1.position = CGPoint(x: frame.width/2, y: frame.height * 0.79)
        }
        else
        {
            pauseTitleLabel1.fontSize = frame.width/7.5
            pauseTitleLabel1.position = CGPoint(x: frame.width/2, y: frame.height * 0.80)
            pauseTitleBackground1.position = CGPoint(x: frame.width/2, y: frame.height * 0.80)
        }
        pauseTitleLabel1.fontName = "Futura"
        pauseTitleLabel1.fontColor = SKColor.white
        pauseTitleLabel1.horizontalAlignmentMode = .center
        pauseTitleLabel1.verticalAlignmentMode = .center
        pauseTitleLabel1.zPosition = 126
        pauseTitleLabel1.text = "MAGNET"
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
    
    func createMagnets()
    {
        leftMagnetPosition = CGPoint(x: frame.width * 0.30, y: frame.height/2)
        centerMagnetPosition = CGPoint(x: frame.width * 0.50, y: frame.height/2)
        rightMagnetPosition = CGPoint(x: frame.width * 0.70, y: frame.height/2)
        
        leftMagnet = Magnet(categoryBitMask: BodyType.leftMagnet.rawValue)
        centerMagnet = Magnet(categoryBitMask: BodyType.centerMagnet.rawValue)
        rightMagnet = Magnet(categoryBitMask: BodyType.rightMagnet.rawValue)
        
        leftMagnet!.position = leftMagnetPosition
        centerMagnet!.position = centerMagnetPosition
        rightMagnet!.position = rightMagnetPosition

        addChild(leftMagnet!)
        addChild(centerMagnet!)
        addChild(rightMagnet!)
    }
    
    func createMagnetHolders()
    {
        leftMagnetHolder = SKSpriteNode(imageNamed: "magnetSpots.png")
        rightMagnetHolder = SKSpriteNode(imageNamed: "magnetSpots.png")
        centerMagnetHolder = SKSpriteNode(imageNamed: "magnetSpots.png")
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
        
        drawCenterLine()
        getMaxBallAndMagnetSpeed()
        createCenterCircle()
        createPauseAndPlayButton()
        createPlayers()
        createMagnets()
        createMagnetHolders()
        createGoals()
        createBall()
        createPlayerLoseWinBackgrounds()
        createPauseBackground()
        createPauseGameTitle()
        createBackToMenuButton()
        createSoundAndTutorialButton()
        createNorthPlayerScore()
        createSouthPlayerScore()
        createEdges()
        createSpringFieldTopGoal()
        createMagnetXMarks()
        createSpringFieldBottomGoal()
        createSpringFieldPlayer()
        createPlayerLoseWinBackgrounds()
        if UserDefaults.standard.string(forKey: "GameType") == "GameMode1"
        {
            createElectricFieldPlayer()
            repulsionMode = true
        }
        createTutorialInterface()
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
        centerLine.zPosition = -110
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
    
    func createTutorialInterface()
    {
        tutorialModeIsActive = false
        tutorialBackground = SKSpriteNode(imageNamed: "black.png")
        tutorialBackground.scale(to: CGSize(width: frame.width, height: frame.height))
        tutorialBackground.zPosition = -50
        tutorialBackground.colorBlendFactor = 0.15
        tutorialBackground.position = CGPoint(x: -4000, y: -4000)
        tutorialBackground.isHidden = true
        addChild(tutorialBackground)
        
        blockGameTouchesSprite = SKSpriteNode(imageNamed: "black.png")
        blockGameTouchesSprite.scale(to: CGSize(width: frame.width, height: frame.height))
        blockGameTouchesSprite.zPosition = 225
        blockGameTouchesSprite.colorBlendFactor = 1
        blockGameTouchesSprite.position = CGPoint(x: -4000, y: -4000)
        blockGameTouchesSprite.isHidden = true
        addChild(blockGameTouchesSprite)

        createGlow(glowName: leftMagnetGlow, glowSize: leftMagnet!)
        createGlow(glowName: centerMagnetGlow, glowSize: centerMagnet!)
        createGlow(glowName: rightMagnetGlow, glowSize: rightMagnet!)
        createGlow(glowName: southPlayerGlow, glowSize: southPlayer!)
        createGlow(glowName: northPlayerGlow, glowSize: northPlayer!)
        createGlow(glowName: ballGlow, glowSize: ball!)
        createGlow(glowName: topGoalGlow, glowSize: topGoal)
        createGlow(glowName: bottomGoalGlow, glowSize: bottomGoal)


        gameInstructionsButton = SKSpriteNode(imageNamed: "WhiteButton.png")
        gameInstructionsButton.position = CGPoint(x: frame.width/2, y: frame.height * 0.20)
        gameInstructionsButton.scale(to: CGSize(width: frame.width * 0.60, height: frame.height * 0.1))
        gameInstructionsButton.isHidden = true
        gameInstructionsButton.zPosition = 125
        gameInstructionsButton.colorBlendFactor = 0.10
        addChild(gameInstructionsButton)
        
        
        // set size, color, position and text of the label
        gameInstructionsButtonLabel.fontSize = frame.width/20
        gameInstructionsButtonLabel.fontColor = SKColor.black
        gameInstructionsButtonLabel.horizontalAlignmentMode = .center
        gameInstructionsButtonLabel.verticalAlignmentMode = .center
        gameInstructionsButtonLabel.zPosition = 126
        gameInstructionsButtonLabel.text = "Avoid bumping into 2"
        gameInstructionsButtonLabel.isHidden = true
        addChild(gameInstructionsButtonLabel)
        
        // set size, color, position and text of the label
        gameInstructionsButtonLabel2.fontSize = frame.width/20
        gameInstructionsButtonLabel2.fontColor = SKColor.black
        gameInstructionsButtonLabel2.horizontalAlignmentMode = .center
        gameInstructionsButtonLabel2.verticalAlignmentMode = .center
        gameInstructionsButtonLabel2.position = CGPoint(x: gameInstructionsButton.position.x, y: gameInstructionsButton.position.y)
        gameInstructionsButtonLabel2.zPosition = 126
        gameInstructionsButtonLabel2.text = "or more magnets!"
        gameInstructionsButtonLabel2.isHidden = true
        addChild(gameInstructionsButtonLabel2)
        
        tutorialDoneButton = SKSpriteNode(imageNamed: "WhiteButton.png")
        tutorialDoneButton.position = CGPoint(x: frame.width/2, y: frame.height * 0.20)
        tutorialDoneButton.scale(to: CGSize(width: frame.width * 0.25, height: frame.height * 0.07))
        tutorialDoneButton.isHidden = true
        tutorialDoneButton.zPosition = 125
        tutorialDoneButton.colorBlendFactor = 0
        addChild(tutorialDoneButton)
        
        // set size, color, position and text of the label
        doneButtonLabel.fontSize = frame.width/20
        doneButtonLabel.fontColor = SKColor.black
        doneButtonLabel.horizontalAlignmentMode = .center
        doneButtonLabel.verticalAlignmentMode = .center
        doneButtonLabel.zPosition = 126
        doneButtonLabel.text = "PLAY"
        doneButtonLabel.isHidden = true
        addChild(doneButtonLabel)
        
        backButton = SKSpriteNode(imageNamed: "WhiteSquare.png")
        backButton.position = CGPoint(x: -1000, y: -1000)
        backButton.scale(to: CGSize(width: frame.width * 0.13, height: frame.width * 0.13))
        backButton.colorBlendFactor = 0.5
        addChild(backButton)
        
        backButtonSprite  = SKSpriteNode(imageNamed: "arrowLeftBlack.png")
        backButtonSprite.position = CGPoint(x: -1000, y: -1000)
        backButtonSprite.scale(to: CGSize(width: frame.width * 0.08, height: frame.width * 0.08))
        backButtonSprite.colorBlendFactor = 0
        backButtonSprite.zPosition = 1
        addChild(backButtonSprite)
        
        forwardButton = SKSpriteNode(imageNamed: "WhiteSquare.png")
        forwardButton.position = CGPoint(x: -1000, y: -1000)
        forwardButton.scale(to: CGSize(width: frame.width * 0.13, height: frame.width * 0.13))
        forwardButton.colorBlendFactor = 0.1
        addChild(forwardButton)
        
        forwardButtonSprite = SKSpriteNode(imageNamed: "arrowRightBlack.png")
        forwardButtonSprite.position = CGPoint(x: -1000, y: -1000)
        forwardButtonSprite.scale(to: CGSize(width: frame.width * 0.08, height: frame.width * 0.08))
        forwardButtonSprite.colorBlendFactor = 0
        forwardButtonSprite.zPosition = 1
        addChild(forwardButtonSprite)
    }
    
    func resetTutorialZPositions()
    {
        tutorialMagnetStage = false
        tutorialPlayerStage = false
        tutorialBallStage = false
        tutorialGoalStage = false
        tutorialScoreStage = false
    }
    
    func handleTutorialActions()
    {
        if tutorialArrowCounter == 0
        {
            tutorialMagnetDirections()
            
            tutorialMagnetStage = true
            tutorialPlayerStage = false
            tutorialBallStage = false
            tutorialGoalStage = false
            tutorialScoreStage = false
            leftMagnetGlow.isHidden = false
            centerMagnetGlow.isHidden = false
            rightMagnetGlow.isHidden = false
            topGoalGlow.isHidden = true
            bottomGoalGlow.isHidden = true
            southPlayerGlow.isHidden = true
            northPlayerGlow.isHidden = true
            ballGlow.isHidden = true
            
            
            topGoal.zPosition = -100
            bottomGoal.zPosition = -100
            topGoalPlus.zPosition = -99
            bottomGoalPlus.zPosition = -99
            northPlayerScoreText.zPosition = -100
            southPlayerScoreText.zPosition = -100
            southPlayer?.zPosition = -98
            northPlayer?.zPosition = -98
            ball?.zPosition = -97
            leftMagnetHolder.zPosition = -100
            centerMagnetHolder.zPosition = -100
            rightMagnetHolder.zPosition = -100
            northLeftMagnetX.zPosition = 0
            northCenterMagnetX.zPosition = 0
            northRightMagnetX.zPosition = 0
            southLeftMagnetX.zPosition = 0
            southCenterMagnetX.zPosition = 0
            southRightMagnetX.zPosition = 0
            leftMagnet?.zPosition = 0
            centerMagnet?.zPosition = 0
            rightMagnet?.zPosition = 0
            
        }
        else if tutorialArrowCounter == 1
        {
            tutorialPlayerDirections()

            tutorialPlayerStage = true
            tutorialMagnetStage = false
            tutorialBallStage = false
            tutorialGoalStage = false
            tutorialScoreStage = false
            leftMagnetGlow.isHidden = true
            centerMagnetGlow.isHidden = true
            rightMagnetGlow.isHidden = true
            topGoalGlow.isHidden = true
            bottomGoalGlow.isHidden = true
            ballGlow.isHidden = true
            southPlayerGlow.isHidden = false
            northPlayerGlow.isHidden = false
            tutorialDoneButton.isHidden = true
            doneButtonLabel.isHidden = true
            
            topGoal.zPosition = -100
            bottomGoal.zPosition = -100
            topGoalPlus.zPosition = -99
            bottomGoalPlus.zPosition = -99
            northPlayerScoreText.zPosition = -100
            southPlayerScoreText.zPosition = -100
            southPlayer?.zPosition = 0
            northPlayer?.zPosition = 0
            ball?.zPosition = -97
            leftMagnetHolder.zPosition = -100
            centerMagnetHolder.zPosition = -100
            rightMagnetHolder.zPosition = -100
            northLeftMagnetX.zPosition = -100
            northCenterMagnetX.zPosition = -100
            northRightMagnetX.zPosition = -100
            southLeftMagnetX.zPosition = -100
            southCenterMagnetX.zPosition = -100
            southRightMagnetX.zPosition = -100
            leftMagnet?.zPosition = -97
            centerMagnet?.zPosition = -97
            rightMagnet?.zPosition = -97
        }
        else if tutorialArrowCounter == 2
        {
            tutorialBallDirections()

            tutorialPlayerStage = false
            tutorialMagnetStage = false
            tutorialBallStage = true
            tutorialGoalStage = false
            tutorialScoreStage = false
            leftMagnetGlow.isHidden = true
            centerMagnetGlow.isHidden = true
            rightMagnetGlow.isHidden = true
            southPlayerGlow.isHidden = true
            northPlayerGlow.isHidden = true
            topGoalGlow.isHidden = true
            bottomGoalGlow.isHidden = true
            ballGlow.isHidden = false
            tutorialDoneButton.isHidden = true
            doneButtonLabel.isHidden = true
            
            topGoal.zPosition = -100
            bottomGoal.zPosition = -100
            topGoalPlus.zPosition = -99
            bottomGoalPlus.zPosition = -99
            northPlayerScoreText.zPosition = -100
            southPlayerScoreText.zPosition = -100
            southPlayer?.zPosition = -97
            northPlayer?.zPosition = -97
            ball?.zPosition = 0
            leftMagnetHolder.zPosition = -100
            centerMagnetHolder.zPosition = -100
            rightMagnetHolder.zPosition = -100
            northLeftMagnetX.zPosition = -100
            northCenterMagnetX.zPosition = -100
            northRightMagnetX.zPosition = -100
            southLeftMagnetX.zPosition = -100
            southCenterMagnetX.zPosition = -100
            southRightMagnetX.zPosition = -100
            leftMagnet?.zPosition = -97
            centerMagnet?.zPosition = -97
            rightMagnet?.zPosition = -97
        }
        
        else if tutorialArrowCounter == 3
        {
            tutorialGoalDirections()

            tutorialPlayerStage = false
            tutorialMagnetStage = false
            tutorialBallStage = false
            tutorialGoalStage = true
            tutorialScoreStage = false
            leftMagnetGlow.isHidden = true
            centerMagnetGlow.isHidden = true
            rightMagnetGlow.isHidden = true
            southPlayerGlow.isHidden = true
            northPlayerGlow.isHidden = true
            tutorialDoneButton.isHidden = true
            doneButtonLabel.isHidden = true
            ballGlow.isHidden = true
            topGoalGlow.isHidden = false
            bottomGoalGlow.isHidden = false
            
            topGoal.zPosition = 0
            bottomGoal.zPosition = 0
            topGoalPlus.zPosition = 1
            bottomGoalPlus.zPosition = 1
            northPlayerScoreText.zPosition = -100
            southPlayerScoreText.zPosition = -100
            southPlayer?.zPosition = -97
            northPlayer?.zPosition = -97
            ball?.zPosition = -97
            leftMagnetHolder.zPosition = -100
            centerMagnetHolder.zPosition = -100
            rightMagnetHolder.zPosition = -100
            northLeftMagnetX.zPosition = -100
            northCenterMagnetX.zPosition = -100
            northRightMagnetX.zPosition = -100
            southLeftMagnetX.zPosition = -100
            southCenterMagnetX.zPosition = -100
            southRightMagnetX.zPosition = -100
            leftMagnet?.zPosition = -97
            centerMagnet?.zPosition = -97
            rightMagnet?.zPosition = -97
        }
        
        else if tutorialArrowCounter == 4
        {
            tutorialTextDirections()
            
            tutorialPlayerStage = false
            tutorialMagnetStage = false
            tutorialBallStage = false
            tutorialGoalStage = false
            tutorialScoreStage = true
            leftMagnetGlow.isHidden = true
            centerMagnetGlow.isHidden = true
            rightMagnetGlow.isHidden = true
            southPlayerGlow.isHidden = true
            northPlayerGlow.isHidden = true
            ballGlow.isHidden = true
            topGoalGlow.isHidden = true
            bottomGoalGlow.isHidden = true
            tutorialDoneButton.isHidden = false
            doneButtonLabel.isHidden = false
            
            topGoal.zPosition = -100
            bottomGoal.zPosition = -100
            topGoalPlus.zPosition = -99
            bottomGoalPlus.zPosition = -99
            northPlayerScoreText.zPosition = 0
            southPlayerScoreText.zPosition = 0
            southPlayer?.zPosition = -97
            northPlayer?.zPosition = -97
            ball?.zPosition = -97
            leftMagnetHolder.zPosition = -100
            centerMagnetHolder.zPosition = -100
            rightMagnetHolder.zPosition = -100
            northLeftMagnetX.zPosition = -100
            northCenterMagnetX.zPosition = -100
            northRightMagnetX.zPosition = -100
            southLeftMagnetX.zPosition = -100
            southCenterMagnetX.zPosition = -100
            southRightMagnetX.zPosition = -100
            leftMagnet?.zPosition = -97
            centerMagnet?.zPosition = -97
            rightMagnet?.zPosition = -97
        }
    }
    
    func displayTutorial()
    {
        tutorialBackground.position = CGPoint(x: frame.width/2, y: frame.height/2)
        blockGameTouchesSprite.position = CGPoint(x: frame.width/2, y: frame.height/2)
        tutorialMagnetStage = true
        tutorialBackground.isHidden = false
        blockGameTouchesSprite.isHidden = false
        backButton.isHidden = false
        backButtonSprite.isHidden = false
        forwardButton.isHidden = false
        forwardButtonSprite.isHidden = false
        gameInstructionsButton.isHidden = false
        gameInstructionsButtonLabel.isHidden = false
        gameInstructionsButtonLabel2.isHidden = false
        backButton.colorBlendFactor = 0.5
        forwardButton.colorBlendFactor = 0
        handleTutorialActions()
    }
    
    func tutorialMagnetDirections()
    {
        gameInstructionsButtonLabel.text = "Avoid bumping into 2"
        gameInstructionsButtonLabel2.text = "or more magnets!"

        // Check magnets location to see where to place directions
        // All magnets are active
        if leftMagnetIsActive == true && centerMagnetIsActive == true && rightMagnetIsActive == true
        {
            // if 2 magnets are at or below the center line
            if (leftMagnet!.position.y <= frame.height * 0.5 && (centerMagnet!.position.y <= frame.height * 0.5 || rightMagnet!.position.y <= frame.height * 0.5))
                || (centerMagnet!.position.y <= frame.height * 0.5 && (leftMagnet!.position.y <= frame.height * 0.5 || rightMagnet!.position.y <= frame.height * 0.5)) ||
                (rightMagnet!.position.y <= frame.height * 0.5 && (centerMagnet!.position.y <= frame.height * 0.5 || leftMagnet!.position.y <= frame.height * 0.5))
            {
                placeMagnetStageDirectionsOnTopHalf()
                placeLabelsAndButtonsRelativeToInstructionsButton()
            }
            // 2 or more magnets are in the top half of the screen
            else
            {
                placeMagnetStageDirectionsOnBottomHalf()
                placeLabelsAndButtonsRelativeToInstructionsButton()
            }
        }
        // 2 Magnets are active
        else if ((leftMagnetIsActive == true && centerMagnetIsActive == true && rightMagnetIsActive == false) || (leftMagnetIsActive == true && centerMagnetIsActive == false && rightMagnetIsActive == true) || (leftMagnetIsActive == false && centerMagnetIsActive == true && rightMagnetIsActive == true))
        {
            if (leftMagnetIsActive && leftMagnet!.position.y <= frame.height * 0.50) || (centerMagnetIsActive && centerMagnet!.position.y <= frame.height * 0.50) || (rightMagnetIsActive && rightMagnet!.position.y <= frame.height * 0.50)
            {
                placeMagnetStageDirectionsOnTopHalf()
                placeLabelsAndButtonsRelativeToInstructionsButton()
            }
            else
            {
                placeMagnetStageDirectionsOnBottomHalf()
                placeLabelsAndButtonsRelativeToInstructionsButton()
            }
        }
        // 1 Magnet is active
        else if (leftMagnetIsActive == true && centerMagnetIsActive == false && rightMagnetIsActive == false) || (leftMagnetIsActive == false && centerMagnetIsActive == true && rightMagnetIsActive == false) || (leftMagnetIsActive == false && centerMagnetIsActive == false && rightMagnetIsActive == true)
        {
            // if the one magnet is on the top half of the screen
            if (leftMagnetIsActive && leftMagnet!.position.y <= frame.height * 0.5) || (centerMagnetIsActive && centerMagnet!.position.y <= frame.height * 0.5) || (rightMagnetIsActive && rightMagnet!.position.y <= frame.height * 0.5)
            {
                placeMagnetStageDirectionsOnTopHalf()
                placeLabelsAndButtonsRelativeToInstructionsButton()
            }
            // if the one magnet is on the bottom half of the screen
            else
            {
                placeMagnetStageDirectionsOnBottomHalf()
                placeLabelsAndButtonsRelativeToInstructionsButton()
            }
        }
        else
        {
            placeMagnetStageDirectionsOnTopHalf()
            placeLabelsAndButtonsRelativeToInstructionsButton()
        }
    }
    
    func tutorialPlayerDirections()
    {
        gameInstructionsButtonLabel.text = "Players can touch to"
        gameInstructionsButtonLabel2.text = "control the red mallets."
        
        if (southPlayer!.position.y <= frame.height * 0.3) && (northPlayer!.position.y >= frame.height * 0.7)
        {
            if ball!.position.y > frame.height * 0.5
            {
                gameInstructionsButton.position = CGPoint(x: frame.width * 0.5, y: frame.height * 0.45)
                placeLabelsAndButtonsRelativeToInstructionsButton()
            }
            else
            {
                gameInstructionsButton.position = CGPoint(x: frame.width * 0.5, y: frame.height * 0.55)
                placeLabelsAndButtonsRelativeToInstructionsButton()
            }
        }
        else if (southPlayer!.position.y > frame.height * 0.3) && (northPlayer!.position.y >= frame.height * 0.7)
        {
            if ball!.position.y > frame.height * 0.5
            {
                gameInstructionsButton.position = CGPoint(x: frame.width * 0.5, y: frame.height * 0.25)
                placeLabelsAndButtonsRelativeToInstructionsButton()
            }
            else
            {
                gameInstructionsButton.position = CGPoint(x: frame.width * 0.5, y: frame.height * 0.65)
                placeLabelsAndButtonsRelativeToInstructionsButton()
            }
        }
        else if (southPlayer!.position.y <= frame.height * 0.3) && (northPlayer!.position.y < frame.height * 0.7)
        {
            if ball!.position.y > frame.height * 0.5
            {
                gameInstructionsButton.position = CGPoint(x: frame.width * 0.5, y: frame.height * 0.45)
                placeLabelsAndButtonsRelativeToInstructionsButton()
            }
            else
            {
                gameInstructionsButton.position = CGPoint(x: frame.width * 0.5, y: frame.height * 0.85)
                placeLabelsAndButtonsRelativeToInstructionsButton()
            }
        }
        else
        {
            if ball!.position.y > frame.height * 0.5
            {
                gameInstructionsButton.position = CGPoint(x: frame.width * 0.5, y: frame.height * 0.25)
                placeLabelsAndButtonsRelativeToInstructionsButton()
            }
            else
            {
                gameInstructionsButton.position = CGPoint(x: frame.width * 0.5, y: frame.height * 0.85)
                placeLabelsAndButtonsRelativeToInstructionsButton()
            }
        }
    }
    
    func tutorialBallDirections()
    {
        gameInstructionsButtonLabel.text = "Use the mallets to"
        gameInstructionsButtonLabel2.text = "strike the " + ballColorGame.lowercased() + "."
        
        if (southPlayer!.position.y <= frame.height * 0.3) && (northPlayer!.position.y >= frame.height * 0.7)
        {
            if ball!.position.y <= frame.height * 0.5 && ball!.position.y >= frame.height * 0.3
            {
                gameInstructionsButton.position = CGPoint(x: frame.width * 0.5, y: frame.height * 0.70)
                placeLabelsAndButtonsRelativeToInstructionsButton()
            }
            else
            {
                gameInstructionsButton.position = CGPoint(x: frame.width * 0.5, y: frame.height * 0.40)
                placeLabelsAndButtonsRelativeToInstructionsButton()
            }
        }
    }
    
    func tutorialGoalDirections()
    {
        gameInstructionsButtonLabel.text = "Aim for the enemy's"
        gameInstructionsButtonLabel2.text = "goal to score!"
        
        if gameInstructionsButton.position.y > frame.height * 0.65
        {
            gameInstructionsButton.position = CGPoint(x: frame.width * 0.5, y: frame.height * 0.60)
            placeLabelsAndButtonsRelativeToInstructionsButton()
        }
        else if gameInstructionsButton.position.y < frame.height * 0.35
        {
            gameInstructionsButton.position = CGPoint(x: frame.width * 0.5, y: frame.height * 0.40)
            placeLabelsAndButtonsRelativeToInstructionsButton()
        }
    }
    
    func tutorialTextDirections()
    {
        gameInstructionsButtonLabel.text = "The score is indicated"
        gameInstructionsButtonLabel2.text = "on the left side."
        
        gameInstructionsButton.position = CGPoint(x: frame.width * 0.5, y: frame.height * 0.65)
        tutorialDoneButton.position = CGPoint(x: frame.width * 0.5, y: frame.height * 0.425)
        doneButtonLabel.position = tutorialDoneButton.position
        tutorialDoneButton.colorBlendFactor = 0
        placeLabelsAndButtonsRelativeToInstructionsButton()
    }
    
    func placeLabelsAndButtonsRelativeToInstructionsButton()
    {
        gameInstructionsButtonLabel.position = CGPoint(x: gameInstructionsButton.position.x, y: gameInstructionsButton.position.y + (frame.height * 0.02))
        gameInstructionsButtonLabel2.position = CGPoint(x: gameInstructionsButton.position.x, y: gameInstructionsButton.position.y - (frame.height * 0.02))
        
        backButton.position = CGPoint(x: frame.width * 0.4, y: gameInstructionsButton.position.y - (frame.height * 0.10))
        backButtonSprite.position = CGPoint(x: backButton.position.x, y: backButton.position.y)
        forwardButton.position = CGPoint(x: frame.width * 0.6, y: gameInstructionsButton.position.y - (frame.height * 0.10))
        forwardButtonSprite.position = CGPoint(x: forwardButton.position.x, y: forwardButton.position.y)
    }
    
    func placeMagnetStageDirectionsOnTopHalf()
    {
        gameInstructionsButton.position = CGPoint(x: frame.width * 0.5, y: frame.height * 0.75)
    }
    
    func placeMagnetStageDirectionsOnBottomHalf()
    {
        gameInstructionsButton.position = CGPoint(x: frame.width * 0.5, y: frame.height * 0.35)
    }
    
    func clearTutorial()
    {
        tutorialBackground.position = CGPoint(x: -4000, y: -4000)
        tutorialBackground.isHidden = true
        blockGameTouchesSprite.position = CGPoint(x: -4000, y: -4000)
        blockGameTouchesSprite.isHidden = true
        leftMagnetGlow.isHidden = true
        centerMagnetGlow.isHidden = true
        rightMagnetGlow.isHidden = true
        southPlayerGlow.isHidden = true
        northPlayerGlow.isHidden = true
        ballGlow.isHidden = true
        topGoalGlow.isHidden = true
        bottomGoalGlow.isHidden = true
        gameInstructionsButton.isHidden = true
        gameInstructionsButtonLabel.isHidden = true
        gameInstructionsButtonLabel2.isHidden = true
        backButton.isHidden = true
        backButtonSprite.isHidden = true
        forwardButton.isHidden = true
        forwardButtonSprite.isHidden = true
        doneButtonLabel.isHidden = true
        tutorialDoneButton.isHidden = true
       
        southPlayer?.zPosition = 3
        northPlayer?.zPosition = 3
        topGoal.zPosition = 1
        bottomGoal.zPosition = 1
        topGoalPlus.zPosition = 4
        bottomGoalPlus.zPosition = 4
        northPlayerScoreText.zPosition = 5
        southPlayerScoreText.zPosition = 5
        leftMagnetHolder.zPosition = 0
        centerMagnetHolder.zPosition = 0
        rightMagnetHolder.zPosition = 0
        northLeftMagnetX.zPosition = 0
        northCenterMagnetX.zPosition = 0
        northRightMagnetX.zPosition = 0
        southLeftMagnetX.zPosition = 0
        southCenterMagnetX.zPosition = 0
        southRightMagnetX.zPosition = 0
        ball?.zPosition = 3
        leftMagnet?.zPosition = 3
        centerMagnet?.zPosition = 3
        rightMagnet?.zPosition = 3
    }
    
    func createGlow(glowName: SKShapeNode, glowSize: SKShapeNode)
    {
        //draw left magnet
        let spriteGlowPath = CGMutablePath()
        let π = CGFloat.pi
        var spriteGlowRadius = CGFloat(0.0)
        spriteGlowRadius = glowSize.frame.size.width * 0.55
        
        spriteGlowPath.addArc(center: CGPoint(x: 0, y:0), radius: spriteGlowRadius, startAngle: 0, endAngle: π*2, clockwise: true)
        glowName.path = spriteGlowPath
        glowName.lineWidth = 0
        glowName.fillColor = UIColor.clear
        glowName.zPosition = -9
        glowName.lineWidth = 1
        glowName.strokeColor = UIColor.red
        glowName.glowWidth = 8
        glowName.isHidden = true
        addChild(glowName)
    }
    
    //overload function to accept spritenodes as well
    func createGlow(glowName: SKShapeNode, glowSize: SKSpriteNode)
    {
        //draw left magnet
        let spriteGlowPath = CGMutablePath()
        let π = CGFloat.pi
        var spriteGlowRadius = CGFloat(0.0)
        spriteGlowRadius = glowSize.frame.size.width * 0.55
        
        spriteGlowPath.addArc(center: CGPoint(x: 0, y:0), radius: spriteGlowRadius, startAngle: 0, endAngle: π*2, clockwise: true)
        glowName.path = spriteGlowPath
        glowName.lineWidth = 0
        glowName.fillColor = UIColor.clear
        glowName.zPosition = -9
        glowName.lineWidth = 1
        glowName.strokeColor = UIColor.red
        glowName.glowWidth = 8
        glowName.isHidden = true
        addChild(glowName)
    }
    
    func glowFlash(glow:SKShapeNode, downSwitch: Bool) -> (Bool)
    {
        if glow.glowWidth >= 8
        {
            glow.glowWidth -= 0.25
            return true
        }
        else if glow.glowWidth < 8 && glow.glowWidth > 0 && downSwitch == true
        {
            glow.glowWidth -= 0.25
            return true
        }
        else if glow.glowWidth < 8 && glow.glowWidth <= 0 && downSwitch == true
        {
            return false
        }
        else if glow.glowWidth < 8 && downSwitch == false
        {
            glow.glowWidth += 0.25
            return false
        }
        else
        {
            return false
        }
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
        leftMagnet?.clearMagnet()
        centerMagnet?.clearMagnet()
        rightMagnet?.clearMagnet()
    }
    
    
    func resetMagnets()
    {
        leftMagnet?.resetMagnet(resetPosition: leftMagnetPosition)
        centerMagnet?.resetMagnet(resetPosition: centerMagnetPosition)
        rightMagnet?.resetMagnet(resetPosition: rightMagnetPosition)
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
    
    func pausePhysics()
    {
        tempBallVelocity = ball!.physicsBody!.velocity
        tempLeftMagnetVelocity = leftMagnet!.physicsBody!.velocity
        tempCenterMagnetVelocity = centerMagnet!.physicsBody!.velocity
        tempRightMagnetVelocity = rightMagnet!.physicsBody!.velocity
        
        ball?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        leftMagnet?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        centerMagnet?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        rightMagnet?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
    }
    
    func resumePhysics()
    {
        ball?.physicsBody?.velocity = tempBallVelocity
        leftMagnet?.physicsBody?.velocity = tempLeftMagnetVelocity
        centerMagnet?.physicsBody?.velocity = tempCenterMagnetVelocity
        rightMagnet?.physicsBody?.velocity = tempRightMagnetVelocity
        
        tempBallVelocity = CGVector(dx: 0, dy: 0)
        tempLeftMagnetVelocity = CGVector(dx: 0, dy: 0)
        tempCenterMagnetVelocity = CGVector(dx: 0, dy: 0)
        tempRightMagnetVelocity = CGVector(dx: 0, dy: 0)
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
            let strength = 1.0 * ((leftMagnet!.position.x) < frame.width / 2 ? 1 : -1)
            let body = leftMagnet?.physicsBody
            body!.applyImpulse(CGVector(dx: strength, dy: 0))
            if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(magnetHitsWallSound)}
        }
        else if (contact.bodyA.categoryBitMask == BodyType.sideWalls.rawValue && contact.bodyB.categoryBitMask == BodyType.leftMagnet.rawValue) && leftMagnetIsActive == true
        {
            let strength = 1.0 * ((leftMagnet!.position.x) < frame.width / 2 ? 1 : -1)
            let body = leftMagnet?.physicsBody
            body!.applyImpulse(CGVector(dx: strength, dy: 0))
            if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(magnetHitsWallSound)}
        }
        
        if (contact.bodyA.categoryBitMask == BodyType.leftMagnet.rawValue && contact.bodyB.categoryBitMask == BodyType.topBottomWalls.rawValue) && leftMagnetIsActive == true
        {
            let strength = 1.0 * ((leftMagnet!.position.x) < frame.height / 2 ? 1 : -1)
            let body = leftMagnet!.physicsBody
            body!.applyImpulse(CGVector(dx: 0, dy: strength))
            if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(magnetHitsWallSound)}
        }
        else if (contact.bodyA.categoryBitMask == BodyType.topBottomWalls.rawValue && contact.bodyB.categoryBitMask == BodyType.leftMagnet.rawValue) && leftMagnetIsActive == true
        {
            let strength = 1.0 * ((leftMagnet!.position.y) < frame.height / 2 ? 1 : -1)
            let body = leftMagnet!.physicsBody
            body!.applyImpulse(CGVector(dx: 0, dy: strength))
            if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(magnetHitsWallSound)}
        }
        
        // Center magnet Collision detect with wall to prevent sticking (SpriteKit Issue)
        if (contact.bodyB.categoryBitMask == BodyType.sideWalls.rawValue && contact.bodyA.categoryBitMask == BodyType.centerMagnet.rawValue) && centerMagnetIsActive == true
        {
            let strength = 1.0 * ((centerMagnet!.position.x) < frame.width / 2 ? 1 : -1)
            let body = centerMagnet!.physicsBody
            body!.applyImpulse(CGVector(dx: strength, dy: 0))
            if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(magnetHitsWallSound)}
        }
        else if (contact.bodyA.categoryBitMask == BodyType.sideWalls.rawValue && contact.bodyB.categoryBitMask == BodyType.centerMagnet.rawValue) && centerMagnetIsActive == true
        {
            let strength = 1.0 * ((centerMagnet!.position.x) < frame.width / 2 ? 1 : -1)
            let body = centerMagnet!.physicsBody
            body!.applyImpulse(CGVector(dx: strength, dy: 0))
            if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(magnetHitsWallSound)}
        }
        
        if (contact.bodyA.categoryBitMask == BodyType.centerMagnet.rawValue && contact.bodyB.categoryBitMask == BodyType.topBottomWalls.rawValue) && centerMagnetIsActive == true
        {
            let strength = 1.0 * ((centerMagnet!.position.x) < frame.height / 2 ? 1 : -1)
            let body = centerMagnet!.physicsBody
            body!.applyImpulse(CGVector(dx: 0, dy: strength))
            if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(magnetHitsWallSound)}
        }
        else if (contact.bodyA.categoryBitMask == BodyType.topBottomWalls.rawValue && contact.bodyB.categoryBitMask == BodyType.centerMagnet.rawValue) && centerMagnetIsActive == true
        {
            let strength = 1.0 * ((centerMagnet!.position.y) < frame.height / 2 ? 1 : -1)
            let body = centerMagnet!.physicsBody
            body!.applyImpulse(CGVector(dx: 0, dy: strength))
            if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(magnetHitsWallSound)}
        }
        
        // Right magnet Collision detect with wall to prevent sticking (SpriteKit Issue)
        if (contact.bodyB.categoryBitMask == BodyType.sideWalls.rawValue && contact.bodyA.categoryBitMask == BodyType.rightMagnet.rawValue) && rightMagnetIsActive == true
        {
            let strength = 1.0 * ((rightMagnet!.position.x) < frame.width / 2 ? 1 : -1)
            let body = rightMagnet!.physicsBody
            body!.applyImpulse(CGVector(dx: strength, dy: 0))
            if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(magnetHitsWallSound)}
        }
        else if (contact.bodyA.categoryBitMask == BodyType.sideWalls.rawValue && contact.bodyB.categoryBitMask == BodyType.rightMagnet.rawValue) && rightMagnetIsActive == true
        {
            let strength = 1.0 * ((rightMagnet!.position.x) < frame.width / 2 ? 1 : -1)
            let body = rightMagnet!.physicsBody
            body!.applyImpulse(CGVector(dx: strength, dy: 0))
            if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(magnetHitsWallSound)}
        }
        
        if (contact.bodyA.categoryBitMask == BodyType.rightMagnet.rawValue && contact.bodyB.categoryBitMask == BodyType.topBottomWalls.rawValue) && rightMagnetIsActive == true
        {
            let strength = 1.0 * ((rightMagnet!.position.x) < frame.height / 2 ? 1 : -1)
            let body = rightMagnet!.physicsBody
            body!.applyImpulse(CGVector(dx: 0, dy: strength))
            if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(magnetHitsWallSound)}
        }
        else if (contact.bodyA.categoryBitMask == BodyType.topBottomWalls.rawValue && contact.bodyB.categoryBitMask == BodyType.rightMagnet.rawValue) && rightMagnetIsActive == true
        {
            let strength = 1.0 * ((rightMagnet!.position.y) < frame.height / 2 ? 1 : -1)
            let body = rightMagnet!.physicsBody
            body!.applyImpulse(CGVector(dx: 0, dy: strength))
            if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(magnetHitsWallSound)}
        }
        
        if (contact.bodyA.categoryBitMask == BodyType.leftMagnet.rawValue && contact.bodyB.categoryBitMask == BodyType.topGoalZone.rawValue)
        {
            if UserDefaults.standard.string(forKey: "Sound") != "Off" && (leftMagnet!.physicsBody!.velocity.dy < -100 || leftMagnet!.physicsBody!.velocity.dy > 100 || leftMagnet!.physicsBody!.velocity.dx < -100 || leftMagnet!.physicsBody!.velocity.dx > 100) && (leftMagnetJustHitGoal == false)
            {
                run(magnetHitsGoalSound)
                leftMagnetJustHitGoal = true
                Timer.scheduledTimer(withTimeInterval: 0.50, repeats: false, block: { timer in
                    self.leftMagnetJustHitGoal = false
                })
            }
            leftMagnet!.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        }
        else if (contact.bodyA.categoryBitMask == BodyType.topGoalZone.rawValue && contact.bodyB.categoryBitMask == BodyType.leftMagnet.rawValue)
        {
            if UserDefaults.standard.string(forKey: "Sound") != "Off" && (leftMagnet!.physicsBody!.velocity.dy < -100 || leftMagnet!.physicsBody!.velocity.dy > 100 || leftMagnet!.physicsBody!.velocity.dx < -100 || leftMagnet!.physicsBody!.velocity.dx > 100) && (leftMagnetJustHitGoal == false)
            {
                run(magnetHitsGoalSound)
                leftMagnetJustHitGoal = true
                Timer.scheduledTimer(withTimeInterval: 0.50, repeats: false, block: { timer in
                    self.leftMagnetJustHitGoal = false
                })
            }
            leftMagnet!.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        }
        if (contact.bodyA.categoryBitMask == BodyType.centerMagnet.rawValue && contact.bodyB.categoryBitMask == BodyType.topGoalZone.rawValue)
        {
            if UserDefaults.standard.string(forKey: "Sound") != "Off" && (centerMagnet!.physicsBody!.velocity.dy < -100 || centerMagnet!.physicsBody!.velocity.dy > 100 || centerMagnet!.physicsBody!.velocity.dx < -100 || centerMagnet!.physicsBody!.velocity.dx > 100) && centerMagnetJustHitGoal == false
            {
                run(magnetHitsGoalSound)
                centerMagnetJustHitGoal = true
                Timer.scheduledTimer(withTimeInterval: 0.50, repeats: false, block: { timer in
                    self.centerMagnetJustHitGoal = false
                })
            }
            centerMagnet!.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        }
        else if (contact.bodyA.categoryBitMask == BodyType.topGoalZone.rawValue && contact.bodyB.categoryBitMask == BodyType.centerMagnet.rawValue)
        {
            if UserDefaults.standard.string(forKey: "Sound") != "Off" && (centerMagnet!.physicsBody!.velocity.dy < -100 || centerMagnet!.physicsBody!.velocity.dy > 100 || centerMagnet!.physicsBody!.velocity.dx < -100 || centerMagnet!.physicsBody!.velocity.dx > 100) && centerMagnetJustHitGoal == false
            {
                run(magnetHitsGoalSound)
                centerMagnetJustHitGoal = true
                Timer.scheduledTimer(withTimeInterval: 0.50, repeats: false, block: { timer in
                    self.centerMagnetJustHitGoal = false
                })
            }
            centerMagnet!.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        }
        if (contact.bodyA.categoryBitMask == BodyType.rightMagnet.rawValue && contact.bodyB.categoryBitMask == BodyType.topGoalZone.rawValue)
        {
            if UserDefaults.standard.string(forKey: "Sound") != "Off" && (rightMagnet!.physicsBody!.velocity.dy < -100 || rightMagnet!.physicsBody!.velocity.dy > 100 || rightMagnet!.physicsBody!.velocity.dx < -100 || rightMagnet!.physicsBody!.velocity.dx > 100) && rightMagnetJustHitGoal == false
            {
                run(magnetHitsGoalSound)
                rightMagnetJustHitGoal = true
                Timer.scheduledTimer(withTimeInterval: 0.50, repeats: false, block: { timer in
                    self.rightMagnetJustHitGoal = false
                })
            }
            rightMagnet!.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        }
        else if (contact.bodyA.categoryBitMask == BodyType.topGoalZone.rawValue && contact.bodyB.categoryBitMask == BodyType.rightMagnet.rawValue)
        {
            if UserDefaults.standard.string(forKey: "Sound") != "Off" && (rightMagnet!.physicsBody!.velocity.dy < -100 || rightMagnet!.physicsBody!.velocity.dy > 100 || rightMagnet!.physicsBody!.velocity.dx < -100 || rightMagnet!.physicsBody!.velocity.dx > 100) && rightMagnetJustHitGoal == false
            {
                run(magnetHitsGoalSound)
                rightMagnetJustHitGoal = true
                Timer.scheduledTimer(withTimeInterval: 0.50, repeats: false, block: { timer in
                    self.rightMagnetJustHitGoal = false
                })
            }
            rightMagnet!.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        }
        
        if (contact.bodyA.categoryBitMask == BodyType.leftMagnet.rawValue && contact.bodyB.categoryBitMask == BodyType.bottomGoalZone.rawValue)
        {
            if UserDefaults.standard.string(forKey: "Sound") != "Off" && (leftMagnet!.physicsBody!.velocity.dy < -100 || leftMagnet!.physicsBody!.velocity.dy > 100 || leftMagnet!.physicsBody!.velocity.dx < -100 || leftMagnet!.physicsBody!.velocity.dx > 100) && (leftMagnetJustHitGoal == false)
            {
                run(magnetHitsGoalSound)
                leftMagnetJustHitGoal = true
                Timer.scheduledTimer(withTimeInterval: 0.50, repeats: false, block: { timer in
                    self.leftMagnetJustHitGoal = false
                })
            }
            leftMagnet!.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        }
        else if (contact.bodyA.categoryBitMask == BodyType.bottomGoalZone.rawValue && contact.bodyB.categoryBitMask == BodyType.leftMagnet.rawValue)
        {
            if UserDefaults.standard.string(forKey: "Sound") != "Off" && (leftMagnet!.physicsBody!.velocity.dy < -100 || leftMagnet!.physicsBody!.velocity.dy > 100 || leftMagnet!.physicsBody!.velocity.dx < -100 || leftMagnet!.physicsBody!.velocity.dx > 100) && (leftMagnetJustHitGoal == false)
            {
                run(magnetHitsGoalSound)
                leftMagnetJustHitGoal = true
                Timer.scheduledTimer(withTimeInterval: 0.50, repeats: false, block: { timer in
                    self.leftMagnetJustHitGoal = false
                })
            }
            leftMagnet!.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        }
        if (contact.bodyA.categoryBitMask == BodyType.centerMagnet.rawValue && contact.bodyB.categoryBitMask == BodyType.bottomGoalZone.rawValue)
        {
            if UserDefaults.standard.string(forKey: "Sound") != "Off" && (centerMagnet!.physicsBody!.velocity.dy < -100 || centerMagnet!.physicsBody!.velocity.dy > 100 || centerMagnet!.physicsBody!.velocity.dx < -100 || centerMagnet!.physicsBody!.velocity.dx > 100) && centerMagnetJustHitGoal == false
            {
                run(magnetHitsGoalSound)
                centerMagnetJustHitGoal = true
                Timer.scheduledTimer(withTimeInterval: 0.50, repeats: false, block: { timer in
                    self.centerMagnetJustHitGoal = false
                })
            }
            centerMagnet!.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        }
        else if (contact.bodyA.categoryBitMask == BodyType.bottomGoalZone.rawValue && contact.bodyB.categoryBitMask == BodyType.centerMagnet.rawValue)
        {
            if UserDefaults.standard.string(forKey: "Sound") != "Off" && (centerMagnet!.physicsBody!.velocity.dy < -100 || centerMagnet!.physicsBody!.velocity.dy > 100 || centerMagnet!.physicsBody!.velocity.dx < -100 || centerMagnet!.physicsBody!.velocity.dx > 100) && centerMagnetJustHitGoal == false
            {
                run(magnetHitsGoalSound)
                centerMagnetJustHitGoal = true
                Timer.scheduledTimer(withTimeInterval: 0.50, repeats: false, block: { timer in
                    self.centerMagnetJustHitGoal = false
                })
            }
            centerMagnet!.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        }
        if (contact.bodyA.categoryBitMask == BodyType.rightMagnet.rawValue && contact.bodyB.categoryBitMask == BodyType.bottomGoalZone.rawValue)
        {
            if UserDefaults.standard.string(forKey: "Sound") != "Off" && (rightMagnet!.physicsBody!.velocity.dy < -100 || rightMagnet!.physicsBody!.velocity.dy > 100 || rightMagnet!.physicsBody!.velocity.dx < -100 || rightMagnet!.physicsBody!.velocity.dx > 100) && rightMagnetJustHitGoal == false
            {
                run(magnetHitsGoalSound)
                rightMagnetJustHitGoal = true
                Timer.scheduledTimer(withTimeInterval: 0.50, repeats: false, block: { timer in
                    self.rightMagnetJustHitGoal = false
                })
            }
            rightMagnet!.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        }
        else if (contact.bodyA.categoryBitMask == BodyType.bottomGoalZone.rawValue && contact.bodyB.categoryBitMask == BodyType.rightMagnet.rawValue)
        {
            if UserDefaults.standard.string(forKey: "Sound") != "Off" && (rightMagnet!.physicsBody!.velocity.dy < -100 || rightMagnet!.physicsBody!.velocity.dy > 100 || rightMagnet!.physicsBody!.velocity.dx < -100 || rightMagnet!.physicsBody!.velocity.dx > 100) && rightMagnetJustHitGoal == false
            {
                run(magnetHitsGoalSound)
                rightMagnetJustHitGoal = true
                Timer.scheduledTimer(withTimeInterval: 0.50, repeats: false, block: { timer in
                    self.rightMagnetJustHitGoal = false
                })
            }
            rightMagnet!.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
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
                self.leftMagnet!.position = CGPoint(x: -100, y: -100)
                self.leftMagnet!.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                self.northPlayerMagnetCount += 1
            })
        }
        else if (contact.bodyB.categoryBitMask == BodyType.player.rawValue && contact.bodyA.categoryBitMask == BodyType.leftMagnet.rawValue && (contact.bodyA.fieldBitMask != 45 && contact.bodyB.fieldBitMask != 45) && (leftMagnetIsActive == true))
        {
            leftMagnetIsActive = false
            if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(magnetPlayerSound)}
            Timer.scheduledTimer(withTimeInterval: 0.02, repeats: false, block: { timer in
                self.leftMagnet!.position = CGPoint(x: -100, y: -100)
                self.leftMagnet!.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                self.northPlayerMagnetCount += 1
            })
        }
        
        if (contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.leftMagnet.rawValue && (contact.bodyA.fieldBitMask == 45 || contact.bodyB.fieldBitMask == 45) && (leftMagnetIsActive == true))
        {
            leftMagnetIsActive = false
            if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(magnetPlayerSound)}
            Timer.scheduledTimer(withTimeInterval: 0.02, repeats: false, block: { timer in
                self.leftMagnet!.position = CGPoint(x: -100, y: -100)
                self.leftMagnet!.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                self.southPlayerMagnetCount += 1
            })
        }
        else if (contact.bodyB.categoryBitMask == BodyType.player.rawValue && contact.bodyA.categoryBitMask == BodyType.leftMagnet.rawValue && (contact.bodyA.fieldBitMask == 45 || contact.bodyB.fieldBitMask == 45) && (leftMagnetIsActive == true))
        {
            leftMagnetIsActive = false
            if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(magnetPlayerSound)}
            Timer.scheduledTimer(withTimeInterval: 0.02, repeats: false, block: { timer in
                self.leftMagnet!.position = CGPoint(x: -100, y: -100)
                self.leftMagnet!.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                self.southPlayerMagnetCount += 1
            })
        }

        if (contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.centerMagnet.rawValue && (contact.bodyA.fieldBitMask != 45 && contact.bodyB.fieldBitMask != 45) && (centerMagnetIsActive == true))
        {
            centerMagnetIsActive = false
            if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(magnetPlayerSound)}
            Timer.scheduledTimer(withTimeInterval: 0.02, repeats: false, block: { timer in
                self.centerMagnet!.position = CGPoint(x: -100, y: -100)
                self.centerMagnet!.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                self.northPlayerMagnetCount += 1
            })
        }
        else if (contact.bodyB.categoryBitMask == BodyType.player.rawValue && contact.bodyA.categoryBitMask == BodyType.centerMagnet.rawValue && (contact.bodyA.fieldBitMask != 45 && contact.bodyB.fieldBitMask != 45) && (centerMagnetIsActive == true))
        {
            centerMagnetIsActive = false
            if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(magnetPlayerSound)}
            Timer.scheduledTimer(withTimeInterval: 0.02, repeats: false, block: { timer in
                self.centerMagnet!.position = CGPoint(x: -100, y: -100)
                self.centerMagnet!.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                self.northPlayerMagnetCount += 1
            })
        }
        
        if (contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.centerMagnet.rawValue && (contact.bodyA.fieldBitMask == 45 || contact.bodyB.fieldBitMask == 45) && (centerMagnetIsActive == true))
        {
            centerMagnetIsActive = false
            if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(magnetPlayerSound)}
            Timer.scheduledTimer(withTimeInterval: 0.02, repeats: false, block: { timer in
                self.centerMagnet!.position = CGPoint(x: -100, y: -100)
                self.centerMagnet!.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                self.southPlayerMagnetCount += 1
            })
        }
        else if (contact.bodyB.categoryBitMask == BodyType.player.rawValue && contact.bodyA.categoryBitMask == BodyType.centerMagnet.rawValue && (contact.bodyA.fieldBitMask == 45 || contact.bodyB.fieldBitMask == 45) && (centerMagnetIsActive == true))
        {
            centerMagnetIsActive = false
            if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(magnetPlayerSound)}
            Timer.scheduledTimer(withTimeInterval: 0.02, repeats: false, block: { timer in
                self.centerMagnet!.position = CGPoint(x: -100, y: -100)
                self.centerMagnet!.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                self.southPlayerMagnetCount += 1
            })
        }

        if (contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.rightMagnet.rawValue && (contact.bodyA.fieldBitMask != 45 && contact.bodyB.fieldBitMask != 45) && (rightMagnetIsActive == true))
        {
            rightMagnetIsActive = false
            if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(magnetPlayerSound)}
            Timer.scheduledTimer(withTimeInterval: 0.02, repeats: false, block: { timer in
                self.rightMagnet!.position = CGPoint(x: -100, y: -100)
                self.rightMagnet!.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                self.northPlayerMagnetCount += 1
            })
        }
        
        else if (contact.bodyB.categoryBitMask == BodyType.player.rawValue && contact.bodyA.categoryBitMask == BodyType.rightMagnet.rawValue && (contact.bodyA.fieldBitMask != 45 && contact.bodyB.fieldBitMask != 45) && (rightMagnetIsActive == true))
        {
            rightMagnetIsActive = false
            if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(magnetPlayerSound)}
            Timer.scheduledTimer(withTimeInterval: 0.02, repeats: false, block: { timer in
                self.rightMagnet!.position = CGPoint(x: -100, y: -100)
                self.rightMagnet!.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                self.northPlayerMagnetCount += 1
            })
        }

        if (contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.rightMagnet.rawValue && (contact.bodyA.fieldBitMask == 45 || contact.bodyB.fieldBitMask == 45) && rightMagnetIsActive == true)
        {
            rightMagnetIsActive = false
            if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(magnetPlayerSound)}
            Timer.scheduledTimer(withTimeInterval: 0.02, repeats: false, block: { timer in
                self.rightMagnet!.position = CGPoint(x: -100, y: -100)
                self.rightMagnet!.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                self.southPlayerMagnetCount += 1

            })
        }
        
        else if (contact.bodyB.categoryBitMask == BodyType.player.rawValue && contact.bodyA.categoryBitMask == BodyType.rightMagnet.rawValue && (contact.bodyA.fieldBitMask == 45 || contact.bodyB.fieldBitMask == 45) && (rightMagnetIsActive == true))
        {
            rightMagnetIsActive = false
            if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(magnetPlayerSound)}
            Timer.scheduledTimer(withTimeInterval: 0.02, repeats: false, block: { timer in
                self.rightMagnet!.position = CGPoint(x: -100, y: -100)
                self.rightMagnet!.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
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
            ballInSouthGoal = false
            northPlayerPointOrder += "2"
            northPlayerScore += 1
            ball?.physicsBody?.isDynamic = false
            ball?.position = CGPoint(x: bottomGoal.position.x, y: bottomGoal.position.y)
            updatePlayerLoseWinBackgroundsTopPlayerWinsRound()
            updateNorthPlayerScore()
            clearMagnets()
            clearPauseButton()
            clearPlayer()
            southPlayerMagnetCount = 0
            northPlayerMagnetCount = 0
            topPlayerWinsRound = true
            if (northPlayerScore * 2) < numberRounds
            {
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { timer in
                    self.resetBallBottomPlayerBallStart()
                    self.resetMagnets()
                    self.resetPauseButton()
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
            southPlayerPointOrder += "2"
            ball?.physicsBody?.isDynamic = false
            ball?.position = CGPoint(x: topGoal.position.x, y: topGoal.position.y)
            updatePlayerLoseWinBackgroundsBottomPlayerWinsRound()
            southPlayerScore += 1
            clearMagnets()
            clearPauseButton()
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
                    self.resetPauseButton()
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
            northPlayerPointOrder += "1"
            northPlayerScore += 1
            updateNorthPlayerScore()
            topPlayerWinsRound = true
            clearMagnets()
            clearPauseButton()
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
                    self.resetPauseButton()
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
            southPlayerPointOrder += "1"
            southPlayerScore += 1
            updateSouthPlayerScore()
            bottomPlayerWinsRound = true
            clearPauseButton()
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
                    self.resetPauseButton()
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
            DBHelper.shared.createDatabase()
            DBHelper.shared.createTable(game: "MagnetHockey")
            DBHelper.shared.createTable(game: "All")

            if northPlayerScore > 0 && southPlayerScore > 0
            {
                DBHelper.shared.insertGame(game: "MagnetHockey", topScoreGame: northPlayerScore, bottomScoreGame: southPlayerScore, magnetGoalsOrderGameTop: Int(northPlayerPointOrder)!, magnetGoalsOrderGameBottom: Int(southPlayerPointOrder)!)
                DBHelper.shared.insertGame(game: "All", topScoreGame: northPlayerScore, bottomScoreGame: southPlayerScore, magnetGoalsOrderGameTop: Int(northPlayerPointOrder)!, magnetGoalsOrderGameBottom: Int(southPlayerPointOrder)!)
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { timer in
                    self.gameOverIsTrue()
                })
            }
            else if northPlayerScore > 0 && southPlayerScore == 0
            {
                DBHelper.shared.insertGame(game: "MagnetHockey", topScoreGame: northPlayerScore, bottomScoreGame: southPlayerScore, magnetGoalsOrderGameTop: Int(northPlayerPointOrder)!, magnetGoalsOrderGameBottom: 0)
                DBHelper.shared.insertGame(game: "All", topScoreGame: northPlayerScore, bottomScoreGame: southPlayerScore, magnetGoalsOrderGameTop: Int(northPlayerPointOrder)!, magnetGoalsOrderGameBottom: 0)
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { timer in
                    self.gameOverIsTrue()
                })
            }
            else if northPlayerScore == 0 && southPlayerScore > 0
            {
                DBHelper.shared.insertGame(game: "MagnetHockey", topScoreGame: northPlayerScore, bottomScoreGame: southPlayerScore, magnetGoalsOrderGameTop: 0, magnetGoalsOrderGameBottom: Int(southPlayerPointOrder)!)
                DBHelper.shared.insertGame(game: "All", topScoreGame: northPlayerScore, bottomScoreGame: southPlayerScore, magnetGoalsOrderGameTop: 0, magnetGoalsOrderGameBottom: Int(southPlayerPointOrder)!)
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { timer in
                    self.gameOverIsTrue()
                })
            }
            else
            {
                DBHelper.shared.insertGame(game: "MagnetHockey", topScoreGame: northPlayerScore, bottomScoreGame: southPlayerScore, magnetGoalsOrderGameTop: 0, magnetGoalsOrderGameBottom: 0)
                DBHelper.shared.insertGame(game: "All", topScoreGame: northPlayerScore, bottomScoreGame: southPlayerScore, magnetGoalsOrderGameTop: 0, magnetGoalsOrderGameBottom: 0)
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { timer in
                    self.gameOverIsTrue()
                })
            }
            clearPauseButton()

        }
    }
    
    func glowFollow(glowName: SKShapeNode, SKShapeToFollow: SKShapeNode)
    {
        if glowName.isHidden != true && SKShapeToFollow.isHidden != true
        {
            glowName.position = SKShapeToFollow.position
        }
    }
    
    func glowFollow(glowName: SKShapeNode, SKSpriteToFollow: SKSpriteNode)
    {
        if glowName.isHidden != true && SKSpriteToFollow.isHidden != true
        {
            glowName.position = SKSpriteToFollow.position
        }
    }
    
    override func update(_ currentTime: TimeInterval)
    {
        print(northPlayerPointOrder)
        if isOffScreen(node: ball!) && (bottomPlayerWinsRound != true && topPlayerWinsRound != true)
        {
            ball?.position = tempResetBallPosition
        }
        else
        {
            tempResetBallPosition = ball!.position
        }
        
        if tutorialModeIsActive == true
        {
            if tutorialMagnetStage
            {
                glowFollow(glowName: leftMagnetGlow, SKShapeToFollow: leftMagnet!)
                glowFollow(glowName: centerMagnetGlow, SKShapeToFollow: centerMagnet!)
                glowFollow(glowName: rightMagnetGlow, SKShapeToFollow: rightMagnet!)
                
                downSwitchLeftMagnet = glowFlash(glow: leftMagnetGlow, downSwitch: downSwitchLeftMagnet)
                downSwitchCenterMagnet = glowFlash(glow: centerMagnetGlow, downSwitch: downSwitchCenterMagnet)
                downSwitchRightMagnet = glowFlash(glow: rightMagnetGlow, downSwitch: downSwitchRightMagnet)
            }
            else if tutorialPlayerStage
            {
                glowFollow(glowName: southPlayerGlow, SKShapeToFollow: southPlayer!)
                glowFollow(glowName: northPlayerGlow, SKShapeToFollow: northPlayer!)
                
                downSwitchSouthPlayer = glowFlash(glow: southPlayerGlow, downSwitch: downSwitchSouthPlayer)
                downSwitchNorthPlayer = glowFlash(glow: northPlayerGlow, downSwitch: downSwitchNorthPlayer)
            }
            else if tutorialBallStage
            {
                glowFollow(glowName: ballGlow, SKShapeToFollow: ball!)
                
                downSwitchBall = glowFlash(glow: ballGlow, downSwitch: downSwitchBall)
            }
            else if tutorialGoalStage
            {
                glowFollow(glowName: topGoalGlow, SKSpriteToFollow: topGoal)
                downSwitchTopGoal = glowFlash(glow: topGoalGlow, downSwitch: downSwitchTopGoal)
                
                glowFollow(glowName: bottomGoalGlow, SKSpriteToFollow: bottomGoal)
                downSwitchBottomGoal = glowFlash(glow: bottomGoalGlow, downSwitch: downSwitchBottomGoal)
            }
            else if tutorialScoreStage
            {

            }
        }
        
        if GameIsPaused == true
        {
            ball?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            leftMagnet?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            centerMagnet?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            rightMagnet?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
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
        
        if sqrt(pow((leftMagnet?.physicsBody?.velocity.dx)!, 2) + pow((leftMagnet?.physicsBody?.velocity.dy)!, 2)) > CGFloat(maxMagnetSpeed)
        {
            leftMagnet?.physicsBody?.velocity.dx = (leftMagnet?.physicsBody?.velocity.dx)! * (maxMagnetSpeed / (sqrt(pow((leftMagnet?.physicsBody?.velocity.dx)!, 2) + pow((leftMagnet?.physicsBody?.velocity.dy)!, 2))))
            leftMagnet?.physicsBody?.velocity.dy = (leftMagnet?.physicsBody?.velocity.dy)! * (maxMagnetSpeed / (sqrt(pow((leftMagnet?.physicsBody?.velocity.dx)!, 2) + pow((leftMagnet?.physicsBody?.velocity.dy)!, 2))))
        }
        
        if sqrt(pow((centerMagnet?.physicsBody?.velocity.dx)!, 2) + pow((centerMagnet?.physicsBody?.velocity.dy)!, 2)) > CGFloat(maxMagnetSpeed)
        {
            centerMagnet?.physicsBody?.velocity.dx = (centerMagnet?.physicsBody?.velocity.dx)! * (maxMagnetSpeed / (sqrt(pow((centerMagnet?.physicsBody?.velocity.dx)!, 2) + pow((centerMagnet?.physicsBody?.velocity.dy)!, 2))))
            centerMagnet?.physicsBody?.velocity.dy = (centerMagnet?.physicsBody?.velocity.dy)! * (maxMagnetSpeed / (sqrt(pow((centerMagnet?.physicsBody?.velocity.dx)!, 2) + pow((centerMagnet?.physicsBody?.velocity.dy)!, 2))))
        }
        
        if sqrt(pow((rightMagnet?.physicsBody?.velocity.dx)!, 2) + pow((rightMagnet?.physicsBody?.velocity.dy)!, 2)) > CGFloat(maxMagnetSpeed)
        {
            rightMagnet?.physicsBody?.velocity.dx = (rightMagnet?.physicsBody?.velocity.dx)! * (maxMagnetSpeed / (sqrt(pow((rightMagnet?.physicsBody?.velocity.dx)!, 2) + pow((rightMagnet?.physicsBody?.velocity.dy)!, 2))))
            rightMagnet?.physicsBody?.velocity.dy = (rightMagnet?.physicsBody?.velocity.dy)! * (maxMagnetSpeed / (sqrt(pow((rightMagnet?.physicsBody?.velocity.dx)!, 2) + pow((rightMagnet?.physicsBody?.velocity.dy)!, 2))))
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touch = touches.first
        if let location = touch?.location(in: self)
        {
            let nodesArray = self.nodes(at: location)

            if nodesArray.contains(pauseButton) || nodesArray.contains(pauseButtonWhite)
            {
                pauseButton.colorBlendFactor = 0
                touchedPauseButton = true
            }
            else if nodesArray.contains(backToMenuButton)
            {
                backToMenuButton.colorBlendFactor = 0.50
                touchedBackToMenuButton = true
            }
            else if nodesArray.contains(backButton) && tutorialArrowCounter > 0
            {
                backButton.colorBlendFactor = 0.5
                touchedBackButton = true
            }
            else if nodesArray.contains(forwardButton) && tutorialArrowCounter < 4
            {
                forwardButton.colorBlendFactor = 0.5
                touchedForwardButton = true
            }
            else if nodesArray.contains(soundButton)
            {
                soundButton.colorBlendFactor = 0.5
                touchedSoundOff = true
            }
            else if nodesArray.contains(tutorialButton)
            {
                tutorialButton.colorBlendFactor = 0.5
                touchedTutorial = true
            }
            else if nodesArray.contains(tutorialDoneButton)
            {
                tutorialDoneButton.colorBlendFactor = 0.5
                touchedDoneButton = true
            }
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touch = touches.first
        
        if let location = touch?.location(in: self)
        {
            let nodesArray = self.nodes(at: location)
            
            if (nodesArray.contains(pauseButton) || nodesArray.contains(pauseButtonWhite)) && touchedPauseButton == true && GameIsPaused == false
            {
                touchedPauseButton = false
                pauseButton.colorBlendFactor = 0.40
                if UserDefaults.standard.string(forKey: "Sound") == "On" && nodesArray.contains(pauseButton)
                {
                    run(buttonSound)
                    SKTAudio.sharedInstance().playBackgroundMusic2("TutorialSong.mp3")
                }
                else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                else{run(buttonSound)}
                
                if pauseButton.isHidden == false
                {
                    pausePhysics()
                }
                updatePauseBackground()
                pauseButtonWhite.isHidden = true
                pauseButtonSpriteBlack.isHidden = true
                pauseButtonSprite.isHidden = true
                pauseButton.isHidden = false
                playButtonSprite.isHidden = false
                tutorialArrowCounter = 0
                showPauseMenuButton()
                // Configure the view.
                let skView = self.view!
                skView.isMultipleTouchEnabled = false
                GameIsPaused = true
                tutorialModeIsActive = false
                clearTutorial()
                resetTutorialZPositions()
            }
            else if (nodesArray.contains(pauseButton) || nodesArray.contains(pauseButtonWhite)) && touchedPauseButton == true && GameIsPaused == true
            {
                if nodesArray.contains(pauseButton)
                {
                    SKTAudio.sharedInstance().pauseBackgroundMusic()
                }
                touchedPauseButton = false
                pauseButton.colorBlendFactor = 0.40
                if UserDefaults.standard.string(forKey: "Sound") == "On" {run(buttonSound)}
                else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                else{run(buttonSound)}
                resetPauseBackground()
                playButtonSprite.isHidden = true
                pauseButtonWhite.isHidden = true
                pauseButtonSpriteBlack.isHidden = true
                tutorialArrowCounter = 0
                pauseButtonSprite.isHidden = false
                pauseButton.isHidden = false
                resumePhysics()
                hidePauseMenuButtons()
                // Configure the view.
                let skView = self.view!
                skView.isMultipleTouchEnabled = true
                GameIsPaused = false
                resetTutorialZPositions()
            }
            
            else if nodesArray.contains(tutorialDoneButton)
            {
                SKTAudio.sharedInstance().pauseBackgroundMusic()
                touchedDoneButton = false
                if UserDefaults.standard.string(forKey: "Sound") == "On" {run(buttonSound)}
                else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                else{run(buttonSound)}
                resetPauseBackground()
                playButtonSprite.isHidden = true
                pauseButtonWhite.isHidden = true
                pauseButtonSpriteBlack.isHidden = true
                tutorialArrowCounter = 0
                pauseButtonSprite.isHidden = false
                pauseButton.isHidden = false
                resumePhysics()
                hidePauseMenuButtons()
                clearTutorial()
                // Configure the view.
                let skView = self.view!
                skView.isMultipleTouchEnabled = true
                GameIsPaused = false
                resetTutorialZPositions()
            }
            
            else if nodesArray.contains(backToMenuButton) && touchedBackToMenuButton == true
            {
                if UserDefaults.standard.string(forKey: "Sound") == "On"
                {
                    run(buttonSound)
                    SKTAudio.sharedInstance().playBackgroundMusic("MenuSong2.mp3")
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
                    SKTAudio.sharedInstance().playBackgroundMusic2("TutorialSong.mp3")
                }
                else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                else{run(buttonSound)}
            }
            else if nodesArray.contains(tutorialButton) && touchedTutorial == true
            {
                touchedTutorial = false
                tutorialButton.colorBlendFactor = 0
                pauseButton.isHidden = true
                pauseButtonSprite.isHidden = true
                playButtonSprite.isHidden = true
                pauseButtonWhite.isHidden = false
                pauseButtonSpriteBlack.isHidden = false
                if UserDefaults.standard.string(forKey: "Sound") == "On"
                {
                    run(buttonSound)
                }
                else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                else{run(buttonSound)}
                resetPauseBackground()
                hidePauseMenuButtons()
                // Configure the view.
                GameIsPaused = false
                tutorialModeIsActive = true
                displayTutorial()
            }
            else if nodesArray.contains(backButton) && touchedBackButton == true && tutorialArrowCounter > 1
            {
                touchedBackButton = false
                backButton.colorBlendFactor = 0
                forwardButton.colorBlendFactor = 0
                tutorialArrowCounter -= 1
                if UserDefaults.standard.string(forKey: "Sound") == "On" {run(buttonSound)}
                else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                else{run(buttonSound)}
                handleTutorialActions()
            }
            
            else if nodesArray.contains(backButton) && touchedBackButton == true && tutorialArrowCounter == 1
            {
                touchedBackButton = false
                backButton.colorBlendFactor = 0.5
                forwardButton.colorBlendFactor = 0
                tutorialArrowCounter -= 1
                if UserDefaults.standard.string(forKey: "Sound") == "On" {run(buttonSound)}
                else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                else{run(buttonSound)}
                handleTutorialActions()
            }
            else if nodesArray.contains(forwardButton) && touchedForwardButton == true && tutorialArrowCounter < 3
            {
                touchedForwardButton = false
                forwardButton.colorBlendFactor = 0
                backButton.colorBlendFactor = 0
                if UserDefaults.standard.string(forKey: "Sound") == "On" {run(buttonSound)}
                else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                else{run(buttonSound)}
                tutorialArrowCounter += 1
                handleTutorialActions()
            }
            else if nodesArray.contains(forwardButton) && touchedForwardButton == true && tutorialArrowCounter == 3
            {
                touchedForwardButton = false
                forwardButton.colorBlendFactor = 0.5
                if UserDefaults.standard.string(forKey: "Sound") == "On" {run(buttonSound)}
                else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                else{run(buttonSound)}
                tutorialArrowCounter += 1
                handleTutorialActions()
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
                if touchedTutorial == true
                {
                    touchedTutorial = false
                    tutorialButton.colorBlendFactor = 0
                }
                if touchedBackButton == true
                {
                    touchedBackButton = false
                    backButton.colorBlendFactor = 0
                }
                if touchedForwardButton == true
                {
                    touchedForwardButton = false
                    forwardButton.colorBlendFactor = 0
                }
                if touchedDoneButton == true
                {
                    touchedDoneButton = false
                    tutorialDoneButton.colorBlendFactor = 0
                }
            }
        }
    }
}


