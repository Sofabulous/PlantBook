//
//  DispatchQueue.swift
//  PlantBook
//
//  Created by yukun on 2018/10/7.
//  Copyright © 2018 SouthWest University-yukun. All rights reserved.
//

import Foundation

extension DispatchQueue {
    private static var onceTrcker = [String]()
    
    public class func once(token: String, block:() -> Void) {
        objc_sync_enter(self)
        defer {
            objc_sync_exit(self)
        }
        
        if onceTrcker.contains(token) {
            return
        }
        
        onceTrcker.append(token)
        block()
    }
}
