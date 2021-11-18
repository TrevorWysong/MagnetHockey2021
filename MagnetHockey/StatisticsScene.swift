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
    let result1Label = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    let result2Label = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    let result3Label = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    let result4Label = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    let result5Label = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    let gameModeLabel = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    let statsTypeLabel = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    let showResultsButtonLabel = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    let resultsPagesLabel = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    var showResultsButton = SKSpriteNode()
    let clearDataButtonLabel = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    var clearDataButton = SKSpriteNode()
    var backToSelectionButton = SKSpriteNode()
    var backToSelectionButtonSprite = SKSpriteNode()
    var clearDataConfirmationButton = SKSpriteNode()
    let clearDataConfirmationLabel1 = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    let clearDataConfirmationLabel2 = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    let yesClearButtonLabel = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    var yesClearDataButton = SKSpriteNode()
    let noClearDataButtonLabel = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    var noClearDataButton = SKSpriteNode()
    var blurryStatsBackground = SKSpriteNode()
    var backButtonGameMode = SKSpriteNode()
    var forwardButtonGameMode = SKSpriteNode()
    var backButtonPages = SKSpriteNode()
    var forwardButtonPages = SKSpriteNode()
    var forwardButtonSpritePages = SKSpriteNode()
    var backButtonSpritePages = SKSpriteNode()
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
    var touchedBackButtonPages = false
    var touchedForwardButtonPages = false
    var touchedMenu = false
    var touchedShowResults = false
    var touchedClearData = false
    var touchedNoButton = false
    var touchedYesButton = false
    var touchedBackToSelectionButton = false
    var clearDataModeIsActive = false
    let backToMenuButtonLabel = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    var statisticsBackgroundSprite = SKSpriteNode()
    var statisticsSprite = SKSpriteNode()
    var gameModeButton = SKSpriteNode()
    var statsTypeButton = SKSpriteNode()
    var backToMenuButton = SKSpriteNode()
    var arrowPressCounterGameMode = 0
    var arrowPressCounterStatsType = 0
    var arrowPressCounterPages = 0
    var numPages = 0
    var resultsPerPage = 5
    var numGames = 0
    var firstResultNum = 1
    var secondResultNum = 0
    var oneResultPage = false
    var currentTopScore = 0
    var currentBottomScore = 0
    var currentTopScoreOrder = 0
    var currentBottomScoreOrder = 0


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
    
    func createBackToSelectionButton()
    {
        backToSelectionButton = SKSpriteNode(imageNamed: "IcyChillCircle.png")
        backToSelectionButton.position = CGPoint(x: frame.width * 0.50, y: frame.height * 0.265)
        backToSelectionButtonSprite = SKSpriteNode(imageNamed: "curledBackArrow.png")
        backToSelectionButtonSprite.position = CGPoint(x: backToSelectionButton.position.x, y: backToSelectionButton.position.y)
        if frame.width < 500
        {
            backToSelectionButton.scale(to: CGSize(width: frame.width * 0.17, height: frame.width * 0.17))
            backToSelectionButtonSprite.scale(to: CGSize(width: frame.width * 0.11, height: frame.width * 0.11))
        }
        else
        {
            backToSelectionButton.scale(to: CGSize(width: frame.width * 0.13, height: frame.width * 0.13))
            backToSelectionButtonSprite.scale(to: CGSize(width: frame.width * 0.09, height: frame.width * 0.09))
        }
        backToSelectionButton.isHidden = true
        backToSelectionButtonSprite.isHidden = true
        backToSelectionButton.colorBlendFactor = 0
        backToSelectionButton.zPosition = 0
        addChild(backToSelectionButton)
        
        backToSelectionButtonSprite.colorBlendFactor = 0
        backToSelectionButtonSprite.zPosition = 1
        addChild(backToSelectionButtonSprite)
    }
    
    func createArrowButtons(backButtonName: SKSpriteNode, forwardButtonName: SKSpriteNode, backButtonPosition: CGPoint, forwardButtonPosition: CGPoint, backButtonSprite: SKSpriteNode, forwardButtonSprite: SKSpriteNode)
    {
        backButtonName.position = backButtonPosition
        backButtonName.scale(to: CGSize(width: frame.width * 0.13, height: frame.width * 0.13))
        backButtonName.colorBlendFactor = 0.5
        backButtonName.zPosition = 0
        addChild(backButtonName)
        
        backButtonSprite.position = CGPoint(x: backButtonName.position.x, y: backButtonName.position.y)
        backButtonSprite.scale(to: CGSize(width: frame.width * 0.08, height: frame.width * 0.08))
        backButtonSprite.colorBlendFactor = 0
        backButtonSprite.zPosition = 1
        addChild(backButtonSprite)
        
        forwardButtonName.position = forwardButtonPosition
        forwardButtonName.scale(to: CGSize(width: frame.width * 0.13, height: frame.width * 0.13))
        forwardButtonName.colorBlendFactor = 0
        forwardButtonName.zPosition = 0
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
    
    func createClearDataConfirmationButton()
    {
        clearDataConfirmationButton = SKSpriteNode(imageNamed: "RedRectangle.png")
        clearDataConfirmationButton.position = CGPoint(x: frame.width/2, y: frame.height * 0.45)
        clearDataConfirmationButton.scale(to: CGSize(width: frame.width * 0.80, height: frame.height * 0.15))
        clearDataConfirmationButton.isHidden = true
        addChild(clearDataConfirmationButton)
        
        
        // set size, color, position and text of the tapStartLabel
        clearDataConfirmationLabel1.fontSize = frame.width/18
        clearDataConfirmationLabel1.fontColor = SKColor.white
        clearDataConfirmationLabel1.horizontalAlignmentMode = .center
        clearDataConfirmationLabel1.verticalAlignmentMode = .center
        clearDataConfirmationLabel1.position = CGPoint(x: clearDataConfirmationButton.position.x, y: clearDataConfirmationButton.position.y + frame.height * 0.02)
        clearDataConfirmationLabel1.zPosition = 1
        clearDataConfirmationLabel1.text = "Are you sure you would"
        clearDataConfirmationLabel1.isHidden = true
        addChild(clearDataConfirmationLabel1)
        
        // set size, color, position and text of the tapStartLabel
        clearDataConfirmationLabel2.fontSize = frame.width/18
        clearDataConfirmationLabel2.fontColor = SKColor.white
        clearDataConfirmationLabel2.horizontalAlignmentMode = .center
        clearDataConfirmationLabel2.verticalAlignmentMode = .center
        clearDataConfirmationLabel2.position = CGPoint(x: clearDataConfirmationButton.position.x, y: clearDataConfirmationButton.position.y - frame.height * 0.02)
        clearDataConfirmationLabel2.zPosition = 1
        clearDataConfirmationLabel2.text = "like to clear all game data?"
        clearDataConfirmationLabel2.isHidden = true
        addChild(clearDataConfirmationLabel2)
        
        yesClearDataButton = SKSpriteNode(imageNamed: "IcyChillLongOval.png")
        yesClearDataButton.position = CGPoint(x: frame.width/3, y: frame.height * 0.3)
        yesClearDataButton.scale(to: CGSize(width: frame.width * 0.25, height: frame.height * 0.08))
        yesClearDataButton.isHidden = true
        addChild(yesClearDataButton)
        
        
        // set size, color, position and text of the tapStartLabel
        yesClearButtonLabel.fontSize = frame.width/20
        yesClearButtonLabel.fontColor = SKColor.white
        yesClearButtonLabel.horizontalAlignmentMode = .center
        yesClearButtonLabel.verticalAlignmentMode = .center
        yesClearButtonLabel.position = CGPoint(x: yesClearDataButton.position.x, y: yesClearDataButton.position.y)
        yesClearButtonLabel.zPosition = 1
        yesClearButtonLabel.text = "Yes"
        yesClearButtonLabel.isHidden = true
        addChild(yesClearButtonLabel)
        
        noClearDataButton = SKSpriteNode(imageNamed: "IcyChillLongOval.png")
        noClearDataButton.position = CGPoint(x: frame.width * 2/3, y: frame.height * 0.3)
        noClearDataButton.scale(to: CGSize(width: frame.width * 0.25, height: frame.height * 0.08))
        noClearDataButton.isHidden = true
        addChild(noClearDataButton)
        
        
        // set size, color, position and text of the tapStartLabel
        noClearDataButtonLabel.fontSize = frame.width/20
        noClearDataButtonLabel.fontColor = SKColor.white
        noClearDataButtonLabel.horizontalAlignmentMode = .center
        noClearDataButtonLabel.verticalAlignmentMode = .center
        noClearDataButtonLabel.position = CGPoint(x: noClearDataButton.position.x, y: noClearDataButton.position.y)
        noClearDataButtonLabel.zPosition = 1
        noClearDataButtonLabel.text = "No"
        noClearDataButtonLabel.isHidden = true
        addChild(noClearDataButtonLabel)
    }
    
    func createBackgroundEmitters()
    {
        statsEmitter1 = SKEmitterNode()
        statsEmitter2 = SKEmitterNode()
        addChild(MenuHelper.shared.createTopBackgroundEmitter(frame: frame, emitter: statsEmitter1, scale: 0.15, image: SKTexture(imageNamed: "crown")))
        addChild(MenuHelper.shared.createBottomBackgroundEmitter(frame: frame, emitter: statsEmitter2, scale: 0.15, image: SKTexture(imageNamed: "crown")))
    }
    
    func createBlurryStatsBackground()
    {
        blurryStatsBackground = SKSpriteNode(imageNamed: "blurryWhiteBackground.png")
        blurryStatsBackground.position = CGPoint(x: frame.width/2, y: frame.height * 0.56)
        blurryStatsBackground.scale(to: CGSize(width: frame.width * 0.85, height: frame.height * 0.625))
        blurryStatsBackground.colorBlendFactor = 0.25
        blurryStatsBackground.isHidden = true
        blurryStatsBackground.zPosition = -1
        addChild(blurryStatsBackground)
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
        clearDataConfirmationButton.isHidden = false
        clearDataConfirmationLabel1.isHidden = false
        clearDataConfirmationLabel2.isHidden = false
        yesClearDataButton.isHidden = false
        yesClearButtonLabel.isHidden = false
        noClearDataButton.isHidden = false
        noClearDataButtonLabel.isHidden = false
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
    
    func UIBehaviorAfterRespondingToClearDataPrompt()
    {
        clearDataModeIsActive = false
        clearDataConfirmationButton.isHidden = true
        clearDataConfirmationLabel1.isHidden = true
        clearDataConfirmationLabel2.isHidden = true
        yesClearDataButton.isHidden = true
        yesClearButtonLabel.isHidden = true
        noClearDataButton.isHidden = true
        noClearDataButtonLabel.isHidden = true
        backToSelectionButton.isHidden = true
        backToSelectionButtonSprite.isHidden = true

        clearDataButton.colorBlendFactor = 0
        
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
        blurryStatsBackground.isHidden = true
        backToSelectionButton.isHidden = true
        backToSelectionButtonSprite.isHidden = true
        backButtonPages.isHidden = true
        forwardButtonPages.isHidden = true
        backButtonSpritePages.isHidden = true
        forwardButtonSpritePages.isHidden = true
        resultsPagesLabel.isHidden = true
        numPages = 0
        numGames = 0
        firstResultNum = 1
        secondResultNum = 2
        arrowPressCounterPages = 0
        oneResultPage = false
        result1Label.isHidden = true
        result2Label.isHidden = true
        result3Label.isHidden = true
        result4Label.isHidden = true
        result5Label.isHidden = true
        result1Label.text = ""
        result2Label.text = ""
        result3Label.text = ""
        result4Label.text = ""
        result5Label.text = ""
//        currentTopScore = 0
//        currentBottomScore = 0
//        currentTopScoreOrder = 0
//        currentBottomScoreOrder = 0
        
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
        getResults()
        blurryStatsBackground.isHidden = false
        backToSelectionButton.isHidden = false
        backToSelectionButtonSprite.isHidden = false
        backButtonPages.isHidden = false
        forwardButtonPages.isHidden = false
        backButtonSpritePages.isHidden = false
        forwardButtonSpritePages.isHidden = false
        resultsPagesLabel.isHidden = false
        backButtonSpritePages.colorBlendFactor = 0
        forwardButtonSpritePages.colorBlendFactor = 0
        
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
        result1Label.isHidden = false
        result2Label.isHidden = false
        result3Label.isHidden = false
        result4Label.isHidden = false
        result5Label.isHidden = false
        
        statisticsBackgroundSprite.position = CGPoint(x: frame.width * 0.50, y: frame.height * 0.88)
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
        
        if numGames <= 5
        {
            resultsPagesLabel.text = String(firstResultNum) + " to " + String(numGames)
            forwardButtonPages.colorBlendFactor = 0.5
            secondResultNum = numGames
            oneResultPage = true
        }
        else
        {
            firstResultNum = 1
            secondResultNum = 5
            resultsPagesLabel.text = String(firstResultNum) + " to " + String(secondResultNum)
            forwardButtonPages.colorBlendFactor = 0
        }
        showPageResults(game: gameModeLabel.text!)

    }
    
    func createPagesLabel()
    {
        // set size, color, position and text of the tapStartLabel
        resultsPagesLabel.fontSize = frame.width/18
        resultsPagesLabel.fontColor = SKColor.white
        resultsPagesLabel.horizontalAlignmentMode = .center
        resultsPagesLabel.verticalAlignmentMode = .center
        resultsPagesLabel.position = CGPoint(x: frame.width * 0.5, y: backToSelectionButton.position.y + (frame.height * 0.07))
        resultsPagesLabel.zPosition = 1
        resultsPagesLabel.text = "1 to 5"
        resultsPagesLabel.isHidden = true
        addChild(resultsPagesLabel)
    }
    
    func createLabel(labelName: SKLabelNode, text: String, position: CGPoint)
    {
        // set size, color, position and text of the tapStartLabel
        labelName.fontSize = frame.width/24
        labelName.fontColor = SKColor.black
        labelName.horizontalAlignmentMode = .center
        labelName.verticalAlignmentMode = .center
        labelName.position = position
        labelName.zPosition = 1
        labelName.text = text
        labelName.isHidden = true
        addChild(labelName)
    }
    
    func getResults()
    {
        if gameModeLabel.text == "Magnet Hockey"
        {
            DBHelper.shared.magnetHockeyArr.removeAll()
            DBHelper.shared.listGames(game: "MagnetHockey")
            print(DBHelper.shared.magnetHockeyArr)
            getNumPages(arrayCount: DBHelper.shared.magnetHockeyArr.count)
            numGames = DBHelper.shared.magnetHockeyArr.count
        }
    
        
        //for goal/magnet order:
        //consider binary int to get order of goal and magnet goals...
        //concatenate to string and then cast to int before inserting to db
        //for ex. int: 10111 % 2 != 0, then divide by 10 and take floor..
        // ... 10 mod 10 = 0, therefore other..
        
        // pages algorithm:
        // get length of arr (.count)
        // len % (desired number of games per page)
        // ex. 43 games with 5 games displayed per page should have 9 pages
        // 43 / 8 = 5.3xx.. take floor of division and then + 1 ***if*** len % games per page != 0
        
    }
    
    func showPageResults(game: String)
    {
        if game == "Magnet Hockey"
        {
            if DBHelper.shared.magnetHockeyArr.count != 0
            {
                //show firstResultNum to secondResultNum games
                for i in firstResultNum - 1...secondResultNum - 1
                {
                    currentTopScore = DBHelper.shared.magnetHockeyArr[i][0]
                    currentBottomScore = DBHelper.shared.magnetHockeyArr[i][1]
                    currentTopScoreOrder = DBHelper.shared.magnetHockeyArr[i][2]
                    currentBottomScoreOrder =  DBHelper.shared.magnetHockeyArr[i][3]
                    if i == firstResultNum - 1
                    {
                        result1Label.text = "Top Score   " + String(currentTopScore) + " - " + String(currentBottomScore) + "   Bottom Score"
                        result1Label.isHidden = false
                    }
                    else if i == firstResultNum
                    {
                        result2Label.text = "Top Score   " + String(currentTopScore) + " - " + String(currentBottomScore) + "   Bottom Score"
                        result2Label.isHidden = false
                    }
                }
            }
        }
        else if game == "AirHockey1P"
        {
            
        }
        else if game == "AirHockey2P"
        {
            
        }
        else
        {
            //All results
            
        }
    }
    
    func getNumPages(arrayCount: Int)
    {
        if arrayCount > 0
        {
            if arrayCount % resultsPerPage == 0
            {
                numPages = arrayCount / resultsPerPage
            }
            else
            {
                numPages = Int(floor(Double(arrayCount / resultsPerPage)) + 1)
            }
        }
    }
    
    func createResultLabels()
    {
        createLabel(labelName: result1Label, text: "", position: CGPoint(x: frame.height * 0.275, y: frame.height * 0.75))
        createLabel(labelName: result2Label, text: "", position: CGPoint(x: frame.height * 0.275, y: frame.height * 0.65))
    }
    
    override func didMove(to view: SKView)
    {
        handleAds()
        createEdges()
        createBackToMenuButton()
        createShowResultsButton()
        createClearDataButton()
        createClearDataConfirmationButton()
        createSceneTitleSprites()
        createBackground()
        createBlurryStatsBackground()
        createBackToSelectionButton()
        createPagesLabel()
        createResultLabels()
        DBHelper.shared.createDatabase()
        
        backButtonGameMode = SKSpriteNode(imageNamed: "GreySquare.png")
        forwardButtonGameMode = SKSpriteNode(imageNamed: "GreySquare.png")
        backButtonPages = SKSpriteNode(imageNamed: "IcyChillRoundedSquare.png")
        forwardButtonPages = SKSpriteNode(imageNamed: "IcyChillRoundedSquare.png")
        backButtonStatsType = SKSpriteNode(imageNamed: "GreySquare.png")
        forwardButtonStatsType = SKSpriteNode(imageNamed: "GreySquare.png")
        backButtonSpriteGameMode = SKSpriteNode(imageNamed: "arrowLeft.png")
        backButtonSpriteStatsType = SKSpriteNode(imageNamed: "arrowLeft.png")
        forwardButtonSpriteGameMode = SKSpriteNode(imageNamed: "arrowRight.png")
        forwardButtonSpriteStatsType = SKSpriteNode(imageNamed: "arrowRight.png")
        backButtonSpritePages = SKSpriteNode(imageNamed: "arrowLeft.png")
        forwardButtonSpritePages = SKSpriteNode(imageNamed: "arrowRight.png")
        backButtonPages.isHidden = true
        forwardButtonPages.isHidden = true
        backButtonSpritePages.isHidden = true
        forwardButtonSpritePages.isHidden = true
        


        createArrowButtons(backButtonName: backButtonGameMode, forwardButtonName: forwardButtonGameMode, backButtonPosition: CGPoint(x: frame.width * 0.12, y: frame.height * 0.50), forwardButtonPosition: CGPoint(x: frame.width * 0.88, y: frame.height * 0.50), backButtonSprite: backButtonSpriteGameMode, forwardButtonSprite: forwardButtonSpriteGameMode)
        createArrowButtons(backButtonName: backButtonStatsType, forwardButtonName: forwardButtonStatsType, backButtonPosition: CGPoint(x: frame.width * 0.12, y: frame.height * 0.40), forwardButtonPosition: CGPoint(x: frame.width * 0.88, y: frame.height * 0.40), backButtonSprite: backButtonSpriteStatsType, forwardButtonSprite: forwardButtonSpriteStatsType)
        
        createArrowButtons(backButtonName: backButtonPages, forwardButtonName: forwardButtonPages, backButtonPosition: CGPoint(x: frame.width * 0.30, y: frame.height * 0.25), forwardButtonPosition: CGPoint(x: frame.width * 0.70, y: frame.height * 0.25), backButtonSprite: backButtonSpritePages, forwardButtonSprite: forwardButtonSpritePages)
        
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
            else if nodesArray.contains(yesClearDataButton)
            {
                yesClearDataButton.colorBlendFactor = 0.5
                touchedYesButton = true
            }
            else if nodesArray.contains(noClearDataButton)
            {
                noClearDataButton.colorBlendFactor = 0.5
                touchedNoButton = true
            }
            else if nodesArray.contains(backToSelectionButton)
            {
                backToSelectionButton.colorBlendFactor = 0.5
                touchedBackToSelectionButton = true
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
            
            else if nodesArray.contains(backButtonPages) && arrowPressCounterPages > 0
            {
                backButtonPages.colorBlendFactor = 0.5
                touchedBackButtonPages = true
            }

            else if nodesArray.contains(forwardButtonPages) && arrowPressCounterPages + 1 < numPages && oneResultPage != true
            {
                forwardButtonPages.colorBlendFactor = 0.5
                touchedForwardButtonPages = true
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
            
            else if nodesArray.contains(yesClearDataButton) && touchedYesButton == true
            {
                if UserDefaults.standard.string(forKey: "Sound") == "On" {run(buttonSound)}
                else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                else{run(buttonSound)}
                yesClearDataButton.colorBlendFactor = 0
                touchedYesButton = false
                DBHelper.shared.deleteTables()
                UIBehaviorAfterRespondingToClearDataPrompt()
            }
            
            else if nodesArray.contains(noClearDataButton) && touchedNoButton == true
            {
                if UserDefaults.standard.string(forKey: "Sound") == "On" {run(buttonSound)}
                else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                else{run(buttonSound)}
                noClearDataButton.colorBlendFactor = 0
                touchedNoButton = false
                UIBehaviorAfterRespondingToClearDataPrompt()
            }
            
            else if nodesArray.contains(backToSelectionButton) && touchedBackToSelectionButton == true
            {
                if UserDefaults.standard.string(forKey: "Sound") == "On" {run(buttonSound)}
                else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                else{run(buttonSound)}
                backToSelectionButton.colorBlendFactor = 0
                touchedBackToSelectionButton = false
                UIBehaviorBeforeShowingResult()
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
            
            else if nodesArray.contains(backButtonPages) && touchedBackButtonPages == true && arrowPressCounterPages > 0
            {
                touchedBackButtonPages = false
                backButtonPages.colorBlendFactor = 0.50
                forwardButtonPages.colorBlendFactor = 0
                arrowPressCounterPages -= 1
                if UserDefaults.standard.string(forKey: "Sound") == "On" {run(buttonSound)}
                else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                else{run(buttonSound)}
                print(arrowPressCounterPages)
                print(numPages)
                if (arrowPressCounterPages == 0)
                {
                    backButtonPages.colorBlendFactor = 0.5
                    firstResultNum = 1
                    secondResultNum = 5
                    resultsPagesLabel.text = String(firstResultNum) + " to " + String(secondResultNum)
                    showPageResults(game: gameModeLabel.text!)
                }
                else
                {
                    backButtonPages.colorBlendFactor = 0
                    let tempFirstNum = firstResultNum
                    if secondResultNum % resultsPerPage != 0
                    {
                        secondResultNum = (tempFirstNum + 4) - 5
                        firstResultNum -= 5
                    }
                    else
                    {
                        firstResultNum -= 5
                        secondResultNum -= 5
                    }
                    resultsPagesLabel.text = String(firstResultNum) + " to " + String(secondResultNum)
                    showPageResults(game: gameModeLabel.text!)
                }
            }
            
            else if nodesArray.contains(forwardButtonPages) && touchedForwardButtonPages == true
            {
                touchedForwardButtonPages = false
                backButtonPages.colorBlendFactor = 0
                if UserDefaults.standard.string(forKey: "Sound") == "On" {run(buttonSound)}
                else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                else{run(buttonSound)}
                arrowPressCounterPages += 1
                if (arrowPressCounterPages + 1 == numPages) && (oneResultPage != true)
                {
                    forwardButtonPages.colorBlendFactor = 0.5
                    firstResultNum += 5
                    secondResultNum = numGames
                    resultsPagesLabel.text = String(firstResultNum) + " to " + String(secondResultNum)
                    showPageResults(game: gameModeLabel.text!)
                }
                else
                {
                    forwardButtonPages.colorBlendFactor = 0
                    firstResultNum += 5
                    secondResultNum += 5
                    resultsPagesLabel.text = String(firstResultNum) + " to " + String(secondResultNum)
                    showPageResults(game: gameModeLabel.text!)
                }
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
                if touchedYesButton == true
                {
                    yesClearDataButton.colorBlendFactor = 0
                    touchedYesButton = false
                }
                if touchedNoButton == true
                {
                    noClearDataButton.colorBlendFactor = 0
                    touchedNoButton = false
                }
                if touchedBackToSelectionButton == true
                {
                    backToSelectionButton.colorBlendFactor = 0
                    touchedBackToSelectionButton = false
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
                if touchedBackButtonPages == true
                {
                    touchedBackButtonPages = false
                    backButtonPages.colorBlendFactor = 0
                }
                if touchedForwardButtonPages == true
                {
                    touchedForwardButtonPages = false
                    forwardButtonPages.colorBlendFactor = 0
                }
            }
        }
    }
}
