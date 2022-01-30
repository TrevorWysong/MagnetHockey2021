//
//  CenterCircle.swift
//  MagnetHockey
//
//  Created by Wysong, Trevor on 1/29/22.
//  Copyright © 2022 Wysong, Trevor. All rights reserved.
//

import SpriteKit

class CenterCircle: SKSpriteNode
{
    init()
    {
        var textureImage: String
        
        if deviceType.contains("iPad")
        {
            textureImage = "centerCircleFixediPadFinal.png"
        }
        else
        {
            textureImage = "centerCircleFixed.png"
        }
        
        super.init(texture: SKTexture(imageNamed: textureImage), color: UIColor.clear, size: CGSize(width: screenWidth * 0.415, height: screenWidth * 0.415))
        
        position = CGPoint(x: screenWidth/2, y: screenHeight/2)
        zPosition = -100
        colorBlendFactor = 0.50
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
