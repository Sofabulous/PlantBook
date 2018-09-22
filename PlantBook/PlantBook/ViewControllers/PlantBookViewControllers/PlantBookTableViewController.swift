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
    var resultArray:Array<PlantStore.plantName> = []
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
        self.searchBar?.delegate = self
        resultArray = PlantStore.plantNames
        self.searchBar?.searchBarStyle = .minimal
        self.searchBarView?.addSubview(self.searchBar!)
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
        return sortedCharacter[section]
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
        let detailViewController = UIViewController()
        detailViewController.title = cell.textLabel?.text
        detailViewController.view.backgroundColor = UIColor.white
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    // MARK: - UIScrollViewDelegate
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.searchBar?.resignFirstResponder()
    }

}
