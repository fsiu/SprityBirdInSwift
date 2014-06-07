//
//  GameViewController.swift
//  SprityBirdInSwift
//
//  Created by Frederick Siu on 6/6/14.
//  Copyright (c) 2014 Frederick Siu. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {

    @IBOutlet
    var gameView: SKView?
    @IBOutlet
    var getReadyView: UIView?
    @IBOutlet
    var gameOverView: UIView?
    @IBOutlet
    var medalImageView: UIImageView?
    @IBOutlet
    var currentScore: UILabel?
    @IBOutlet
    var bestScoreLabel: UILabel?
    
    var scene: Scene?
    var flash: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().setStatusBarHidden(true, UIStatusBarAnimationSlide);
        
        // Create and configure the scene.
        scene = Scene(self.gameView.bounds.size);
        scene.scaleMode = SKSceneScaleModeAspectFill;
        scene.delegate = self;
        
        // Present the scene
        self.gameOverView.alpha = 0;
        self.gameOverView.transform = CGAffineTransformMakeScale(0.9, 0.9);
        
        self.gameView.presentScene(scene);
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }
    
    func eventPlay() {
        UIView.animateWithDuration(0.5, animations: {
            self.getReadyView.alpha = 0;
            })
    }
    
    func eventWasted() {
        flash = UIView(frame: self.view.frame);
        flash.backgroundColor = UIColor.whiteColor();
        flash.alpha = 0.9;
        
        // shakeFrame
        UIView.animateWithDuration(0.6, delay: 0, options: UIViewAnimationOptionCurveEaseIn, animations: {
            // Display game over
            flash.alpha = 0.4;
            self.gameOverView.alpha = 1;
            self.gameOverView.transform = CGAffineTransformMakeScale(1, 1);
            
            // Set medal
            if(scene.score >= 40){
                self.medalImageView.image = UIImage(named: "medal_platinum");
            }else if (scene.score >= 30){
                self.medalImageView.image = UIImage(named: "medal_gold");
            }else if (scene.score >= 20){
                self.medalImageView.image = UIImage(named: "medal_silver");
            }else if (scene.score >= 10){
                self.medalImageView.image = UIImage(named: "medal_bronze");
            }else{
                self.medalImageView.image = nil;
            }
            
            // Set scores
            self.currentScore.text = scene.score + "";
            self.bestScoreLabel.text = Score.bestScore();
            },
            completion: {(Bool) -> Void in flash.userInteractionEnabled = false});
    }
    
    func shakeFrame() {
        let animation = CABasicAnimation(keyPath: "position");
        animation.duration = 0.05;
        animation.repeatCount = 4;
        animation.autoreverses = true;
        let fromPoint = CGPointMake(self.view.center.x - 4.0, self.view.center.y);
        let toPoint = CGPointMake(self.view.center.x + 4.0, self.view.center.y);
        let fromValue = NSValue.CGPointValue(fromPoint);
        let toValue = NSValue.CGPointValue(toPoint)
        animation.fromValue = fromValue;
        animation.toValue = toValue;
        self.view.layer.addAnimation(anim: animation, forKey: "position");
    }
}
