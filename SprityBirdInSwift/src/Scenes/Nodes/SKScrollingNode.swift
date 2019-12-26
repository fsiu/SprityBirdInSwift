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
    
    class func scrollingNode(_ imageNamed: String, containerSize: CGSize) -> SKScrollingNode {
        let image = UIImage(named: imageNamed);
        
        let result = SKScrollingNode(color: UIColor.clear, size: CGSize(width: CGFloat(containerSize.width), height: containerSize.height));
        result.scrollingSpeed = 1.0;
        
        var total:CGFloat = 0.0;
        while(total < CGFloat(containerSize.width) + image!.size.width) {
            let child = SKSpriteNode(imageNamed: imageNamed);
            child.size = containerSize
            child.anchorPoint = CGPoint.zero;
            child.position = CGPoint(x: total, y: 0);
            result.addChild(child);
            total+=child.size.width;
        }
        return result;
    }
    
    class func scrollingNode(_ imageNamed: String, containerWidth: CGFloat) -> SKScrollingNode {
        let image = UIImage(named: imageNamed);
        
        let result = SKScrollingNode(color: UIColor.clear, size: CGSize(width: CGFloat(containerWidth), height: image!.size.height));
        result.scrollingSpeed = 1.0;
        
        var total:CGFloat = 0.0;
        while(total < CGFloat(containerWidth) + image!.size.width) {
            let child = SKSpriteNode(imageNamed: imageNamed);
            child.anchorPoint = CGPoint.zero;
            child.position = CGPoint(x: total, y: 0);
            result.addChild(child);
            total+=child.size.width;
        }
        return result;
    }

    func update(_ currentTime: TimeInterval) {
        let runBlock: () -> Void = {
            for child in self.children as! [SKSpriteNode] {
                
                
                child.position = CGPoint(x: child.position.x-CGFloat(self.scrollingSpeed), y: child.position.y);
                if(child.position.x <= -child.size.width) {
                    let delta = child.position.x + child.size.width;
                    child.position = CGPoint(x: CGFloat(child.size.width * CGFloat(self.children.count-1)) + delta, y: child.position.y);
                }
            }
        }
        runBlock();
    }
}
