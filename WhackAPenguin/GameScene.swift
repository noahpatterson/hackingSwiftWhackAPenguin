//
//  GameScene.swift
//  WhackAPenguin
//
//  Created by Noah Patterson on 12/16/16.
//  Copyright © 2016 noahpatterson. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    var gameScoreLabel: SKLabelNode!
    var score: Int = 0 {
        didSet {
            gameScoreLabel.text = "Score: \(score)"
        }
    }
    
    
    override func didMove(to view: SKView) {
        // add background
        let background = SKSpriteNode(imageNamed: "whackBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        //add score label
        gameScoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        gameScoreLabel.text = "Score: 0"
        gameScoreLabel.position = CGPoint(x: 8, y: 8)
        gameScoreLabel.horizontalAlignmentMode = .left
        gameScoreLabel.fontSize = 48
        addChild(gameScoreLabel)
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
}
