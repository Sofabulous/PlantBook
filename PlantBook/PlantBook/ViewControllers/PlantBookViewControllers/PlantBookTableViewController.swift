//
//  PlantBookTableViewController.swift
//  PlantBook
//
//  Created by yukun on 2018/9/7.
//  Copyright © 2018 SouthWest University-yukun. All rights reserved.
//

import UIKit

class PlantBookTableViewController: UITableViewController,UISearchBarDelegate {
    var searchBar: UISearchBar?
    var searchBarView: UIView?
    var resultArray:Array<PlantStore.PlantName> = []
    var characterDic:[String:Int] {
        get {
            var characterDic:[String:Int] = [:]
            for plant in resultArray {
                if let letter = plant.latinPlantName.first {
                    let firstLetter = String(letter)
                    if let num = characterDic[firstLetter] {
                        characterDic[firstLetter] = num + 1
                    }else {
                        characterDic[firstLetter] = 1
                    }
                }else {
                    if let num = characterDic["#"] {
                        characterDic["#"] = num + 1
                    }else {
                        characterDic["#"] = 1
                    }
                }
            }
            return characterDic
        }
    }
    
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedSectionHeaderHeight = 0
        self.searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        self.searchBar?.placeholder = "请输入植物名称"
        self.searchBar?.delegate = self
        resultArray = PlantStore.plantNames
        self.searchBar?.searchBarStyle = .minimal
        self.searchBarView?.addSubview(self.searchBar!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let text = searchText.transformTextToLatin()
        if text.isEmpty {
            resultArray = PlantStore.plantNames
        } else {
            resultArray = PlantStore.plantNames.filter{$0.latinPlantName.contains(text.lowercased())
            }
        }
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sortedCharacter = characterDic.keys.sorted()
        return sortedCharacter[section].uppercased()
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.characterDic.keys.sorted()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return characterDic.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sortedCharacter = characterDic.keys.sorted()
        let key = sortedCharacter[section]
        return characterDic[key] ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detail", for: indexPath)
        let sortedCharacter = characterDic.keys.sorted()
        var sum = 0
        for i in 0..<indexPath.section {
            let key = sortedCharacter[i]
            sum += characterDic[key] ?? 0
        }
        cell.textLabel?.text = resultArray[sum + indexPath.row].CHSPlantName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableView(tableView, cellForRowAt: indexPath)
        guard let plantName = cell.textLabel?.text else {return}
        self.view.startLoading()
        PlantStore.shared.getPlantDataWith(name: plantName) { [weak self] plantData in
            self?.view.endLoading()
            if let data = plantData {
                self?.pushDetailTVC(plantName: plantName, plantData: data)
            }else {
                self?.view.show(text: "🙁似乎遇到了一些小问题")
                self?.tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }
    
    private func pushDetailTVC(plantName: String, plantData: PlantData) {
        let DatailStoryboard = UIStoryboard.init(name: "Detail", bundle: nil)
        let plantDetailTVC = DatailStoryboard.instantiateInitialViewController() as? PlantDetailTableViewController
        if let VC = plantDetailTVC {
            VC.plantData = plantData
            VC.navigationItem.title = plantName
            self.navigationController?.pushViewController(VC, animated: true)
            self.navigationController?.viewControllers.first?.hidesBottomBarWhenPushed = false
        }
    }
    
    // MARK: - UIScrollViewMethod
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.searchBar?.resignFirstResponder()
    }
}
