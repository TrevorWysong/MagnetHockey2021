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
    let repulsionModeLabel = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    let standardModeLabel = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    let storeButtonLabel = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    var repulsionModeButton = SKSpriteNode()
    var standardModeButton = SKSpriteNode()
    var settingsButton = SKSpriteNode()
    var instructionsButton = SKSpriteNode()
    var playButton:SKSpriteNode!
    var storeButton:SKSpriteNode!
    var infoButton:SKSpriteNode!
    var magnetEmitter:SKEmitterNode!
    let buttonSound = SKAction.playSoundFileNamed("ChangeRounds.mp3", waitForCompletion: false)
    var touchedPlay = false
    var touchedRepulsionMode = false
    var touchedStandardMode = false
    var touchedStore = false
    var touchedSettings = false
    var touchedInstructions = false
    
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
        
        if UserDefaults.standard.string(forKey: "GameType") == "RepulsionMode" || UserDefaults.standard.string(forKey: "GameType") == "StandardMode" {}
        else
        {
            let saveGameType = UserDefaults.standard
            saveGameType.set("StandardMode", forKey: "GameType")
            saveGameType.synchronize()
        }
        
        // set size, color, position and text of the tapStartLabel
        if frame.width < 600 && frame.height > 800
        {
            titleLabel.fontSize = frame.width/7
            titleLabel.position = CGPoint(x: frame.width/2, y: frame.height * 0.84)
        }
        else
        {
            titleLabel.fontSize = frame.width/8
            titleLabel.position = CGPoint(x: frame.width/2, y: frame.height * 0.85)
        }
        titleLabel.fontName = "Futura"
        titleLabel.fontColor = SKColor.white
        titleLabel.horizontalAlignmentMode = .center
        titleLabel.verticalAlignmentMode = .center
        titleLabel.zPosition = 1
        titleLabel.text = "MAGNET"
        addChild(titleLabel)
        
        // set size, color, position and text of the tapStartLabel
        if frame.width < 600 && frame.height > 800
        {
            titleLabel2.fontSize = frame.width/7
            titleLabel2.position = CGPoint(x: frame.width/2, y: frame.height * 0.76)
        }
        else
        {
            titleLabel2.fontSize = frame.width/8
            titleLabel2.position = CGPoint(x: frame.width/2, y: frame.height * 0.75)
        }
        titleLabel2.fontName = "Futura"
        titleLabel2.fontColor = SKColor.white
        titleLabel2.horizontalAlignmentMode = .center
        titleLabel2.verticalAlignmentMode = .center
        titleLabel2.zPosition = 1
        titleLabel2.text = "HOCKEY"
        addChild(titleLabel2)
        
        repulsionModeButton = SKSpriteNode(imageNamed: "IcyChillRoundedRectangle.png")
        repulsionModeButton.position = CGPoint(x: frame.width/2, y: frame.height * 0.60)
        repulsionModeButton.scale(to: CGSize(width: frame.width * 2/3, height: frame.height/10))
        addChild(repulsionModeButton)
        
        standardModeButton = SKSpriteNode(imageNamed: "IcyChillRoundedRectangle.png")
        standardModeButton.position = CGPoint(x: frame.width/2, y: frame.height * 0.48)
        standardModeButton.scale(to: CGSize(width: frame.width * 2/3, height: frame.height/10))
        standardModeButton.colorBlendFactor = 0.5
        if UserDefaults.standard.string(forKey: "GameType") == "StandardMode"
        {
            standardModeButton.colorBlendFactor = 0.5
            repulsionModeButton.colorBlendFactor = 0
        }
        else if UserDefaults.standard.string(forKey: "GameType") == "RepulsionMode"
        {
            standardModeButton.colorBlendFactor = 0
            repulsionModeButton.colorBlendFactor = 0.5
        }
        else
        {
            standardModeButton.colorBlendFactor = 0.5
            repulsionModeButton.colorBlendFactor = 0
        }
        addChild(standardModeButton)
        
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
        repulsionModeLabel.fontSize = frame.width/17.5
        repulsionModeLabel.fontColor = SKColor.white
        repulsionModeLabel.horizontalAlignmentMode = .center
        repulsionModeLabel.verticalAlignmentMode = .center
        repulsionModeLabel.position = CGPoint(x: repulsionModeButton.position.x, y: repulsionModeButton.position.y)
        repulsionModeLabel.zPosition = 1
        repulsionModeLabel.text = "Repulsion Mode"
        addChild(repulsionModeLabel)
        
        // set size, color, position and text of the tapStartLabel
        standardModeLabel.fontSize = frame.width/17.5
        standardModeLabel.fontColor = SKColor.white
        standardModeLabel.horizontalAlignmentMode = .center
        standardModeLabel.verticalAlignmentMode = .center
        standardModeLabel.position = CGPoint(x: standardModeButton.position.x, y: standardModeButton.position.y)
        standardModeLabel.zPosition = 1
        standardModeLabel.text = "Standard Mode"
        addChild(standardModeLabel)
       
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
    }

    func gameScene()
    {
        repulsionModeButton.colorBlendFactor = 0
        let scene = GameScene(size: (view?.bounds.size)!)
            
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
            else if nodesArray.contains(repulsionModeButton)
            {
                if repulsionModeButton.colorBlendFactor > 0
                {
                    repulsionModeButton.colorBlendFactor = 0
                }
                else
                {
                    repulsionModeButton.colorBlendFactor = 0.5
                }
                touchedRepulsionMode = true
            }
                
            else if nodesArray.contains(standardModeButton)
            {
                if standardModeButton.colorBlendFactor > 0
                {
                    standardModeButton.colorBlendFactor = 0
                }
                else
                {
                    standardModeButton.colorBlendFactor = 0.5
                }
                touchedStandardMode = true
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
                if repulsionModeButton.colorBlendFactor > 0 && standardModeButton.colorBlendFactor == 0
                {
                    SKTAudio.sharedInstance().pauseBackgroundMusic()
                    if UserDefaults.standard.string(forKey: "Sound") == "On" {run(buttonSound)}
                    else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                    else{run(buttonSound)}
                    touchedPlay = false
                    playButton.colorBlendFactor = 0
                    gameScene()
                }
                else if standardModeButton.colorBlendFactor > 0 && repulsionModeButton.colorBlendFactor == 0
                {
                    SKTAudio.sharedInstance().pauseBackgroundMusic()
                    if UserDefaults.standard.string(forKey: "Sound") == "On" {run(buttonSound)}
                    else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                    else{run(buttonSound)}
                    touchedPlay = false
                    playButton.colorBlendFactor = 0
                    gameScene()
                }
                else
                {
                    if UserDefaults.standard.string(forKey: "Sound") == "On" {run(buttonSound)}
                    else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                    else{run(buttonSound)}
                    playButton.colorBlendFactor = 0
                }
            }
            else if nodesArray.contains(repulsionModeButton) && touchedRepulsionMode == true
            {
                let saveGameType = UserDefaults.standard
                saveGameType.set("RepulsionMode", forKey: "GameType")
                saveGameType.synchronize()
                touchedRepulsionMode = false
                standardModeButton.colorBlendFactor = 0
                repulsionModeButton.colorBlendFactor = 0.5
                if UserDefaults.standard.string(forKey: "Sound") == "On" {run(buttonSound)}
                else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                else{run(buttonSound)}
            }
                
            else if nodesArray.contains(standardModeButton) && touchedStandardMode == true
            {
                let saveGameType = UserDefaults.standard
                saveGameType.set("StandardMode", forKey: "GameType")
                saveGameType.synchronize()
                touchedStandardMode = false
                repulsionModeButton.colorBlendFactor = 0
                standardModeButton.colorBlendFactor = 0.5
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
            
            else
            {
                if touchedPlay == true
                {
                    touchedPlay = false
                    playButton.colorBlendFactor = 0
                }
                if touchedRepulsionMode == true
                {
                    touchedRepulsionMode = false
                    if repulsionModeButton.colorBlendFactor > 0 && standardModeButton.colorBlendFactor > 0
                    {
                        standardModeButton.colorBlendFactor = 0.5
                        repulsionModeButton.colorBlendFactor = 0
                    }
                    else
                    {
                        standardModeButton.colorBlendFactor = 0
                        repulsionModeButton.colorBlendFactor = 0.5
                    }                }
                if touchedStandardMode == true
                {
                    touchedStandardMode = false
                    if standardModeButton.colorBlendFactor > 0 && repulsionModeButton.colorBlendFactor > 0
                    {
                        standardModeButton.colorBlendFactor = 0
                        repulsionModeButton.colorBlendFactor = 0.5
                    }
                    else
                    {
                        standardModeButton.colorBlendFactor = 0.5
                        repulsionModeButton.colorBlendFactor = 0
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
            }
        }
    }
}
