//
//  String+UIImage.swift
//  AssetTracker
//
//  Created by Daniel Garbień on 24/08/16.
//  Copyright © 2016 Trifork GmbH. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    func imageWithFont(font: UIFont, color: UIColor) -> UIImage {
        let size = boundingRectSizeWithFont(font, constrainedToSize: CGSizeMake(CGFloat.max, CGFloat.max))
        let drawRect = CGRect(origin: CGPointZero, size: size)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        defer {
            UIGraphicsEndImageContext()
        }
        
        NSString(string: self).drawInRect(drawRect, withAttributes: [
            NSFontAttributeName: font,
            NSForegroundColorAttributeName: color
            ])
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

extension String {
    
    func boundingRectSizeWithFont(font: UIFont, constrainedToSize size: CGSize, lineBreakMode: NSLineBreakMode = .ByWordWrapping) -> CGSize {
        
        let style = NSMutableParagraphStyle()
        style.lineBreakMode = lineBreakMode
        
        let boundingRect = NSString(string: self).boundingRectWithSize(
            size,
            options: .UsesLineFragmentOrigin,
            attributes:  [
                NSFontAttributeName: font,
                NSParagraphStyleAttributeName: style
            ],
            context: nil)
        
        return CGSize(width: ceil(boundingRect.width), height: ceil(boundingRect.height))
    }
}
