//  Created by Wysong, Trevor on 4/16/20.
//  Copyright © 2020 Wysong, Trevor. All rights reserved.

import SpriteKit
import GoogleMobileAds

class GameOverScene: SKScene
{
    // you can use another font for the label if you want...
    var tapStartLabel = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    var gameWinnerLabel = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    var gameWinnerLabelOutlineWest = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    var gameWinnerLabelOutlineNorthWest = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    var gameWinnerLabelOutlineSouthWest = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    var gameWinnerLabelOutlineEast = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    var gameWinnerLabelOutlineSouthEast = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    var gameWinnerLabelOutlineNorthEast = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    var gameWinnerLabelOutlineSouth = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    var gameWinnerLabelOutlineNorth = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    var gameWinnerLabelMiddle = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    var gameWinnerLabelMiddleOutlineWest = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    var gameWinnerLabelMiddleOutlineEast = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    var gameWinnerLabelMiddleOutlineSouth = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    var gameWinnerLabelMiddleOutlineNorth = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    var gameWinnerLabelMiddleOutlineNorthEast = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    var gameWinnerLabelMiddleOutlineNorthWest = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    var gameWinnerLabelMiddleOutlineSouthEast = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    var gameWinnerLabelMiddleOutlineSouthWest = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    var backToMenuButtonLabel = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    var magnetEmitter:SKEmitterNode!
    let buttonSound = SKAction.playSoundFileNamed("ChangeRounds.mp3", waitForCompletion: false)
    var backToMenuButton = SKSpriteNode()
    var playButton:SKSpriteNode!
    var playTriangleButton:SKSpriteNode!
    var gameWinnerForLabel = ""
    var touchedPlay = false
    var touchedMenu = false
    var numberReviews = 0
    var adsAreDisabled = false
    let reviewService = ReviewService.shared
    
    let refreshAlert = UIAlertController(title: "Magnet Hockey", message: "Are you having fun?", preferredStyle: UIAlertController.Style.alert)
    
    func createEdges()
    {
        var leftEdge = SKSpriteNode(), rightEdge = SKSpriteNode(), bottomEdge = SKSpriteNode(), topEdge = SKSpriteNode()
        (leftEdge, rightEdge, bottomEdge, topEdge) = UIHelper.shared.createEdges()
        addChild(leftEdge)
        addChild(rightEdge)
        addChild(bottomEdge)
        addChild(topEdge)
    }
    
