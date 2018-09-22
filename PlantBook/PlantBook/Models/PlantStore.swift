//
//  PlantStore.swift
//  PlantBook
//
//  Created by yukun on 2018/9/16.
//  Copyright © 2018 SouthWest University-yukun. All rights reserved.
//

import Foundation

class PlantStore {
    // 优化显示速度，本地保存这个植物数组
    //MARK: - 植物名称数组，以及方便首字母排序的相关操作
    static let CHSPlantNames = ["侧柏","慈竹","凤尾竹","桂竹","海金沙","柳杉","罗汉松","毛蕨","南方红豆杉","铺地柏","肾蕨","水杉","四川苏铁","苏铁","塔柏","铁线蕨","蜈蚣草","小琴丝竹","孝顺竹","雪松","异叶南洋杉","银杏","紫竹"]
    
    static let latinPlantNames = CHSPlantNames.map { $0.transformTextToLatin() }
    
    static let plantNames:[plantName] = {
        var names:[plantName] = []
        for i in 0..<CHSPlantNames.count {
            names.append(plantName(CHSPlantName: CHSPlantNames[i], latinPlantName: latinPlantNames[i]))
        }
        let sortedNames = names.sorted {
            $0.latinPlantName < $1.latinPlantName
        }
        return sortedNames
    }()
    
    struct plantName {
        let CHSPlantName:String
        let latinPlantName:String
    }
    
    // 查询数据库，实现模糊搜索
    
}
