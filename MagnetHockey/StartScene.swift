//
//  StartScene.swift
//  Pong_TW
//
//  Created by Wysong, Trevor on 4/16/20.
//  Copyright © 2020 Wysong, Trevor. All rights reserved.
//

import SpriteKit
import GoogleMobileAds

class StartScene: SKScene
{
    // you can use another font for the label if you want...
    let titleLabel = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    let titleLabel2 = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    let gameModeLabel1 = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    let gameModeLabel2 = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    let storeButtonLabel = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    var gameModeButton1 = SKSpriteNode()
    var gameModeButton2 = SKSpriteNode()
    var settingsButton = SKSpriteNode()
    var instructionsButton = SKSpriteNode()
    var playButton:SKSpriteNode!
    var storeButton:SKSpriteNode!
    var infoButton:SKSpriteNode!
    var magnetEmitter:SKEmitterNode!
    let buttonSound = SKAction.playSoundFileNamed("ChangeRounds.mp3", waitForCompletion: false)
    var touchedPlay = false
    var touchedGameMode1 = false
    var touchedGameMode2 = false
    var touchedStore = false
    var touchedSettings = false
    var touchedInstructions = false
    var backButton = SKSpriteNode()
    var forwardButton = SKSpriteNode()
    var pageDotOne = SKSpriteNode()
    var pageDotTwo = SKSpriteNode()
    var touchedBackButton = false
    var touchedForwardButton = false
    var arrowPressCounter = 0
    
    func createEdges()
    {
        let leftEdge = SKSpriteNode(color: UIColor.systemBlue, size: CGSize(width: CGFloat(533/10000 * frame.width), height: size.height + ((35000/400000) * frame.height)))
        leftEdge.position = CGPoint(x: 0, y: frame.height/2)
        leftEdge.zPosition = 100
        addChild(leftEdge)
        
        //copy the left edge and position it as the right edge
        let rightEdge = SKSpriteNode(color: UIColor.systemBlue, size: CGSize(width: CGFloat(20/75 * frame.width), height: size.height + ((35000/400000) * frame.height)))
        rightEdge.position = CGPoint(x: size.width + (6.85/65 * (frame.width)), y: frame.height/2)
        rightEdge.zPosition = 100
        addChild(rightEdge)
        
        let bottomEdge = SKSpriteNode(color: UIColor.systemBlue, size: CGSize(width: frame.width*3, height: CGFloat(14/20 * frame.width)))
        if frame.height > 800 && frame.width < 500
        {
            bottomEdge.position = CGPoint(x: 0, y: -1 * frame.height/10)
        }
        else
        {
            bottomEdge.position = CGPoint(x: 0, y: 0 - (frame.width * 6.50/20))
        }
        bottomEdge.zPosition = -5
        addChild(bottomEdge)
        
        let topEdge = SKSpriteNode(color: UIColor.systemBlue, size: CGSize(width: frame.width*3 + ((20/100) * frame.width), height: CGFloat(55.00/100) * frame.width))
        if frame.height > 800 && frame.width < 500
        {
            topEdge.position = CGPoint(x: -1 * frame.width/10, y: frame.height + (2/30 * frame.height))
        }
        else
        {
            topEdge.position = CGPoint(x: 0, y: frame.height + ((9.2/37.5) * frame.width))
        }
        topEdge.zPosition = -5
        addChild(topEdge)
    }
    
    func leftArrowPressed()
    {
        arrowPressCounter -= 1
    }
    
    func rightArrowPressed()
    {
        arrowPressCounter += 1
    }
    
    override func didMove(to view: SKView)
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
        
        UserDefaults.standard.set(false, forKey: "RestoredRemoveAds")
        UserDefaults.standard.synchronize()
        
        UserDefaults.standard.set(false, forKey: "RestoredColorPack")
        UserDefaults.standard.synchronize()
        
