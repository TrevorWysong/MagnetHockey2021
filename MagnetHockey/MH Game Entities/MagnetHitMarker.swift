//
//  MagnetHitMarker.swift
//  MagnetHockey
//
//  Created by Wysong, Trevor on 1/24/22.
//  Copyright © 2022 Wysong, Trevor. All rights reserved.
//

import SpriteKit

class MagnetHitMarker: SKSpriteNode
{
    init(hitMarkerNum: Int)
    {
        var hitMarkerSize: CGSize
        if deviceType.contains("iPad")
        {
            hitMarkerSize = CGSize(width: 75, height: 75)

        }
        else
        {
            hitMarkerSize = CGSize(width: 30, height: 30)
        }
        
        var hitMarkerPosition: CGPoint
        
        super.init(texture: SKTexture(imageNamed: "magnetHitMarkerNew.png"), color: UIColor.clear, size: hitMarkerSize)
        
        // Hit Marker positioning for bottom player
        if (hitMarkerNum <= 2)
        {
            let xPos = (CGFloat(hitMarkerNum) * size.width) + (screenWidth * 0.003)
            let yPos = CGFloat(size.height + (screenHeight * 0.003))
            hitMarkerPosition = CGPoint(x: xPos, y: yPos)
            
        }
        // Hit marker positioning for top player
        else
        {
            let xPos = (screenWidth - (screenWidth * 0.003)) - (CGFloat(hitMarkerNum - 2) * size.width)
            let yPos = (screenHeight - (screenHeight * 0.003)) - size.height
            hitMarkerPosition = CGPoint(x: xPos, y: yPos)
        }
        position = hitMarkerPosition
        
        zPosition = -1
        isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
}
