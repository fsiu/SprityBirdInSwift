//
//  BirdNode.swift
//  SprityBirdInSwift
//
//  Created by Frederick Siu on 6/6/14.
//  Copyright (c) 2014 Frederick Siu. All rights reserved.
//

import Foundation
import SpriteKit

class BirdNode: SKSpriteNode {
    
    let VERTICAL_SPEED = 1.0;
    let VERTICAL_DELTA = 5.0;
    
    var deltaPosY = 0.0;
    var goingUp = false;
    
    var flap: SKAction!
    var flapForever: SKAction!
    
    class func instance() -> BirdNode {
        let birdTexture1 = SKTexture(imageNamed: "bird_1");
        let birdTexture2 = SKTexture(imageNamed: "bird_2");
        let birdTexture3 = SKTexture(imageNamed: "bird_3");
        birdTexture1.filteringMode = SKTextureFilteringMode.nearest;
        birdTexture2.filteringMode = SKTextureFilteringMode.nearest;
        birdTexture3.filteringMode = SKTextureFilteringMode.nearest;

        let result = BirdNode(texture:SKTexture(imageNamed: "bird_1"));
        
        result.flap = SKAction.animate(with: [birdTexture1, birdTexture2, birdTexture3], timePerFrame: 0.2)
        result.flapForever = SKAction.repeatForever(result.flap);
        
        result.run(result.flapForever, withKey: "flapForever");
        
        return result;
    }
    
    func update(_ currentTime: TimeInterval) {
        if(self.physicsBody == nil) {
            if(self.deltaPosY > VERTICAL_DELTA) {
                self.goingUp = false;
            }
            if(self.deltaPosY < -VERTICAL_DELTA) {
                self.goingUp = true;
            }
            
            let displacement = self.goingUp ? VERTICAL_SPEED : -VERTICAL_SPEED;
            self.position = CGPoint(x: self.position.x, y: self.position.y);
            self.deltaPosY += displacement;
            
        } else {
            self.zRotation = CGFloat(M_PI) * self.physicsBody!.velocity.dy * 0.0005;
        }
    }
    
    func startPlaying() {
        self.deltaPosY = 0;
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 26, height: 18));
        self.physicsBody!.categoryBitMask = Constants.BIRD_BIT_MASK;
        self.physicsBody!.mass = 0.1;
        self.removeAction(forKey: "flapForever");
    }
    
    func bounce() {
        if(self.physicsBody != nil) {
            self.physicsBody!.velocity = CGVector(dx: 0, dy: 0);
            self.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 40));
            self.run(self.flap)
        }
    }
    
}
