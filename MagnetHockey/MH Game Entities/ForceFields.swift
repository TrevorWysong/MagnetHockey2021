//
//  SpringField.swift
//  MagnetHockey
//
//  Created by Wysong, Trevor on 1/30/22.
//  Copyright © 2022 Wysong, Trevor. All rights reserved.
//
import SpriteKit

class ForceFields
{
    static let shared = ForceFields()
    
    func createPlayerSpringField(springField: SKFieldNode, playerPosition: CGPoint, playerRadius: Float) -> SKFieldNode
    {
        springField.strength = 1.5
        springField.position = playerPosition
        springField.falloff = 0.0
        springField.categoryBitMask = 5
        springField.region = SKRegion(radius: playerRadius + (playerRadius * 0.60))
        return springField
    }
    
    func createGoalSpringField(springField: SKFieldNode, goalPosition: CGPoint, goalRadius: Float) -> SKFieldNode
    {
        springField.strength = 0.2
        springField.position = goalPosition
        springField.falloff = 0
        springField.physicsBody?.collisionBitMask = 3
        springField.physicsBody?.fieldBitMask = 3
        springField.physicsBody?.contactTestBitMask = 3
        springField.categoryBitMask = 64
        springField.region = SKRegion(radius: goalRadius)
        return springField
    }
    
    func createPlayerElectricField(electricField: SKFieldNode, playerPosition: CGPoint, playerRadius: Float) -> SKFieldNode
    {
        electricField.strength = 1.5
        electricField.position = playerPosition
        electricField.falloff = 0.0
        electricField.isEnabled = true
        electricField.categoryBitMask = 5
        electricField.region = SKRegion(radius: playerRadius + (playerRadius * 0.75))
        return electricField
    }
}
