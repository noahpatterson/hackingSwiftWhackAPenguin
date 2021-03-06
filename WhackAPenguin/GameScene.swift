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
    var gameOver: SKSpriteNode?
    var playAgainLabel: SKLabelNode?
    var slots = [WhackSlot]()
    var popupTime = 0.85
    var score: Int = 0 {
        didSet {
            gameScoreLabel.text = "Score: \(score)"
        }
    }
    var numRounds = 0
    
    
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
        
        //create rows of slots
        for i in 0..<5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 410)) }
        for i in 0..<4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 320)) }
        for i in 0..<5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 230)) }
        for i in 0..<4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 140)) }
        
        createEnemy()
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location    = touch.location(in: self)
            let tappedNodes = nodes(at: location)
            
            for node in tappedNodes {
                if node.name == "charEnemy" {
                  let whackSlot = node.parent!.parent as! WhackSlot
                    if !whackSlot.isVisible && whackSlot.isHit { continue }
                    
                    whackSlot.hit()
                    score -= 5
                    
                    run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion: false))
                } else if node.name == "charFriend" {
                    let whackSlot = node.parent!.parent as! WhackSlot
                    if !whackSlot.isVisible && whackSlot.isHit { continue }
                    
                    whackSlot.charNode.xScale = 0.85
                    whackSlot.charNode.yScale = 0.85
                    
                    whackSlot.hit()
                    score += 1
                    
                    run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
                } else if node.name == "playAgainLabel" {
                    playAgain()
                }
            }
        }
    }
    
    func createSlot(at position: CGPoint) {
        let slot = WhackSlot()
        slot.configure(at: position)
        addChild(slot)
        slots.append(slot)
    }
    
    func createEnemy() -> Void {
        //end game after 30 rounds
        numRounds += 1
        if numRounds >= 30 {
            for slot in slots {
                slot.hide()
            }
            
            if gameOver == nil {
                gameOver = SKSpriteNode(imageNamed: "gameOver")
                playAgainLabel = SKLabelNode(fontNamed: "Chalkduster")
                
                gameOver!.position = CGPoint(x: 512, y: 385)
                gameOver!.zPosition = 1
                addChild(gameOver!)
                
                playAgainLabel!.text = "Play Again?"
                playAgainLabel!.position = CGPoint(x: 512, y: 300)
                playAgainLabel!.zPosition = 1
                playAgainLabel!.name = "playAgainLabel"
                addChild(playAgainLabel!)
                
            }
            gameOver!.isHidden = false
            
            
            playAgainLabel?.isHidden = false
            
            return
        }
        
        //decrease popup time each time to make the game faster
        popupTime *= 0.991
        
        //shuffle slots
        slots = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: slots) as! [WhackSlot]
        
        //make slot show itself
        slots[0].show(hideTime: popupTime)
        
        //see if more slots should be shown
        if RandomInt(min: 0, max: 12) > 4 {
            slots[1].show(hideTime: popupTime)
        }
        if RandomInt(min: 0, max: 12) > 8 {
            slots[2].show(hideTime: popupTime)
        }
        if RandomInt(min: 0, max: 12) > 10 {
            slots[3].show(hideTime: popupTime)
        }
        if RandomInt(min: 0, max: 12) > 11 {
            slots[4].show(hideTime: popupTime)
        }
        
        //call this function again after a delay
        let minDelay = popupTime / 2.0
        let maxDelay = popupTime * 2
        let delay    = RandomDouble(min: minDelay, max: maxDelay)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            [unowned self] in
            self.createEnemy()
        }
    }
    
    func playAgain() {
        numRounds = 0
        gameOver?.isHidden = true
        playAgainLabel?.isHidden = true
        createEnemy()
    }
}
