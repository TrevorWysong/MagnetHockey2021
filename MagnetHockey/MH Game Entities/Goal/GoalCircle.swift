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
    init()
    {        
        let hitMarkerSize = CGSize(width: 30, height: 30)
        
        super.init(texture: SKTexture(imageNamed: "goal.png"), color: UIColor.clear, size: hitMarkerSize)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
