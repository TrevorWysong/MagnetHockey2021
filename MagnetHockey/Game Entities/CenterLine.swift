//
//  CenterLine.swift
//  MagnetHockey
//
//  Created by Wysong, Trevor on 1/30/22.
//  Copyright © 2022 Wysong, Trevor. All rights reserved.
//

import SpriteKit

class CenterLine: SKSpriteNode
{
    init()
    {
        var lineSize: CGSize
        
        if deviceType.contains("iPad")
        {
            lineSize = CGSize(width: screenWidth, height: screenWidth/102.5)
        }
        else
        {
            lineSize = CGSize(width: screenWidth, height: screenWidth/82)
        }

        super.init(texture: nil, color: UIColor.black, size: lineSize)
        
        position = CGPoint(x: screenWidth/2, y: screenHeight/2)
        colorBlendFactor = 0.75;
        zPosition = -110
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
