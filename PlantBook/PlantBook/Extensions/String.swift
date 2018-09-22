//
//  String.swift
//  PlantBook
//
//  Created by yukun on 2018/9/20.
//  Copyright © 2018 SouthWest University-yukun. All rights reserved.
//

import Foundation

extension String {
    func transformTextToLatin() -> String{
        let str = NSMutableString(string: self) as CFMutableString
        if CFStringTransform(str, nil, kCFStringTransformToLatin, false) {
            if CFStringTransform(str, nil, kCFStringTransformStripDiacritics, false) {
                return str as String
            }
        }
        return ""
    }
}