    func createWinnerText()
    {
        if let gameWinner = self.userData?.value(forKey: "gameWinner")
        {
            gameWinnerForLabel = gameWinner as! String
        }
        
        let topGameWinnerBackground:SKSpriteNode!
        topGameWinnerBackground = SKSpriteNode(imageNamed: "SandstoneRectangle.png")
        
        if hasTopNotch && !deviceType.contains("iPad")
        {
            topGameWinnerBackground.position = CGPoint(x: frame.width * 0.50, y: frame.height * 0.80)
        }
        else
        {
            topGameWinnerBackground.position = CGPoint(x: frame.width * 0.50, y: frame.height * 0.85)
        }
        
        if gameWinnerForLabel == "TOP"
        {
            if !deviceType.contains("iPad")
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
            if !deviceType.contains("iPad")
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
        if hasTopNotch && !deviceType.contains("iPad")
        {
            bottomGameWinnerBackground.position = CGPoint(x: frame.width * 0.50, y: frame.height * 0.675)
        }
        else
        {
            bottomGameWinnerBackground.position = CGPoint(x: frame.width * 0.50, y: frame.height * 0.70)
        }
        
        if !deviceType.contains("iPad")
        {
            bottomGameWinnerBackground.scale(to: CGSize(width: frame.width * 0.60, height: frame.width * 0.225))
        }
        else
        {
            bottomGameWinnerBackground.scale(to: CGSize(width: frame.width * 0.55, height: frame.width * 0.20))

        }
        bottomGameWinnerBackground.zPosition = 0
        addChild(bottomGameWinnerBackground)
        
        addChild(UIHelper.shared.createText(textName: gameWinnerLabel, text: gameWinnerForLabel, position: CGPoint(x: topGameWinnerBackground.position.x, y: topGameWinnerBackground.position.y), iPhoneFontSize: frame.width/6.5, iPadFontSize: frame.width/8, color: SKColor.white, zPos: 2))
        addChild(UIHelper.shared.createText(textName: gameWinnerLabelOutlineWest, text: gameWinnerForLabel, position: CGPoint(x: topGameWinnerBackground.position.x - 2, y: topGameWinnerBackground.position.y), iPhoneFontSize: frame.width/6.5, iPadFontSize: frame.width/8, color: SKColor.black, zPos: 1))
        addChild(UIHelper.shared.createText(textName: gameWinnerLabelOutlineNorthWest, text: gameWinnerForLabel, position: CGPoint(x: topGameWinnerBackground.position.x - 2, y: topGameWinnerBackground.position.y + 2), iPhoneFontSize: frame.width/6.5, iPadFontSize: frame.width/8, color: SKColor.black, zPos: 1))
        addChild(UIHelper.shared.createText(textName: gameWinnerLabelOutlineSouthWest, text: gameWinnerForLabel, position: CGPoint(x: topGameWinnerBackground.position.x - 2, y: topGameWinnerBackground.position.y - 2), iPhoneFontSize: frame.width/6.5, iPadFontSize: frame.width/8, color: SKColor.black, zPos: 1))
        addChild(UIHelper.shared.createText(textName: gameWinnerLabelOutlineNorthEast, text: gameWinnerForLabel, position: CGPoint(x: topGameWinnerBackground.position.x + 2, y: topGameWinnerBackground.position.y + 2), iPhoneFontSize: frame.width/6.5, iPadFontSize: frame.width/8, color: SKColor.black, zPos: 1))
        addChild(UIHelper.shared.createText(textName: gameWinnerLabelOutlineSouthEast, text: gameWinnerForLabel, position: CGPoint(x: topGameWinnerBackground.position.x + 2, y: topGameWinnerBackground.position.y - 2), iPhoneFontSize: frame.width/6.5, iPadFontSize: frame.width/8, color: SKColor.black, zPos: 1))
        addChild(UIHelper.shared.createText(textName: gameWinnerLabelOutlineEast, text: gameWinnerForLabel, position: CGPoint(x: topGameWinnerBackground.position.x + 2, y: topGameWinnerBackground.position.y), iPhoneFontSize: frame.width/6.5, iPadFontSize: frame.width/8, color: SKColor.black, zPos: 1))
        addChild(UIHelper.shared.createText(textName: gameWinnerLabelOutlineSouth, text: gameWinnerForLabel, position: CGPoint(x: topGameWinnerBackground.position.x, y: topGameWinnerBackground.position.y - 2), iPhoneFontSize: frame.width/6.5, iPadFontSize: frame.width/8, color: SKColor.black, zPos: 1))
        addChild(UIHelper.shared.createText(textName: gameWinnerLabelOutlineNorth, text: gameWinnerForLabel, position: CGPoint(x: topGameWinnerBackground.position.x, y: topGameWinnerBackground.position.y + 2), iPhoneFontSize: frame.width/6.5, iPadFontSize: frame.width/8, color: SKColor.black, zPos: 1))
        addChild(UIHelper.shared.createText(textName: gameWinnerLabelMiddle, text: "WINS!", position: CGPoint(x: bottomGameWinnerBackground.position.x, y: bottomGameWinnerBackground.position.y), iPhoneFontSize: frame.width/6.5, iPadFontSize: frame.width/8, color: SKColor.white, zPos: 2))
        addChild(UIHelper.shared.createText(textName: gameWinnerLabelMiddleOutlineWest, text: "WINS!", position: CGPoint(x: bottomGameWinnerBackground.position.x - 2, y: bottomGameWinnerBackground.position.y), iPhoneFontSize: frame.width/6.5, iPadFontSize: frame.width/8, color: SKColor.black, zPos: 1))
        addChild(UIHelper.shared.createText(textName: gameWinnerLabelMiddleOutlineEast, text: "WINS!", position: CGPoint(x: bottomGameWinnerBackground.position.x + 2, y: bottomGameWinnerBackground.position.y), iPhoneFontSize: frame.width/6.5, iPadFontSize: frame.width/8, color: SKColor.black, zPos: 1))
        addChild(UIHelper.shared.createText(textName: gameWinnerLabelMiddleOutlineSouth, text: "WINS!", position: CGPoint(x: bottomGameWinnerBackground.position.x, y: bottomGameWinnerBackground.position.y - 2), iPhoneFontSize: frame.width/6.5, iPadFontSize: frame.width/8, color: SKColor.black, zPos: 1))
        addChild(UIHelper.shared.createText(textName: gameWinnerLabelMiddleOutlineSouthWest, text: "WINS!", position: CGPoint(x: bottomGameWinnerBackground.position.x - 2, y: bottomGameWinnerBackground.position.y - 2), iPhoneFontSize: frame.width/6.5, iPadFontSize: frame.width/8, color: SKColor.black, zPos: 1))
        addChild(UIHelper.shared.createText(textName: gameWinnerLabelMiddleOutlineSouthEast, text: "WINS!", position: CGPoint(x: bottomGameWinnerBackground.position.x + 2, y: bottomGameWinnerBackground.position.y - 2), iPhoneFontSize: frame.width/6.5, iPadFontSize: frame.width/8, color: SKColor.black, zPos: 1))
        addChild(UIHelper.shared.createText(textName: gameWinnerLabelMiddleOutlineNorth, text: "WINS!", position: CGPoint(x: bottomGameWinnerBackground.position.x, y: bottomGameWinnerBackground.position.y + 2), iPhoneFontSize: frame.width/6.5, iPadFontSize: frame.width/8, color: SKColor.black, zPos: 1))
        addChild(UIHelper.shared.createText(textName: gameWinnerLabelMiddleOutlineNorthEast, text: "WINS!", position: CGPoint(x: bottomGameWinnerBackground.position.x + 2, y: bottomGameWinnerBackground.position.y + 2), iPhoneFontSize: frame.width/6.5, iPadFontSize: frame.width/8, color: SKColor.black, zPos: 1))
        addChild(UIHelper.shared.createText(textName: gameWinnerLabelMiddleOutlineNorthWest, text: "WINS!", position: CGPoint(x: bottomGameWinnerBackground.position.x - 2, y: bottomGameWinnerBackground.position.y + 2), iPhoneFontSize: frame.width/6.5, iPadFontSize: frame.width/8, color: SKColor.black, zPos: 1))
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
    }
    
    func handleReviewRequest()
    {
        if reviewService.shouldRequestReview == true
        {
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { timer in
                if (UserDefaults.standard.integer(forKey: "NumberReviews") < 1)
                {
                    self.refreshAlert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
                        UserDefaults.standard.set("No", forKey: "EnjoyedApp")
                        UserDefaults.standard.synchronize()
                    }))

                    self.refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                    self.reviewService.requestReview(isWrittenReview: false)
                    }))
                    
                    let keyWindow = UIApplication.shared.connectedScenes
                            .filter({$0.activationState == .foregroundActive})
                            .compactMap({$0 as? UIWindowScene})
                            .first?.windows
                            .filter({$0.isKeyWindow}).first
                    keyWindow?.rootViewController?.present(self.refreshAlert, animated: true, completion: nil)

                    self.numberReviews = 1
                    UserDefaults.standard.set(1, forKey: "NumberReviews")
                    UserDefaults.standard.synchronize()
                }
                else if (UserDefaults.standard.integer(forKey: "NumberReviews") >= 1)
                {
                    self.reviewService.requestReview(isWrittenReview: false)
                    self.numberReviews = UserDefaults.standard.integer(forKey: "NumberReviews") + 1
                    UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "NumberReviews") + 1, forKey: "NumberReviews")
                    UserDefaults.standard.synchronize()
                }
            })
        }
    }
    
    func createMagnetEmitter()
    {
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
    
    func createPlayButton()
    {
        playButton = SKSpriteNode(imageNamed: "IcyChillSquare.png")
        playButton.position = CGPoint(x: frame.width * 0.50, y: frame.height * 0.45)
        if hasTopNotch && !deviceType.contains("iPad")
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
        if hasTopNotch && !deviceType.contains("iPad")
        {
            playTriangleButton.scale(to: CGSize(width: frame.width * 0.285, height: frame.width * 0.285))
        }
        else
        {
            playTriangleButton.scale(to: CGSize(width: frame.width * 0.25, height: frame.width * 0.25))
        }
        playTriangleButton.zPosition = 2
        addChild(playTriangleButton)
    }
    
    override func didMove(to view: SKView)
    {
        // set the background
        backgroundColor = SKColor.black
        let background = UIHelper.shared.createBackground()
        addChild(background)

        handleAds()
        createWinnerText()
        createEdges()
                
        backToMenuButton = SKSpriteNode(imageNamed: "IcyChillRectangle.png")
        addChild(UIHelper.shared.createBackToMenuButton(menuButton: backToMenuButton))
        addChild(UIHelper.shared.createBackToMenuLabel(menuLabel: backToMenuButtonLabel))
    
        createPlayButton()
        createMagnetEmitter()
        handleReviewRequest()
    }
    
    func gameScene()
    {
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
    
    func gameSceneAirHockey2P()
    {
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
    
    func gameSceneAirHockey2PMultiPuck()
    {
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
    
    func gameSceneAirHockey1P()
    {
        let scene = AirHockey1P(size: (view?.bounds.size)!)
            
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
            if nodesArray.contains(playButton) && touchedPlay == true && UserDefaults.standard.string(forKey: "Game") == "Magnet Hockey"
            {
                SKTAudio.sharedInstance().pauseBackgroundMusic()
                if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(buttonSound)}
                else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                else{run(buttonSound)}
                touchedPlay = false
                playButton.colorBlendFactor = 0
                gameScene()
            }
            else if nodesArray.contains(playButton) && touchedPlay == true && UserDefaults.standard.string(forKey: "Game") == "Air Hockey"
            {
                SKTAudio.sharedInstance().pauseBackgroundMusic()
                if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(buttonSound)}
                else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                else{run(buttonSound)}
                touchedPlay = false
                playButton.colorBlendFactor = 0
                if UserDefaults.standard.string(forKey: "PlayerMode") == "1Player"
                {
                    gameSceneAirHockey1P()
                }
                else if UserDefaults.standard.string(forKey: "PlayerMode") == "2Player"
                {
                    if UserDefaults.standard.string(forKey: "GameType") == "GameMode1"
                    {
                        gameSceneAirHockey2P()
                    }
                    else if UserDefaults.standard.string(forKey: "GameType") == "GameMode2"
                    {
                        gameSceneAirHockey2PMultiPuck()
                    }
                }
                else
                {
                    gameSceneAirHockey2P()
                }
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
