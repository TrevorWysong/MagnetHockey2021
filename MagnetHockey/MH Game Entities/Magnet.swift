//
//  Magnet.swift
//  MagnetHockey
//
//  Created by Wysong, Trevor on 1/23/22.
//  Copyright © 2022 Wysong, Trevor. All rights reserved.
//

import SpriteKit

class Magnet: SKShapeNode
{
    var radius = CGFloat()
    
    init(categoryBitMask: UInt32)
    {
        if deviceType.contains("iPad")
        {
            radius = screenWidth / 50
        }
        else
        {
            radius = screenWidth / 40
        }
        
        //ensure we pass the init call to the base class
        super.init()
        
        //draw left magnet
        let circularMagnetPath = CGMutablePath()
        let π = CGFloat.pi

        fillColor = UIColor.white
        fillTexture = SKTexture(imageNamed: "newMagnetSmaller.png")
        strokeColor = .black
        lineWidth = 0.5
        circularMagnetPath.addArc(center: CGPoint(x: 0, y:0), radius: radius, startAngle: 0, endAngle: π*2, clockwise: true)
        path = circularMagnetPath
        //set ball physics properties
        physicsBody = SKPhysicsBody(circleOfRadius: radius)
        //how heavy it is
        physicsBody!.mass = 0.04
        physicsBody!.affectedByGravity = false
        physicsBody?.allowsRotation = true
        //how much momentum is maintained after it hits somthing
        physicsBody!.restitution = 1
        position = CGPoint(x: frame.width * 1.5/5, y: frame.height/2)
        //how much friction affects it
        physicsBody!.linearDamping = 0.85
        physicsBody!.angularDamping = 0.85
    
        physicsBody?.collisionBitMask = 4294967295
        physicsBody?.contactTestBitMask = 4294967295
        physicsBody?.categoryBitMask = categoryBitMask
        
        if UserDefaults.standard.string(forKey: "GameType") == "GameMode1"
        {
            physicsBody?.charge = 0.70
        }

    }
    
    func clearMagnet()
    {
        position = CGPoint(x: 0 * frame.width, y: -350)
        physicsBody?.velocity = CGVector(dx: 0, dy: 0)
    }
    
    func resetMagnet(resetPosition: CGPoint)
    {
        position = resetPosition
        physicsBody?.velocity = CGVector(dx: 0, dy: 0)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
}
