//
//  GoalCollisionPlus.swift
//  MagnetHockey
//
//  Created by Wysong, Trevor on 1/30/22.
//  Copyright © 2022 Wysong, Trevor. All rights reserved.
//

import SpriteKit

//Plus is for the goal sprites detecting collision in the goal
class GoalCollisionPlus: SKSpriteNode
{
    init(goalPosition: CGPoint, topGoal: Bool)
    {
        var goalCollisionPlusSize: CGSize
        
        if deviceType.contains("iPad")
        {
            goalCollisionPlusSize = CGSize(width: screenWidth/50, height: screenWidth/50)
        }
        else
        {
            goalCollisionPlusSize = CGSize(width: screenWidth/40, height: screenWidth/40)
        }
        
        super.init(texture: SKTexture(imageNamed: "plus.png"), color: UIColor.clear, size: goalCollisionPlusSize)
        
        // Set on same Z level as sprites
        zPosition = 0
        // Assign Collision category masks
        physicsBody = SKPhysicsBody(circleOfRadius: max(self.size.width / 2, self.size.height / 2))
        physicsBody?.affectedByGravity = false
        physicsBody?.isDynamic = false
        physicsBody?.allowsRotation = false
        physicsBody?.fieldBitMask = 4294967295
        physicsBody?.contactTestBitMask = BodyType.ball.rawValue
        physicsBody?.collisionBitMask = 4294967295
        position = goalPosition
        
        if topGoal == true
        {
            physicsBody?.categoryBitMask = BodyType.topGoalZone.rawValue
        }
        else
        {
            physicsBody?.categoryBitMask = BodyType.bottomGoalZone.rawValue
        }
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
