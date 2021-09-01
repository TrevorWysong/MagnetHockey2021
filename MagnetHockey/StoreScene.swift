//
//  StoreScene.swift
//  MagnetHockey
//
//  Created by Wysong, Trevor on 4/29/20.
//  Copyright © 2020 Wysong, Trevor. All rights reserved.
//

import SpriteKit
import GoogleMobileAds
import StoreKit

class StoreScene: SKScene
{
    // you can use another font for the label if you want...
    let backToMenuButtonLabel = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    var backToMenuButton = SKSpriteNode()
    let purchaseBlackBallLabel = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    let removeAdsLabel = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    var purchaseNoAdsBackgroundButton = SKSpriteNode()
    var purchaseBallPackBackgroundButton = SKSpriteNode()
    var noAdsLabelButton = SKSpriteNode()
    var ballPackLabelButton = SKSpriteNode()
    let restorePurchasesLabel = SKLabelNode(fontNamed: "STHeitiTC-Medium")
    var restorePurchasesButton = SKSpriteNode()
    let buttonSound = SKAction.playSoundFileNamed("ChangeRounds.mp3", waitForCompletion: false)
    var cartEmitter1:SKEmitterNode!
    var cartEmitter2:SKEmitterNode!
    var touchedRestore = false
    var touchedBuyNoAds = false
    var touchedBuyColorPack = false
    var touchedMenu = false
    let alertController2 = UIAlertController(title: "Magnet Hockey Store", message: "You have already purchased everything!", preferredStyle: UIAlertController.Style.alert)
    
    let alertController3 = UIAlertController(title: "Magnet Hockey Store", message: "Restored 'Remove Ads'!", preferredStyle: UIAlertController.Style.alert)
    let alertController4 = UIAlertController(title: "Magnet Hockey Store", message: "Restored 'Ball Color Pack'!", preferredStyle: UIAlertController.Style.alert)
    let alertController5 = UIAlertController(title: "Magnet Hockey Store", message: "Restored 'Remove Ads' and 'Ball Color Pack'!", preferredStyle: UIAlertController.Style.alert)
    let alertController6 = UIAlertController(title: "Magnet Hockey Store", message: "You have already purchased 'Remove Ads'!", preferredStyle: UIAlertController.Style.alert)
    let alertController7 = UIAlertController(title: "Magnet Hockey Store", message: "You have already purchased 'Ball Color Pack'!", preferredStyle: UIAlertController.Style.alert)
    
