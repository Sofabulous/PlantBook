//
//  UserFavoritesTableViewController.swift
//  PlantBook
//
//  Created by yukun on 2018/9/27.
//  Copyright © 2018 SouthWest University-yukun. All rights reserved.
//

import UIKit

class UserFavoritesTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        self.navigationItem.title = "收藏夹"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        PlantStore.shared.getUserFavorites()
        self.tableView.reloadData()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return PlantStore.shared.userFavorites.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detail", for: indexPath)
        cell.textLabel?.text = PlantStore.shared.userFavorites[indexPath.row]
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
        }
    }
    
}
