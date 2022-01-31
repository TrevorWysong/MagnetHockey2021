//
//  Goal.swift
//  MagnetHockey
//
//  Created by Wysong, Trevor on 1/23/22.
//  Copyright © 2022 Wysong, Trevor. All rights reserved.
//

import SpriteKit

class GoalCircle: SKSpriteNode
{
    init(topGoal: Bool)
    {
        var goalSize: CGSize
        if deviceType.contains("iPad")
        {
            goalSize = CGSize(width: screenWidth/7.5, height: screenWidth/7.5)
        }
        else
        {
            goalSize = CGSize(width: screenWidth/6, height: screenWidth/6)
        }
        
        super.init(texture: SKTexture(imageNamed: "goal.png"), color: UIColor.clear, size: goalSize)
        
        if hasTopNotch == true && !deviceType.contains("iPad")
        {
            if topGoal == true
            {
                position = CGPoint(x: screenWidth/2, y: screenHeight * 0.84)
            }
            else
            {
                position = CGPoint(x: screenWidth/2, y: screenHeight * 0.16)
            }
        }
        else
        {
            if topGoal == true
            {
                position = CGPoint(x: screenWidth/2, y: screenHeight * (8.7/10))
            }
            else
            {
                position = CGPoint(x: screenWidth/2, y: screenHeight * 1.30/10)
            }
        }
        scale(to: goalSize)
        zPosition = -1
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
