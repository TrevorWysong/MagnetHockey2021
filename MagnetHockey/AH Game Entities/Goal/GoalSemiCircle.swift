//
//  GoalSemiCircle.swift
//  MagnetHockey
//
//  Created by Wysong, Trevor on 1/31/22.
//  Copyright © 2022 Wysong, Trevor. All rights reserved.
//

import SpriteKit

class GoalSemiCircle: SKSpriteNode
{
    init(topGoal: Bool)
    {
        var textureImage: String
        
        if topGoal == true
        {
            textureImage = "semiCircleTop.png"
        }
        else
        {
            textureImage = "semiCircleBottom.png"
        }
        
        super.init(texture: SKTexture(imageNamed: textureImage), color: UIColor.clear, size: CGSize(width: screenWidth * 0.60, height: (screenWidth * 0.60) * 0.48))
        
        if topGoal == true
        {
            position = CGPoint(x: screenWidth/2, y: topGoalEdgeBottom - (self.size.height / 2))
        }
        else
        {
            position = CGPoint(x: screenWidth/2, y: bottomGoalEdgeTop + (self.size.height/2))
        }
        
        zPosition = -15
        colorBlendFactor = 0.90
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
