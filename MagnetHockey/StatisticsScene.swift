//
//  StatisticsScene.swift
//  StatisticsScene
//
//  Created by Wysong, Trevor on 11/7/21.
//  Copyright © 2021 Wysong, Trevor. All rights reserved.
//

import SpriteKit
import GoogleMobileAds

class StatisticsScene: SKScene
{
    let buttonSound = SKAction.playSoundFileNamed("ChangeRounds.mp3", waitForCompletion: false)
    var statsEmitter1:SKEmitterNode!
    var statsEmitter2:SKEmitterNode!
    let gameModeLabel = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    let statsTypeLabel = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    var backButtonGameMode = SKSpriteNode()
    var forwardButtonGameMode = SKSpriteNode()
    var backButtonStatsType = SKSpriteNode()
    var forwardButtonStatsType = SKSpriteNode()
    var touchedBackButtonGameMode = false
    var touchedForwardButtonGameMode = false
    var touchedBackButtonStatsType = false
    var touchedForwardButtonStatsType = false
    var touchedMenu = false
    let backToMenuButtonLabel = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    var backToMenuButton = SKSpriteNode()
    var arrowPressCounterGameMode = 0
    var arrowPressCounterStatsType = 0
    
    func createEdges()
    {
        var leftEdge = SKSpriteNode(), rightEdge = SKSpriteNode(), bottomEdge = SKSpriteNode(), topEdge = SKSpriteNode()
        (leftEdge, rightEdge, bottomEdge, topEdge) = MenuHelper.shared.createEdges(frame: frame)
        addChild(leftEdge)
        addChild(rightEdge)
        addChild(bottomEdge)
        addChild(topEdge)
    }
    
    func createBackToMenuButton()
    {
        backToMenuButton = SKSpriteNode(imageNamed: "IcyChillRectangle.png")
        addChild(MenuHelper.shared.createBackToMenuButton(frame: frame, menuButton: backToMenuButton))
        addChild(MenuHelper.shared.createBackToMenuLabel(frame: frame, menuLabel: backToMenuButtonLabel))
    }
    
    func createSceneTitleSprites()
    {
        let statisticsBackgroundSprite:SKSpriteNode!
        statisticsBackgroundSprite = SKSpriteNode(imageNamed: "RedCircle.png")
        statisticsBackgroundSprite.position = CGPoint(x: frame.width * 0.50, y: frame.height * 0.80)
        if frame.width < 500
        {
            statisticsBackgroundSprite.scale(to: CGSize(width: frame.width * 0.33, height: frame.width * 0.33))
        }
        else
        {
            statisticsBackgroundSprite.scale(to: CGSize(width: frame.width * 0.25, height: frame.width * 0.25))
        }
        statisticsBackgroundSprite.colorBlendFactor = 0
        statisticsBackgroundSprite.zPosition = 0
        addChild(statisticsBackgroundSprite)
        
        let statisticsSprite:SKSpriteNode!
        statisticsSprite = SKSpriteNode(imageNamed: "crown.png")
        statisticsSprite.position = CGPoint(x: statisticsBackgroundSprite.position.x, y: statisticsBackgroundSprite.position.y)
        if frame.width < 500
        {
            statisticsSprite.scale(to: CGSize(width: frame.width * 0.24, height: frame.width * 0.24))
        }
        else
        {
            statisticsSprite.scale(to: CGSize(width: frame.width * 0.18, height: frame.width * 0.18))
        }
        statisticsSprite.colorBlendFactor = 0
        statisticsSprite.zPosition = 1
        addChild(statisticsSprite)
    }
    
