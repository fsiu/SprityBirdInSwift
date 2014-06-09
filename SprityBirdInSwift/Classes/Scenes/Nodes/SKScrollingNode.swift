//
//  SKScrollingNode.swift
//  SprityBirdInSwift
//
//  Created by Frederick Siu on 6/6/14.
//  Copyright (c) 2014 Frederick Siu. All rights reserved.
//

import Foundation
import SpriteKit

class SKScrollingNode: SKSpriteNode {

    var scrollingSpeed: Float = Float(0.0)
    
    func scrollingNode(imageNamed: String, containerWidth: Float) -> SKScrollingNode {
        let image = UIImage(named: imageNamed);
        let result = SKScrollingNode(color: UIColor.clearColor(), size: CGSizeMake(containerWidth, image.size.height));
        result.scrollingSpeed = 1.0;
        var total:Float = 0.0;
        var totalWidth = containerWidth + image.size.width;
        while(total < totalWidth) {
            let child = SKSpriteNode(imageNamed: imageNamed);
            child.anchorPoint = CGPointZero;
            child.position = CGPointMake(total, 0);
            result.addChild(child);
            total+=child.size.width;
        }
        return result;
    }
    
    func update(currentTime: NSTimeInterval) {
        let runBlock: () -> Void = {
            for child: SKSpriteNode! in self.children  {
                child.position = CGPointMake(child.position.x-self.scrollingSpeed, child.position.y);
                if(child.position.x <= -child.size.width) {
                    var delta = child.position.x + child.size.width;
                    child.position = CGPointMake(Float(child.size.width * Float(self.children.count-1)) + delta, child.position.y);
                }
            }
        }
        runBlock();
    }
}