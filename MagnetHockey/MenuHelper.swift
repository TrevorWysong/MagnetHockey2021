//
//  GeneralMenuHelper.swift
//  GeneralMenuHelper
//
//  Created by Wysong, Trevor on 11/10/21.
//  Copyright © 2021 Wysong, Trevor. All rights reserved.
//
import SpriteKit

class MenuHelper
{
    static let shared = MenuHelper()

    func createEdges(frame: CGRect) -> (SKSpriteNode, SKSpriteNode, SKSpriteNode, SKSpriteNode)
    {
        let edgeWidth = frame.width * 0.03
        let notchOffset = frame.height * 0.0625
        
        let leftEdge = SKSpriteNode(color: UIColor.systemBlue, size: CGSize(width: edgeWidth, height: frame.height))
        let rightEdge = SKSpriteNode(color: UIColor.systemBlue, size: CGSize(width: edgeWidth, height: frame.height))
        let bottomEdge = SKSpriteNode(color: UIColor.systemBlue, size: CGSize(width: frame.width, height: edgeWidth))
        let topEdge = SKSpriteNode(color: UIColor.systemBlue, size: CGSize(width: frame.width, height: edgeWidth))
        
        leftEdge.position = CGPoint(x: 0 + edgeWidth/2, y: frame.height/2)
        leftEdge.zPosition = 100
        rightEdge.position = CGPoint(x: frame.width - edgeWidth/2, y: frame.height/2)
        rightEdge.zPosition = 100

        if frame.height > 800 && frame.width < 500
        {
            bottomEdge.size.height = notchOffset
            topEdge.size.height = notchOffset
            bottomEdge.position = CGPoint(x: frame.width * 0.5, y: 0 + notchOffset/2)
            topEdge.position = CGPoint(x: frame.width * 0.5, y: frame.height - notchOffset/2)
        }
        else
        {
            bottomEdge.size.height = edgeWidth
            topEdge.size.height = edgeWidth
            bottomEdge.position = CGPoint(x: frame.width * 0.5, y: 0 + edgeWidth/2)
            topEdge.position = CGPoint(x: frame.width * 0.5, y: frame.height - edgeWidth/2)
        }
        bottomEdge.zPosition = -5
        topEdge.zPosition = -5
        return (leftEdge, rightEdge, bottomEdge, topEdge)
    }
    func createBackground(frame: CGRect) -> (SKSpriteNode)
    {
        let background = SKSpriteNode(imageNamed: "icyBackground3.png")
        background.blendMode = .replace
        background.position = CGPoint(x: frame.width/2, y: frame.height/2)
        background.scale(to: CGSize(width: frame.width, height: frame.height))
        background.colorBlendFactor = 0
        background.zPosition = -100
        return background
    }
    
    func createTopBackgroundEmitter(frame: CGRect, emitter: SKEmitterNode, scale: CGFloat, image: SKTexture) -> (SKEmitterNode)
    {
        emitter.particleTexture = image
        emitter.particlePositionRange = CGVector(dx: frame.width * 7/8, dy: 0)
        emitter.particleScale = scale
        emitter.particlePosition = CGPoint(x: frame.width/2, y: -2/50 * frame.height)
        emitter.particleLifetime = 6
        emitter.particleBirthRate = 0.65
        emitter.particleSpeed = 30
        emitter.yAcceleration = 60
        emitter.zPosition = -6
        emitter.particleColorBlendFactor = 0.50
        emitter.particleColorBlendFactorSpeed = 0.20
        emitter.advanceSimulationTime(1.5)
        return (emitter)
    }
    
    func createBottomBackgroundEmitter(frame: CGRect, emitter: SKEmitterNode, scale: CGFloat, image: SKTexture) -> (SKEmitterNode)
    {
        emitter.particleTexture = image
        emitter.particlePositionRange = CGVector(dx: frame.width * 7/8, dy: 0)
        emitter.particleScale = scale
        emitter.particlePosition = CGPoint(x: frame.width/2, y: 51/50 * frame.height)
        emitter.particleLifetime = 6
        emitter.particleBirthRate = 0.65
        emitter.particleSpeed = 30
        emitter.yAcceleration = -60
        emitter.zPosition = -6
        emitter.particleColorBlendFactor = 0.50
        emitter.particleColorBlendFactorSpeed = 0.20
        emitter.advanceSimulationTime(1.5)
        return (emitter)
    }
    
    func createBackToMenuButton(frame: CGRect, menuButton: SKSpriteNode) -> (SKSpriteNode)
    {
        menuButton.blendMode = .replace
        menuButton.position = CGPoint(x: frame.width/2, y: frame.height * 0.17)
        menuButton.scale(to: CGSize(width: frame.width * 2/3, height: frame.height/10))
        menuButton.colorBlendFactor = 0
        return (menuButton)
    }
    
    func createBackToMenuLabel(frame: CGRect, menuLabel: SKLabelNode) -> (SKLabelNode)
    {
        menuLabel.fontSize = frame.width/17.5
        menuLabel.fontColor = SKColor.white
        menuLabel.horizontalAlignmentMode = .center
        menuLabel.verticalAlignmentMode = .center
        menuLabel.position = CGPoint(x: frame.width/2, y: frame.height * 0.17)
        menuLabel.zPosition = 2
        menuLabel.text = "Back to Menu"
        return (menuLabel)
    }
    
    func createText(frame: CGRect, textName: SKLabelNode, text: String, position: CGPoint, iPhoneFontSize: CGFloat, iPadFontSize: CGFloat, color: SKColor, zPos: CGFloat) -> SKLabelNode
    {
        // set size, color, position and text of the gameWinnerLabel
        if frame.width < 600
        {
            textName.fontSize = iPhoneFontSize
        }
        else
        {
            textName.fontSize = iPadFontSize
        }
        textName.fontColor = color
        textName.horizontalAlignmentMode = .center
        textName.verticalAlignmentMode = .center
        textName.position = position
        textName.zPosition = zPos
        textName.text = text
        return textName
    }
}