    func createArrowButtons(backButtonName: SKSpriteNode, forwardButtonName: SKSpriteNode, backButtonPosition: CGPoint, forwardButtonPosition: CGPoint)
    {
        backButtonName.position = backButtonPosition
        backButtonName.scale(to: CGSize(width: frame.width * 0.13, height: frame.width * 0.13))
        backButtonName.colorBlendFactor = 0.5
        addChild(backButtonName)

        
        let backButtonSprite:SKSpriteNode!
        backButtonSprite = SKSpriteNode(imageNamed: "arrowLeft.png")
        backButtonSprite.position = CGPoint(x: backButtonName.position.x, y: backButtonName.position.y)
        backButtonSprite.scale(to: CGSize(width: frame.width * 0.08, height: frame.width * 0.08))
        backButtonSprite.colorBlendFactor = 0
        backButtonSprite.zPosition = 1
        addChild(backButtonSprite)
        
        forwardButtonName.position = forwardButtonPosition
        forwardButtonName.scale(to: CGSize(width: frame.width * 0.13, height: frame.width * 0.13))
        forwardButtonName.colorBlendFactor = 0
        addChild(forwardButtonName)
        
        let forwardButtonSprite:SKSpriteNode!
        forwardButtonSprite = SKSpriteNode(imageNamed: "arrowRight.png")
        forwardButtonSprite.position = CGPoint(x: forwardButtonName.position.x, y: forwardButtonName.position.y)
        forwardButtonSprite.scale(to: CGSize(width: frame.width * 0.08, height: frame.width * 0.08))
        forwardButtonSprite.colorBlendFactor = 0
        forwardButtonSprite.zPosition = 1
        addChild(forwardButtonSprite)
    }
    
    func createBackground()
    {
        let background = MenuHelper.shared.createBackground(frame: frame)
        addChild(background)
    }
    
    func createGameModeButton()
    {
        let gameModeButton = SKSpriteNode(imageNamed: "IcyChillRoundedRectangle.png")
        gameModeButton.position = CGPoint(x: frame.width/2, y: frame.height * 0.60)
        gameModeButton.scale(to: CGSize(width: frame.width * 0.60, height: frame.height * 0.09))
        addChild(gameModeButton)

        
        // set size, color, position and text of the tapStartLabel
        gameModeLabel.fontSize = frame.width/20
        gameModeLabel.fontColor = SKColor.white
        gameModeLabel.horizontalAlignmentMode = .center
        gameModeLabel.verticalAlignmentMode = .center
        gameModeLabel.position = CGPoint(x: gameModeButton.position.x, y: gameModeButton.position.y)
        gameModeLabel.zPosition = 1
        gameModeLabel.text = "All Modes"
        addChild(gameModeLabel)
        
        let statsTypeButton = SKSpriteNode(imageNamed: "IcyChillRoundedRectangle.png")
        statsTypeButton.position = CGPoint(x: frame.width/2, y: frame.height * 0.50)
        statsTypeButton.scale(to: CGSize(width: frame.width * 0.60, height: frame.height * 0.09))
        addChild(statsTypeButton)
        
        // set size, color, position and text of the tapStartLabel
        statsTypeLabel.fontSize = frame.width/20
        statsTypeLabel.fontColor = SKColor.white
        statsTypeLabel.horizontalAlignmentMode = .center
        statsTypeLabel.verticalAlignmentMode = .center
        statsTypeLabel.position = CGPoint(x: statsTypeButton.position.x, y: statsTypeButton.position.y)
        statsTypeLabel.zPosition = 1
        statsTypeLabel.text = "Game History"
        addChild(statsTypeLabel)
    }
    
    func createBackgroundEmitters()
    {
        statsEmitter1 = SKEmitterNode()
        statsEmitter2 = SKEmitterNode()
        addChild(MenuHelper.shared.createTopBackgroundEmitter(frame: frame, emitter: statsEmitter1, scale: 0.15, image: SKTexture(imageNamed: "crown")))
        addChild(MenuHelper.shared.createBottomBackgroundEmitter(frame: frame, emitter: statsEmitter2, scale: 0.15, image: SKTexture(imageNamed: "crown")))
    }
    
    func handleAds()
    {
        let bannerViewStartScene = self.view?.viewWithTag(100) as! GADBannerView?
        let bannerViewGameOverScene = self.view?.viewWithTag(101) as! GADBannerView?
        let bannerViewInfoScene = self.view?.viewWithTag(102) as! GADBannerView?
        let bannerViewSettingsScene = self.view?.viewWithTag(103) as! GADBannerView?
        
        if KeychainWrapper.standard.bool(forKey: "Purchase") != true
        {
            bannerViewStartScene?.isHidden = true
            bannerViewGameOverScene?.isHidden = true
            bannerViewInfoScene?.isHidden = false
            bannerViewSettingsScene?.isHidden = true
        }
        else
        {
            bannerViewStartScene?.isHidden = true
            bannerViewGameOverScene?.isHidden = true
            bannerViewInfoScene?.isHidden = true
            bannerViewSettingsScene?.isHidden = true
        }
    }
    
