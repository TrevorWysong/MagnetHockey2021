//
//  BotPlayer.swift
//  BotPlayer
//
//  Created by Wysong, Trevor on 10/8/21.
//  Copyright © 2021 Wysong, Trevor. All rights reserved.
//
//  Originally started by Wysong, Trevor on 6/8/20.

import SpriteKit

protocol BotPlayerDelegate : class
{
//    func botForce(_ force: CGVector, fromBotPlayer botPlayer: BotPlayer)
    func botTouchIsActive(_ botTouchIsActive: Bool, fromBotPlayer botPlayer: BotPlayer)
}

class BotPlayer: SKShapeNode
{
    //keep track of previous touch time (will use to calculate vector)
    var lastTouchTimeStamp: Double?
    
    //delegate will refer to class which will act on player force
    weak var delegate:BotPlayerDelegate?
    
    //this will determine the allowable area for the player
    let activeArea:CGRect
    
    var botTouchIsActive = false
    
    //define player size
    var radius:CGFloat
    
    //when we instantiate the class we will set the active area
    init(activeArea: CGRect)
    {
        let screenRect = UIScreen.main.bounds
        let screenWidth = screenRect.size.width
        
        if UserDefaults.standard.string(forKey: "Game") != "Air Hockey"
        {
            if screenWidth > 700
            {
                radius = screenWidth/15
            }
            else
            {
                radius = screenWidth/11
            }
        }
        else
        {
            if screenWidth > 700
            {
                radius = screenWidth/12
            }
            else
            {
                radius = screenWidth/9
            }
        }
        
        //set the active area variable this class with the variable passed in
        self.activeArea = activeArea
        
        //ensure we pass the init call to the base class
        super.init()
        
        //allow the player to handle touch events
        isUserInteractionEnabled = false
        
        //create a mutable path (later configured as a circle)
        let circularPath = CGMutablePath()
        
        //define pi as CGFloat (type π using alt-p)
        let π = CGFloat.pi
        
               
        //create the circle shape
        circularPath.addArc(center: CGPoint(x: 0, y:0), radius: radius, startAngle: 0, endAngle: 2*π, clockwise: true)
       // CGPathAddArc(circularPath, nil, 0, 0, radius, 0, π*2, true)
        
        //assign the path to this SKShapeNode's path property
        path = circularPath
        
        lineWidth = 0;
        
        fillColor = .white
        fillTexture = SKTexture(imageNamed: "AirHockeyMallet1.png")
        
        
        //set physics properties (note physicsBody is an optional)
        physicsBody = SKPhysicsBody(circleOfRadius: radius)
        physicsBody!.mass = 500;
        physicsBody?.categoryBitMask = BodyType.player.rawValue
        physicsBody!.affectedByGravity = false;
        physicsBody?.linearDamping = 1
        physicsBody?.angularDamping = 1
        physicsBody?.friction = 1

    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
//    {
//        botTouchIsActive = true
//        var releventTouch:UITouch!
//        //convert set to known type
//        let touchSet = touches
//
//        //get array of touches so we can loop through them
//        let orderedTouches = Array(touchSet)
//
//
//        for touch in orderedTouches
//        {
//            //if we've not yet found a relevent touch
//            if releventTouch == nil
//            {
//                //look for a touch that is in the activeArea (Avoid touches by opponent)
//                if activeArea.contains(CGPoint(x: touch.location(in: parent!).x, y: touch.location(in: parent!).y - frame.height * 0.42))
//                {
//                    isUserInteractionEnabled = true
//                    releventTouch = touch
//                }
//                else
//                {
//                    releventTouch = nil
//                }
//            }
//        }
//
//        if (releventTouch != nil)
//        {
//            //get touch position and relocate player
////            let location = releventTouch!.location(in: parent!)
//            let location = CGPoint(x: releventTouch!.location(in: parent!).x, y: releventTouch!.location(in: parent!).y - frame.height * 0.42)
//            position = location
//
//            //find old location and use pythagoras to determine length between both points
////            let oldLocation = releventTouch!.previousLocation(in: parent!)
//            let oldLocation = CGPoint(x: releventTouch!.previousLocation(in: parent!).x, y: releventTouch!.previousLocation(in: parent!).y - frame.height * 0.42)
//            let xOffset = location.x - oldLocation.x
//            let yOffset = location.y - oldLocation.y
//            let vectorLength = sqrt(xOffset * xOffset + yOffset * yOffset)
//
//            //get eleapsed and use to calculate speed
//            if  lastTouchTimeStamp != nil
//            {
//                let seconds = releventTouch.timestamp - lastTouchTimeStamp!
//                let velocity = 0.01 * Double(vectorLength) / seconds
//
//                //to calculate the vector, the velcity needs to be converted to a CGFloat
//                let velocityCGFloat = CGFloat(velocity)
//
//                //calculate the impulse
//                let directionVector = CGVector(dx: velocityCGFloat * xOffset / vectorLength, dy: velocityCGFloat * yOffset / vectorLength)
//
//                //pass the vector to the scene (so it can apply an impulse to the puck)
//                delegate?.botForce(directionVector, fromBotPlayer: self)
//                delegate?.botTouchIsActive(botTouchIsActive, fromBotPlayer: self)
//            }
//            //update latest touch time for next calculation
//            lastTouchTimeStamp = releventTouch.timestamp
//        }
//    }
//
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
//    {
//        botTouchIsActive = false
//        delegate?.botTouchIsActive(botTouchIsActive, fromBotPlayer: self)
//    }
}
