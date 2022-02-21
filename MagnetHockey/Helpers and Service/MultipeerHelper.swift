//
//  MultipeerHelper.swift
//  MagnetHockey
//
//  Created by Wysong, Trevor on 2/9/22.
//  Copyright © 2022 Wysong, Trevor. All rights reserved.
//

import MultipeerConnectivity

class MultipeerHelper: NSObject, MCSessionDelegate, MCBrowserViewControllerDelegate
{
    var peerID:MCPeerID!
    var session:MCSession!
    var browser:MCBrowserViewController!
    var advertiser:MCAdvertiserAssistant? = nil
    var playerPosition = Float(0.0)
    var client = false
    var host = false


    func setupPeerWithDisplayName (displayName:String)
    {
        peerID = MCPeerID(displayName: displayName)
    }

    func setupSession()
    {
        session = MCSession(peer: peerID)
        session.delegate = self
    }

    func killSession()
    {
        advertiser?.stop()
        session.disconnect()
    }

    func setupBrowser()
    {
        browser = MCBrowserViewController(serviceType: "air-hockey", session: session)
        client = true
    }

    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController)
    {
        browserViewController.dismiss(animated: true, completion: nil)
        if session.connectedPeers.count == 1
        {
            multipeerGameReady = true
            client = true
            // Open Game
        }
    }

    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController)
    {
        browserViewController.dismiss(animated: true, completion: nil)
        session.disconnect()
    }

    func advertiseSelf(advertise:Bool)
    {
        if advertise
        {
            advertiser = MCAdvertiserAssistant(serviceType: "air-hockey", discoveryInfo: nil, session: session)
            advertiser!.start()
        }
        else
        {
            advertiser!.stop()
            advertiser = nil
        }
    }

    func sendData(variable: String)
    {
        //Send Data
        guard let data = variable.data(using: .utf8) else { return }

        do
        {
            try session.send(data, toPeers: session.connectedPeers, with: .unreliable)
        }
        catch _ as NSError
        {
            print("Error: Cannot send Message.")
        }
    }

    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState)
    {

    }

    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?)
    {

    }

//    func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID)
//    {
//        //Receive Data
//        let string = String(bytes: data, encoding: .utf8)
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "receivedMPCDataNotification"), object: string)
//    }
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID)
    {
        if let positionString = String(data: data, encoding: .utf8), let positionFloat = Float(positionString)
        {
//            print("didReceive position \(string)")
            DispatchQueue.main.async
            {
                self.playerPosition = positionFloat
            }
        }
        else
        {
            print("didReceive invalid value \(data.count) bytes")
        }
    }

    func session(session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, atURL localURL: NSURL, withError error: NSError?)
    {

    }

    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress)
    {

    }

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID)
    {

    }

    func startHosting() {
        guard let session = session else { return }
        advertiser = MCAdvertiserAssistant(serviceType: "air-hockey", discoveryInfo: nil, session: session)
        advertiser?.start()
        host = true
        client = false
    }

    func stopHosting()
    {
        guard let session = session else { return }
        advertiser = MCAdvertiserAssistant(serviceType: "air-hockey", discoveryInfo: nil, session: session)
        advertiser?.stop()
        host = false
        client = false
    }

    func joinSession()
    {
        stopHosting()
        guard let session = session else { return }
        let browser = MCBrowserViewController(serviceType: "air-hockey", session: session)
        browser.delegate = self
        let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .compactMap({$0 as? UIWindowScene})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        keyWindow?.rootViewController?.present(browser, animated: true)
    }
}
