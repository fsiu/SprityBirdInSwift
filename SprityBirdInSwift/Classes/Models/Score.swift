//
//  Score.swift
//  SprityBirdInSwift
//
//  Created by Frederick Siu on 6/6/14.
//  Copyright (c) 2014 Frederick Siu. All rights reserved.
//

import Foundation

struct Score {
    static func registerScore(_ score: Int) {
        if(score > Score.bestScore()) {
            setBestScore(score)
        }
    }
    
    static func setBestScore(_ bestScore: Int) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(bestScore, forKey: "bestScore")
        userDefaults.synchronize()
    }
    
    static func bestScore() -> NSInteger {
        return UserDefaults.standard.integer(forKey: "bestScore")
    }
}