    // if user likes app, request is sent for review
    let okAction2 = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(alertAction: UIAlertAction) in
    })
    let okAction3 = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(alertAction: UIAlertAction) in
    })
    let okAction4 = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(alertAction: UIAlertAction) in
    })
    let okAction5 = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(alertAction: UIAlertAction) in
    })
    let okAction6 = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(alertAction: UIAlertAction) in
    })
    let okAction7 = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(alertAction: UIAlertAction) in
    })
    
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
        // set the background
        backgroundColor = SKColor.black
        IAPService.shared.getProducts()

        createEdges()
        alertController2.addAction(okAction2)
        alertController3.addAction(okAction3)
        alertController4.addAction(okAction4)
        alertController5.addAction(okAction5)
        alertController6.addAction(okAction6)
        alertController7.addAction(okAction7)

        let bannerViewStartScene = self.view?.viewWithTag(100) as! GADBannerView?
        let bannerViewGameOverScene = self.view?.viewWithTag(101) as! GADBannerView?
        let bannerViewInfoScene = self.view?.viewWithTag(102) as! GADBannerView?
        let bannerViewSettingsScene = self.view?.viewWithTag(103) as! GADBannerView?
        bannerViewStartScene?.isHidden = true
        bannerViewGameOverScene?.isHidden = true
        bannerViewInfoScene?.isHidden = true
        bannerViewSettingsScene?.isHidden = true

        
        let background = SKSpriteNode(imageNamed: "icyBackground3.jpg")
        background.blendMode = .replace
        background.position = CGPoint(x: frame.width/2, y: frame.height/2)
        background.scale(to: CGSize(width: frame.width, height: frame.height))
        background.colorBlendFactor = 0
        background.zPosition = -100
        addChild(background)
        
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
        settingsSprite = SKSpriteNode(imageNamed: "vector_cart.png")
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
        
        purchaseNoAdsBackgroundButton = SKSpriteNode(imageNamed: "AgedEmeraldSquare.png")
        purchaseNoAdsBackgroundButton.position = CGPoint(x: frame.width * 0.30, y: frame.height * 0.34)
        addChild(purchaseNoAdsBackgroundButton)
        
        purchaseBallPackBackgroundButton = SKSpriteNode(imageNamed: "AgedEmeraldSquare.png")
        purchaseBallPackBackgroundButton.position = CGPoint(x: frame.width * 0.70, y: frame.height * 0.34)
        addChild(purchaseBallPackBackgroundButton)

        // set size, color, position and text of the tapStartLabel
        backToMenuButtonLabel.fontSize = frame.width/17.5
        backToMenuButtonLabel.fontColor = SKColor.white
        backToMenuButtonLabel.horizontalAlignmentMode = .center
        backToMenuButtonLabel.verticalAlignmentMode = .center
        backToMenuButtonLabel.position = CGPoint(x: backToMenuButton.position.x, y: backToMenuButton.position.y)
        backToMenuButtonLabel.zPosition = 1
        backToMenuButtonLabel.text = "Back to Menu"
        addChild(backToMenuButtonLabel)
        
        let purchaseBlackBallButton:SKSpriteNode!
        purchaseBlackBallButton = SKSpriteNode(imageNamed: "ColorWheel4.png")
        purchaseBlackBallButton.position = CGPoint(x: purchaseBallPackBackgroundButton.position.x, y: purchaseBallPackBackgroundButton.position.y)
        purchaseBlackBallButton.zPosition = 1
        addChild(purchaseBlackBallButton)

        // set size, color, position and text of the tapStartLabel
        purchaseBlackBallLabel.fontSize = frame.width/25
        purchaseBlackBallLabel.fontColor = SKColor.black
        purchaseBlackBallLabel.horizontalAlignmentMode = .center
        purchaseBlackBallLabel.verticalAlignmentMode = .center
        purchaseBlackBallLabel.position = CGPoint(x: purchaseBlackBallButton.position.x, y: purchaseBlackBallButton.position.y + (frame.height * 0.14))
        purchaseBlackBallLabel.zPosition = 1
        purchaseBlackBallLabel.text = "Ball Color Pack"
        if UserDefaults.standard.bool(forKey: "PurchaseBlackBall") == true
        {
            purchaseBlackBallLabel.text = "Purchased!"
        }
        addChild(purchaseBlackBallLabel)
        
        let removeAdsButton: SKSpriteNode!
        removeAdsButton = SKSpriteNode(imageNamed: "removeAds.png")
        removeAdsButton.position = CGPoint(x: purchaseNoAdsBackgroundButton.position.x, y: purchaseNoAdsBackgroundButton.position.y)
        removeAdsButton.colorBlendFactor = 0
        removeAdsButton.zPosition = 1
        addChild(removeAdsButton)
        
        if frame.width > 700
        {
            purchaseBlackBallButton.scale(to: CGSize(width: frame.width * 0.16, height: frame.width * 0.16))
            removeAdsButton.scale(to: CGSize(width: frame.width * 0.20, height: frame.width * 0.20))
            purchaseBallPackBackgroundButton.scale(to: CGSize(width: frame.width * 0.23, height: frame.width * 0.23))
            purchaseNoAdsBackgroundButton.scale(to: CGSize(width: frame.width * 0.23, height: frame.width * 0.23))
        }
        else
        {
            purchaseBlackBallButton.scale(to: CGSize(width: frame.width * 0.20, height: frame.width * 0.20))
            removeAdsButton.scale(to: CGSize(width: frame.width * 0.25, height: frame.width * 0.25))
            purchaseBallPackBackgroundButton.scale(to: CGSize(width: frame.width * 0.30, height: frame.width * 0.30))
            purchaseNoAdsBackgroundButton.scale(to: CGSize(width: frame.width * 0.30, height: frame.width * 0.30))
        }

        // set size, color, position and text of the tapStartLabel
        removeAdsLabel.fontSize = frame.width/25
        removeAdsLabel.fontColor = SKColor.black
        removeAdsLabel.horizontalAlignmentMode = .center
        removeAdsLabel.verticalAlignmentMode = .center
        removeAdsLabel.position = CGPoint(x: removeAdsButton.position.x, y: removeAdsButton.position.y + (frame.height * 0.14))
        removeAdsLabel.zPosition = 1
        removeAdsLabel.text = "Remove Ads"
        if UserDefaults.standard.bool(forKey: "Purchase") == true
        {
            removeAdsLabel.text = "Purchased!"
        }
        addChild(removeAdsLabel)
        
        restorePurchasesButton = SKSpriteNode(imageNamed: "IcyChillLongOval.png")
        restorePurchasesButton.position = CGPoint(x: frame.width * 1/2, y: frame.height * 0.60)
        restorePurchasesButton.scale(to: CGSize(width: frame.width * 0.60, height: frame.height/10))
        addChild(restorePurchasesButton)

        // set size, color, position and text of the tapStartLabel
        restorePurchasesLabel.fontSize = frame.width/20
        restorePurchasesLabel.fontColor = SKColor.white
        restorePurchasesLabel.horizontalAlignmentMode = .center
        restorePurchasesLabel.verticalAlignmentMode = .center
        restorePurchasesLabel.position = CGPoint(x: restorePurchasesButton.position.x, y: restorePurchasesButton.position.y)
        restorePurchasesLabel.zPosition = 1
        restorePurchasesLabel.text = "Restore Purchases"
        addChild(restorePurchasesLabel)
        
        noAdsLabelButton = SKSpriteNode(imageNamed: "AgedEmeraldRectangle.png")
        noAdsLabelButton.position = CGPoint(x: frame.width * 0.30, y: removeAdsButton.position.y + (frame.height * 0.14))
        noAdsLabelButton.scale(to: CGSize(width: frame.width * 0.35, height: frame.width * 0.1))
        addChild(noAdsLabelButton)
        
        ballPackLabelButton = SKSpriteNode(imageNamed: "AgedEmeraldRectangle.png")
        ballPackLabelButton.position = CGPoint(x: frame.width * 0.70, y: purchaseBlackBallButton.position.y + (frame.height * 0.14))
        ballPackLabelButton.scale(to: CGSize(width: frame.width * 0.35, height: frame.width * 0.1))
        addChild(ballPackLabelButton)
        
        cartEmitter1 = SKEmitterNode()
        cartEmitter1.particleTexture = SKTexture(imageNamed: "vector_cart.png")
        cartEmitter1.particlePositionRange = CGVector(dx: frame.width * 7/8, dy: 0)
        cartEmitter1.particleScale = 0.10
        cartEmitter1.particlePosition = CGPoint(x: frame.width/2, y: -2/50 * frame.height)
        cartEmitter1.particleLifetime = 6
        cartEmitter1.particleBirthRate = 0.65
        cartEmitter1.particleSpeed = 30
        cartEmitter1.yAcceleration = 60
        cartEmitter1.zPosition = -6
        cartEmitter1.particleColorBlendFactor = 0.50
        cartEmitter1.particleColorBlendFactorSpeed = 0.20
        cartEmitter1.advanceSimulationTime(1.5)
        addChild(cartEmitter1)
        
        cartEmitter2 = SKEmitterNode()
        cartEmitter2.particleTexture = SKTexture(imageNamed: "vector_cart.png")
        cartEmitter2.particlePositionRange = CGVector(dx: frame.width * 7/8, dy: 0)
        cartEmitter2.particleScale = 0.10
        cartEmitter2.particlePosition = CGPoint(x: frame.width/2, y: 51/50 * frame.height)
        cartEmitter2.particleLifetime = 6
        cartEmitter2.particleBirthRate = 0.65
        cartEmitter2.particleSpeed = 30
        cartEmitter2.yAcceleration = -60
        cartEmitter2.zPosition = -6
        cartEmitter2.particleColorBlendFactor = 0.50
        cartEmitter2.particleColorBlendFactorSpeed = 0.20
        cartEmitter2.advanceSimulationTime(1.5)
        addChild(cartEmitter2)
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
            else if nodesArray.contains(purchaseBallPackBackgroundButton)
            {
                purchaseBallPackBackgroundButton.colorBlendFactor = 0.5
                ballPackLabelButton.colorBlendFactor = 0.5
                touchedBuyColorPack = true
            }
            else if nodesArray.contains(purchaseNoAdsBackgroundButton)
            {
                purchaseNoAdsBackgroundButton.colorBlendFactor = 0.5
                noAdsLabelButton.colorBlendFactor = 0.5
                touchedBuyNoAds = true
            }
            else if nodesArray.contains(restorePurchasesButton)
            {
                restorePurchasesButton.colorBlendFactor = 0.5
                touchedRestore = true
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
            else if nodesArray.contains(purchaseBallPackBackgroundButton) && touchedBuyColorPack == true
            {
                if UserDefaults.standard.string(forKey: "Sound") == "On" {run(buttonSound)}
                else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                else{run(buttonSound)}
                purchaseBallPackBackgroundButton.colorBlendFactor = 0
                ballPackLabelButton.colorBlendFactor = 0
                touchedBuyColorPack = false
                if UserDefaults.standard.bool(forKey: "PurchaseBlackBall") == true
                {
                    self.view?.window?.rootViewController?.present(alertController7, animated: true, completion: nil)
                    purchaseBlackBallLabel.text = "Purchased!"
                }
                else
                {
                    IAPService.shared.purchase(product: .purchaseBlackBall)
                }
            }
            else if nodesArray.contains(purchaseNoAdsBackgroundButton) && touchedBuyNoAds == true
            {
                if UserDefaults.standard.string(forKey: "Sound") == "On" {run(buttonSound)}
                else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                else{run(buttonSound)}
                purchaseNoAdsBackgroundButton.colorBlendFactor = 0
                noAdsLabelButton.colorBlendFactor = 0
                touchedBuyNoAds = false
                if UserDefaults.standard.bool(forKey: "Purchase") == true
                {
                    self.view?.window?.rootViewController?.present(alertController6, animated: true, completion: nil)
                    removeAdsLabel.text = "Purchased!"
                }
                else
                {
                    IAPService.shared.purchase(product: .removeAds)
                }
            }
            else if nodesArray.contains(restorePurchasesButton) && touchedRestore == true
            {
                if UserDefaults.standard.string(forKey: "Sound") == "On" {run(buttonSound)}
                else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                else{run(buttonSound)}
                restorePurchasesButton.colorBlendFactor = 0
                touchedRestore = false
                if UserDefaults.standard.bool(forKey: "Purchase") == true && UserDefaults.standard.bool(forKey: "PurchaseBlackBall") == true
                {
                    purchaseBlackBallLabel.text = "Purchased!"
                    removeAdsLabel.text = "Purchased!"
                    self.view?.window?.rootViewController?.present(alertController2, animated: true, completion: nil)
                }
                else
                {
                    IAPService.shared.restorePurchases()
                }
            }
            else
            {
                if touchedMenu == true
                {
                    backToMenuButton.colorBlendFactor = 0
                    touchedMenu = false
                }
                if touchedBuyColorPack == true
                {
                    purchaseBallPackBackgroundButton.colorBlendFactor = 0
                    ballPackLabelButton.colorBlendFactor = 0
                    touchedBuyColorPack = false
                }
                if touchedBuyNoAds == true
                {
                    purchaseNoAdsBackgroundButton.colorBlendFactor = 0
                    noAdsLabelButton.colorBlendFactor = 0
                    touchedBuyNoAds = false
                }
                if touchedRestore == true
                {
                    restorePurchasesButton.colorBlendFactor = 0
                    touchedRestore = false
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval)
    {
        if UserDefaults.standard.bool(forKey: "RestoredColorPack") == true && UserDefaults.standard.bool(forKey: "RestoredRemoveAds") == true
        {
            UserDefaults.standard.set(false, forKey: "RestoredRemoveAds")
            UserDefaults.standard.synchronize()
            
            UserDefaults.standard.set(false, forKey: "RestoredColorPack")
            UserDefaults.standard.synchronize()
            
            self.view?.window?.rootViewController?.present(alertController5, animated: true, completion: nil)
            removeAdsLabel.text = "Purchased!"
            purchaseBlackBallLabel.text = "Purchased!"
        }
        
        if UserDefaults.standard.bool(forKey: "RestoredRemoveAds") == true && UserDefaults.standard.bool(forKey: "RestoredColorPack") == false
        {
            UserDefaults.standard.set(false, forKey: "RestoredRemoveAds")
            UserDefaults.standard.synchronize()

            self.view?.window?.rootViewController?.present(alertController3, animated: true, completion: nil)
            removeAdsLabel.text = "Purchased!"
        }
        if UserDefaults.standard.bool(forKey: "RestoredColorPack") == true && UserDefaults.standard.bool(forKey: "RestoredRemoveAds") == false
        {
            UserDefaults.standard.set(false, forKey: "RestoredColorPack")
            UserDefaults.standard.synchronize()
            
            self.view?.window?.rootViewController?.present(alertController4, animated: true, completion: nil)
            purchaseBlackBallLabel.text = "Purchased!"
        }
    }
}
