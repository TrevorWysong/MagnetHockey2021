//
//  StartScene.swift
//  Pong_TW
//
//  Created by Wysong, Trevor on 4/16/20.
//  Copyright © 2020 Wysong, Trevor. All rights reserved.
//

import SpriteKit
import GoogleMobileAds
import MultipeerConnectivity

class StartScene: SKScene
{
    var appDelegate:AppDelegate!

    // you can use another font for the label if you want...
    let titleLabel = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    let titleLabel2 = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    let gameModeLabel1 = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    let gameModeLabel2 = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    let storeButtonLabel = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    var onePlayerButton = SKSpriteNode()
    var twoPlayerButton = SKSpriteNode()
    var gameModeButton1 = SKSpriteNode()
    var gameModeButton2 = SKSpriteNode()
    var settingsButton = SKSpriteNode()
    var instructionsButton = SKSpriteNode()
    var statisticsButton = SKSpriteNode()
    var onePlayerActiveSprite = SKSpriteNode()
    var onePlayerLockedSprite = SKSpriteNode()
    var onePlayerInactiveSprite = SKSpriteNode()
    var twoPlayerActiveSprite = SKSpriteNode()
    var twoPlayerInactiveSprite = SKSpriteNode()
    var playButton:SKSpriteNode!
    var playTriangleButton:SKSpriteNode!
    var storeButton:SKSpriteNode!
    var infoButton:SKSpriteNode!
    var magnetEmitter:SKEmitterNode!
    let buttonSound = SKAction.playSoundFileNamed("ChangeRounds.mp3", waitForCompletion: false)
    var touchedPlay = false
    var touchedGameMode1 = false
    var touchedGameMode2 = false
    var touched1Player = false
    var touched2Player = false
    var touchedStore = false
    var touchedSettings = false
    var touchedInstructions = false
    var touchedStatistics = false
    var backButton = SKSpriteNode()
    var forwardButton = SKSpriteNode()
    var pageDotOne = SKSpriteNode()
    var pageDotTwo = SKSpriteNode()
    var pageDotThree = SKSpriteNode()
    var touchedBackButton = false
    var touchedForwardButton = false
    var arrowPressCounter = 0
    let joinOrHostAlert = UIAlertController(title: "Magnet Hockey", message: "How would you like to connect?", preferredStyle: UIAlertController.Style.actionSheet)

    
    func leftArrowPressed()
    {
        arrowPressCounter -= 1
    }
    
    func rightArrowPressed()
    {
        arrowPressCounter += 1
    }
    
    func createEdges()
    {
        var leftEdge = SKSpriteNode(), rightEdge = SKSpriteNode(), bottomEdge = SKSpriteNode(), topEdge = SKSpriteNode()
        (leftEdge, rightEdge, bottomEdge, topEdge) = UIHelper.shared.createEdges()
        addChild(leftEdge)
        addChild(rightEdge)
        addChild(bottomEdge)
        addChild(topEdge)
    }
    
    func multipeerSetup()
    {
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate.MPC.setupPeerWithDisplayName(displayName: UIDevice.current.name)
        appDelegate.MPC.setupSession()
    }
    
