//
//  InfoScene.swift
//  MagnetHockey
//
//  Created by Wysong, Trevor on 10/16/20.
//  Copyright © 2020 Wysong, Trevor. All rights reserved.
//

import SpriteKit
import GoogleMobileAds

class InfoScene: SKScene
{
    // you can use another font for the label if you want...
    let descriptionLabel = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    let descriptionLabel2 = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    let descriptionLabel3 = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    let roundsButtonLabel = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    let buttonSound = SKAction.playSoundFileNamed("ChangeRounds.mp3", waitForCompletion: false)
    var infoEmitter1:SKEmitterNode!
    var infoEmitter2:SKEmitterNode!
    var backButton = SKSpriteNode()
    var forwardButton = SKSpriteNode()
    var pageDotOne = SKSpriteNode()
    var pageDotTwo = SKSpriteNode()
    var pageDotThree = SKSpriteNode()
    var pageDotFour = SKSpriteNode()
    var pageDotFive = SKSpriteNode()
    var touchedBackButton = false
    var touchedForwardButton = false
    var touchedMenu = false
    let backToMenuButtonLabel = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    var backToMenuButton = SKSpriteNode()
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
        
        if UserDefaults.standard.bool(forKey: "Purchase") != true
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
        
        createEdges()
        backToMenuButton = SKSpriteNode(imageNamed: "IcyChillRectangle.png")
        backToMenuButton.position = CGPoint(x: frame.width/2, y: frame.height * 0.175)
        backToMenuButton.scale(to: CGSize(width: frame.width * 0.60, height: frame.height * 0.1))
        addChild(backToMenuButton)
        
        let infoBackgroundSprite:SKSpriteNode!
        infoBackgroundSprite = SKSpriteNode(imageNamed: "RedCircle.png")
        infoBackgroundSprite.position = CGPoint(x: frame.width * 0.50, y: frame.height * 0.80)
        if frame.width < 500
        {
            infoBackgroundSprite.scale(to: CGSize(width: frame.width * 0.33, height: frame.width * 0.33))
        }
        else
        {
            infoBackgroundSprite.scale(to: CGSize(width: frame.width * 0.25, height: frame.width * 0.25))
        }
        infoBackgroundSprite.colorBlendFactor = 0
        infoBackgroundSprite.zPosition = 0
        addChild(infoBackgroundSprite)
        
        let infoSprite:SKSpriteNode!
        infoSprite = SKSpriteNode(imageNamed: "vector_info.png")
        infoSprite.position = CGPoint(x: infoBackgroundSprite.position.x, y: infoBackgroundSprite.position.y)
        if frame.width < 500
        {
            infoSprite.scale(to: CGSize(width: frame.width * 0.20, height: frame.width * 0.20))
        }
        else
        {
            infoSprite.scale(to: CGSize(width: frame.width * 0.15, height: frame.width * 0.15))
        }
        infoSprite.colorBlendFactor = 0
        infoSprite.zPosition = 1
        addChild(infoSprite)
        
        // set size, color, position and text of the tapStartLabel
        backToMenuButtonLabel.fontSize = frame.width/17.5
        backToMenuButtonLabel.fontColor = SKColor.white
        backToMenuButtonLabel.horizontalAlignmentMode = .center
        backToMenuButtonLabel.verticalAlignmentMode = .center
        backToMenuButtonLabel.position = CGPoint(x: backToMenuButton.position.x, y: backToMenuButton.position.y)
        backToMenuButtonLabel.zPosition = 1
        backToMenuButtonLabel.text = "Back to Menu"
        addChild(backToMenuButtonLabel)
        
        let descriptionSprite:SKSpriteNode!
        descriptionSprite = SKSpriteNode(imageNamed: "IcyChillRectangle.png")
        descriptionSprite.position = CGPoint(x: frame.width * 0.50, y: frame.height * 0.55)
        descriptionSprite.scale(to: CGSize(width: frame.width * 0.80, height: frame.width * 0.3))
        descriptionSprite.colorBlendFactor = 0
        descriptionSprite.zPosition = -1
        addChild(descriptionSprite)
        
