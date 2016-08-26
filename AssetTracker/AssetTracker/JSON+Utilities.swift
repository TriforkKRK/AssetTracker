//
//  JSON+Utilities.swift
//  AssetTracker
//
//  Created by Wojciech Nagrodzki on 26/08/2016.
//  Copyright © 2016 Trifork GmbH. All rights reserved.
//

import Foundation
import CoreLocation


enum JSONValidationError: ErrorType, CustomStringConvertible
{
    case ObjectMissingForKey(key: String)
    case ObjectInvalidForKey(key: String)
    case ObjectInvalid
    
    var description: String
    {
        let description = String(JSONValidationError) + "."
        switch self
        {
        case .ObjectMissingForKey(let key): return description + "ObjectMissingForKey\(key)"
        case .ObjectInvalidForKey(let key): return description + "ObjectInvalidForKey\(key)"
        case .ObjectInvalid: return description + "ObjectInvalid"
        }
    }
}


extension JSON
{
    func stringForKey(key: String) throws -> String
    {
        guard let stringForKey = self[key].string else
        {
            throw JSONValidationError.ObjectMissingForKey(key: key)
        }
        return stringForKey
    }
    
    func locationCoordinate2DForKey(key: String) throws -> CLLocationCoordinate2D
    {
        let string = try stringForKey(key)
        let coordinates = string.componentsSeparatedByString(",")
        
        guard coordinates.count == 2 else
        {
            throw JSONValidationError.ObjectInvalidForKey(key: key)
        }
        
        guard let latitude = Double(coordinates[0]), longitude = Double(coordinates[1]) else
        {
            throw JSONValidationError.ObjectInvalidForKey(key: key)
        }
        
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    func timestampForKey(key: String) throws -> NSDate
    {
        let string = try stringForKey(key)
        guard let date = DateFormatterList.mainDateFormatter.dateFromString(string) else
        {
            throw JSONValidationError.ObjectInvalidForKey(key: key)
        }
        return date
    }
}
