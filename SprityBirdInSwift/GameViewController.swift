//
//  GameViewController.swift
//  SprityBirdInSwift
//
//  Created by Frederick Siu on 6/6/14.
//  Copyright (c) 2014 Frederick Siu. All rights reserved.
//

import UIKit
import SpriteKit
import QuartzCore

class GameViewController: UIViewController, SceneDelegate {

    
    @IBOutlet
    var gameView: SKView
    @IBOutlet
    var getReadyView: UIView
    @IBOutlet
    var gameOverView: UIView
    @IBOutlet
    var medalImageView: UIImageView
    @IBOutlet
    var currentScore: UILabel
    @IBOutlet
    var bestScoreLabel: UILabel
    
    var scene: Scene
    var flash: UIView?
	
	init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
		scene = Scene(size: gameView.bounds.size)
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Slide)
        // Create and configure the scene.
        
        scene.scaleMode = .AspectFill
        scene.sceneDelegate = self
        
        // Present the scene
        self.gameOverView.alpha = 0
        self.gameOverView.transform = CGAffineTransformMakeScale(0.9, 0.9)
        
        self.gameView.presentScene(scene)

    }
    
    func eventStart() {
        UIView.animateWithDuration(0.2, animations: {
        self.gameOverView.alpha = 0
        self.gameOverView.transform = CGAffineTransformMakeScale(0.8, 0.8)
        self.flash!.alpha = 0
        self.getReadyView.alpha = 1
            }, completion: {
                (Bool) -> Void in self.flash!.removeFromSuperview()
            });
    }
    
    func eventPlay() {
        UIView.animateWithDuration(0.5, animations: {
            self.getReadyView.alpha = 0
		});
    }
    
    func eventBirdDeath() {
        self.flash = UIView(frame: self.view.frame)
        self.flash!.backgroundColor = UIColor.whiteColor()
        self.flash!.alpha = 0.9
        
        // shakeFrame
        
        UIView.animateWithDuration(0.6, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            // Display game over
            self.flash!.alpha = 0.4
            self.gameOverView.alpha = 1
            self.gameOverView.transform = CGAffineTransformMakeScale(1, 1)
            
            // Set medal
            if(self.scene.score >= 30){
                self.medalImageView.image = UIImage(named: "medal_platinum")
            }else if (self.scene.score >= 20){
                self.medalImageView.image = UIImage(named: "medal_gold")
            }else if (self.scene.score >= 10){
                self.medalImageView.image = UIImage(named: "medal_silver")
            }else if (self.scene.score >= 0){
                self.medalImageView.image = UIImage(named: "medal_bronze")
            }else{
                self.medalImageView.image = nil
            }
            
            // Set scores
            self.currentScore.text = NSString(format: "%li", self.scene.score)
            self.bestScoreLabel.text = NSString(format: "%li", Score.bestScore())
            },
            completion: {(Bool) -> Void in self.flash!.userInteractionEnabled = false})

    }
    
    func shakeFrame() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 4
        animation.autoreverses = true
        let fromPoint = CGPointMake(self.view.center.x - 4.0, self.view.center.y)
        let toPoint = CGPointMake(self.view.center.x + 4.0, self.view.center.y)
        
        let fromValue = NSValue(CGPoint: fromPoint)
        let toValue = NSValue(CGPoint: toPoint)
        animation.fromValue = fromValue
        animation.toValue = toValue
        self.view.layer.addAnimation(animation, forKey: "position")
    }
    
}