        // set size, color, position and text of the tapStartLabel
        descriptionLabel.fontSize = frame.width * 0.06
        descriptionLabel.fontColor = SKColor.white
        descriptionLabel.horizontalAlignmentMode = .center
        descriptionLabel.verticalAlignmentMode = .center
        descriptionLabel.position = CGPoint(x: frame.width * 0.5, y: frame.height * 0.575)
        descriptionLabel.zPosition = 1
        descriptionLabel.text = "Magnet Hockey is"
        addChild(descriptionLabel)
        
        // set size, color, position and text of the tapStartLabel
        descriptionLabel2.fontSize = frame.width * 0.06
        descriptionLabel2.fontColor = SKColor.white
        descriptionLabel2.horizontalAlignmentMode = .center
        descriptionLabel2.verticalAlignmentMode = .center
        descriptionLabel2.position = CGPoint(x: frame.width * 0.5, y: frame.height * 0.53)
        descriptionLabel2.zPosition = 1
        descriptionLabel2.text = "a two-player game."
        addChild(descriptionLabel2)
        
        // set size, color, position and text of the tapStartLabel
        descriptionLabel3.fontSize = frame.width * 0.06
        descriptionLabel3.fontColor = SKColor.white
        descriptionLabel3.horizontalAlignmentMode = .center
        descriptionLabel3.verticalAlignmentMode = .center
        descriptionLabel3.position = CGPoint(x: frame.width * 0.5, y: frame.height * 0.53)
        descriptionLabel3.zPosition = 1
        descriptionLabel3.text = ""
        addChild(descriptionLabel3)
        
        let background = SKSpriteNode(imageNamed: "icyBackground3.jpg")
        background.blendMode = .replace
        background.position = CGPoint(x: frame.width/2, y: frame.height/2)
        background.scale(to: CGSize(width: frame.width, height: frame.height))
        background.colorBlendFactor = 0
        background.zPosition = -100
        addChild(background)
        
        backButton = SKSpriteNode(imageNamed: "GreySquare.png")
        backButton.position = CGPoint(x: frame.width * 0.4, y: frame.height * 0.325)
        backButton.scale(to: CGSize(width: frame.width * 0.13, height: frame.width * 0.13))
        backButton.colorBlendFactor = 0.5
        addChild(backButton)
        
        let backButtonSprite:SKSpriteNode!
        backButtonSprite = SKSpriteNode(imageNamed: "arrowLeft.png")
        backButtonSprite.position = CGPoint(x: backButton.position.x, y: backButton.position.y)
        backButtonSprite.scale(to: CGSize(width: frame.width * 0.08, height: frame.width * 0.08))
        backButtonSprite.colorBlendFactor = 0
        backButtonSprite.zPosition = 1
        addChild(backButtonSprite)
        
        forwardButton = SKSpriteNode(imageNamed: "GreySquare.png")
        forwardButton.position = CGPoint(x: frame.width * 0.6, y: frame.height * 0.325)
        forwardButton.scale(to: CGSize(width: frame.width * 0.13, height: frame.width * 0.13))
        forwardButton.colorBlendFactor = 0
        addChild(forwardButton)
        
        let forwardButtonSprite:SKSpriteNode!
        forwardButtonSprite = SKSpriteNode(imageNamed: "arrowRight.png")
        forwardButtonSprite.position = CGPoint(x: forwardButton.position.x, y: forwardButton.position.y)
        forwardButtonSprite.scale(to: CGSize(width: frame.width * 0.08, height: frame.width * 0.08))
        forwardButtonSprite.colorBlendFactor = 0
        forwardButtonSprite.zPosition = 1
        addChild(forwardButtonSprite)
        
