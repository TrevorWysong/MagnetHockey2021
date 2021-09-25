//
//  StartScene.swift
//  Pong_TW
//
//  Created by Wysong, Trevor on 4/16/20.
//  Copyright © 2020 Wysong, Trevor. All rights reserved.
//

import SpriteKit
import GoogleMobileAds

class Settings: SKScene
{
    // you can use another font for the label if you want...
    let roundsButtonLabel = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    let ballColorButtonLabel = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    let buttonSound = SKAction.playSoundFileNamed("ChangeRounds.mp3", waitForCompletion: false)
    var rounds = Int()
    var roundsButton = SKSpriteNode()
    var soundButton = SKSpriteNode()
    var soundButtonSprite = SKSpriteNode()
    var soundButtonOffSprite = SKSpriteNode()
    var ballColorButton = SKSpriteNode()
    var settingsEmitter1:SKEmitterNode!
    var settingsEmitter2:SKEmitterNode!
    var touchedRounds = false
    var touchedSoundOff = false
    var touchedColor = false
    var touchedMenu = false
    let backToMenuButtonLabel = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    var backToMenuButton = SKSpriteNode()

    
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
            bannerViewStartScene?.isHidden = true
            bannerViewGameOverScene?.isHidden = true
            bannerViewInfoScene?.isHidden = true
            bannerViewSettingsScene?.isHidden = false
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
        
        let titleBackgroundSprite:SKSpriteNode!
        titleBackgroundSprite = SKSpriteNode(imageNamed: "RedCircle.png")
        titleBackgroundSprite.position = CGPoint(x: frame.width * 0.50, y: frame.height * 0.80)
        if frame.width < 500
        {
            titleBackgroundSprite.scale(to: CGSize(width: frame.width * 0.33, height: frame.width * 0.33))
        }
        else
        {
            titleBackgroundSprite.scale(to: CGSize(width: frame.width * 0.25, height: frame.width * 0.25))
        }
        titleBackgroundSprite.colorBlendFactor = 0
        titleBackgroundSprite.zPosition = 0
        addChild(titleBackgroundSprite)
        
        let settingsSprite:SKSpriteNode!
        settingsSprite = SKSpriteNode(imageNamed: "settings.png")
        settingsSprite.position = CGPoint(x: titleBackgroundSprite.position.x, y: titleBackgroundSprite.position.y)
        if frame.width < 500
        {
            settingsSprite.scale(to: CGSize(width: frame.width * 0.20, height: frame.width * 0.20))
        }
        else
        {
            settingsSprite.scale(to: CGSize(width: frame.width * 0.15, height: frame.width * 0.15))
        }
        settingsSprite.colorBlendFactor = 0
        settingsSprite.zPosition = 1
        addChild(settingsSprite)
        
        backToMenuButton = SKSpriteNode(imageNamed: "IcyChillRectangle.png")
        backToMenuButton.position = CGPoint(x: frame.width/2, y: frame.height * 0.175)
        backToMenuButton.scale(to: CGSize(width: frame.width * 0.60, height: frame.height * 0.1))
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
        
        roundsButton = SKSpriteNode(imageNamed: "IcyChillRoundedRectangle.png.png")
        roundsButton.position = CGPoint(x: frame.width/2, y: frame.height * 0.60)
        roundsButton.scale(to: CGSize(width: frame.width * 2/3, height: frame.height/10))
        roundsButton.colorBlendFactor = 0
        addChild(roundsButton)
        
