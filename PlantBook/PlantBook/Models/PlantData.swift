//
//  PlantData.swift
//  PlantBook
//
//  Created by yukun on 2018/9/8.
//  Copyright © 2018 SouthWest University-yukun. All rights reserved.
//

import Foundation

struct PlantData {
    
    /// 植物图片的URL
    let url: URL?
    /// 植物学名（中文）
    let name: String
    /// 植物学名（拉丁）
    let name_en: String
    /// 生物分类学
    let taxonomy: String
    /// 植物相关描述
    let description: PlantDescription
    
    struct PlantDescription {
        /// 植物介绍
        let desc: String
        /// 植物用途
        let usage: String
        /// 植物分布
        let distribution: String
    }
}
