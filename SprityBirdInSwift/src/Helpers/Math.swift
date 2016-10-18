//
//  Math.swift
//  SprityBirdInSwift
//
//  Created by Frederick Siu on 6/6/14.
//  Copyright (c) 2014 Frederick Siu. All rights reserved.
//

import Foundation

struct Math {
    static var seed: UInt32 = 0
    
//    func setRandomSeed(_ seed: UInt32) {
//        Math.seed = seed;
//        arc4random(seed)
//    }
    
    func randomFloatBetween(_ min: Float, max: Float) -> Float {
        let randMaxNumerator = Float(arc4random_uniform(UInt32(RAND_MAX)))//Float(arc4random() % RAND_MAX)
        let randMaxDivisor = Float(RAND_MAX) * 1.0
        let random: Float = Float((randMaxNumerator / randMaxDivisor) * (max-min)) + Float(min)
        return random
    }
}