        // set size, color, position and text of the tapStartLabel
        roundsButtonLabel.fontSize = frame.width/17.5
        roundsButtonLabel.fontColor = SKColor.white
        roundsButtonLabel.horizontalAlignmentMode = .center
        roundsButtonLabel.verticalAlignmentMode = .center
        roundsButtonLabel.position = CGPoint(x: roundsButton.position.x, y: roundsButton.position.y)
        roundsButtonLabel.zPosition = 1
        if UserDefaults.standard.integer(forKey: "Rounds") == 3 ||
            UserDefaults.standard.integer(forKey: "Rounds") == 5 ||
            UserDefaults.standard.integer(forKey: "Rounds") == 7 ||
            UserDefaults.standard.integer(forKey: "Rounds") == 9 ||
            UserDefaults.standard.integer(forKey: "Rounds") == 11 ||
            UserDefaults.standard.integer(forKey: "Rounds") == 13
        {
            roundsButtonLabel.text = "Best of " + String(UserDefaults.standard.integer(forKey: "Rounds")) + " Rounds"
        }
        else
        {
            roundsButtonLabel.text = "Best of 3 Rounds"
        }
        addChild(roundsButtonLabel)
        
        soundButton = SKSpriteNode(imageNamed: "IcyChillRoundedSquare.png")
        soundButton.position = CGPoint(x: frame.width * 0.50, y: frame.height * 0.325)
        if frame.height > 800 && frame.width < 600
        {
            soundButton.scale(to: CGSize(width: frame.width * 0.25, height: frame.width * 0.25))
        }
        else
        {
            soundButton.scale(to: CGSize(width: frame.width * 0.20, height: frame.width * 0.20))
        }
        soundButton.colorBlendFactor = 0
        addChild(soundButton)
        
        soundButtonSprite = SKSpriteNode(imageNamed: "soundOn.png")
        soundButtonSprite.position = CGPoint(x: soundButton.position.x, y: soundButton.position.y)
        if frame.height > 800 && frame.width < 600
        {
            soundButtonSprite.scale(to: CGSize(width: frame.width * 0.1125, height: frame.width * 0.1125))
        }
        else
        {
            soundButtonSprite.scale(to: CGSize(width: frame.width * 0.09, height: frame.width * 0.09))
        }
        soundButtonSprite.colorBlendFactor = 0
        soundButtonSprite.zPosition = 1
        addChild(soundButtonSprite)
        
        soundButtonOffSprite = SKSpriteNode(imageNamed: "soundOff.png")
        soundButtonOffSprite.position = CGPoint(x: soundButton.position.x, y: soundButton.position.y)
        if frame.height > 800 && frame.width < 600
        {
            soundButtonOffSprite.scale(to: CGSize(width: frame.width * 0.1125, height: frame.width * 0.1125))
        }
        else
        {
            soundButtonOffSprite.scale(to: CGSize(width: frame.width * 0.09, height: frame.width * 0.09))
        }
        soundButtonOffSprite.colorBlendFactor = 0
        soundButtonOffSprite.zPosition = 1
        addChild(soundButtonOffSprite)
        
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
        
        ballColorButton = SKSpriteNode(imageNamed: "IcyChillRoundedRectangle.png")
        ballColorButton.position = CGPoint(x: frame.width/2, y: frame.height * 0.48)
        ballColorButton.scale(to: CGSize(width: frame.width * 2/3, height: frame.height/10))
        ballColorButton.colorBlendFactor = 0
        addChild(ballColorButton)
        
        // set size, color, position and text of the tapStartLabel
        ballColorButtonLabel.fontSize = frame.width/17.5
        ballColorButtonLabel.fontColor = SKColor.white
        ballColorButtonLabel.horizontalAlignmentMode = .center
        ballColorButtonLabel.verticalAlignmentMode = .center
        ballColorButtonLabel.position = CGPoint(x: ballColorButton.position.x, y: ballColorButton.position.y)
        ballColorButtonLabel.zPosition = 1
        if KeychainWrapper.standard.string(forKey: "BallColor") == "Yellow Ball" || KeychainWrapper.standard.string(forKey: "BallColor") == "Black Ball" || KeychainWrapper.standard.string(forKey: "BallColor") == "Blue Ball" || KeychainWrapper.standard.string(forKey: "BallColor") == "Red Ball" || KeychainWrapper.standard.string(forKey: "BallColor") == "Orange Ball" ||
            KeychainWrapper.standard.string(forKey: "BallColor") == "Pink Ball" ||
            KeychainWrapper.standard.string(forKey: "BallColor") == "Purple Ball" ||
            KeychainWrapper.standard.string(forKey: "BallColor") == "Green Ball"
        {
            ballColorButtonLabel.text = KeychainWrapper.standard.string(forKey: "BallColor")
        }
        else
        {
            ballColorButtonLabel.text = "Yellow Ball"
        }
        addChild(ballColorButtonLabel)
        