        pageDotOne = SKSpriteNode(imageNamed: "whiteDot.png")
        pageDotOne.position = CGPoint(x: frame.width * 0.40, y: frame.height * 0.425)
        pageDotOne.scale(to: CGSize(width: frame.width * 0.025, height: frame.width * 0.025))
        pageDotOne.colorBlendFactor = 0
        addChild(pageDotOne)
        
        pageDotTwo = SKSpriteNode(imageNamed: "whiteDot.png")
        pageDotTwo.position = CGPoint(x: frame.width * 0.45, y: frame.height * 0.425)
        pageDotTwo.scale(to: CGSize(width: frame.width * 0.025, height: frame.width * 0.025))
        pageDotTwo.colorBlendFactor = 0.75
        addChild(pageDotTwo)
        
        pageDotThree = SKSpriteNode(imageNamed: "whiteDot.png")
        pageDotThree.position = CGPoint(x: frame.width * 0.50, y: frame.height * 0.425)
        pageDotThree.scale(to: CGSize(width: frame.width * 0.025, height: frame.width * 0.025))
        pageDotThree.colorBlendFactor = 0.75
        addChild(pageDotThree)
        
        pageDotFour = SKSpriteNode(imageNamed: "whiteDot.png")
        pageDotFour.position = CGPoint(x: frame.width * 0.55, y: frame.height * 0.425)
        pageDotFour.scale(to: CGSize(width: frame.width * 0.025, height: frame.width * 0.025))
        pageDotFour.colorBlendFactor = 0.75
        addChild(pageDotFour)
        
        pageDotFive = SKSpriteNode(imageNamed: "whiteDot.png")
        pageDotFive.position = CGPoint(x: frame.width * 0.60, y: frame.height * 0.425)
        pageDotFive.scale(to: CGSize(width: frame.width * 0.025, height: frame.width * 0.025))
        pageDotFive.colorBlendFactor = 0.75
        addChild(pageDotFive)

        infoEmitter1 = SKEmitterNode()
        infoEmitter1.particleTexture = SKTexture(imageNamed: "vector_info.png")
        infoEmitter1.particlePositionRange = CGVector(dx: frame.width * 7/8, dy: 0)
        infoEmitter1.particleScale = 0.10
        infoEmitter1.particlePosition = CGPoint(x: frame.width/2, y: -2/50 * frame.height)
        infoEmitter1.particleLifetime = 6
        infoEmitter1.particleBirthRate = 0.65
        infoEmitter1.particleSpeed = 30
        infoEmitter1.yAcceleration = 60
        infoEmitter1.zPosition = -6
        infoEmitter1.particleColorBlendFactor = 0.50
        infoEmitter1.particleColorBlendFactorSpeed = 0.20
        infoEmitter1.advanceSimulationTime(1.5)
        addChild(infoEmitter1)
        
