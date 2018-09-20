//
//  PlantData.swift
//  PlantBook
//
//  Created by yukun on 2018/9/8.
//  Copyright © 2018 SouthWest University-yukun. All rights reserved.
//

import Foundation

struct PlantData {
    typealias PlantId = UUID
    
    let id: UUID
    let name_CHS: String
    let name_EN: String
    let description: PlantDescription
    
    struct PlantDescription {
        let classification: String
        let introduction: String
        let usage: String
        let location: String
    }
}
