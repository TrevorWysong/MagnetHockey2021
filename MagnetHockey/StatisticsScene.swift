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
    let showResultsButtonLabel = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    var showResultsButton = SKSpriteNode()
    let clearDataButtonLabel = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    var clearDataButton = SKSpriteNode()
    var backButtonGameMode = SKSpriteNode()
    var forwardButtonGameMode = SKSpriteNode()
    var backButtonStatsType = SKSpriteNode()
    var forwardButtonStatsType = SKSpriteNode()
    var backButtonSpriteGameMode = SKSpriteNode()
    var backButtonSpriteStatsType = SKSpriteNode()
    var forwardButtonSpriteGameMode = SKSpriteNode()
    var forwardButtonSpriteStatsType = SKSpriteNode()
    var touchedBackButtonGameMode = false
    var touchedForwardButtonGameMode = false
    var touchedBackButtonStatsType = false
    var touchedForwardButtonStatsType = false
    var touchedMenu = false
    var touchedShowResults = false
    var touchedClearData = false
    var clearDataModeIsActive = false
    let backToMenuButtonLabel = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    var statisticsBackgroundSprite = SKSpriteNode()
    var statisticsSprite = SKSpriteNode()
    var gameModeButton = SKSpriteNode()
    var statsTypeButton = SKSpriteNode()
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
    
    func createArrowButtons(backButtonName: SKSpriteNode, forwardButtonName: SKSpriteNode, backButtonPosition: CGPoint, forwardButtonPosition: CGPoint, backButtonSprite: SKSpriteNode, forwardButtonSprite: SKSpriteNode)
    {
        backButtonName.position = backButtonPosition
        backButtonName.scale(to: CGSize(width: frame.width * 0.13, height: frame.width * 0.13))
        backButtonName.colorBlendFactor = 0.5
        addChild(backButtonName)
        
        backButtonSprite.position = CGPoint(x: backButtonName.position.x, y: backButtonName.position.y)
        backButtonSprite.scale(to: CGSize(width: frame.width * 0.08, height: frame.width * 0.08))
        backButtonSprite.colorBlendFactor = 0
        backButtonSprite.zPosition = 1
        addChild(backButtonSprite)
        
        forwardButtonName.position = forwardButtonPosition
        forwardButtonName.scale(to: CGSize(width: frame.width * 0.13, height: frame.width * 0.13))
        forwardButtonName.colorBlendFactor = 0
        addChild(forwardButtonName)
        
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
        gameModeButton = SKSpriteNode(imageNamed: "IcyChillRoundedRectangle.png")
        gameModeButton.position = CGPoint(x: frame.width/2, y: frame.height * 0.50)
        gameModeButton.scale(to: CGSize(width: frame.width * 0.615, height: frame.height * 0.09))
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
        
        statsTypeButton = SKSpriteNode(imageNamed: "IcyChillRoundedRectangle.png")
        statsTypeButton.position = CGPoint(x: frame.width/2, y: frame.height * 0.40)
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
    
    func createShowResultsButton()
    {
        showResultsButton = SKSpriteNode(imageNamed: "IcyChillLongOval.png")
        showResultsButton.position = CGPoint(x: frame.width/2, y: frame.height * 0.28)
        showResultsButton.scale(to: CGSize(width: frame.width * 0.545, height: frame.height * 0.08))
        showResultsButton.colorBlendFactor = 0
        addChild(showResultsButton)
        
        // set size, color, position and text of the tapStartLabel
        showResultsButtonLabel.fontSize = frame.width/17.5
        showResultsButtonLabel.fontColor = SKColor.white
        showResultsButtonLabel.horizontalAlignmentMode = .center
        showResultsButtonLabel.verticalAlignmentMode = .center
        showResultsButtonLabel.position = CGPoint(x: showResultsButton.position.x, y: showResultsButton.position.y)
        showResultsButtonLabel.zPosition = 1
        showResultsButtonLabel.text = "Show Results"
        addChild(showResultsButtonLabel)
    }
    
    func createClearDataButton()
    {
        clearDataButton = SKSpriteNode(imageNamed: "redRoundedOval.png")
        clearDataButton.position = CGPoint(x: frame.width/2, y: frame.height * 0.62)
        clearDataButton.scale(to: CGSize(width: frame.width * 0.45, height: frame.height * 0.08))
        clearDataButton.colorBlendFactor = 0
        addChild(clearDataButton)
        
        // set size, color, position and text of the tapStartLabel
        clearDataButtonLabel.fontSize = frame.width/17.5
        clearDataButtonLabel.fontColor = SKColor.white
        clearDataButtonLabel.horizontalAlignmentMode = .center
        clearDataButtonLabel.verticalAlignmentMode = .center
        clearDataButtonLabel.position = CGPoint(x: clearDataButton.position.x, y: clearDataButton.position.y)
        clearDataButtonLabel.zPosition = 1
        clearDataButtonLabel.text = "Clear Data"
        addChild(clearDataButtonLabel)
    }
    
    func UIBehaviorAfterPressingClearData()
    {
        clearDataModeIsActive = true
        clearDataButton.colorBlendFactor = 0.5
        
        gameModeButton.isHidden = true
        gameModeLabel.isHidden = true
        statsTypeButton.isHidden = true
        statsTypeLabel.isHidden = true
        showResultsButton.isHidden = true
        showResultsButtonLabel.isHidden = true
        backButtonStatsType.isHidden = true
        backButtonGameMode.isHidden = true
        forwardButtonStatsType.isHidden = true
        forwardButtonGameMode.isHidden = true
        backButtonSpriteGameMode.isHidden = true
        backButtonSpriteStatsType.isHidden = true
        forwardButtonSpriteGameMode.isHidden = true
        forwardButtonSpriteStatsType.isHidden = true
    }
    
    func UIBehaviorBeforeShowingResult()
    {
        clearDataButton.isHidden = false
        clearDataButtonLabel.isHidden = false
        gameModeButton.isHidden = false
        gameModeLabel.isHidden = false
        statsTypeButton.isHidden = false
        statsTypeLabel.isHidden = false
        showResultsButton.isHidden = false
        showResultsButtonLabel.isHidden = false
        backButtonStatsType.isHidden = false
        backButtonGameMode.isHidden = false
        forwardButtonStatsType.isHidden = false
        forwardButtonGameMode.isHidden = false
        backButtonSpriteGameMode.isHidden = false
        backButtonSpriteStatsType.isHidden = false
        forwardButtonSpriteGameMode.isHidden = false
        forwardButtonSpriteStatsType.isHidden = false
        
        statisticsBackgroundSprite.position = CGPoint(x: frame.width * 0.50, y: frame.height * 0.80)
        statisticsSprite.position = CGPoint(x: statisticsBackgroundSprite.position.x, y: statisticsBackgroundSprite.position.y)
        if frame.width < 500
        {
            statisticsBackgroundSprite.scale(to: CGSize(width: frame.width * 0.33, height: frame.width * 0.33))
            statisticsSprite.scale(to: CGSize(width: frame.width * 0.24, height: frame.width * 0.24))
        }
        else
        {
            statisticsBackgroundSprite.scale(to: CGSize(width: frame.width * 0.25, height: frame.width * 0.25))
            statisticsSprite.scale(to: CGSize(width: frame.width * 0.18, height: frame.width * 0.18))
        }
    }
    
    func UIBehaviorAfterShowingResult()
    {
        clearDataButton.isHidden = true
        clearDataButtonLabel.isHidden = true
        gameModeButton.isHidden = true
        gameModeLabel.isHidden = true
        statsTypeButton.isHidden = true
        statsTypeLabel.isHidden = true
        showResultsButton.isHidden = true
        showResultsButtonLabel.isHidden = true
        backButtonStatsType.isHidden = true
        backButtonGameMode.isHidden = true
        forwardButtonStatsType.isHidden = true
        forwardButtonGameMode.isHidden = true
        backButtonSpriteGameMode.isHidden = true
        backButtonSpriteStatsType.isHidden = true
        forwardButtonSpriteGameMode.isHidden = true
        forwardButtonSpriteStatsType.isHidden = true
        
        statisticsBackgroundSprite.position = CGPoint(x: frame.width * 0.50, y: frame.height * 0.90)
        statisticsSprite.position = CGPoint(x: statisticsBackgroundSprite.position.x, y: statisticsBackgroundSprite.position.y)
        if frame.width < 500
        {
            statisticsBackgroundSprite.scale(to: CGSize(width: frame.width * 0.25, height: frame.width * 0.25))
            statisticsSprite.scale(to: CGSize(width: frame.width * 0.18, height: frame.width * 0.18))
        }
        else
        {
            statisticsBackgroundSprite.scale(to: CGSize(width: frame.width * 0.18, height: frame.width * 0.18))
            statisticsSprite.scale(to: CGSize(width: frame.width * 0.13, height: frame.width * 0.13))
        }
    }
    
    override func didMove(to view: SKView)
    {
        handleAds()
        createEdges()
        createBackToMenuButton()
        createShowResultsButton()
        createClearDataButton()
        createSceneTitleSprites()
        createBackground()
        
        backButtonGameMode = SKSpriteNode(imageNamed: "GreySquare.png")
        forwardButtonGameMode = SKSpriteNode(imageNamed: "GreySquare.png")
        backButtonStatsType = SKSpriteNode(imageNamed: "GreySquare.png")
        forwardButtonStatsType = SKSpriteNode(imageNamed: "GreySquare.png")
        backButtonSpriteGameMode = SKSpriteNode(imageNamed: "arrowLeft.png")
        backButtonSpriteStatsType = SKSpriteNode(imageNamed: "arrowLeft.png")
        forwardButtonSpriteGameMode = SKSpriteNode(imageNamed: "arrowRight.png")
        forwardButtonSpriteStatsType = SKSpriteNode(imageNamed: "arrowRight.png")


        createArrowButtons(backButtonName: backButtonGameMode, forwardButtonName: forwardButtonGameMode, backButtonPosition: CGPoint(x: frame.width * 0.12, y: frame.height * 0.50), forwardButtonPosition: CGPoint(x: frame.width * 0.88, y: frame.height * 0.50), backButtonSprite: backButtonSpriteGameMode, forwardButtonSprite: forwardButtonSpriteGameMode)
        createArrowButtons(backButtonName: backButtonStatsType, forwardButtonName: forwardButtonStatsType, backButtonPosition: CGPoint(x: frame.width * 0.12, y: frame.height * 0.40), forwardButtonPosition: CGPoint(x: frame.width * 0.88, y: frame.height * 0.40), backButtonSprite: backButtonSpriteStatsType, forwardButtonSprite: forwardButtonSpriteStatsType)
        
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
            else if nodesArray.contains(showResultsButton)
            {
                showResultsButton.colorBlendFactor = 0.5
                touchedShowResults = true
            }
            else if nodesArray.contains(clearDataButton) && clearDataModeIsActive == false
            {
                clearDataButton.colorBlendFactor = 0.5
                touchedClearData = true
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
            
            else if nodesArray.contains(showResultsButton) && touchedShowResults == true
            {
                if UserDefaults.standard.string(forKey: "Sound") == "On" {run(buttonSound)}
                else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                else{run(buttonSound)}
                showResultsButton.colorBlendFactor = 0
                touchedShowResults = false
                UIBehaviorAfterShowingResult()
            }
            
            else if nodesArray.contains(clearDataButton) && touchedClearData == true && clearDataModeIsActive == false
            {
                if UserDefaults.standard.string(forKey: "Sound") == "On" {run(buttonSound)}
                else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                else{run(buttonSound)}
                clearDataButton.colorBlendFactor = 0
                touchedClearData = false
                UIBehaviorAfterPressingClearData()
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
                if touchedShowResults == true
                {
                    showResultsButton.colorBlendFactor = 0
                    touchedShowResults = false
                }
                if touchedClearData == true
                {
                    clearDataButton.colorBlendFactor = 0
                    touchedClearData = false
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
