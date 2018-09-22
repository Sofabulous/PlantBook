//
//  NetworkService.swift
//  PlantBook
//
//  Created by yukun on 2018/9/22.
//  Copyright © 2018 SouthWest University-yukun. All rights reserved.
//

import Foundation
class  NetworkService {
    static public func getPlantDataWith(type:PlantType, handler: @escaping BmobObjectArrayResultBlock) {
        let query = BmobQuery(className: "Plant")
        query?.whereKey(NetworkServiceKey.PlantData.type, equalTo: type.rawValue)
        query?.findObjectsInBackground{ (array, error) in
            if let array = array {
                var plantDatas:[PlantData] = []
                for object in array {
                    if let object = object as? BmobObject{
                        if let plantData = transformToPlantData(object: object) {
                            plantDatas.append(plantData)
                        }
                    }
                }
                handler(plantDatas,error)
            }else {
                handler(nil,error)
            }
        }
    }
    
    static private func transformToPlantData(object:BmobObject) -> PlantData? {
        let urlStr = object.object(forKey: NetworkServiceKey.PlantData.url) as! String
        let url = URL(string: urlStr)
        let name = object.object(forKey: NetworkServiceKey.PlantData.name) as! String
        let name_en = object.object(forKey: NetworkServiceKey.PlantData.name_en) as! String
        let taxonomy = object.object(forKey: NetworkServiceKey.PlantData.name_en) as! String
        // description
        let desc = object.object(forKey: NetworkServiceKey.PlantData.PlantDescription.desc) as! String
        let usage = object.object(forKey: NetworkServiceKey.PlantData.PlantDescription.usage) as! String
        let distribution = object.object(forKey: NetworkServiceKey.PlantData.PlantDescription.distribution) as! String
        let description = PlantData.PlantDescription.init(desc: desc, usage: usage, distribution: distribution)
        let plantData = PlantData.init(url: url, name: name, name_en: name_en, taxonomy: taxonomy, description: description)
        return plantData
    }
}

struct NetworkServiceKey {
    struct PlantData {
        static let url = "url"
        static let type = "type"
        static let name = "name"
        static let name_en = "name_en"
        static let taxonomy = "taxonomy"
        struct PlantDescription {
            /// 植物介绍
            static let desc = "desc"
            /// 植物用途
            static let usage = "usage"
            /// 植物分布
            static let distribution = "distribution"
        }
    }
}

enum PlantType:String {
    case angiosperms = "angiosperms"
    case gymnosperms = "gymnosperms"
    case fern = "fern"
}
