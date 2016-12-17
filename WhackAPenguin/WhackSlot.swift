//
//  WhackSlot.swift
//  WhackAPenguin
//
//  Created by Noah Patterson on 12/17/16.
//  Copyright © 2016 noahpatterson. All rights reserved.
//

import UIKit
import SpriteKit

class WhackSlot: SKNode {

    func configure(at position: CGPoint) {
        self.position = position
        let sprite = SKSpriteNode(imageNamed: "whackHole")
        
        addChild(sprite)
    }
}
