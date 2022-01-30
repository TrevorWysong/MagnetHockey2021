// APP ID: ca-app-pub-1934152718802892~5598207501
// Main screen AD Unit ID: ca-app-pub-1934152718802892/9617343562
// Game over screen AD Unit ID: ca-app-pub-1934152718802892/4065633981
// Play again button full screen AD Unit ID: ca-app-pub-1934152718802892/4165065703

// Black Ball: TrevorWysong.MagnetHockey.BlackBallNonConsumable
// Remove Ads: TrevorWysong.MagnetHockey.RemoveAds

import SpriteKit
import GoogleMobileAds

var adsAreDisabled = false
var textureAtlas = [SKTextureAtlas]()
var GameIsPaused : Bool?
let deviceType = UIDevice.current.model
let screenRect = UIScreen.main.bounds
let screenWidth = screenRect.size.width
let screenHeight = screenRect.size.height
let screenPixels = screenWidth * screenHeight

extension SKNode {
    class func unarchiveFromFile(_ file : NSString) -> SKNode?
    {
        if let path = Bundle.main.path(forResource: file as String, ofType: "sks")
        {
            let sceneData = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let archiver = NSKeyedUnarchiver(forReadingWith: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as! MagnetHockey
            archiver.finishDecoding()
            return scene
        }
        else
        {
            return nil
        }
    }
}

class GameViewController: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if UIDevice.current.model == "iPad"
        {
            
        }
        else if UIDevice.current.model == "iPhone" || UIDevice.current.model == "iPad"
        {
            
        }
        
        if KeychainWrapper.standard.bool(forKey: "Purchase") != true
        {
            let ads = GADMobileAds.sharedInstance()
            ads.start { status in
              // Optional: Log each adapter's initialization latency.
              let adapterStatuses = status.adapterStatusesByClassName
              for adapter in adapterStatuses {
                let adapterStatus = adapter.value
                NSLog("Adapter Name: %@, Description: %@, Latency: %f", adapter.key,
                adapterStatus.description, adapterStatus.latency)
              }

              // Start loading ads here...
            }
            let bannerADStartScene = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
            bannerADStartScene.adUnitID = "ca-app-pub-9321678829614862/5296995882"
            bannerADStartScene.rootViewController = self
            let req:GADRequest = GADRequest()
            bannerADStartScene.load(req)
            bannerADStartScene.tag = 100
            if view.bounds.height > 800 && view.bounds.width < 600
            {
                bannerADStartScene.frame = CGRect(x: 0, y: view.bounds.height - bannerADStartScene.frame.size.height - (view.bounds.height * 4/100), width: bannerADStartScene.frame.size.width, height: bannerADStartScene.frame.size.height)
            }
            else
            {
                bannerADStartScene.frame = CGRect(x: 0, y: view.bounds.height - bannerADStartScene.frame.size.height, width: bannerADStartScene.frame.size.width, height: bannerADStartScene.frame.size.height)
            }
            view.addSubview(bannerADStartScene)
            
            // create banner ad for game over scene
            let bannerADGameOverScene = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
            bannerADGameOverScene.adUnitID = "ca-app-pub-9321678829614862/7519641022"
            bannerADGameOverScene.rootViewController = self
            let req2:GADRequest = GADRequest()
            bannerADGameOverScene.load(req2)
            bannerADGameOverScene.tag = 101

            if view.bounds.height > 800 && view.bounds.width < 600
            {
                bannerADGameOverScene.frame = CGRect(x: 0, y: view.bounds.height - bannerADGameOverScene.frame.size.height - (view.bounds.height * 4/100), width: bannerADGameOverScene.frame.size.width, height: bannerADGameOverScene.frame.size.height)
            }
            else
            {
                bannerADGameOverScene.frame = CGRect(x: 0, y: view.bounds.height - bannerADGameOverScene.frame.size.height, width: bannerADGameOverScene.frame.size.width, height: bannerADGameOverScene.frame.size.height)
            }
            view.addSubview(bannerADGameOverScene)
            
            let bannerADInfoScene = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
            bannerADInfoScene.adUnitID = "ca-app-pub-9321678829614862/9954232675"
            bannerADInfoScene.rootViewController = self
            let req3:GADRequest = GADRequest()
            bannerADInfoScene.load(req3)
            bannerADInfoScene.tag = 102
            if view.bounds.height > 800 && view.bounds.width < 600
            {
                bannerADInfoScene.frame = CGRect(x: 0, y: view.bounds.height - bannerADInfoScene.frame.size.height - (view.bounds.height * 4/100), width: bannerADInfoScene.frame.size.width, height: bannerADInfoScene.frame.size.height)
            }
            else
            {
                bannerADInfoScene.frame = CGRect(x: 0, y: view.bounds.height - bannerADInfoScene.frame.size.height, width: bannerADInfoScene.frame.size.width, height: bannerADInfoScene.frame.size.height)
            }
            view.addSubview(bannerADInfoScene)
            
            let bannerADSettingsScene = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
            bannerADSettingsScene.adUnitID = "ca-app-pub-9321678829614862/7757645874"
            bannerADSettingsScene.rootViewController = self
            let req4:GADRequest = GADRequest()
            bannerADSettingsScene.load(req4)
            bannerADSettingsScene.tag = 103

            if view.bounds.height > 800 && view.bounds.width < 600
            {
                bannerADSettingsScene.frame = CGRect(x: 0, y: view.bounds.height - bannerADSettingsScene.frame.size.height - (view.bounds.height * 4/100), width: bannerADSettingsScene.frame.size.width, height: bannerADSettingsScene.frame.size.height)
            }
            else
            {
                bannerADSettingsScene.frame = CGRect(x: 0, y: view.bounds.height - bannerADSettingsScene.frame.size.height, width: bannerADSettingsScene.frame.size.width, height: bannerADSettingsScene.frame.size.height)
            }
            view.addSubview(bannerADSettingsScene)
        }
        
        if UserDefaults.standard.string(forKey: "Sound") != "Off"
        {
            SKTAudio.sharedInstance().playBackgroundMusicFadeIn("MenuSong2.mp3")
        }
        startScene()
    }

    func startScene()
    {
        let scene = StartScene(size: view.bounds.size)
        // Configure the view.
        let skView = self.view as! SKView
        skView.isMultipleTouchEnabled = false

        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true

        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .resizeFill

        skView.presentScene(scene)
    }
    
    override func viewWillLayoutSubviews()
    {
    }
    
    override var shouldAutorotate : Bool
    {
        return false
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask
    {
            return UIInterfaceOrientationMask.portrait
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden : Bool
    {
        return true
    }
}

extension UIViewController: GADBannerViewDelegate
{
    public func adViewDidReceiveAd(_ bannerView: GADBannerView)
    {
        print("received ad")
    }
    public func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError)
    {
        print(error)
    }
}