        createEdges()
        
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
            titleLabel.position = CGPoint(x: frame.width/2, y: frame.height * 0.90)
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
            titleLabel2.position = CGPoint(x: frame.width/2, y: frame.height * 0.80)
        }
        titleLabel2.fontName = "Futura"
        titleLabel2.fontColor = SKColor.white
        titleLabel2.horizontalAlignmentMode = .center
        titleLabel2.verticalAlignmentMode = .center
        titleLabel2.zPosition = 1
        titleLabel2.text = "HOCKEY"
        addChild(titleLabel2)
        
        gameModeButton1 = SKSpriteNode(imageNamed: "IcyChillRoundedRectangle.png")
        gameModeButton1.position = CGPoint(x: frame.width/2, y: frame.height * 0.60)
        gameModeButton1.scale(to: CGSize(width: frame.width * 2/3, height: frame.height/10))
        addChild(gameModeButton1)
        
        gameModeButton2 = SKSpriteNode(imageNamed: "IcyChillRoundedRectangle.png")
        gameModeButton2.position = CGPoint(x: frame.width/2, y: frame.height * 0.48)
        gameModeButton2.scale(to: CGSize(width: frame.width * 2/3, height: frame.height/10))
        gameModeButton2.colorBlendFactor = 0.5
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
        addChild(gameModeButton2)
        
        storeButton = SKSpriteNode(imageNamed: "AgedEmeraldRectangle.png")
        storeButton.position = CGPoint(x: frame.width/2, y: frame.height * 0.17)
        storeButton.scale(to: CGSize(width: frame.width * 2/3, height: frame.height/10))
        storeButton.colorBlendFactor = 0
        addChild(storeButton)
        
        settingsButton = SKSpriteNode(imageNamed: "RedRoundedSquare.png")
        settingsButton.position = CGPoint(x: frame.width * 0.25, y: frame.height * 0.325)
        settingsButton.scale(to: CGSize(width: frame.width * 0.13, height: frame.width * 0.13))
        settingsButton.colorBlendFactor = 0
        addChild(settingsButton)
        
        instructionsButton = SKSpriteNode(imageNamed: "RedRoundedSquare.png")
        instructionsButton.position = CGPoint(x: frame.width * 0.75, y: frame.height * 0.325)
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

        
        let background = SKSpriteNode(imageNamed: "icyBackground3.png")
        background.blendMode = .replace
        background.position = CGPoint(x: frame.width/2, y: frame.height/2)
        background.scale(to: CGSize(width: frame.width, height: frame.height))
        background.colorBlendFactor = 0
        background.zPosition = -100
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
            gameModeLabel1.text = "1-Player Mode"
            gameModeLabel2.text = "2-Player Mode"
        }
        else
        {
            let saveGame = UserDefaults.standard
            saveGame.set("Magnet Hockey", forKey: "Game")
            saveGame.synchronize()
            gameModeLabel1.text = "Repulsion Mode"
            gameModeLabel2.text = "Standard Mode"
        }
       
        playButton = SKSpriteNode(imageNamed: "IcyChillSquare.png")
        playButton.position = CGPoint(x: frame.width/2, y: frame.height * 0.325)
        addChild(playButton)
        
        let playTriangleButton:SKSpriteNode!
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
        pageDotOne.position = CGPoint(x: frame.width * 0.47, y: frame.height * 0.73)
        pageDotOne.scale(to: CGSize(width: frame.width * 0.025, height: frame.width * 0.025))
        addChild(pageDotOne)
        
        pageDotTwo = SKSpriteNode(imageNamed: "whiteDot.png")
        pageDotTwo.position = CGPoint(x: frame.width * 0.53, y: frame.height * 0.73)
        pageDotTwo.scale(to: CGSize(width: frame.width * 0.025, height: frame.width * 0.025))
        addChild(pageDotTwo)
        
        if UserDefaults.standard.string(forKey: "Game") == "Magnet Hockey"
        {
            forwardButton.colorBlendFactor = 0
            backButton.colorBlendFactor = 0.5
            pageDotOne.colorBlendFactor = 0
            pageDotTwo.colorBlendFactor = 0.75
        }
        else if UserDefaults.standard.string(forKey: "Game") == "Air Hockey"
        {
            forwardButton.colorBlendFactor = 0.5
            backButton.colorBlendFactor = 0
            pageDotOne.colorBlendFactor = 0.75
            pageDotTwo.colorBlendFactor = 0
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
            
            else if nodesArray.contains(backButton) && arrowPressCounter > 0
            {
                backButton.colorBlendFactor = 0.5
                touchedBackButton = true
            }

            else if nodesArray.contains(forwardButton) && arrowPressCounter < 1
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
                if gameModeButton1.colorBlendFactor > 0 && gameModeButton2.colorBlendFactor == 0 && titleLabel.text == "AIR"
                {
                    SKTAudio.sharedInstance().pauseBackgroundMusic()
                    if UserDefaults.standard.string(forKey: "Sound") == "On" {run(buttonSound)}
                    else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                    else{run(buttonSound)}
                    touchedPlay = false
                    playButton.colorBlendFactor = 0
                    playAirHockey1P()
                }
                else if gameModeButton2.colorBlendFactor > 0 && gameModeButton1.colorBlendFactor == 0 && titleLabel.text == "AIR"
                {
                    SKTAudio.sharedInstance().pauseBackgroundMusic()
                    if UserDefaults.standard.string(forKey: "Sound") == "On" {run(buttonSound)}
                    else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                    else{run(buttonSound)}
                    touchedPlay = false
                    playButton.colorBlendFactor = 0
                    playAirHockey2P()
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
                
            else if nodesArray.contains(storeButton) && touchedStore == true
            {
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
            
            else if nodesArray.contains(backButton) && touchedBackButton == true && arrowPressCounter == 1
            {
                touchedBackButton = false
                backButton.colorBlendFactor = 0.5
                forwardButton.colorBlendFactor = 0
                pageDotOne.colorBlendFactor = 0.0
                pageDotTwo.colorBlendFactor = 0.5
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
            }
            
            else if nodesArray.contains(forwardButton) && touchedForwardButton == true && arrowPressCounter == 0
            {
                touchedForwardButton = false
                forwardButton.colorBlendFactor = 0.5
                backButton.colorBlendFactor = 0.0
                pageDotOne.colorBlendFactor = 0.5
                pageDotTwo.colorBlendFactor = 0.0
                if UserDefaults.standard.string(forKey: "Sound") == "On" {run(buttonSound)}
                else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                else{run(buttonSound)}
                titleLabel.text = "AIR"
                gameModeLabel1.text = "1-Player Mode"
                gameModeLabel2.text = "2-Player Mode"
                arrowPressCounter += 1
                let saveGame = UserDefaults.standard
                saveGame.set("Air Hockey", forKey: "Game")
                saveGame.synchronize()
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
        if arrowPressCounter == 0
        {
            titleLabel.text = "MAGNET"
        }
        else if arrowPressCounter == 1
        {
            titleLabel.text = "AIR"
        }
        else
        {
            titleLabel.text = "MAGNET"
            arrowPressCounter = 0
        }
    }
}
