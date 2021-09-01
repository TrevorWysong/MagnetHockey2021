//  Created by Wysong, Trevor on 4/16/20.
//  Copyright © 2020 Wysong, Trevor. All rights reserved.

import SpriteKit
import GoogleMobileAds

class GameOverScene: SKScene
{
    // you can use another font for the label if you want...
    let tapStartLabel = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    let gameWinnerLabel = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    let gameWinnerLabelMiddle = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    let backToMenuButtonLabel = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    var magnetEmitter:SKEmitterNode!
    let buttonSound = SKAction.playSoundFileNamed("ChangeRounds.mp3", waitForCompletion: false)
    var backToMenuButton = SKSpriteNode()
    var playButton:SKSpriteNode!
    var playTriangleButton:SKSpriteNode!
    var gameWinnerForLabel = ""
    var touchedPlay = false
    var touchedMenu = false
    var adsAreDisabled = false
//    let reviewService = ReviewService.shared
    
    func createEdges()
    {
        let leftEdge = SKSpriteNode(color: UIColor.systemBlue, size: CGSize(width: CGFloat(533/10000 * frame.width), height: size.height + ((35/40) * frame.height)))
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
        
        let topEdge = SKSpriteNode(color: UIColor.systemBlue, size: CGSize(width: frame.width*3 + ((20/100) * frame.width), height: CGFloat(55.0/100) * frame.width))
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
        
        if UserDefaults.standard.bool(forKey: "Purchase") != true
        {
            bannerViewStartScene?.isHidden = true
            bannerViewGameOverScene?.isHidden = false
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
        
        // set the background
        backgroundColor = SKColor.black

        createEdges()
        
        let background = SKSpriteNode(imageNamed: "icyBackground3.jpg")
        background.blendMode = .replace
        background.position = CGPoint(x: frame.width/2, y: frame.height/2)
        background.scale(to: CGSize(width: frame.width, height: frame.height))
        background.zPosition = -100
        addChild(background)
        
        backToMenuButton = SKSpriteNode(imageNamed: "IcyChillRectangle.png")
        backToMenuButton.blendMode = .replace
        backToMenuButton.position = CGPoint(x: frame.width/2, y: frame.height * 0.20)
        backToMenuButton.scale(to: CGSize(width: frame.width * 2/3, height: frame.height/10))
        backToMenuButton.colorBlendFactor = 0
        addChild(backToMenuButton)

        // set size, color, position and text of the tapStartLabel
        backToMenuButtonLabel.fontSize = frame.width/17.5
        backToMenuButtonLabel.fontColor = SKColor.white
        backToMenuButtonLabel.horizontalAlignmentMode = .center
        backToMenuButtonLabel.verticalAlignmentMode = .center
        backToMenuButtonLabel.position = CGPoint(x: backToMenuButton.position.x, y: backToMenuButton.position.y)
        backToMenuButtonLabel.zPosition = 1
        backToMenuButtonLabel.text = "Back to Menu"
        addChild(backToMenuButtonLabel)
        
        if let gameWinner = self.userData?.value(forKey: "gameWinner")
        {
            gameWinnerForLabel = gameWinner as! String
        }
        
        let topGameWinnerBackground:SKSpriteNode!
        topGameWinnerBackground = SKSpriteNode(imageNamed: "SandstoneRectangle.png")
        
        if frame.height > 800 && frame.width < 600
        {
            topGameWinnerBackground.position = CGPoint(x: frame.width * 0.50, y: frame.height * 0.80)
        }
        else
        {
            topGameWinnerBackground.position = CGPoint(x: frame.width * 0.50, y: frame.height * 0.85)
        }
        
        if gameWinnerForLabel == "TOP"
        {
            if frame.width < 600
            {
                topGameWinnerBackground.scale(to: CGSize(width: frame.width * 0.50, height: frame.width * 0.225))
            }
            else
            {
                topGameWinnerBackground.scale(to: CGSize(width: frame.width * 0.40, height: frame.width * 0.20))
            }
        }
        else
        {
            if frame.width < 600
            {
                topGameWinnerBackground.scale(to: CGSize(width: frame.width * 0.85, height: frame.width * 0.225))
            }
            else
            {
                topGameWinnerBackground.scale(to: CGSize(width: frame.width * 0.75, height: frame.width * 0.20))
            }
        }
        topGameWinnerBackground.zPosition = 0
        addChild(topGameWinnerBackground)
        
        let bottomGameWinnerBackground:SKSpriteNode!
        bottomGameWinnerBackground = SKSpriteNode(imageNamed: "SandstoneRectangle.png")
        if frame.width < 600 && frame.height > 800
        {
            bottomGameWinnerBackground.position = CGPoint(x: frame.width * 0.50, y: frame.height * 0.675)
        }
        else
        {
            bottomGameWinnerBackground.position = CGPoint(x: frame.width * 0.50, y: frame.height * 0.70)
        }
        if frame.width < 600
        {
            bottomGameWinnerBackground.scale(to: CGSize(width: frame.width * 0.60, height: frame.width * 0.225))

        }
        else
        {
            bottomGameWinnerBackground.scale(to: CGSize(width: frame.width * 0.55, height: frame.width * 0.20))

        }
        bottomGameWinnerBackground.zPosition = 0
        addChild(bottomGameWinnerBackground)
        
        // set size, color, position and text of the gameWinnerLabel
        if frame.width < 600
        {
            gameWinnerLabel.fontSize = frame.width/6.5
        }
        else
        {
            gameWinnerLabel.fontSize = frame.width/8
        }
        gameWinnerLabel.fontColor = SKColor.white
        gameWinnerLabel.horizontalAlignmentMode = .center
        gameWinnerLabel.verticalAlignmentMode = .center
        gameWinnerLabel.position = CGPoint(x: topGameWinnerBackground.position.x, y: topGameWinnerBackground.position.y)
        gameWinnerLabel.zPosition = 1
        gameWinnerLabel.text = gameWinnerForLabel
        addChild(gameWinnerLabel)
        
        // set size, color, position and text of the gameWinnerLabel
        if frame.width < 600
        {
            gameWinnerLabelMiddle.fontSize = frame.width/6.5
        }
        else
        {
            gameWinnerLabelMiddle.fontSize = frame.width/8
        }
        gameWinnerLabelMiddle.fontColor = SKColor.white
        gameWinnerLabelMiddle.horizontalAlignmentMode = .center
        gameWinnerLabelMiddle.verticalAlignmentMode = .center
        gameWinnerLabelMiddle.position = CGPoint(x: bottomGameWinnerBackground.position.x, y: bottomGameWinnerBackground.position.y)
        gameWinnerLabelMiddle.zPosition = 1
        gameWinnerLabelMiddle.text = "WINS!"
        addChild(gameWinnerLabelMiddle)
       
        playButton = SKSpriteNode(imageNamed: "IcyChillSquare.png")
        playButton.position = CGPoint(x: frame.width * 0.50, y: frame.height * 0.45)
        if frame.height > 800 && frame.width < 600
        {
            playButton.scale(to: CGSize(width: frame.width * 0.40, height: frame.width * 0.40))

        }
        else
        {
            playButton.scale(to: CGSize(width: frame.width * 0.35, height: frame.width * 0.35))
        }
        addChild(playButton)
        
        playTriangleButton = SKSpriteNode(imageNamed: "whitePlayButton.png")
        playTriangleButton.position = CGPoint(x: playButton.position.x, y: playButton.position.y)
        if frame.height > 800 && frame.width < 600
        {
            playTriangleButton.scale(to: CGSize(width: frame.width * 0.285, height: frame.width * 0.285))
        }
        else
        {
            playTriangleButton.scale(to: CGSize(width: frame.width * 0.25, height: frame.width * 0.25))
        }
        playTriangleButton.zPosition = 2
        addChild(playTriangleButton)

        magnetEmitter = SKEmitterNode()
        magnetEmitter.particleTexture = SKTexture(imageNamed: "newMagnetSmaller.png")
        magnetEmitter.particlePositionRange = CGVector(dx: frame.width * 7/8, dy: 0)
        magnetEmitter.particleScale = 0.15
        magnetEmitter.particlePosition = CGPoint(x: frame.width/2, y: -2/50 * frame.height)
        magnetEmitter.particleLifetime = 6
        magnetEmitter.particleBirthRate = 0.50
        magnetEmitter.particleSpeed = 30
        magnetEmitter.yAcceleration = 60
        magnetEmitter.zPosition = -6
        magnetEmitter.particleColorBlendFactor = 0.1
        magnetEmitter.particleColorBlendFactorSpeed = 0.40
        magnetEmitter.advanceSimulationTime(1.0)
        addChild(magnetEmitter)
    }
    
    func gameScene()
    {
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
            if nodesArray.contains(playButton) && touchedPlay == true
            {
                SKTAudio.sharedInstance().pauseBackgroundMusic()
                if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(buttonSound)}
                else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                else{run(buttonSound)}
                touchedPlay = false
                playButton.colorBlendFactor = 0
                gameScene()
            }
            else if nodesArray.contains(backToMenuButton) && touchedMenu == true
            {
                if UserDefaults.standard.string(forKey: "Sound") != "Off"
                {
                    run(buttonSound)
                    SKTAudio.sharedInstance().playBackgroundMusicFadeIn("MenuSong2.mp3")
                }
                else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                else{run(buttonSound)}
                touchedMenu = false
                backToMenuButton.colorBlendFactor = 0
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
            else
            {
                if touchedPlay == true
                {
                    touchedPlay = false
                    playButton.colorBlendFactor = 0
                }
                if touchedMenu == true
                {
                    touchedMenu = false
                    backToMenuButton.colorBlendFactor = 0
                }
            }
        }
    }
}
