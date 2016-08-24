//
//  UIColor+Colorflow.swift
//  AssetTracker
//
//  Created by Daniel Garbień on 23/08/16.
//  Copyright © 2016 Trifork GmbH. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    class func color(at: Int) -> UIColor {
        return colorflowColors[at % colorflowColors.count]
    }
    
    private static var colorflowColors : [UIColor] {
        return [
            UIColor(red: 115/255.0, green: 83/255.0, blue: 183/255.0, alpha: 1),
            UIColor(red: 68/255.0, green: 166/255.0, blue: 237/255.0, alpha: 1),
            UIColor(red: 51/255.0, green: 196/255.0, blue: 173/255.0, alpha: 1),
            UIColor(red: 129/255.0, green: 96/255.0, blue: 86/255.0, alpha: 1),
            UIColor(red: 255/255.0, green: 205/255.0, blue: 60/255.0, alpha: 1),
            UIColor(red: 241/255.0, green: 82/255.0, blue: 78/255.0, alpha: 1),
            UIColor(red: 65/255.0, green: 233/255.0, blue: 252/255.0, alpha: 1),
            UIColor(red: 64/255.0, green: 115/255.0, blue: 48/255.0, alpha: 1),
            UIColor(red: 199/255.0, green: 115/255.0, blue: 33/255.0, alpha: 1),
            UIColor(red: 79/255.0, green: 63/255.0, blue: 112/255.0, alpha: 1),
            UIColor(red: 100/255.0, green: 145/255.0, blue: 48/255.0, alpha: 1),
            UIColor(red: 55/255.0, green: 110/255.0, blue: 151/255.0, alpha: 1),
            UIColor(red: 30/255.0, green: 132/255.0, blue: 118/255.0, alpha: 1),
            UIColor(red: 105/255.0, green: 39/255.0, blue: 18/255.0, alpha: 1),
            UIColor(red: 204/255.0, green: 180/255.0, blue: 81/255.0, alpha: 1),
            UIColor(red: 182/255.0, green: 27/255.0, blue: 25/255.0, alpha: 1),
            UIColor(red: 69/255.0, green: 175/255.0, blue: 189/255.0, alpha: 1),
            UIColor(red: 47/255.0, green: 74/255.0, blue: 38/255.0, alpha: 1),
        ]
    }
}