    func addNetworkingAlertButtons()
    {
        self.joinOrHostAlert.addAction(UIAlertAction(title: "Host Game", style: .default, handler: { (action: UIAlertAction!) in
            self.appDelegate.MPC.startHosting()
        }))
        
        self.joinOrHostAlert.addAction(UIAlertAction(title: "Join Game", style: .default, handler: { (action: UIAlertAction!) in
            self.appDelegate.MPC.joinSession()
        }))
        
        self.joinOrHostAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in

        }))
    }
    
    func triggerNetworkingAlert()
    {
        let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .compactMap({$0 as? UIWindowScene})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        keyWindow?.rootViewController?.present(self.joinOrHostAlert, animated: true, completion: nil)
    }

    
    func handleIAPandAds()
    {
        let bannerViewStartScene = self.view?.viewWithTag(100) as! GADBannerView?
        let bannerViewGameOverScene = self.view?.viewWithTag(101) as! GADBannerView?
        let bannerViewInfoScene = self.view?.viewWithTag(102) as! GADBannerView?
        let bannerViewSettingsScene = self.view?.viewWithTag(103) as! GADBannerView?
        
        if KeychainWrapper.standard.bool(forKey: "Purchase") != true
        {
            bannerViewStartScene?.isHidden = false
            bannerViewGameOverScene?.isHidden = true
            bannerViewInfoScene?.isHidden = true
            bannerViewSettingsScene?.isHidden = true
        }
        else
        {
            bannerViewStartScene?.isHidden = true
            bannerViewGameOverScene?.isHidden = true
            bannerViewInfoScene?.isHidden = true
            bannerViewSettingsScene?.isHidden = true
        }
        
        let _: Bool = KeychainWrapper.standard.set(false, forKey: "RestoredRemoveAds")
        
        let _: Bool = KeychainWrapper.standard.set(false, forKey: "RestoredColorPack")
    }
    
    override func didMove(to view: SKView)
    {
        handleIAPandAds()
        createEdges()
        multipeerSetup()
        addNetworkingAlertButtons()
        
        if UserDefaults.standard.string(forKey: "GameType") == "GameMode1" || UserDefaults.standard.string(forKey: "GameType") == "GameMode2" {}
        else
        {
            let saveGameType = UserDefaults.standard
            saveGameType.set("GameType2", forKey: "GameType")
            saveGameType.synchronize()
        }
        
        // set size, color, position and text of the tapStartLabel
        if frame.width < 600 && frame.height > 800
        {
            titleLabel.fontSize = frame.width/7
            titleLabel.position = CGPoint(x: frame.width/2, y: frame.height * 0.89)
        }
        else
        {
            titleLabel.fontSize = frame.width/8
            titleLabel.position = CGPoint(x: frame.width/2, y: frame.height * 0.91)
        }
        titleLabel.fontName = "Futura"
        titleLabel.fontColor = SKColor.white
        titleLabel.horizontalAlignmentMode = .center
        titleLabel.verticalAlignmentMode = .center
        titleLabel.zPosition = 1
        if UserDefaults.standard.string(forKey: "Game") == "Magnet Hockey"
        {
            titleLabel.text = "MAGNET HOCKEY"
            arrowPressCounter = 0
        }
        else if UserDefaults.standard.string(forKey: "Game") == "Air Hockey"
        {
            titleLabel.text = "AIR HOCKEY"
            arrowPressCounter = 1
        }
        else
        {
            let saveGame = UserDefaults.standard
            saveGame.set("Magnet Hockey", forKey: "Game")
            saveGame.synchronize()
            titleLabel.text = "MAGNET HOCKEY"
            arrowPressCounter = 0
        }
        addChild(titleLabel)
        
        // set size, color, position and text of the tapStartLabel
        if frame.width < 600 && frame.height > 800
        {
            titleLabel2.fontSize = frame.width/7
            titleLabel2.position = CGPoint(x: frame.width/2, y: frame.height * 0.81)
        }
        else
        {
            titleLabel2.fontSize = frame.width/8
            titleLabel2.position = CGPoint(x: frame.width/2, y: frame.height * 0.815)
        }
        titleLabel2.fontName = "Futura"
        titleLabel2.fontColor = SKColor.white
        titleLabel2.horizontalAlignmentMode = .center
        titleLabel2.verticalAlignmentMode = .center
        titleLabel2.zPosition = 1
        titleLabel2.text = "HOCKEY"
        addChild(titleLabel2)
        
        gameModeButton1 = SKSpriteNode(imageNamed: "IcyChillRoundedRectangle.png")
        gameModeButton1.position = CGPoint(x: frame.width/2, y: frame.height * 0.67)
        gameModeButton1.scale(to: CGSize(width: frame.width * 0.65, height: frame.height * 0.085))
        
        gameModeButton2 = SKSpriteNode(imageNamed: "IcyChillRoundedRectangle.png")
        gameModeButton2.position = CGPoint(x: frame.width/2, y: frame.height * 0.57)
        gameModeButton2.scale(to: CGSize(width: frame.width * 0.65, height: frame.height * 0.085))

        
        if UserDefaults.standard.string(forKey: "GameType") == "GameMode2"
        {
            gameModeButton2.colorBlendFactor = 0.5
            gameModeButton1.colorBlendFactor = 0
        }
        else if UserDefaults.standard.string(forKey: "GameType") == "GameMode1"
        {
            gameModeButton2.colorBlendFactor = 0
            gameModeButton1.colorBlendFactor = 0.5
        }
        else
        {
            gameModeButton2.colorBlendFactor = 0.5
            gameModeButton1.colorBlendFactor = 0
        }
        addChild(gameModeButton1)
        addChild(gameModeButton2)
        
        storeButton = SKSpriteNode(imageNamed: "AgedEmeraldRectangle.png")
        storeButton.position = CGPoint(x: frame.width/2, y: frame.height * 0.17)
        storeButton.scale(to: CGSize(width: frame.width * 2/3, height: frame.height/10))
        storeButton.colorBlendFactor = 0
        addChild(storeButton)
        
        playButton = SKSpriteNode(imageNamed: "IcyChillSquare.png")
        playButton.position = CGPoint(x: frame.width/2, y: frame.height * 0.415)
        addChild(playButton)
        
        playTriangleButton = SKSpriteNode(imageNamed: "whitePlayButton.png")
        playTriangleButton.position = CGPoint(x: playButton.position.x, y: playButton.position.y)
        playTriangleButton.scale(to: CGSize(width: frame.width * 0.20, height: frame.width * 0.20))
        playTriangleButton.zPosition = 2
        addChild(playTriangleButton)
        
        if frame.width > 700
        {
            playButton.scale(to: CGSize(width: frame.width * 0.24, height: frame.width * 0.24))
            playTriangleButton.scale(to: CGSize(width: frame.width * 0.16, height: frame.width * 0.16))
        }
        else
        {
            playButton.scale(to: CGSize(width: frame.width * 0.30, height: frame.width * 0.30))
            playTriangleButton.scale(to: CGSize(width: frame.width * 0.20, height: frame.width * 0.20))
        }
        
        settingsButton = SKSpriteNode(imageNamed: "RedRoundedSquare.png")
        settingsButton.position = CGPoint(x: frame.width * 0.34, y: frame.height * 0.2725)
        settingsButton.scale(to: CGSize(width: frame.width * 0.13, height: frame.width * 0.13))
        settingsButton.colorBlendFactor = 0
        addChild(settingsButton)
        
        instructionsButton = SKSpriteNode(imageNamed: "RedRoundedSquare.png")
        instructionsButton.position = CGPoint(x: frame.width * 0.66, y: frame.height * 0.2725)
        instructionsButton.scale(to: CGSize(width: frame.width * 0.13, height: frame.width * 0.13))
        instructionsButton.colorBlendFactor = 0
        addChild(instructionsButton)
        
        let instructionsSprite:SKSpriteNode!
        instructionsSprite = SKSpriteNode(imageNamed: "information.png")
        instructionsSprite.position = CGPoint(x: instructionsButton.position.x, y: instructionsButton.position.y)
        instructionsSprite.scale(to: CGSize(width: frame.width * 0.08, height: frame.width * 0.08))
        instructionsSprite.colorBlendFactor = 0
        instructionsSprite.zPosition = 1
        addChild(instructionsSprite)
        
        let settingsSprite:SKSpriteNode!
        settingsSprite = SKSpriteNode(imageNamed: "settings.png")
        settingsSprite.position = CGPoint(x: settingsButton.position.x, y: settingsButton.position.y)
        settingsSprite.scale(to: CGSize(width: frame.width * 0.08, height: frame.width * 0.08))
        settingsSprite.colorBlendFactor = 0
        settingsSprite.zPosition = 1
        addChild(settingsSprite)
        
        statisticsButton = SKSpriteNode(imageNamed: "RedRoundedSquare.png")
        statisticsButton.position = CGPoint(x: frame.width * 0.50, y: frame.height * 0.2725)
        statisticsButton.scale(to: CGSize(width: frame.width * 0.13, height: frame.width * 0.13))
        statisticsButton.colorBlendFactor = 0
        addChild(statisticsButton)
        
        let statisticsSprite:SKSpriteNode!
        statisticsSprite = SKSpriteNode(imageNamed: "crown.png")
        statisticsSprite.position = CGPoint(x: statisticsButton.position.x, y: statisticsButton.position.y)
        statisticsSprite.scale(to: CGSize(width: frame.width * 0.09, height: frame.width * 0.09))
        statisticsSprite.colorBlendFactor = 0
        statisticsSprite.zPosition = 1
        addChild(statisticsSprite)

        
        onePlayerButton = SKSpriteNode(imageNamed: "IcyChillRoundedSquare.png")
        onePlayerButton.position = CGPoint(x: frame.width * 0.2, y: playButton.position.y)
        onePlayerButton.scale(to: CGSize(width: frame.width * 0.18, height: frame.width * 0.18))
        onePlayerButton.colorBlendFactor = 0
        addChild(onePlayerButton)
        
        twoPlayerButton = SKSpriteNode(imageNamed: "IcyChillRoundedSquare.png")
        twoPlayerButton.position = CGPoint(x: frame.width * 0.8, y: playButton.position.y)
        twoPlayerButton.scale(to: CGSize(width: frame.width * 0.18, height: frame.width * 0.18))
        twoPlayerButton.colorBlendFactor = 0
        addChild(twoPlayerButton)
        
        onePlayerActiveSprite = SKSpriteNode(imageNamed: "onePersonSelected.png")
        onePlayerActiveSprite.position = onePlayerButton.position
        onePlayerActiveSprite.scale(to: CGSize(width: frame.width * 0.15, height: frame.width * 0.15))
        onePlayerActiveSprite.colorBlendFactor = 0
        onePlayerActiveSprite.zPosition = 1
        
        onePlayerInactiveSprite = SKSpriteNode(imageNamed: "onePerson.png")
        onePlayerInactiveSprite.position = onePlayerButton.position
        onePlayerInactiveSprite.scale(to: CGSize(width: frame.width * 0.15, height: frame.width * 0.15))
        onePlayerInactiveSprite.colorBlendFactor = 0
        onePlayerInactiveSprite.zPosition = 1
        
        onePlayerLockedSprite = SKSpriteNode(imageNamed: "onePersonLocked.png")
        onePlayerLockedSprite.position = onePlayerButton.position
        onePlayerLockedSprite.scale(to: CGSize(width: frame.width * 0.15, height: frame.width * 0.15))
        onePlayerLockedSprite.colorBlendFactor = 0
        onePlayerLockedSprite.zPosition = 1
        
        twoPlayerActiveSprite = SKSpriteNode(imageNamed: "twoPersonSelected.png")
        twoPlayerActiveSprite.position = twoPlayerButton.position
        twoPlayerActiveSprite.scale(to: CGSize(width: frame.width * 0.15, height: frame.width * 0.15))
        twoPlayerActiveSprite.colorBlendFactor = 0
        twoPlayerActiveSprite.zPosition = 1
        
        twoPlayerInactiveSprite = SKSpriteNode(imageNamed: "twoPerson.png")
        twoPlayerInactiveSprite.position = twoPlayerButton.position
        twoPlayerInactiveSprite.scale(to: CGSize(width: frame.width * 0.15, height: frame.width * 0.15))
        twoPlayerInactiveSprite.colorBlendFactor = 0
        twoPlayerInactiveSprite.zPosition = 1

        if UserDefaults.standard.string(forKey: "Game") == "Magnet Hockey"
        {
            onePlayerActiveSprite.isHidden = true
            onePlayerInactiveSprite.isHidden = true
            onePlayerLockedSprite.isHidden = false
            twoPlayerActiveSprite.isHidden = false
            twoPlayerInactiveSprite.isHidden = true
            onePlayerButton.colorBlendFactor = 0
            twoPlayerButton.colorBlendFactor = 0.50
        }
        else if UserDefaults.standard.string(forKey: "Game") == "Air Hockey" && UserDefaults.standard.string(forKey: "PlayerMode") == "1Player"
        {
            onePlayerActiveSprite.isHidden = false
            onePlayerInactiveSprite.isHidden = true
            onePlayerLockedSprite.isHidden = true
            twoPlayerActiveSprite.isHidden = true
            twoPlayerInactiveSprite.isHidden = false
            onePlayerButton.colorBlendFactor = 0.50
            twoPlayerButton.colorBlendFactor = 0
        }
        else if UserDefaults.standard.string(forKey: "Game") == "Air Hockey" && UserDefaults.standard.string(forKey: "PlayerMode") == "2Player"
        {
            onePlayerActiveSprite.isHidden = true
            onePlayerInactiveSprite.isHidden = false
            onePlayerLockedSprite.isHidden = true
            twoPlayerActiveSprite.isHidden = false
            twoPlayerInactiveSprite.isHidden = true
            onePlayerButton.colorBlendFactor = 0
            twoPlayerButton.colorBlendFactor = 0.50
        }
        else
        {
            onePlayerActiveSprite.isHidden = true
            onePlayerInactiveSprite.isHidden = true
            onePlayerLockedSprite.isHidden = false
            twoPlayerActiveSprite.isHidden = false
            twoPlayerInactiveSprite.isHidden = true
            onePlayerButton.colorBlendFactor = 0
            twoPlayerButton.colorBlendFactor = 0.50
            let saveGameType = UserDefaults.standard
            saveGameType.set("2Player", forKey: "PlayerMode")
            saveGameType.synchronize()
        }
        
        addChild(onePlayerActiveSprite)
        addChild(onePlayerInactiveSprite)
        addChild(onePlayerLockedSprite)
        addChild(twoPlayerActiveSprite)
        addChild(twoPlayerInactiveSprite)
        
        let background = UIHelper.shared.createBackground()
        addChild(background)

        // set size, color, position and text of the tapStartLabel
        storeButtonLabel.fontSize = frame.width/17.5
        storeButtonLabel.fontColor = SKColor.black
        storeButtonLabel.horizontalAlignmentMode = .center
        storeButtonLabel.verticalAlignmentMode = .center
        storeButtonLabel.position = CGPoint(x: storeButton.position.x, y: storeButton.position.y)
        storeButtonLabel.zPosition = 1
        storeButtonLabel.text = "Check out the store!"
        addChild(storeButtonLabel)
        
        // set size, color, position and text of the tapStartLabel
        gameModeLabel1.fontSize = frame.width/17.5
        gameModeLabel1.fontColor = SKColor.white
        gameModeLabel1.horizontalAlignmentMode = .center
        gameModeLabel1.verticalAlignmentMode = .center
        gameModeLabel1.position = CGPoint(x: gameModeButton1.position.x, y: gameModeButton1.position.y)
        gameModeLabel1.zPosition = 1
        addChild(gameModeLabel1)
        
        // set size, color, position and text of the tapStartLabel
        gameModeLabel2.fontSize = frame.width/17.5
        gameModeLabel2.fontColor = SKColor.white
        gameModeLabel2.horizontalAlignmentMode = .center
        gameModeLabel2.verticalAlignmentMode = .center
        gameModeLabel2.position = CGPoint(x: gameModeButton2.position.x, y: gameModeButton2.position.y)
        gameModeLabel2.zPosition = 1
        addChild(gameModeLabel2)
        
        if UserDefaults.standard.string(forKey: "Game") == "Magnet Hockey"
        {
            gameModeLabel1.text = "Repulsion Mode"
            gameModeLabel2.text = "Standard Mode"
        }
        else if UserDefaults.standard.string(forKey: "Game") == "Air Hockey"
        {
            if UserDefaults.standard.string(forKey: "PlayerMode") == "1Player"
            {
                gameModeLabel1.text = "Normal Bot"
                gameModeLabel2.text = "Expert Bot"
            }
            else
            {
                gameModeLabel1.text = "1 Puck"
                gameModeLabel2.text = "2 Pucks"
            }
        }
        else
        {
            let saveGame = UserDefaults.standard
            saveGame.set("Magnet Hockey", forKey: "Game")
            saveGame.synchronize()
            gameModeLabel1.text = "Repulsion Mode"
            gameModeLabel2.text = "Standard Mode"
        }
        
        magnetEmitter = SKEmitterNode()
        magnetEmitter.particleTexture = SKTexture(imageNamed: "newMagnetSmaller.png")
        magnetEmitter.particlePositionRange = CGVector(dx: frame.width * 7/8, dy: 0)
        magnetEmitter.particleScale = 0.15
        magnetEmitter.particlePosition = CGPoint(x: frame.width/2, y: 51/50 * frame.height)
        magnetEmitter.particleLifetime = 6
        magnetEmitter.particleBirthRate = 0.75
        magnetEmitter.particleSpeed = -30
        magnetEmitter.yAcceleration = -60
        magnetEmitter.zPosition = -6
        magnetEmitter.particleColorBlendFactor = 0.2
        magnetEmitter.particleColorBlendFactorSpeed = 0.20
        magnetEmitter.advanceSimulationTime(1.5)
        addChild(magnetEmitter)
        
        backButton = SKSpriteNode(imageNamed: "arrowLeft.png")
        backButton.position = CGPoint(x: frame.width * 0.16, y: frame.height * 0.85)
        backButton.scale(to: CGSize(width: frame.width * 0.13, height: frame.width * 0.13))
        addChild(backButton)
        
        forwardButton = SKSpriteNode(imageNamed: "arrowRight.png")
        forwardButton.position = CGPoint(x: frame.width * 0.84, y: frame.height * 0.85)
        forwardButton.scale(to: CGSize(width: frame.width * 0.13, height: frame.width * 0.13))
        addChild(forwardButton)
        
        pageDotOne = SKSpriteNode(imageNamed: "whiteDot.png")
        pageDotOne.position = CGPoint(x: frame.width * 0.47, y: frame.height * 0.75)
        pageDotOne.scale(to: CGSize(width: frame.width * 0.025, height: frame.width * 0.025))
        addChild(pageDotOne)
        
        pageDotTwo = SKSpriteNode(imageNamed: "whiteDot.png")
        pageDotTwo.position = CGPoint(x: frame.width * 0.50, y: frame.height * 0.75)
        pageDotTwo.scale(to: CGSize(width: frame.width * 0.025, height: frame.width * 0.025))
        addChild(pageDotTwo)
        
        pageDotThree = SKSpriteNode(imageNamed: "whiteDot.png")
        pageDotThree.position = CGPoint(x: frame.width * 0.53, y: frame.height * 0.75)
        pageDotThree.scale(to: CGSize(width: frame.width * 0.025, height: frame.width * 0.025))
        addChild(pageDotThree)
        
        if UserDefaults.standard.string(forKey: "Game") == "Magnet Hockey"
        {
            forwardButton.colorBlendFactor = 0
            backButton.colorBlendFactor = 0.5
            pageDotOne.colorBlendFactor = 0
            pageDotTwo.colorBlendFactor = 0.75
            pageDotThree.colorBlendFactor = 0.75

        }
        else if UserDefaults.standard.string(forKey: "Game") == "Air Hockey"
        {
            forwardButton.colorBlendFactor = 0
            backButton.colorBlendFactor = 0
            pageDotOne.colorBlendFactor = 0.75
            pageDotTwo.colorBlendFactor = 0
            pageDotThree.colorBlendFactor = 0.75

        }
        else if UserDefaults.standard.string(forKey: "Game") == "Online"
        {
            forwardButton.colorBlendFactor = 0.5
            backButton.colorBlendFactor = 0
            pageDotOne.colorBlendFactor = 0.75
            pageDotTwo.colorBlendFactor = 0.75
            pageDotThree.colorBlendFactor = 0

        }
        else
        {
            let saveGame = UserDefaults.standard
            saveGame.set("Magnet Hockey", forKey: "Game")
            saveGame.synchronize()
            forwardButton.colorBlendFactor = 0
            backButton.colorBlendFactor = 0.5
            pageDotOne.colorBlendFactor = 0
            pageDotTwo.colorBlendFactor = 0.75
            pageDotThree.colorBlendFactor = 0

        }
    }

    func playMagnetHockey()
    {
        gameModeButton1.colorBlendFactor = 0
        let scene = MagnetHockey(size: (view?.bounds.size)!)
            
        // Configure the view.
        let skView = self.view!
        skView.isMultipleTouchEnabled = true
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true

        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .resizeFill
        let transition = SKTransition.doorsOpenHorizontal(withDuration: 0.75)
        skView.presentScene(scene, transition: transition)
    }
    
    func playAirHockeyOnline()
    {
        let scene = AirHockey2POnline(size: (view?.bounds.size)!)
            
        // Configure the view.
        let skView = self.view!
        skView.isMultipleTouchEnabled = false
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true

        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .resizeFill
        let transition = SKTransition.doorsOpenHorizontal(withDuration: 0.75)
        skView.presentScene(scene, transition: transition)
    }
    
    func playAirHockey2P()
    {
        gameModeButton1.colorBlendFactor = 0
        let scene = AirHockey2P(size: (view?.bounds.size)!)
            
        // Configure the view.
        let skView = self.view!
        skView.isMultipleTouchEnabled = true
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true

        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .resizeFill
        let transition = SKTransition.doorsOpenHorizontal(withDuration: 0.75)
        skView.presentScene(scene, transition: transition)
    }
    
    func playAirHockey2PMultiPuck()
    {
        gameModeButton2.colorBlendFactor = 0
        let scene = AirHockey2PMultiPuck(size: (view?.bounds.size)!)
            
        // Configure the view.
        let skView = self.view!
        skView.isMultipleTouchEnabled = true
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true

        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .resizeFill
        let transition = SKTransition.doorsOpenHorizontal(withDuration: 0.75)
        skView.presentScene(scene, transition: transition)
    }
    
    func playAirHockey1P()
    {
        gameModeButton1.colorBlendFactor = 0
        let scene = AirHockey1P(size: (view?.bounds.size)!)
            
        // Configure the view.
        let skView = self.view!
        skView.isMultipleTouchEnabled = false
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true

        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .resizeFill
        let transition = SKTransition.doorsOpenHorizontal(withDuration: 0.75)
        skView.presentScene(scene, transition: transition)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touch = touches.first
        if let location = touch?.location(in: self)
        {
            let nodesArray = self.nodes(at: location)
            if nodesArray.contains(playButton)
            {
                playButton.colorBlendFactor = 0.5
                touchedPlay = true
            }
            else if nodesArray.contains(gameModeButton1)
            {
                if gameModeButton1.colorBlendFactor > 0
                {
                    gameModeButton1.colorBlendFactor = 0
                }
                else
                {
                    gameModeButton1.colorBlendFactor = 0.5
                }
                touchedGameMode1 = true
            }
            
            else if nodesArray.contains(gameModeButton2)
            {
                if gameModeButton2.colorBlendFactor > 0
                {
                    gameModeButton2.colorBlendFactor = 0
                }
                else
                {
                    gameModeButton2.colorBlendFactor = 0.5
                }
                touchedGameMode2 = true
            }
            
            else if nodesArray.contains(onePlayerButton) && UserDefaults.standard.string(forKey: "Game") != "Magnet Hockey" && UserDefaults.standard.string(forKey: "Game") != "Online Hockey"
            {
                if onePlayerButton.colorBlendFactor > 0
                {
                    onePlayerButton.colorBlendFactor = 0
                }
                else
                {
                    onePlayerButton.colorBlendFactor = 0.5
                }
                touched1Player = true
            }
            
            else if nodesArray.contains(twoPlayerButton) && UserDefaults.standard.string(forKey: "Game") != "Online Hockey"
            {
                if twoPlayerButton.colorBlendFactor > 0
                {
                    twoPlayerButton.colorBlendFactor = 0
                }
                else
                {
                    twoPlayerButton.colorBlendFactor = 0.5
                }
                touched2Player = true
            }
                
            else if nodesArray.contains(storeButton)
            {
                storeButton.colorBlendFactor = 0.5
                touchedStore = true
            }
            else if nodesArray.contains(settingsButton)
            {
                settingsButton.colorBlendFactor = 0.5
                touchedSettings = true
            }
            else if nodesArray.contains(instructionsButton)
            {
                instructionsButton.colorBlendFactor = 0.5
                touchedInstructions = true
            }
            else if nodesArray.contains(statisticsButton)
            {
                statisticsButton.colorBlendFactor = 0.5
                touchedStatistics = true
            }
            else if nodesArray.contains(backButton) && arrowPressCounter > 0
            {
                backButton.colorBlendFactor = 0.5
                touchedBackButton = true
            }
            else if nodesArray.contains(forwardButton) && arrowPressCounter < 2
            {
                forwardButton.colorBlendFactor = 0.5
                touchedForwardButton = true
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touch = touches.first
        
        if let location = touch?.location(in: self)
        {
            let nodesArray = self.nodes(at: location)
            if nodesArray.contains(playButton) && touchedPlay == true
            {
                if gameModeButton1.colorBlendFactor > 0 && gameModeButton2.colorBlendFactor == 0 && titleLabel.text == "MAGNET"
                {
                    SKTAudio.sharedInstance().pauseBackgroundMusic()
                    if UserDefaults.standard.string(forKey: "Sound") == "On" {run(buttonSound)}
                    else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                    else{run(buttonSound)}
                    touchedPlay = false
                    playButton.colorBlendFactor = 0
                    playMagnetHockey()
                }
                else if gameModeButton2.colorBlendFactor > 0 && gameModeButton1.colorBlendFactor == 0 && titleLabel.text == "MAGNET"
                {
                    SKTAudio.sharedInstance().pauseBackgroundMusic()
                    if UserDefaults.standard.string(forKey: "Sound") == "On" {run(buttonSound)}
                    else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                    else{run(buttonSound)}
                    touchedPlay = false
                    playButton.colorBlendFactor = 0
                    playMagnetHockey()
                }
                if onePlayerButton.colorBlendFactor > 0 && twoPlayerButton.colorBlendFactor == 0 && titleLabel.text == "AIR"
                {
                    SKTAudio.sharedInstance().pauseBackgroundMusic()
                    if UserDefaults.standard.string(forKey: "Sound") == "On" {run(buttonSound)}
                    else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                    else{run(buttonSound)}
                    touchedPlay = false
                    playButton.colorBlendFactor = 0
                    playAirHockey1P()
                }
                else if twoPlayerButton.colorBlendFactor > 0 && onePlayerButton.colorBlendFactor == 0 && titleLabel.text == "AIR" && UserDefaults.standard.string(forKey: "GameType") == "GameMode1"
                {
                    SKTAudio.sharedInstance().pauseBackgroundMusic()
                    if UserDefaults.standard.string(forKey: "Sound") == "On" {run(buttonSound)}
                    else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                    else{run(buttonSound)}
                    touchedPlay = false
                    playButton.colorBlendFactor = 0
                    playAirHockey2P()
                }
                else if twoPlayerButton.colorBlendFactor > 0 && onePlayerButton.colorBlendFactor == 0 && titleLabel.text == "AIR" && UserDefaults.standard.string(forKey: "GameType") == "GameMode2"
                {
                    SKTAudio.sharedInstance().pauseBackgroundMusic()
                    if UserDefaults.standard.string(forKey: "Sound") == "On" {run(buttonSound)}
                    else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                    else{run(buttonSound)}
                    touchedPlay = false
                    playButton.colorBlendFactor = 0
                    playAirHockey2PMultiPuck()
                }
                
                else if titleLabel.text == "ONLINE" && UserDefaults.standard.string(forKey: "GameType") == "GameMode1"
                {
                    if UserDefaults.standard.string(forKey: "Sound") == "On" {run(buttonSound)}
                    else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                    else{run(buttonSound)}
                    touchedPlay = false
                    playButton.colorBlendFactor = 0
                    triggerNetworkingAlert()
                }
                else
                {
                    if UserDefaults.standard.string(forKey: "Sound") == "On" {run(buttonSound)}
                    else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                    else{run(buttonSound)}
                    playButton.colorBlendFactor = 0
                }
            }
            else if nodesArray.contains(gameModeButton1) && touchedGameMode1 == true
            {
                let saveGameType = UserDefaults.standard
                saveGameType.set("GameMode1", forKey: "GameType")
                saveGameType.synchronize()
                touchedGameMode1 = false
                gameModeButton2.colorBlendFactor = 0
                gameModeButton1.colorBlendFactor = 0.5
                if UserDefaults.standard.string(forKey: "Sound") == "On" {run(buttonSound)}
                else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                else{run(buttonSound)}
            }
                
            else if nodesArray.contains(gameModeButton2) && touchedGameMode2 == true
            {
                let saveGameType = UserDefaults.standard
                saveGameType.set("GameMode2", forKey: "GameType")
                saveGameType.synchronize()
                touchedGameMode2 = false
                gameModeButton1.colorBlendFactor = 0
                gameModeButton2.colorBlendFactor = 0.5
                if UserDefaults.standard.string(forKey: "Sound") == "On" {run(buttonSound)}
                else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                else{run(buttonSound)}
            }
            
            else if nodesArray.contains(onePlayerButton) && touched1Player == true && UserDefaults.standard.string(forKey: "Game") != "Magnet Hockey"
            {
                let saveGameType = UserDefaults.standard
                saveGameType.set("1Player", forKey: "PlayerMode")
                saveGameType.synchronize()
                touched1Player = false
                onePlayerButton.colorBlendFactor = 0.5
                twoPlayerButton.colorBlendFactor = 0
                if UserDefaults.standard.string(forKey: "Sound") == "On" {run(buttonSound)}
                else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                else{run(buttonSound)}
                onePlayerActiveSprite.isHidden = false
                onePlayerInactiveSprite.isHidden = true
                onePlayerLockedSprite.isHidden = true
                twoPlayerActiveSprite.isHidden = true
                twoPlayerInactiveSprite.isHidden = false
                if UserDefaults.standard.string(forKey: "PlayerMode") == "1Player"
                {
                    gameModeLabel1.text = "Normal Bot"
                    gameModeLabel2.text = "Expert Bot"
                }
                else
                {
                    gameModeLabel1.text = "1 Puck"
                    gameModeLabel2.text = "2 Pucks"
                }
            }
            
            else if nodesArray.contains(twoPlayerButton) && touched2Player == true && UserDefaults.standard.string(forKey: "Game") != "Magnet Hockey"
            {
                let saveGameType = UserDefaults.standard
                saveGameType.set("2Player", forKey: "PlayerMode")
                saveGameType.synchronize()
                touched2Player = false
                onePlayerButton.colorBlendFactor = 0
                twoPlayerButton.colorBlendFactor = 0.5
                if UserDefaults.standard.string(forKey: "Sound") == "On" {run(buttonSound)}
                else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                else{run(buttonSound)}
                onePlayerActiveSprite.isHidden = true
                onePlayerInactiveSprite.isHidden = false
                onePlayerLockedSprite.isHidden = true
                twoPlayerActiveSprite.isHidden = false
                twoPlayerInactiveSprite.isHidden = true
                if UserDefaults.standard.string(forKey: "PlayerMode") == "1Player"
                {
                    gameModeLabel1.text = "Normal Bot"
                    gameModeLabel2.text = "Expert Bot"
                }
                else
                {
                    gameModeLabel1.text = "1 Puck"
                    gameModeLabel2.text = "2 Pucks"
                }
            }
            
            else if nodesArray.contains(twoPlayerButton) && touched2Player == true && UserDefaults.standard.string(forKey: "Game") == "Magnet Hockey"
            {
                let saveGameType = UserDefaults.standard
                saveGameType.set("2Player", forKey: "PlayerMode")
                saveGameType.synchronize()
                touched2Player = false
                onePlayerButton.colorBlendFactor = 0
                twoPlayerButton.colorBlendFactor = 0.5
                if UserDefaults.standard.string(forKey: "Sound") == "On" {run(buttonSound)}
                else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                else{run(buttonSound)}
                onePlayerActiveSprite.isHidden = true
                onePlayerInactiveSprite.isHidden = true
                onePlayerLockedSprite.isHidden = false
                twoPlayerActiveSprite.isHidden = false
                twoPlayerInactiveSprite.isHidden = true
            }
                
            else if nodesArray.contains(storeButton) && touchedStore == true
            {
                appDelegate.MPC.killSession()
                if UserDefaults.standard.string(forKey: "Sound") == "On" {run(buttonSound)}
                else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                else{run(buttonSound)}
                touchedStore = false
                storeButton.colorBlendFactor = 0
                let scene = StoreScene(size: (view?.bounds.size)!)
                    
                // Configure the view.
                let skView = self.view!
                skView.isMultipleTouchEnabled = false


                /* Sprite Kit applies additional optimizations to improve rendering performance */
                skView.ignoresSiblingOrder = true

                /* Set the scale mode to scale to fit the window */
                scene.scaleMode = .resizeFill
                let transition = SKTransition.crossFade(withDuration: 0.35)
                skView.presentScene(scene, transition: transition)
            }
                
            else if nodesArray.contains(settingsButton) && touchedSettings == true
            {
                appDelegate.MPC.killSession()
                if UserDefaults.standard.string(forKey: "Sound") == "On" {run(buttonSound)}
                else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                else{run(buttonSound)}
                touchedSettings = false
                settingsButton.colorBlendFactor = 0
                
                let scene = Settings(size: (view?.bounds.size)!)
                // Configure the view.
                let skView = self.view!
                skView.isMultipleTouchEnabled = false

                /* Sprite Kit applies additional optimizations to improve rendering performance */
                skView.ignoresSiblingOrder = true

                /* Set the scale mode to scale to fit the window */
                scene.scaleMode = .resizeFill
                let transition = SKTransition.crossFade(withDuration: 0.35)
                skView.presentScene(scene, transition: transition)
            }
            
            else if nodesArray.contains(instructionsButton) && touchedInstructions == true
            {
                appDelegate.MPC.killSession()
                if UserDefaults.standard.string(forKey: "Sound") == "On" {run(buttonSound)}
                else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                else{run(buttonSound)}
                touchedInstructions = false
                instructionsButton.colorBlendFactor = 0
                let scene = InfoScene(size: (view?.bounds.size)!)
                    
                // Configure the view.
                let skView = self.view!
                skView.isMultipleTouchEnabled = false

                /* Sprite Kit applies additional optimizations to improve rendering performance */
                skView.ignoresSiblingOrder = true

                /* Set the scale mode to scale to fit the window */
                scene.scaleMode = .resizeFill
                let transition = SKTransition.crossFade(withDuration: 0.35)
                skView.presentScene(scene, transition: transition)
            }
            
            else if nodesArray.contains(statisticsButton) && touchedStatistics == true
            {
                appDelegate.MPC.killSession()
                if UserDefaults.standard.string(forKey: "Sound") == "On" {run(buttonSound)}
                else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                else{run(buttonSound)}
                touchedStatistics = false
                statisticsButton.colorBlendFactor = 0
                let scene = StatisticsScene(size: (view?.bounds.size)!)
                    
                // Configure the view.
                let skView = self.view!
                skView.isMultipleTouchEnabled = false

                /* Sprite Kit applies additional optimizations to improve rendering performance */
                skView.ignoresSiblingOrder = true

                /* Set the scale mode to scale to fit the window */
                scene.scaleMode = .resizeFill
                let transition = SKTransition.crossFade(withDuration: 0.35)
                skView.presentScene(scene, transition: transition)
            }
            
            else if nodesArray.contains(backButton) && touchedBackButton == true && arrowPressCounter == 1
            {
                appDelegate.MPC.killSession()
                touchedBackButton = false
                backButton.colorBlendFactor = 0.5
                forwardButton.colorBlendFactor = 0
                pageDotOne.colorBlendFactor = 0.0
                pageDotTwo.colorBlendFactor = 0.5
                pageDotThree.colorBlendFactor = 0.5

                arrowPressCounter -= 1
                if UserDefaults.standard.string(forKey: "Sound") == "On" {run(buttonSound)}
                else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                else{run(buttonSound)}
                titleLabel.text = "MAGNET"
                gameModeLabel1.text = "Repulsion Mode"
                gameModeLabel2.text = "Standard Mode"
                let saveGame = UserDefaults.standard
                saveGame.set("Magnet Hockey", forKey: "Game")
                saveGame.synchronize()
                let savePlayerMode = UserDefaults.standard
                savePlayerMode.set("2Player", forKey: "PlayerMode")
                savePlayerMode.synchronize()
                onePlayerActiveSprite.isHidden = true
                onePlayerInactiveSprite.isHidden = true
                onePlayerLockedSprite.isHidden = false
                twoPlayerActiveSprite.isHidden = false
                twoPlayerInactiveSprite.isHidden = true
                onePlayerButton.colorBlendFactor = 0.0
                twoPlayerButton.colorBlendFactor = 0.5
            }
            
            else if nodesArray.contains(backButton) && touchedBackButton == true && arrowPressCounter == 2
            {
                appDelegate.MPC.killSession()
                touchedBackButton = false
                backButton.colorBlendFactor = 0
                forwardButton.colorBlendFactor = 0
                pageDotOne.colorBlendFactor = 0.5
                pageDotTwo.colorBlendFactor = 0.0
                pageDotThree.colorBlendFactor = 0.5

                arrowPressCounter -= 1
                if UserDefaults.standard.string(forKey: "Sound") == "On" {run(buttonSound)}
                else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                else{run(buttonSound)}
                titleLabel.text = "AIR"
                gameModeLabel1.text = "1 Puck"
                gameModeLabel2.text = "2 Pucks"
                let saveGame = UserDefaults.standard
                saveGame.set("Air Hockey", forKey: "Game")
                saveGame.synchronize()
                let savePlayerMode = UserDefaults.standard
                savePlayerMode.set("2Player", forKey: "PlayerMode")
                savePlayerMode.synchronize()
                playTriangleButton.texture = SKTexture(imageNamed: "whitePlayButton")
                playTriangleButton.scale(to: CGSize(width: frame.width * 0.20, height: frame.width * 0.20))
                onePlayerActiveSprite.isHidden = true
                onePlayerInactiveSprite.isHidden = false
                onePlayerLockedSprite.isHidden = true
                twoPlayerActiveSprite.isHidden = false
                twoPlayerInactiveSprite.isHidden = true
                onePlayerButton.colorBlendFactor = 0.0
                twoPlayerButton.colorBlendFactor = 0.5
            }
            
            else if nodesArray.contains(forwardButton) && touchedForwardButton == true && arrowPressCounter == 0
            {
                appDelegate.MPC.killSession()
                touchedForwardButton = false
                forwardButton.colorBlendFactor = 0.0
                backButton.colorBlendFactor = 0.0
                pageDotOne.colorBlendFactor = 0.5
                pageDotTwo.colorBlendFactor = 0.0
                pageDotThree.colorBlendFactor = 0.5

                if UserDefaults.standard.string(forKey: "Sound") == "On" {run(buttonSound)}
                else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                else{run(buttonSound)}
                titleLabel.text = "AIR"
                if UserDefaults.standard.string(forKey: "PlayerMode") == "1Player"
                {
                    gameModeLabel1.text = "Normal Bot"
                    gameModeLabel2.text = "Expert Bot"
                }
                else
                {
                    gameModeLabel1.text = "1 Puck"
                    gameModeLabel2.text = "2 Pucks"
                }
                arrowPressCounter += 1
                let saveGame = UserDefaults.standard
                saveGame.set("Air Hockey", forKey: "Game")
                saveGame.synchronize()
                let savePlayerMode = UserDefaults.standard
                savePlayerMode.set("2Player", forKey: "PlayerMode")
                savePlayerMode.synchronize()
                if UserDefaults.standard.string(forKey: "GameType") != "GameMode2" && UserDefaults.standard.string(forKey: "GameType") != "GameMode1"
                {
                    let saveGameMode = UserDefaults.standard
                    saveGameMode.set("GameMode2", forKey: "GameType")
                    saveGameMode.synchronize()
                }
                onePlayerActiveSprite.isHidden = true
                onePlayerInactiveSprite.isHidden = false
                onePlayerLockedSprite.isHidden = true
                twoPlayerActiveSprite.isHidden = false
                twoPlayerInactiveSprite.isHidden = true
                onePlayerButton.colorBlendFactor = 0.0
                twoPlayerButton.colorBlendFactor = 0.5
            }
            
            else if nodesArray.contains(forwardButton) && touchedForwardButton == true && arrowPressCounter == 1
            {
                touchedForwardButton = false
                forwardButton.colorBlendFactor = 0.5
                backButton.colorBlendFactor = 0.0
                pageDotOne.colorBlendFactor = 0.5
                pageDotTwo.colorBlendFactor = 0.5
                pageDotThree.colorBlendFactor = 0.0

                if UserDefaults.standard.string(forKey: "Sound") == "On" {run(buttonSound)}
                else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                else{run(buttonSound)}
                titleLabel.text = "ONLINE"
                gameModeLabel1.text = "Nearby Player"
                gameModeLabel2.text = "Random Player"
                arrowPressCounter += 1
                let saveGame = UserDefaults.standard
                saveGame.set("Online Hockey", forKey: "Game")
                saveGame.synchronize()
                playTriangleButton.texture = SKTexture(imageNamed: "searchIcon")
                playTriangleButton.scale(to: CGSize(width: frame.width * 0.15, height: frame.width * 0.15))
                onePlayerActiveSprite.isHidden = true
                onePlayerInactiveSprite.isHidden = true
                onePlayerLockedSprite.isHidden = true
                twoPlayerActiveSprite.isHidden = true
                twoPlayerInactiveSprite.isHidden = true
                onePlayerButton.colorBlendFactor = 1
                twoPlayerButton.colorBlendFactor = 1
            }
            
            else
            {
                if touchedPlay == true
                {
                    touchedPlay = false
                    playButton.colorBlendFactor = 0
                }
                if touchedGameMode1 == true
                {
                    touchedGameMode1 = false
                    if gameModeButton1.colorBlendFactor > 0 && gameModeButton2.colorBlendFactor > 0
                    {
                        gameModeButton2.colorBlendFactor = 0.5
                        gameModeButton1.colorBlendFactor = 0
                    }
                    else
                    {
                        gameModeButton2.colorBlendFactor = 0
                        gameModeButton1.colorBlendFactor = 0.5
                    }
                }
                if touchedGameMode2 == true
                {
                    touchedGameMode2 = false
                    if gameModeButton2.colorBlendFactor > 0 && gameModeButton1.colorBlendFactor > 0
                    {
                        gameModeButton2.colorBlendFactor = 0
                        gameModeButton1.colorBlendFactor = 0.5
                    }
                    else
                    {
                        gameModeButton2.colorBlendFactor = 0.5
                        gameModeButton1.colorBlendFactor = 0
                    }
                }
                
                if touched1Player == true
                {
                    touched1Player = false
                    if onePlayerButton.colorBlendFactor > 0 && twoPlayerButton.colorBlendFactor > 0
                    {
                        twoPlayerButton.colorBlendFactor = 0.5
                        onePlayerButton.colorBlendFactor = 0
                    }
                    else
                    {
                        twoPlayerButton.colorBlendFactor = 0
                        onePlayerButton.colorBlendFactor = 0.5
                    }
                }
                
                if touched2Player == true
                {
                    touched2Player = false
                    if twoPlayerButton.colorBlendFactor > 0 && onePlayerButton.colorBlendFactor > 0
                    {
                        twoPlayerButton.colorBlendFactor = 0
                        onePlayerButton.colorBlendFactor = 0.5
                    }
                    else
                    {
                        twoPlayerButton.colorBlendFactor = 0.5
                        onePlayerButton.colorBlendFactor = 0
                    }
                }
                
                if touchedStore == true
                {
                    touchedStore = false
                    storeButton.colorBlendFactor = 0
                }
                if touchedSettings == true
                {
                    touchedSettings = false
                    settingsButton.colorBlendFactor = 0
                }
                if touchedInstructions == true
                {
                    touchedInstructions = false
                    instructionsButton.colorBlendFactor = 0
                }
                if touchedStatistics == true
                {
                    touchedStatistics = false
                    statisticsButton.colorBlendFactor = 0
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
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval)
    {
        if appDelegate.MPC.session.connectedPeers.count == 1
        {
            multipeerGameReady = true
        }
        if multipeerGameReady == true
        {
            multipeerGameReady = false
            playAirHockeyOnline()
        }
        print(appDelegate.MPC.session.connectedPeers)
        if arrowPressCounter == 0
        {
            titleLabel.text = "MAGNET"
        }
        else if arrowPressCounter == 1
        {
            titleLabel.text = "AIR"
        }
        else if arrowPressCounter == 2
        {
            titleLabel.text = "ONLINE"
        }
        else
        {
            titleLabel.text = "MAGNET"
            arrowPressCounter = 0
        }
    }
}
