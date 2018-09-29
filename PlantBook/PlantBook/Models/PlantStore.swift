//
//  PlantStore.swift
//  PlantBook
//
//  Created by yukun on 2018/9/16.
//  Copyright © 2018 SouthWest University-yukun. All rights reserved.
//

import Foundation

enum PlantDataError:Error {
    case dataError
}

class PlantStore {
    static let shared = PlantStore()
    
    // 查询数据库，实现模糊搜索
    private var plantDatas:[PlantData] = []
    
    typealias ResultClosure = ([PlantData]?,Error?) -> Void
    typealias PlantDataClosure = (PlantData?) -> Void
    
    // 用户喜爱植物
    private var userFavorites:[String] = []
    
    var userFavoritesCount:Int {
        return userFavorites.count
    }
    
    func userFavoritesPlantName(at index:Int) -> String {
        return userFavorites[index]
    }
    
    func isFavoritePlant(name:String) -> Bool {
        return userFavorites.contains(name)
    }
    
    func addFavoritePlant(name:String,_ handler:((Error?) -> Void)?) {
        NetworkService.addUserFavorites(favorite: name) { [weak self] (error) in
            guard let `self` = self else {return}
            if let _ = error {
                handler?(error)
            }else {
                self.userFavorites.append(name)
            }
        }

    }

    func removeFavoritePlant(name:String,_ handler:((Error?) -> Void)?) {
        NetworkService.removeUserFavorites(favorite: name) { [weak self] (error) in
            guard let `self` = self else {return}
            if let _ = error {
                handler?(error)
            }else {
                guard let index = PlantStore.shared.userFavorites.firstIndex(of: name) else {return}
                self.userFavorites.remove(at: index)            }
        }
    }

    func getUserFavorites(_ resultClosure:((Bool)->Void)?) {
        if let _ = GSKeyChainDataManager.readUUID() {
            //TODO: 得到用户喜号植物
            NetworkService.getUserFavorites { [weak self] (favorites, error) in
                guard let `self` = self else {return}
                if let userFavorites = favorites {
                    if self.userFavorites != userFavorites {
                        self.userFavorites = userFavorites
                    }
                    resultClosure?(true)
                }else {
                    resultClosure?(false)
                }
            }
        }else {
            guard let userID = UIDevice.current.identifierForVendor?.uuidString else {return}
            NetworkService.registerUser(id: userID, {(isSuccessful, error) in
                if let error = error {
                    print("error is \(error.localizedDescription)")
                }else {
                    GSKeyChainDataManager.saveUUID(userID)
                    print("registerUser successfully")
                }
            })
        }
    }
    
    func getPlantDataWith(type:PlantType, handler: @escaping ResultClosure) {
        NetworkService.getPlantDataWith(type: type) { [weak self] (datas, error) in
            if let _ = error {
                handler(nil,error)
            }else {
                if let plantDatas = datas as? [PlantData] {
                    self?.plantDatas = plantDatas
                    handler(plantDatas,nil)
                }else {
                    let dataError = PlantDataError.dataError
                    handler(nil,dataError)
                }
            }
        }
    }
    
    func getPlantDataWith(name:String, handler: @escaping PlantDataClosure) {
        NetworkService.searchPlantDataWith(name: name) { data in
            if let plantData = data {
                handler(plantData)
            }else {
                handler(nil)
            }
        }
    }
    
    // 根据地点找到关联的植物
    func getPlantDataWith(location:String, handler: @escaping ResultClosure) {
        NetworkService.searchPlantDataWith(location: location) { [weak self] (datas, error) in
            if let _ = error {
                handler(nil,error)
            }else {
                if let plantDatas = datas as? [PlantData] {
                    self?.plantDatas = plantDatas
                    handler(plantDatas,nil)
                }else {
                    let dataError = PlantDataError.dataError
                    handler(nil,dataError)
                }
            }
        }
    }
    
    // 根据模糊查询的条件找到关联的植物
    func getPlantDataWith(conditions:[String], type:PlantType , handler:@escaping ResultClosure) {
        NetworkService.searchPlantDataWith(conditions: conditions, type: type) { [weak self] (datas, error) in
            if let _ = error {
                handler(nil,error)
            }else {
                if let plantDatas = datas as? [PlantData] {
                    self?.plantDatas = plantDatas
                    handler(plantDatas,nil)
                }else {
                    let dataError = PlantDataError.dataError
                    handler(nil,dataError)
                }
            }
        }
    }

    
    var count:Int {
        return plantDatas.count
    }
    
    func data(at index:Int) -> PlantData? {
        guard index < plantDatas.count else { return nil}
        return plantDatas[index]
    }
    // 优化显示速度，本地保存这个植物数组
    //MARK: - 植物名称数组，以及方便首字母排序的相关操作
    static let CHSPlantNames = ["侧柏","慈竹","凤尾竹","桂竹","海金沙","柳杉","罗汉松","毛蕨","南方红豆杉","铺地柏","肾蕨","水杉","四川苏铁","苏铁","塔柏","铁线蕨","蜈蚣草","小琴丝竹","孝顺竹","雪松","异叶南洋杉","银杏","紫竹"]
    
    static let latinPlantNames = CHSPlantNames.map { $0.transformTextToLatin() }
    
    static let plantNames:[PlantName] = {
        var names:[PlantName] = []
        for i in 0..<CHSPlantNames.count {
            names.append(PlantName(CHSPlantName: CHSPlantNames[i], latinPlantName: latinPlantNames[i]))
        }
        let sortedNames = names.sorted {
            $0.latinPlantName < $1.latinPlantName
        }
        return sortedNames
    }()
    
    struct PlantName {
        let CHSPlantName:String
        let latinPlantName:String
    }
    
    static let plantLocations:[PlantLocation] = {
        let Location1 = PlantLocation(latitude: 29.835631, longitude: 106.439491)
        return [Location1]
    }()

    struct PlantLocation {
        let latitude:Double
        let longitude:Double
    }
}