        infoEmitter2 = SKEmitterNode()
        infoEmitter2.particleTexture = SKTexture(imageNamed: "vector_info.png")
        infoEmitter2.particlePositionRange = CGVector(dx: frame.width * 7/8, dy: 0)
        infoEmitter2.particleScale = 0.10
        infoEmitter2.particlePosition = CGPoint(x: frame.width/2, y: 51/50 * frame.height)
        infoEmitter2.particleLifetime = 6
        infoEmitter2.particleBirthRate = 0.65
        infoEmitter2.particleSpeed = 30
        infoEmitter2.yAcceleration = -60
        infoEmitter2.zPosition = -6
        infoEmitter2.particleColorBlendFactor = 0.50
        infoEmitter2.particleColorBlendFactorSpeed = 0.20
        infoEmitter2.advanceSimulationTime(1.5)
        addChild(infoEmitter2)
    }
    override func update(_ currentTime: TimeInterval)
    {
        if arrowPressCounter == 0
        {
            if frame.width > 700
            {
                descriptionLabel.fontSize = frame.width * 0.06
                descriptionLabel2.fontSize = frame.width * 0.06
                descriptionLabel3.fontSize = frame.width * 0.06
                descriptionLabel.position = CGPoint(x: frame.width * 0.5, y: frame.height * 0.57)
                descriptionLabel2.position = CGPoint(x: frame.width * 0.5, y: frame.height * 0.53)
                descriptionLabel3.position = CGPoint(x: frame.width * 0.5, y: frame.height * 0.53)
            }
            else if frame.height > 800 && frame.width < 600
            {
                descriptionLabel.fontSize = frame.width * 0.06
                descriptionLabel2.fontSize = frame.width * 0.06
                descriptionLabel3.fontSize = frame.width * 0.06
                descriptionLabel.position = CGPoint(x: frame.width * 0.5, y: frame.height * 0.565)
                descriptionLabel2.position = CGPoint(x: frame.width * 0.5, y: frame.height * 0.535)
                descriptionLabel3.position = CGPoint(x: frame.width * 0.5, y: frame.height * 0.525)
            }
            else
            {
                descriptionLabel.fontSize = frame.width * 0.06
                descriptionLabel2.fontSize = frame.width * 0.06
                descriptionLabel3.fontSize = frame.width * 0.06
                descriptionLabel.position = CGPoint(x: frame.width * 0.5, y: frame.height * 0.575)
                descriptionLabel2.position = CGPoint(x: frame.width * 0.5, y: frame.height * 0.53)
                descriptionLabel3.position = CGPoint(x: frame.width * 0.5, y: frame.height * 0.53)
            }
            descriptionLabel.text = "Magnet Hockey is"
            descriptionLabel2.text = "a two-player game."
            descriptionLabel3.text = ""
            pageDotOne.colorBlendFactor = 0
            pageDotTwo.colorBlendFactor = 0.75
            pageDotThree.colorBlendFactor = 0.75
            pageDotFour.colorBlendFactor = 0.75
            pageDotFive.colorBlendFactor = 0.75
        }
        else if arrowPressCounter == 1
        {
            
            if frame.width > 700
            {
                descriptionLabel.fontSize = frame.width * 0.05
                descriptionLabel2.fontSize = frame.width * 0.05
                descriptionLabel3.fontSize = frame.width * 0.05
                descriptionLabel.position = CGPoint(x: frame.width * 0.5, y: frame.height * 0.585)
                descriptionLabel2.position = CGPoint(x: frame.width * 0.5, y: frame.height * 0.55)
                descriptionLabel3.position = CGPoint(x: frame.width * 0.5, y: frame.height * 0.515)
            }
            else if frame.height > 800 && frame.width < 600
            {
                descriptionLabel.fontSize = frame.width * 0.06
                descriptionLabel2.fontSize = frame.width * 0.06
                descriptionLabel3.fontSize = frame.width * 0.06
                descriptionLabel.position = CGPoint(x: frame.width * 0.5, y: frame.height * 0.5775)
                descriptionLabel2.position = CGPoint(x: frame.width * 0.5, y: frame.height * 0.55)
                descriptionLabel3.position = CGPoint(x: frame.width * 0.5, y: frame.height * 0.5225)
            }
            else
            {
                descriptionLabel.fontSize = frame.width * 0.06
                descriptionLabel2.fontSize = frame.width * 0.06
                descriptionLabel3.fontSize = frame.width * 0.06
                descriptionLabel.position = CGPoint(x: frame.width * 0.5, y: frame.height * 0.585)
                descriptionLabel2.position = CGPoint(x: frame.width * 0.5, y: frame.height * 0.55)
                descriptionLabel3.position = CGPoint(x: frame.width * 0.5, y: frame.height * 0.515)
            }
            descriptionLabel.text = "Use the mallets"
            descriptionLabel2.text = "to hit the ball into"
            descriptionLabel3.text = "the enemy's goal."
            pageDotOne.colorBlendFactor = 0.75
            pageDotTwo.colorBlendFactor = 0
            pageDotThree.colorBlendFactor = 0.75
            pageDotFour.colorBlendFactor = 0.75
            pageDotFive.colorBlendFactor = 0.75
        }
        else if arrowPressCounter == 2
        {
            if frame.width > 700
            {
                descriptionLabel.fontSize = frame.width * 0.05
                descriptionLabel2.fontSize = frame.width * 0.05
                descriptionLabel3.fontSize = frame.width * 0.05
                descriptionLabel.position = CGPoint(x: frame.width * 0.5, y: frame.height * 0.585)
                descriptionLabel2.position = CGPoint(x: frame.width * 0.5, y: frame.height * 0.55)
                descriptionLabel3.position = CGPoint(x: frame.width * 0.5, y: frame.height * 0.515)
            }
            else if frame.height > 800 && frame.width < 600
            {
                descriptionLabel.fontSize = frame.width * 0.06
                descriptionLabel2.fontSize = frame.width * 0.06
                descriptionLabel3.fontSize = frame.width * 0.06
                descriptionLabel.position = CGPoint(x: frame.width * 0.5, y: frame.height * 0.5775)
                descriptionLabel2.position = CGPoint(x: frame.width * 0.5, y: frame.height * 0.55)
                descriptionLabel3.position = CGPoint(x: frame.width * 0.5, y: frame.height * 0.5225)
            }
            else
            {
                descriptionLabel.fontSize = frame.width * 0.06
                descriptionLabel2.fontSize = frame.width * 0.06
                descriptionLabel3.fontSize = frame.width * 0.06
                descriptionLabel.position = CGPoint(x: frame.width * 0.5, y: frame.height * 0.585)
                descriptionLabel2.position = CGPoint(x: frame.width * 0.5, y: frame.height * 0.55)
                descriptionLabel3.position = CGPoint(x: frame.width * 0.5, y: frame.height * 0.515)
            }
            descriptionLabel.text = "Collecting two or"
            descriptionLabel2.text = "more magnets will"
            descriptionLabel3.text = "cost you the round."
            pageDotOne.colorBlendFactor = 0.75
            pageDotTwo.colorBlendFactor = 0.75
            pageDotThree.colorBlendFactor = 0
            pageDotFour.colorBlendFactor = 0.75
            pageDotFive.colorBlendFactor = 0.75
        }
        else if arrowPressCounter == 3
        {
            if frame.width > 700
            {
                descriptionLabel.fontSize = frame.width * 0.06
                descriptionLabel2.fontSize = frame.width * 0.06
                descriptionLabel3.fontSize = frame.width * 0.06
            }
            else
            {
                descriptionLabel.fontSize = frame.width * 0.07
                descriptionLabel2.fontSize = frame.width * 0.07
                descriptionLabel3.fontSize = frame.width * 0.07
            }

            descriptionLabel.position = CGPoint(x: frame.width * 0.5, y: frame.height * 0.57)
            descriptionLabel2.position = CGPoint(x: frame.width * 0.5, y: frame.height * 0.53)
            descriptionLabel3.position = CGPoint(x: frame.width * 0.5, y: frame.height * 0.53)
            descriptionLabel.text = "Developed by"
            descriptionLabel2.text = "Trevor Wysong"
            descriptionLabel3.text = ""
            pageDotOne.colorBlendFactor = 0.75
            pageDotTwo.colorBlendFactor = 0.75
            pageDotThree.colorBlendFactor = 0.75
            pageDotFour.colorBlendFactor = 0
            pageDotFive.colorBlendFactor = 0.75
        }
        else if arrowPressCounter == 4
        {
            if frame.width > 700
            {
                descriptionLabel.fontSize = frame.width * 0.06
                descriptionLabel2.fontSize = frame.width * 0.06
                descriptionLabel3.fontSize = frame.width * 0.06
            }
            else
            {
                descriptionLabel.fontSize = frame.width * 0.08
                descriptionLabel2.fontSize = frame.width * 0.08
                descriptionLabel3.fontSize = frame.width * 0.08
            }
            descriptionLabel.fontSize = frame.width * 0.08
            descriptionLabel2.fontSize = frame.width * 0.08
            descriptionLabel3.fontSize = frame.width * 0.08
            descriptionLabel.position = CGPoint(x: frame.width * 0.5, y: frame.height * 0.55)
            descriptionLabel2.position = CGPoint(x: frame.width * 0.5, y: frame.height * 0.53)
            descriptionLabel3.position = CGPoint(x: frame.width * 0.5, y: frame.height * 0.53)
            descriptionLabel.text = "Have fun!"
            descriptionLabel2.text = ""
            descriptionLabel3.text = ""
            pageDotOne.colorBlendFactor = 0.75
            pageDotTwo.colorBlendFactor = 0.75
            pageDotThree.colorBlendFactor = 0.75
            pageDotFour.colorBlendFactor = 0.75
            pageDotFive.colorBlendFactor = 0
        }
        else
        {
            if frame.width > 700
            {
                descriptionLabel.fontSize = frame.width * 0.04
                descriptionLabel2.fontSize = frame.width * 0.04
                descriptionLabel3.fontSize = frame.width * 0.04
            }
            else
            {
                descriptionLabel.fontSize = frame.width * 0.06
                descriptionLabel2.fontSize = frame.width * 0.06
                descriptionLabel3.fontSize = frame.width * 0.06
            }

            descriptionLabel.position = CGPoint(x: frame.width * 0.5, y: frame.height * 0.575)
            descriptionLabel2.position = CGPoint(x: frame.width * 0.5, y: frame.height * 0.53)
            descriptionLabel3.position = CGPoint(x: frame.width * 0.5, y: frame.height * 0.53)
            descriptionLabel.text = "Magnet Hockey is"
            descriptionLabel2.text = "a two-player game."
            descriptionLabel3.text = ""
            arrowPressCounter = 0
        }
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
            
            else if nodesArray.contains(backButton) && arrowPressCounter > 0
            {
                backButton.colorBlendFactor = 0.5
                touchedBackButton = true
            }

            else if nodesArray.contains(forwardButton) && arrowPressCounter < 4
            {
                forwardButton.colorBlendFactor = 0.5
                touchedForwardButton = true
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
            
            else if nodesArray.contains(backButton) && touchedBackButton == true && arrowPressCounter > 1
            {
                touchedBackButton = false
                backButton.colorBlendFactor = 0
                forwardButton.colorBlendFactor = 0
                arrowPressCounter -= 1
                if UserDefaults.standard.string(forKey: "Sound") == "On" {run(buttonSound)}
                else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                else{run(buttonSound)}
            }
            
            else if nodesArray.contains(backButton) && touchedBackButton == true && arrowPressCounter == 1
            {
                touchedBackButton = false
                backButton.colorBlendFactor = 0.5
                forwardButton.colorBlendFactor = 0
                arrowPressCounter -= 1
                if UserDefaults.standard.string(forKey: "Sound") == "On" {run(buttonSound)}
                else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                else{run(buttonSound)}
            }
            
            else if nodesArray.contains(forwardButton) && touchedForwardButton == true && arrowPressCounter < 3
            {
                touchedForwardButton = false
                forwardButton.colorBlendFactor = 0
                backButton.colorBlendFactor = 0
                if UserDefaults.standard.string(forKey: "Sound") == "On" {run(buttonSound)}
                else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                else{run(buttonSound)}
                arrowPressCounter += 1
            }
            else if nodesArray.contains(forwardButton) && touchedForwardButton == true && arrowPressCounter == 3
            {
                touchedForwardButton = false
                forwardButton.colorBlendFactor = 0.5
                if UserDefaults.standard.string(forKey: "Sound") == "On" {run(buttonSound)}
                else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                else{run(buttonSound)}
                arrowPressCounter += 1
            }

            else
            {
                if touchedMenu == true
                {
                    backToMenuButton.colorBlendFactor = 0
                    touchedMenu = false
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
}
