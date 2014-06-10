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

    var scrollingSpeed: CGFloat = 0.0;
    
    class func scrollingNode(imageNamed: String, containerWidth: CGFloat) -> SKScrollingNode {
        let image = UIImage(named: imageNamed);
        
        let result = SKScrollingNode(color: UIColor.clearColor(), size: CGSizeMake(CGFloat(containerWidth), image.size.height));
        result.scrollingSpeed = 1.0;
        
        var total:CGFloat = 0.0;
        while(total < CGFloat(containerWidth) + image.size.width) {
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
                child.position = CGPointMake(child.position.x-CGFloat(self.scrollingSpeed), child.position.y);
                if(child.position.x <= -child.size.width) {
                    var delta = child.position.x + child.size.width;
                    child.position = CGPointMake(CGFloat(child.size.width * CGFloat(self.children.count-1)) + delta, child.position.y);
                }
            }
        }
        runBlock();
    }
}