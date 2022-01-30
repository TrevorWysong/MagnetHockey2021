//
//  Tutorial.swift
//  MagnetHockey
//
//  Created by Wysong, Trevor on 1/24/22.
//  Copyright © 2022 Wysong, Trevor. All rights reserved.
//

import SpriteKit

class TutorialHelper
{
    static let shared = TutorialHelper()
    
    func createGlow(glowName: SKShapeNode, glowSize: SKShapeNode) -> SKShapeNode
    {
        //draw left magnet
        let spriteGlowPath = CGMutablePath()
        let π = CGFloat.pi
        var spriteGlowRadius = CGFloat(0.0)
        spriteGlowRadius = glowSize.frame.size.width * 0.55
        
        spriteGlowPath.addArc(center: CGPoint(x: 0, y:0), radius: spriteGlowRadius, startAngle: 0, endAngle: π*2, clockwise: true)
        glowName.path = spriteGlowPath
        glowName.lineWidth = 0
        glowName.fillColor = UIColor.clear
        glowName.zPosition = -9
        glowName.lineWidth = 1
        glowName.strokeColor = UIColor.red
        glowName.glowWidth = 8
        glowName.isHidden = true
        return glowName
    }
    
    //overload function to accept spritenodes as well
    func createGlow(glowName: SKShapeNode, glowSize: SKSpriteNode) -> SKShapeNode
    {
        //draw left magnet
        let spriteGlowPath = CGMutablePath()
        let π = CGFloat.pi
        var spriteGlowRadius = CGFloat(0.0)
        spriteGlowRadius = glowSize.frame.size.width * 0.55
        
        spriteGlowPath.addArc(center: CGPoint(x: 0, y:0), radius: spriteGlowRadius, startAngle: 0, endAngle: π*2, clockwise: true)
        glowName.path = spriteGlowPath
        glowName.lineWidth = 0
        glowName.fillColor = UIColor.clear
        glowName.zPosition = -9
        glowName.lineWidth = 1
        glowName.strokeColor = UIColor.red
        glowName.glowWidth = 8
        glowName.isHidden = true
        return glowName
    }
    
    func glowFlash(glow:SKShapeNode, downSwitch: Bool) -> (Bool)
    {
        if glow.glowWidth >= 8
        {
            glow.glowWidth -= 0.25
            return true
        }
        else if glow.glowWidth < 8 && glow.glowWidth > 0 && downSwitch == true
        {
            glow.glowWidth -= 0.25
            return true
        }
        else if glow.glowWidth < 8 && glow.glowWidth <= 0 && downSwitch == true
        {
            return false
        }
        else if glow.glowWidth < 8 && downSwitch == false
        {
            glow.glowWidth += 0.25
            return false
        }
        else
        {
            return false
        }
    }
    
    func glowFollow(glowName: SKShapeNode, SKShapeToFollow: SKShapeNode)
    {
        if glowName.isHidden != true && SKShapeToFollow.isHidden != true
        {
            glowName.position = SKShapeToFollow.position
        }
    }
    
    func glowFollow(glowName: SKShapeNode, SKSpriteToFollow: SKSpriteNode)
    {
        if glowName.isHidden != true && SKSpriteToFollow.isHidden != true
        {
            glowName.position = SKSpriteToFollow.position
        }
    }
}
