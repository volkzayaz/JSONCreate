//
//  VideoRecord.swift
//  JSONCreate
//
//  Created by Vlad Soroka on 1/11/16.
//  Copyright © 2016 com.Jonathan. All rights reserved.
//

import Foundation
import CSwiftV

struct VideoRecord {
    
    static func VideoRecordFrom(csvFileURL url:NSURL) -> (NSData?, String?) {
        
        guard let data = NSData(contentsOfURL: url) else {
            return (nil, "Error loading file")
        }
        
        guard let string = String(data: data, encoding: NSUTF8StringEncoding) else {
            return (nil, "Error decoding string. Check file format")
        }
        
        let csv = CSwiftV(String: string.stringByReplacingOccurrencesOfString(";", withString: ","))
        
        let rows = csv.rows
        for row in rows
        {
            guard row.count == 6 else {
                return (nil, "Wrong file format. File should contain exactly 6 columns")
            }
            guard let _ = UInt(row[4]) else {
                return (nil, "Error parsing row " + row[0] + ". Check Video Duration column. It should contain numbers")
            }
            guard let _ = UInt(row[5]) else {
                return (nil, "Error parsing row " + row[0] + ". Check Time code of poster thumb column. It should contain numbers")
            }
        }
        
        let records = rows.map { row -> [String : AnyObject] in
            return
            [
                "video_url" : row[0],
                "thumbnail_pattern_url" : row[1] + "/{timestamp}.jpg",
                "low_resolution_thumbnail_pattern_url" : row[2] + "/{timestamp}.jpg",
                "title" : row[3],
                "length" : UInt(row[4])!,
                "cover_time" : UInt(row[5])!
            ]
        }
        
        return (try? NSJSONSerialization.dataWithJSONObject(records, options: .PrettyPrinted), nil)
    }
    
    
    
}