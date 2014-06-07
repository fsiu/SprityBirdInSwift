//
//  Math.swift
//  SprityBirdInSwift
//
//  Created by Frederick Siu on 6/6/14.
//  Copyright (c) 2014 Frederick Siu. All rights reserved.
//

import Foundation

class Math {
    class var seed = 0;
    
    class func setRandomSeed(seed: UInt64) {
        self.seed = seed;
        srand(self.seed);
    }
    
    class func randomFloatBetween(min: Float, max: Float) {
        let random =  ((rand()%RAND_MAX)/(RAND_MAX*1.0))*(max-min)+min;
        return random;
    }
}
