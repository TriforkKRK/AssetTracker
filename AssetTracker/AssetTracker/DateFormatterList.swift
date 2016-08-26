//
//  DateFormatterList.swift
//  AssetTracker
//
//  Created by Wojciech Nagrodzki on 26/08/2016.
//  Copyright © 2016 Trifork GmbH. All rights reserved.
//

import Foundation

class DateFormatterList
{
    static let mainDateFormatter: NSDateFormatter =
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ssZ"
        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        return dateFormatter
    }()
}
