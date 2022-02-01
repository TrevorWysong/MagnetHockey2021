//
//  MagnetHolder.swift
//  MagnetHockey
//
//  Created by Wysong, Trevor on 1/24/22.
//  Copyright © 2022 Wysong, Trevor. All rights reserved.
//

import SpriteKit

class MagnetHolder: SKSpriteNode
{
    // 1-3: 1 represents left, 2 represents center, 3 represents right
    init(xPos: CGFloat, magnetSize: CGSize)
    {
        let magnetHolderSize = CGSize(width: magnetSize.width * 1.15, height: magnetSize.height * 1.15)
        
        super.init(texture: SKTexture(imageNamed: "magnetSpots.png"), color: UIColor.clear, size: magnetHolderSize)
        
        position = CGPoint(x: xPos, y: screenHeight/2)
        zPosition = -1
        print(position)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
