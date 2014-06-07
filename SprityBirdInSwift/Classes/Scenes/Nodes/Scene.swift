//
//  Scene.swift
//  SprityBirdInSwift
//
//  Created by Frederick Siu on 6/6/14.
//  Copyright (c) 2014 Frederick Siu. All rights reserved.
//

import Foundation
import SpriteKit

class Scene : SKScene, SKPhysicsContactDelegate {

    class let BACK_SCROLLING_SPEED = 0.5
    class let FLOOR_SCROLLING_SPEED = 3.0
    class let VERTICAL_GAP_SIZE = 120
    class let FIRST_OBSTACLE_PADDING = 100
    class let OBSTACLE_MIN_HEIGHT = 60
    class let OBSTACLE_INTERVAL_SPACE = 130
    
    class var wasted = false;

    
    var floor: SKScrollingNode?
    var back: SKScrollingNode?
    var scoreLabel: SKLabelNode?
    var bird: BirdNode?
    
    var nbObstacles: UInt64?
    
    var topPipes: NSMutableArray?
    var bottomPipes: NSMutableArray?
    
    var delegate: SceneDelegate?
    var score: UInt64
    
    init(size: CGSize) {
        super.init(size);
        self.physicsWorld.contactDelegate = self;
        self.startGame();
    }
    
    func startGame() {
        wasted = false;
        self.removeAllChildren();
        
        
        floor.zPosition = ++bird.zPosition;
        self.delegate.eventStart;
    }
    
    func createBackground() {
        back = SKScrollingNode.scrollingNode("back", view.frame.size.width);
        back.scrollingSpeed = BACK_SCROLLING_SPEED;
        back.anchorPoint = CGPointZero;
        back.physicsBody.categoryBitMask = Constants.BACK_BIT_MASK;
        back.physicsBody.contactTestBitMask = Constants.BIRD_BIT_MASK;
        self.addChild(back);
    }
    
    func createScore() {
        self.score = 0;
        scoreLabel = SKLabelNode(fontNamed: "Helvetica-Bold");
        scoreLabel.text = "0";
        scoreLabel.fontSize = 500;
        scoreLabel.position = CGPointMake(CGRectGetMidx(self.rect), 100);CGRectMi
        scoreLabel.alpha = 0.2;
        self.addChild(scoreLabel);
    }
    
    func createFloor() {
        floor = SKScrollingNode.scrollingNode("floor", view.frame.size.width);
        floor.scrollingSpeed = FLOOR_SCROLLING_SPEED;
        floor.anchorPoint = CGPointZero;
        floor.name = "floor";
        floor.physicsBody.categoryBitMask = Constants.FLOOR_BIT_MASK;
        floor.physicsBody.contactTestBitMask = Constants.BIRD_BIT_MASK;
        self.addChild(floor);
    }
    
    func createBird() {
        bird = BirdNode();
        bird.position = CGPointMake(100, CGRectGetMidY(self.frame));
        bird.name = "bird";
        self.addChild(bird);
    }
    
    func createObstacles() {
        nbObstacles = ceil(view.frame.size.width/(OBSTACLE_INTERVAL_SPACE));
        var lastBlockPos = 0.0;
        bottomPipes = NSMutableArray();
        topPipes = NSMutableArray();
        for var i=0; i<nbObstacles ; i++ {
            topPipe = SKSpriteNode(imageNamed: "pipe_top");
            topPipe.anchorPoint = CGPointZero;
            self.addChild(topPipe);
            topPipes.addObject(topPipe);
            
            bottomPipe = SKSpriteNode(imageNamed: "pipe_bottom");
            bottomPipe.anchorPoint = CGPointZero;
            self.addChild(topPipe);
            bottomPipes.addObject(bottomPipe);
            
            if(i==0) {
                place(bottomPipe, topPipe, view.frame.size.width + FIRST_OBSTACLE_PADDING);
            } else {
                place(bottomPipe, topPipe, lastBlockPos + bottomPipe.frame.size.width + OBSTACLE_INTERVAL_SPACE);
            }
            lastBlockPos = topPipe.position.x;
        }
    }
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        if(wasted) {
            self.startGame();
        } else {
            if(!bird.physicsBody) {
                bird.startPlaying();
                self.delegate.eventPlay();
            }
            bird.bounce();
        }
    }
    
    func update(currentTime: NSTimeInterval) {
        if(wasted) {
            return;
        }
        
        back.update(currentTime);
        floor.update(currentTime);
        bird.update(currentTime);
        self.updateObstacles(currentTime);
        self.updateScore(currentTime);
    }
    
    func updateObstacles(currentTime: NSTimeInterval) {
        if(!bird.physicsBody) {
            return;
        }
        
        for var i=0; i<nbObstacles; i++ {
            topPipe = topPipes.objectAtIndex(i);
            bottomPipe = bottomPipes.objectAtIndex(i);
            
            if(topPipe.frame.origin.x < -topPipe.size.width) {
                mostRightPipe = topPipes.objectAtIndex((i+(nbObstacles-1))%nbObstacles);
                place(bottomPipe, topPipe, mostRightPipe.frame.origin.x + topPipe.frame.size.width + OBSTACLE_INTERVAL_SPACE);
            }
            
            topPipe.position = CGPointMake(topPipe.frame.origin.x - FLOOR_SCROLLING_SPEED, topPipe.frame.origin.y);
            bottomPipe.position = CGPointMake(bottomPipe.frame.origin.x - FLOOR_SCROLLING_SPEED, bottomPipe.frame.origin.y);
        }
    }
    
    func place(bottomPipe: SKSpriteNode, topPipe: SKSpriteNode, xPos: Float) {
        let availableSpace = view.frame.size.height - floor.frame.size.height;
        let maxVariance = availableSpace - (2 * OBSTACLE_MIN_HEIGHT) - VERTICAL_GAP_SIZE;
        let variance = Math(0, maxVariance);
        
        let minBottomPosY = floor.frame.size.height + OBSTACLE_MIN_HEIGHT - view.frame.size.height;
        let bottomPosY = minBottomPosY + variance;
        
        bottomPipe.position = CGPointMake(xPos,bottomPosY);
        bottomPipe.physicsBody = SKPhysicsBody(rectangleOfSize: CGRectMake(0,0, bottomPipe.frame.size.width, bottomPipe.frame.size.height));
    
        topPipe.physicsBody.categoryBitMask = Constants.BLOCK_BIT_MASK;
        topPipe.physicsBody.contactTestBitMask = Constants.BIRD_BIT_MASK;
    }
    
    func updateScore(currentTime: NSTimeInterval) {
        for var i=0; i<nbObstacles; i++ {
            topPipe = topPipes[i];
            let topPipePosition = topPipe.frame.origin.x + topPipe.frame.size.width/2;
            if(topPipePosition > bird.position.x && topPipePosition < bird.position.x + FLOOR_SCROLLING_SPEED) {
                self.score++;
                scoreLabel.text = self.score + "";
                if(self.score>=10) {
                    scoreLabel.fontSize = 340;
                    scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), 120);
                }
            }
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        if(wasted) {
            return;
        }
        wasted = true;
        Score.registerScore(score);
        self.delegate.eventWasted();
    }
}


