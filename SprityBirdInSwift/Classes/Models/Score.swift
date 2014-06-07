//
//  Score.swift
//  SprityBirdInSwift
//
//  Created by Frederick Siu on 6/6/14.
//  Copyright (c) 2014 Frederick Siu. All rights reserved.
//

import Foundation

struct Score {
    static func registerScore(score: NSInteger) {
        if(score > Score.bestScore()) {
            setBestScore(score);
        }
    }
    
    static func setBestScore(bestScore: NSInteger) {
        let userDefaults = NSUserDefaults.standardUserDefaults();
        userDefaults.setInteger(bestScore, forKey: "bestScore");
        userDefaults.synchronize();
    }
    
    static func bestScore() -> NSInteger {
        return NSUserDefaults.standardUserDefaults().integerForKey("bestScore");
    }
}