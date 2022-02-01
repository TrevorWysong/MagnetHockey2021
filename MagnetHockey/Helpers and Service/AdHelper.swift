//
//  AdHelper.swift
//  MagnetHockey
//
//  Created by Wysong, Trevor on 1/24/22.
//  Copyright © 2022 Wysong, Trevor. All rights reserved.
//
//
//import GoogleMobileAds
//
//class AdHelper
//{
//    var interstitialAd: GADInterstitial?
//
//    func createAndLoadInterstitial() -> GADInterstitial
//    {
//        let request = GADRequest()
//        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-9321678829614862/2075742650")
//        interstitial.delegate = self
//        interstitial.load(request)
//        return interstitial
//    }
//    
//    
//    func adMobShowInterAd()
//    {
//        guard interstitialAd != nil && interstitialAd!.isReady else
//        {
//            if UserDefaults.standard.string(forKey: "Sound") != "Off"
//            {
//                SKTAudio.sharedInstance().playBackgroundMusic2("MenuSong3.mp3")
//            }
//            
//            let scene = GameOverScene(size: (view?.bounds.size)!)
//
//            // Configure the view.
//            let skView = self.view!
//            skView.isMultipleTouchEnabled = false
//
//            /* Sprite Kit applies additional optimizations to improve rendering performance */
//            skView.ignoresSiblingOrder = true
//
//            /* Set the scale mode to scale to fit the window */
//            scene.scaleMode = .resizeFill
//            scene.userData = NSMutableDictionary()
//            scene.userData?.setObject(numberRounds, forKey: "gameInfo" as NSCopying)
//            scene.userData?.setObject(whoWonGame, forKey: "gameWinner" as NSCopying)
//            let transition = SKTransition.flipVertical(withDuration: 1)
//            skView.presentScene(scene, transition: transition)
//            return
//        }
//        interstitialAd?.present(fromRootViewController: (self.view?.window?.rootViewController)!)
//    }
//    
//    func interstitialDidDismissScreen(_ ad: GADInterstitial)
//    {
//        if UserDefaults.standard.string(forKey: "Sound") != "Off"
//        {
//            SKTAudio.sharedInstance().playBackgroundMusic2("MenuSong3.mp3")
//        }
//        let scene = GameOverScene(size: (view?.bounds.size)!)
//        
//        // Configure the view.
//        let skView = self.view!
//        skView.isMultipleTouchEnabled = false
//
//        /* Sprite Kit applies additional optimizations to improve rendering performance */
//        skView.ignoresSiblingOrder = true
//
//        /* Set the scale mode to scale to fit the window */
//        scene.scaleMode = .resizeFill
//        scene.userData = NSMutableDictionary()
//        scene.userData?.setObject(numberRounds, forKey: "gameInfo" as NSCopying)
//        scene.userData?.setObject(whoWonGame, forKey: "gameWinner" as NSCopying)
//        let transition = SKTransition.flipVertical(withDuration: 1)
//        skView.presentScene(scene, transition: transition)
//    }

//}