    override func didMove(to view: SKView)
    {
        handleAds()
        createEdges()
        createBackToMenuButton()
        createSceneTitleSprites()
        createBackground()
        
        backButtonGameMode = SKSpriteNode(imageNamed: "GreySquare.png")
        forwardButtonGameMode = SKSpriteNode(imageNamed: "GreySquare.png")
        backButtonStatsType = SKSpriteNode(imageNamed: "GreySquare.png")
        forwardButtonStatsType = SKSpriteNode(imageNamed: "GreySquare.png")
        createArrowButtons(backButtonName: backButtonGameMode, forwardButtonName: forwardButtonGameMode, backButtonPosition: CGPoint(x: frame.width * 0.12, y: frame.height * 0.60), forwardButtonPosition: CGPoint(x: frame.width * 0.88, y: frame.height * 0.60))
        createArrowButtons(backButtonName: backButtonStatsType, forwardButtonName: forwardButtonStatsType, backButtonPosition: CGPoint(x: frame.width * 0.12, y: frame.height * 0.50), forwardButtonPosition: CGPoint(x: frame.width * 0.88, y: frame.height * 0.50))
        
        createBackgroundEmitters()
        createGameModeButton()
    }
    
    func handleGameModeArrowPress()
    {
        if arrowPressCounterGameMode == 0
        {
            gameModeLabel.text = "All Modes"
        }
        else if arrowPressCounterGameMode == 1
        {
            gameModeLabel.text = "Magnet Hockey"
        }
        else if arrowPressCounterGameMode == 2
        {
            gameModeLabel.text = "Air Hockey: 1P"
        }
        else if arrowPressCounterGameMode == 3
        {
            gameModeLabel.text = "Air Hockey: 2P"
        }
    }
    
    func handleStatsTypeArrowPress()
    {
        if arrowPressCounterStatsType == 0
        {
            statsTypeLabel.text = "Game History"
        }
        else if arrowPressCounterStatsType == 1
        {
            statsTypeLabel.text = "Stats Overview"
        }
    }
    
