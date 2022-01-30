//
//  Ball.swift
//  MagnetHockey
//
//  Created by Wysong, Trevor on 1/24/22.
//  Copyright © 2022 Wysong, Trevor. All rights reserved.
//

import SpriteKit

class Ball: SKShapeNode
{
    var radius = CGFloat()
    
    override init()
    {
        if deviceType.contains("iPad")
        {
            radius = screenWidth / 25
        }
        else
        {
            radius = screenWidth / 20
        }
        
        super.init()

        //draw ball
        let ballPath = CGMutablePath()
        let π = CGFloat.pi
        let ballRadius = radius
        
        ballPath.addArc(center: CGPoint(x: 0, y:0), radius: ballRadius, startAngle: 0, endAngle: π*2, clockwise: true)
        path = ballPath
        lineWidth = 0
        
        if KeychainWrapper.standard.string(forKey: "BallColor") == "Black Ball"
        {
            fillColor = UIColor.black
        }
        else if KeychainWrapper.standard.string(forKey: "BallColor") == "Blue Ball"
        {
            fillColor = UIColor.blue
        }
        else if KeychainWrapper.standard.string(forKey: "BallColor") == "Orange Ball"
        {
            fillColor = UIColor.orange
        }
        else if KeychainWrapper.standard.string(forKey: "BallColor") == "Pink Ball"
        {
            fillColor = UIColor.systemPink
        }
        else if KeychainWrapper.standard.string(forKey: "BallColor") == "Purple Ball"
        {
            fillColor = UIColor.purple
        }
        else if KeychainWrapper.standard.string(forKey: "BallColor") == "Green Ball"
        {
            fillColor = UIColor.green
        }
        else if KeychainWrapper.standard.string(forKey: "BallColor") == "Red Ball"
        {
            fillColor = UIColor.red
        }
        else
        {
            fillColor = UIColor.yellow
            KeychainWrapper.standard.set("Yellow", forKey: "BallColor")
        }
        
        //set ball physics properties
        physicsBody = SKPhysicsBody(circleOfRadius: ballRadius)
        
        //how heavy it is
        physicsBody!.mass = 0.015
        physicsBody?.friction = 0.10
        physicsBody!.affectedByGravity = false
        
        //how much momentum is maintained after it hits somthing
        physicsBody!.restitution = 1.00
        
        //how much friction affects it
        physicsBody!.linearDamping = 0.90
        physicsBody!.angularDamping = 0.90

        physicsBody?.categoryBitMask = BodyType.ball.rawValue
        physicsBody?.fieldBitMask = 640
        physicsBody?.contactTestBitMask = BodyType.player.rawValue
        lineWidth = 2
        strokeColor = UIColor.black
        
        let ySpawnsArray = [screenHeight * 0.35, screenHeight * 0.65]
        position = CGPoint(x: screenWidth/2, y: ySpawnsArray.randomElement()!)
        physicsBody!.velocity = CGVector(dx: 0, dy: 0)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func clearBall()
    {
        position = CGPoint(x: -200, y: -200)
        physicsBody!.velocity = CGVector(dx: 0, dy: 0)
    }
    
    func resetBallTopPlayerBallStart()
    {
        position = CGPoint(x: screenWidth/2, y: screenHeight * (0.65))
        physicsBody!.velocity = CGVector(dx: 0, dy: 0)
    }
    
    func resetBallBottomPlayerBallStart()
    {
        position = CGPoint(x: screenWidth/2, y: screenHeight * 0.35)
        physicsBody!.velocity = CGVector(dx: 0, dy: 0)
    }
    
}
