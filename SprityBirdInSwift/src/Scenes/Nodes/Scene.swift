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

    let BACK_SCROLLING_SPEED: CGFloat = 0.5
    let FLOOR_SCROLLING_SPEED: CGFloat = 3.0
    let VERTICAL_GAP_SIZE: CGFloat = 200
    let FIRST_OBSTACLE_PADDING: CGFloat = 100
    let OBSTACLE_MIN_HEIGHT: CGFloat = 150
    let OBSTACLE_INTERVAL_SPACE: CGFloat = 130
    
    var birdDeath = false;

    var floor: SKScrollingNode?
    var back: SKScrollingNode?
    var scoreLabel: SKLabelNode = SKLabelNode(fontNamed: "Helvetica-Bold");
    var bird: BirdNode?
    var nbObstacles: Int = 0;
    
    var topPipes: [SKSpriteNode] = [];
    var bottomPipes: [SKSpriteNode] = [];
    
    var score: Int = 0;
    
    var sceneDelegate: SceneDelegate?
    
    required override init(size: CGSize) {
        super.init(size: size);
        self.physicsWorld.contactDelegate = self;
        self.startGame();
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func startGame() {
        self.birdDeath = false;
        self.removeAllChildren();
        
        self.createBackground();
        self.createFloor();
        self.createScore();
        self.createObstacles();
        self.createBird();
        
        self.floor!.zPosition = self.bird!.zPosition + 1;
        if(self.sceneDelegate != nil) {
            self.sceneDelegate!.eventStart();
        }
    }
    
    func createBackground() {
        self.back = SKScrollingNode.scrollingNode("back", containerSize:self.frame.size);
        //self.setScale(2.0);
        self.back!.scrollingSpeed = BACK_SCROLLING_SPEED;
        self.back!.anchorPoint = CGPoint.zero;
        self.back!.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame);
        self.back!.physicsBody!.categoryBitMask = Constants.BACK_BIT_MASK;
        self.back!.physicsBody!.contactTestBitMask = Constants.BIRD_BIT_MASK;
        self.addChild(self.back!);
    }
    
    func createScore() {
        self.score = 0;
        self.scoreLabel.text = "0";
        self.scoreLabel.fontSize = 500;
        self.scoreLabel.position = CGPoint(x: self.frame.midX, y: 100);
        self.scoreLabel.alpha = 0.2;
        self.addChild(self.scoreLabel);
    }
    
    func createFloor() {
        self.floor = SKScrollingNode.scrollingNode("floor", containerWidth: self.frame.size.width) as SKScrollingNode;
        self.floor!.scrollingSpeed = FLOOR_SCROLLING_SPEED;
        self.floor!.anchorPoint = CGPoint.zero;
        self.floor!.name = "floor";
        self.floor!.physicsBody = SKPhysicsBody(edgeLoopFrom: self.floor!.frame);
        self.floor!.physicsBody!.categoryBitMask = Constants.FLOOR_BIT_MASK;
        self.floor!.physicsBody!.contactTestBitMask = Constants.BIRD_BIT_MASK;
        self.addChild(floor!);
    }
    
    func createBird() {
        self.bird = BirdNode.instance();
        self.bird!.position = CGPoint(x: 100, y: self.frame.midY);
        self.bird!.name = "bird";
        self.addChild(bird!);
    }
    
    func createObstacles() {
        self.nbObstacles = Int(ceil(Double(self.frame.size.width)/Double(OBSTACLE_INTERVAL_SPACE)));
        var lastBlockPos:CGFloat = 0.0;
        self.bottomPipes = [];
        self.topPipes = [];
        for i in 0 ..< self.nbObstacles {
            let topPipe = SKSpriteNode(imageNamed: "pipe_top");
            topPipe.anchorPoint = CGPoint.zero;
            self.addChild(topPipe);
            self.topPipes.append(topPipe);
            
            let bottomPipe = SKSpriteNode(imageNamed: "pipe_bottom");
            bottomPipe.anchorPoint = CGPoint.zero;
            self.addChild(bottomPipe);
            self.bottomPipes.append(bottomPipe);
            
            if(i==0) {
                place(bottomPipe, topPipe: topPipe, xPos: self.frame.size.width + FIRST_OBSTACLE_PADDING);
            } else {
                place(bottomPipe, topPipe: topPipe, xPos: lastBlockPos + bottomPipe.frame.size.width +
                    OBSTACLE_INTERVAL_SPACE);
            }
            lastBlockPos = topPipe.position.x;
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(self.birdDeath) {
            self.startGame();
        } else {
            self.bird!.startPlaying();
            self.sceneDelegate!.eventPlay();
            self.bird!.bounce();
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if(!self.birdDeath) {
            self.back!.update(currentTime);
            self.floor!.update(currentTime);
            self.bird!.update(currentTime);
            self.updateObstacles(currentTime);
            self.updateScore(currentTime);
        }
    }
    
    func updateObstacles(_ currentTime: TimeInterval) {
        if(self.bird!.physicsBody == nil) {
            return;
        }
        
        for i in 0 ..< self.nbObstacles {
            let topPipe = self.topPipes[i];
            let bottomPipe = self.bottomPipes[i];
            
            if(topPipe.frame.origin.x < -topPipe.size.width) {
                let mostRightPipe = self.topPipes[(i+(self.nbObstacles-1))%self.nbObstacles];
                place(bottomPipe, topPipe: topPipe, xPos: mostRightPipe.frame.origin.x + topPipe.frame.size.width + OBSTACLE_INTERVAL_SPACE);
            }
            
            topPipe.position = CGPoint(x: topPipe.frame.origin.x - FLOOR_SCROLLING_SPEED, y: topPipe.frame.origin.y);
            bottomPipe.position = CGPoint(x: bottomPipe.frame.origin.x - FLOOR_SCROLLING_SPEED, y: bottomPipe.frame.origin.y);
        }
    }
    
    func place(_ bottomPipe: SKSpriteNode, topPipe: SKSpriteNode, xPos: CGFloat) {
        let availableSpace = self.frame.size.height - self.floor!.frame.size.height;
        let maxVariance = availableSpace - (2 * OBSTACLE_MIN_HEIGHT) - VERTICAL_GAP_SIZE;
        let test = 0.0;
        let variance = Math().randomFloatBetween(Float(0.0), max: Float(maxVariance));
        
        let minBottomPosY = self.floor!.frame.size.height + OBSTACLE_MIN_HEIGHT - self.frame.size.height + 300;
        var bottomPosY = Float(minBottomPosY) + variance;
        
        bottomPipe.position = CGPoint(x: xPos, y: CGFloat(bottomPosY));
        bottomPipe.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: 0,y: 0, width: bottomPipe.frame.size.width, height: bottomPipe.frame.size.height));
    
        bottomPipe.physicsBody!.categoryBitMask = Constants.BLOCK_BIT_MASK;
        bottomPipe.physicsBody!.contactTestBitMask = Constants.BIRD_BIT_MASK;
        
        topPipe.position = CGPoint(x: xPos,y: CGFloat(bottomPosY)+bottomPipe.frame.size.height + VERTICAL_GAP_SIZE);
        topPipe.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: 0,y: 0, width: topPipe.frame.size.width, height: topPipe.frame.size.height));
        
        topPipe.physicsBody!.categoryBitMask = Constants.BLOCK_BIT_MASK;
        topPipe.physicsBody!.contactTestBitMask = Constants.BIRD_BIT_MASK;

    }
    
    func updateScore(_ currentTime: TimeInterval) {
        for i in 0 ..< self.nbObstacles {
            let topPipe = self.topPipes[i];
            let topPipePosition = topPipe.frame.origin.x + topPipe.frame.size.width/2;
            if(topPipePosition > self.bird!.position.x && topPipePosition < self.bird!.position.x + FLOOR_SCROLLING_SPEED) {
                self.score += 1;
                self.scoreLabel.text = NSString(format: "%lu", self.score) as String;
                if(self.score>=10) {
                    self.scoreLabel.fontSize = 340;
                    self.scoreLabel.position = CGPoint(x: self.frame.midX, y: 120);
                }
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if(!self.birdDeath) {
            self.birdDeath = true;
            Score.registerScore(self.score);
            if(self.sceneDelegate != nil) {
                self.sceneDelegate!.eventBirdDeath();
            }
        }
    }
}


