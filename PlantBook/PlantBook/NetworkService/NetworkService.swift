//
//  NetworkService.swift
//  PlantBook
//
//  Created by yukun on 2018/9/22.
//  Copyright © 2018 SouthWest University-yukun. All rights reserved.
//

import Foundation
class  NetworkService {
    static public func registerUser(id userID:String,_ handler: @escaping BmobBooleanResultBlock) {
        let UserTable:BmobObject = BmobObject(className: "UserTable")
        UserTable.setObject(userID, forKey: NetworkServiceKey.userIdentifier)
        UserTable.saveInBackground(resultBlock: handler)
    }
    
    static public func addUserFavorites(favorite:String, handler: ((Error?) -> Void)? ) {
        getObjectByUUID { (array, error) in
            if let array = array {
                if let userData = array.first as? BmobObject {
                    userData.addUniqueObjects(from: [favorite], forKey: NetworkServiceKey.userFavorites)
                    userData.updateInBackground(resultBlock: { (isSuccessful, error) in
                        if isSuccessful {
                            handler?(nil)
                        }else {
                            handler?(error)
                        }
                    })
                }
            }else {
                handler?(error)
            }
        }
    }
    
    static public func removeUserFavorites(favorite:String, handler: ((Error?) -> Void)? ) {
        getObjectByUUID { (array, error) in
            if let array = array {
                if let userData = array.first as? BmobObject {
                    userData.removeObjects(in: [favorite], forKey: NetworkServiceKey.userFavorites)
                    userData.updateInBackground(resultBlock: { (isSuccessful, error) in
                        if isSuccessful {
                            handler?(nil)
                        }else {
                            handler?(error)
                        }
                    })
                }
            }else {
                handler?(error)
            }
        }
    }

    
    static public func getUserFavorites(handler: @escaping ([String]?,Error?) -> Void) {
        getObjectByUUID { (array, error) in
            if let array = array {
                if let userData = array.first as? BmobObject {
                    if let userFavorites = userData.object(forKey: NetworkServiceKey.userFavorites) as? [String] {
                        handler(userFavorites,nil)
                    }else {
                        handler(nil,error)
                    }
                }
            }else {
                handler(nil,error)
            }
        }
    }
    
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
    
    static public func searchPlantDataWith(name: String, handler: @escaping (PlantData?) -> Void) {
        let query = BmobQuery(className: "Plant")
        query?.whereKey(NetworkServiceKey.PlantData.name, equalTo: name)
        query?.findObjectsInBackground{ (array, error) in
            var plantData:PlantData? = nil
            if let array = array {
                if let object = array.first {
                    if let object = object as? BmobObject{
                        if let data = transformToPlantData(object: object) {
                            plantData = data
                        }
                    }
                }
            }
            handler(plantData)
        }
    }
    
    static public func searchPlantDataWith(location: String, handler: @escaping BmobObjectArrayResultBlock) {
        let query = BmobQuery(className: "Plant")
        query?.whereKey(NetworkServiceKey.PlantData.location, equalTo: location)
        query?.findObjectsInBackground { (array, error) in
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
        let taxonomy = object.object(forKey: NetworkServiceKey.PlantData.taxonomy) as! String
        // description
        let desc = object.object(forKey: NetworkServiceKey.PlantData.PlantDescription.desc) as! String
        let usage = object.object(forKey: NetworkServiceKey.PlantData.PlantDescription.usage) as! String
        let distribution = object.object(forKey: NetworkServiceKey.PlantData.PlantDescription.distribution) as! String
        let description = PlantData.PlantDescription.init(desc: desc, usage: usage, distribution: distribution)
        let plantData = PlantData.init(url: url, name: name, name_en: name_en, taxonomy: taxonomy, description: description)
        return plantData
    }
    
    static private func getObjectByUUID(handler: @escaping BmobObjectArrayResultBlock) {
        guard let userID = GSKeyChainDataManager.readUUID() else { return }
        let query = BmobQuery(className: "UserTable")
        query?.whereKey(NetworkServiceKey.userIdentifier, equalTo: userID)
        query?.findObjectsInBackground(handler)
    }
    
}

struct NetworkServiceKey {
    static let userIdentifier = "userid"
    static let userFavorites = "favorites"

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
        /// model里没有的确定植物位置的字段
        static let location = "location"
    }
}

enum PlantType:String {
    case angiosperms = "angiosperms"
    case gymnosperms = "gymnosperms"
    case bamboo = "bamboo"
    case fern = "fern"
    
    func getCHSName() -> String{
        switch self {
        case .angiosperms:
            return "被子植物"
        case .gymnosperms:
            return "裸子植物"
        case .bamboo:
            return "竹子"
        case .fern:
            return "蕨类植物"
        }
    }
}