    override func update(_ currentTime: TimeInterval)
    {
        handleGameModeArrowPress()
        handleStatsTypeArrowPress()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touch = touches.first
        if let location = touch?.location(in: self)
        {
            let nodesArray = self.nodes(at: location)

            if nodesArray.contains(backToMenuButton)
            {
                backToMenuButton.colorBlendFactor = 0.5
                touchedMenu = true
            }
            
            else if nodesArray.contains(backButtonGameMode) && arrowPressCounterGameMode > 0
            {
                backButtonGameMode.colorBlendFactor = 0.5
                touchedBackButtonGameMode = true
            }

            else if nodesArray.contains(forwardButtonGameMode) && arrowPressCounterGameMode < 3
            {
                forwardButtonGameMode.colorBlendFactor = 0.5
                touchedForwardButtonGameMode = true
            }
            
            else if nodesArray.contains(backButtonStatsType) && arrowPressCounterStatsType > 0
            {
                backButtonStatsType.colorBlendFactor = 0.5
                touchedBackButtonStatsType = true
            }

            else if nodesArray.contains(forwardButtonStatsType) && arrowPressCounterStatsType < 1
            {
                forwardButtonStatsType.colorBlendFactor = 0.5
                touchedForwardButtonStatsType = true
            }
            
            else if nodesArray.contains(backToMenuButton)
            {
                backToMenuButton.colorBlendFactor = 0.5
                touchedMenu = true
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touch = touches.first
        
        if let location = touch?.location(in: self)
        {
            let nodesArray = self.nodes(at: location)

            if nodesArray.contains(backToMenuButton) && touchedMenu == true
            {
                if UserDefaults.standard.string(forKey: "Sound") == "On" {run(buttonSound)}
                else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                else{run(buttonSound)}
                backToMenuButton.colorBlendFactor = 0
                touchedMenu = false
                let scene = StartScene(size: (view?.bounds.size)!)
                // Configure the view.
                let skView = self.view!

                /* Sprite Kit applies additional optimizations to improve rendering performance */
                skView.ignoresSiblingOrder = true

                /* Set the scale mode to scale to fit the window */
                scene.scaleMode = .resizeFill
                let transition = SKTransition.crossFade(withDuration: 0.35)
                skView.presentScene(scene, transition: transition)
            }
            
            else if nodesArray.contains(backButtonGameMode) && touchedBackButtonGameMode == true && arrowPressCounterGameMode > 1
            {
                touchedBackButtonGameMode = false
                backButtonGameMode.colorBlendFactor = 0
                forwardButtonGameMode.colorBlendFactor = 0
                arrowPressCounterGameMode -= 1
                if UserDefaults.standard.string(forKey: "Sound") == "On" {run(buttonSound)}
                else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                else{run(buttonSound)}
            }
            
            else if nodesArray.contains(backButtonGameMode) && touchedBackButtonGameMode == true && arrowPressCounterGameMode == 1
            {
                touchedBackButtonGameMode = false
                backButtonGameMode.colorBlendFactor = 0.5
                forwardButtonGameMode.colorBlendFactor = 0
                arrowPressCounterGameMode -= 1
                if UserDefaults.standard.string(forKey: "Sound") == "On" {run(buttonSound)}
                else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                else{run(buttonSound)}
            }
            
            else if nodesArray.contains(forwardButtonGameMode) && touchedForwardButtonGameMode == true && arrowPressCounterGameMode < 2
            {
                touchedForwardButtonGameMode = false
                forwardButtonGameMode.colorBlendFactor = 0
                backButtonGameMode.colorBlendFactor = 0
                if UserDefaults.standard.string(forKey: "Sound") == "On" {run(buttonSound)}
                else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                else{run(buttonSound)}
                arrowPressCounterGameMode += 1
            }
            else if nodesArray.contains(forwardButtonGameMode) && touchedForwardButtonGameMode == true && arrowPressCounterGameMode == 2
            {
                touchedForwardButtonGameMode = false
                forwardButtonGameMode.colorBlendFactor = 0.5
                if UserDefaults.standard.string(forKey: "Sound") == "On" {run(buttonSound)}
                else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                else{run(buttonSound)}
                arrowPressCounterGameMode += 1
            }
            
            else if nodesArray.contains(backButtonStatsType) && touchedBackButtonStatsType == true && arrowPressCounterStatsType > 0
            {
                touchedBackButtonStatsType = false
                backButtonStatsType.colorBlendFactor = 0.50
                forwardButtonStatsType.colorBlendFactor = 0
                arrowPressCounterStatsType -= 1
                if UserDefaults.standard.string(forKey: "Sound") == "On" {run(buttonSound)}
                else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                else{run(buttonSound)}
            }
            
            else if nodesArray.contains(forwardButtonStatsType) && touchedForwardButtonStatsType == true && arrowPressCounterStatsType == 0
            {
                touchedForwardButtonStatsType = false
                forwardButtonStatsType.colorBlendFactor = 0.5
                backButtonStatsType.colorBlendFactor = 0
                if UserDefaults.standard.string(forKey: "Sound") == "On" {run(buttonSound)}
                else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                else{run(buttonSound)}
                arrowPressCounterStatsType += 1
            }

            else
            {
                if touchedMenu == true
                {
                    backToMenuButton.colorBlendFactor = 0
                    touchedMenu = false
                }
                if touchedBackButtonGameMode == true
                {
                    touchedBackButtonGameMode = false
                    backButtonGameMode.colorBlendFactor = 0
                }
                if touchedForwardButtonGameMode == true
                {
                    touchedForwardButtonGameMode = false
                    forwardButtonGameMode.colorBlendFactor = 0
                }
                if touchedBackButtonStatsType == true
                {
                    touchedBackButtonStatsType = false
                    backButtonStatsType.colorBlendFactor = 0
                }
                if touchedForwardButtonStatsType == true
                {
                    touchedForwardButtonStatsType = false
                    forwardButtonStatsType.colorBlendFactor = 0
                }
            }
        }
    }
}