        let background = SKSpriteNode(imageNamed: "icyBackground3.jpg")
        background.blendMode = .replace
        background.position = CGPoint(x: frame.width/2, y: frame.height/2)
        background.scale(to: CGSize(width: frame.width, height: frame.height))
        background.colorBlendFactor = 0
        background.zPosition = -100
        addChild(background)
        
        settingsEmitter1 = SKEmitterNode()
        settingsEmitter1.particleTexture = SKTexture(imageNamed: "settings.png")
        settingsEmitter1.particlePositionRange = CGVector(dx: frame.width * 7/8, dy: 0)
        settingsEmitter1.particleScale = 0.15
        settingsEmitter1.particlePosition = CGPoint(x: frame.width/2, y: -2/50 * frame.height)
        settingsEmitter1.particleLifetime = 6
        settingsEmitter1.particleBirthRate = 0.65
        settingsEmitter1.particleSpeed = 30
        settingsEmitter1.yAcceleration = 60
        settingsEmitter1.zPosition = -6
        settingsEmitter1.particleColorBlendFactor = 0.50
        settingsEmitter1.particleColorBlendFactorSpeed = 0.20
        settingsEmitter1.advanceSimulationTime(1.5)
        addChild(settingsEmitter1)
        
        settingsEmitter2 = SKEmitterNode()
        settingsEmitter2.particleTexture = SKTexture(imageNamed: "settings.png")
        settingsEmitter2.particlePositionRange = CGVector(dx: frame.width * 7/8, dy: 0)
        settingsEmitter2.particleScale = 0.15
        settingsEmitter2.particlePosition = CGPoint(x: frame.width/2, y: 51/50 * frame.height)
        settingsEmitter2.particleLifetime = 6
        settingsEmitter2.particleBirthRate = 0.65
        settingsEmitter2.particleSpeed = 30
        settingsEmitter2.yAcceleration = -60
        settingsEmitter2.zPosition = -6
        settingsEmitter2.particleColorBlendFactor = 0.50
        settingsEmitter2.particleColorBlendFactorSpeed = 0.20
        settingsEmitter2.advanceSimulationTime(1.5)
        addChild(settingsEmitter2)
    }
    
    func roundsButtonPressed()
    {
        if roundsButtonLabel.text == "Best of 3 Rounds"
        {
            roundsButtonLabel.text = "Best of 5 Rounds"
            rounds = 5
            let save = UserDefaults.standard
            save.set(rounds, forKey: "Rounds")
            save.synchronize()
        }
        else if roundsButtonLabel.text == "Best of 5 Rounds"
        {
            roundsButtonLabel.text = "Best of 7 Rounds"
            rounds = 7
            let save = UserDefaults.standard
            save.set(rounds, forKey: "Rounds")
            save.synchronize()
        }
        else if roundsButtonLabel.text == "Best of 7 Rounds"
        {
            roundsButtonLabel.text = "Best of 9 Rounds"
            rounds = 9
            let save = UserDefaults.standard
            save.set(rounds, forKey: "Rounds")
            save.synchronize()
        }
        else if roundsButtonLabel.text == "Best of 9 Rounds"
        {
            roundsButtonLabel.text = "Best of 11 Rounds"
            rounds = 11
            let save = UserDefaults.standard
            save.set(rounds, forKey: "Rounds")
            save.synchronize()
        }
        else if roundsButtonLabel.text == "Best of 11 Rounds"
        {
            roundsButtonLabel.text = "Best of 13 Rounds"
            rounds = 13
            let save = UserDefaults.standard
            save.set(rounds, forKey: "Rounds")
            save.synchronize()
        }
        else if roundsButtonLabel.text == "Best of 13 Rounds"
        {
            roundsButtonLabel.text = "Best of 3 Rounds"
            rounds = 3
            let save = UserDefaults.standard
            save.set(rounds, forKey: "Rounds")
            save.synchronize()
        }
        else
        {
            roundsButtonLabel.text = "Best of 3 Rounds"
            rounds = 3
            let save = UserDefaults.standard
            save.set(rounds, forKey: "Rounds")
            save.synchronize()
        }
    }
    
    func ballColorButtonPressed()
    {
        if KeychainWrapper.standard.bool(forKey: "PurchaseBlackBall") == true
        {
            if ballColorButtonLabel.text == "Yellow Ball"
            {
                ballColorButtonLabel.text = "Black Ball"
            }
            else if ballColorButtonLabel.text == "Black Ball"
            {
                ballColorButtonLabel.text = "Blue Ball"
            }
            else if ballColorButtonLabel.text == "Blue Ball"
            {
                ballColorButtonLabel.text = "Green Ball"
            }
            else if ballColorButtonLabel.text == "Green Ball"
            {
                ballColorButtonLabel.text = "Red Ball"
            }
            else if ballColorButtonLabel.text == "Red Ball"
            {
                ballColorButtonLabel.text = "Purple Ball"
            }
            else if ballColorButtonLabel.text == "Purple Ball"
            {
                ballColorButtonLabel.text = "Pink Ball"
            }
            else if ballColorButtonLabel.text == "Pink Ball"
            {
                ballColorButtonLabel.text = "Orange Ball"
            }
            else if ballColorButtonLabel.text == "Orange Ball"
            {
                ballColorButtonLabel.text = "Yellow Ball"
            }
        }
        else
        {
            if ballColorButtonLabel.text == "Yellow Ball"
            {
                ballColorButtonLabel.text = "Black Ball"
            }
            else
            {
                ballColorButtonLabel.text = "Yellow Ball"
            }
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
            else if nodesArray.contains(roundsButton)
            {
                roundsButton.colorBlendFactor = 0.5
                touchedRounds = true
            }
            else if nodesArray.contains(ballColorButton)
            {
                ballColorButton.colorBlendFactor = 0.5
                touchedColor = true
            }
            else if nodesArray.contains(soundButton)
            {
                soundButton.colorBlendFactor = 0.5
                touchedSoundOff = true
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
                
                let _: Bool = KeychainWrapper.standard.set(ballColorButtonLabel.text!, forKey: "BallColor")
                
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
            
            else if nodesArray.contains(roundsButton) && touchedRounds == true
            {
                touchedRounds = false
                roundsButton.colorBlendFactor = 0
                if UserDefaults.standard.string(forKey: "Sound") == "On" {run(buttonSound)}
                else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                else{run(buttonSound)}
                roundsButtonPressed()
            }
            else if nodesArray.contains(ballColorButton) && touchedColor == true
            {
                touchedColor = false
                ballColorButton.colorBlendFactor = 0
                if UserDefaults.standard.string(forKey: "Sound") == "On" {run(buttonSound)}
                else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                else{run(buttonSound)}
                ballColorButtonPressed()
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
                SKTAudio.sharedInstance().playBackgroundMusic("MenuSong2.mp3")
                touchedSoundOff = false
                soundButton.colorBlendFactor = 0
                if UserDefaults.standard.string(forKey: "Sound") == "On" {run(buttonSound)}
                else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                else{run(buttonSound)}
            }
            else
            {
                if touchedMenu == true
                {
                    backToMenuButton.colorBlendFactor = 0
                    touchedMenu = false
                }
                if touchedRounds == true
                {
                    touchedRounds = false
                    roundsButton.colorBlendFactor = 0
                }
                if touchedColor == true
                {
                    touchedColor = false
                    ballColorButton.colorBlendFactor = 0
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
