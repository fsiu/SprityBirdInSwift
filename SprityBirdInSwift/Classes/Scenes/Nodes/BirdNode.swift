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
    
    var flap: SKAction?
    var flapForever: SKAction?
    
    class func instance() -> BirdNode {
        let birdTexture1 = SKTexture(imageNamed: "bird_1");
        let birdTexture2 = SKTexture(imageNamed: "bird_2");
        let birdTexture3 = SKTexture(imageNamed: "bird_3");
        birdTexture1.filteringMode = SKTextureFilteringMode.Nearest;
        birdTexture2.filteringMode = SKTextureFilteringMode.Nearest;
        birdTexture3.filteringMode = SKTextureFilteringMode.Nearest;

        let result = BirdNode(texture:SKTexture(imageNamed: "bird_1"));
        
        result.flap = SKAction.animateWithTextures([birdTexture1, birdTexture2, birdTexture3], timePerFrame: 0.2)
        result.flapForever = SKAction.repeatActionForever(result.flap);
        
        result.runAction(result.flapForever, withKey: "flapForever");
        
        return result;
    }
    
    func update(currentTime: NSTimeInterval) {
        if(!self.physicsBody) {
            if(self.deltaPosY > VERTICAL_DELTA) {
                self.goingUp = false;
            }
            if(self.deltaPosY < -VERTICAL_DELTA) {
                self.goingUp = true;
            }
            
            let displacement = self.goingUp ? VERTICAL_SPEED : -VERTICAL_SPEED;
            self.position = CGPointMake(self.position.x, self.position.y);
            self.deltaPosY += displacement;
            
        } else {
            self.zRotation = CGFloat(M_PI) * self.physicsBody.velocity.dy * 0.0005;
        }
    }
    
    func startPlaying() {
        self.deltaPosY = 0;
        self.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 26, height: 18));
        self.physicsBody.categoryBitMask = Constants.BIRD_BIT_MASK;
        self.physicsBody.mass = 0.1;
        self.removeActionForKey("flapForever");
    }
    
    func bounce() {
        if(self.physicsBody) {
            self.physicsBody.velocity = CGVectorMake(0, 0);
            self.physicsBody.applyImpulse(CGVectorMake(0, 40));
            self.runAction(self.flap)
        }
    }
    
}
