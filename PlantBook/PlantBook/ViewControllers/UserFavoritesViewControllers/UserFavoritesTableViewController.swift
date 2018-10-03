//
//  UserFavoritesTableViewController.swift
//  PlantBook
//
//  Created by yukun on 2018/9/27.
//  Copyright © 2018 SouthWest University-yukun. All rights reserved.
//

import UIKit

class UserFavoritesTableViewController: UITableViewController {
    
    var noDataView:UIView?
    var haveNoDataView:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        self.navigationItem.title = "收藏夹"
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            // Fallback on earlier versions
        }
        if let noDataView = Bundle.main.loadNibNamed("NoDataView", owner: nil, options: nil)?.last as? UIView {
            noDataView.frame = self.tableView.frame
            self.noDataView = noDataView
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        PlantStore.shared.getUserFavorites { [weak self] (isSuccessful) in
            guard let `self` = self else {return}
            if isSuccessful {
                self.addNoDataView()
                self.tableView.reloadData()
            }else {
                self.tableView.show(text: "😕读取收藏夹失败")
            }
        }
    }
    
    func addNoDataView() {
        if PlantStore.shared.userFavoritesCount == 0 {
            if let noDataView = self.noDataView {
                self.tableView.addSubview(noDataView)
                self.haveNoDataView = true
            }
        }else {
            if self.haveNoDataView {
                self.noDataView?.removeFromSuperview()
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

extension UserFavoritesTableViewController {
    //MARK: - UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PlantStore.shared.userFavoritesCount
    }
    
    
    //MARK: -  UITableViewDelegate
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detail", for: indexPath)
        cell.textLabel?.text = PlantStore.shared.userFavoritesPlantName(at:indexPath.row)
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
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let cell = tableView.cellForRow(at: indexPath)
            if let name = cell?.textLabel?.text {
                PlantStore.shared.removeFavoritePlant(name: name) {[weak self] error in
                    guard let `self` = self else {return}
                    if let _ = error {
                        self.tableView.show(text: "🤨取关失败，在试一试吧")
                    }else {
                        self.tableView.deleteRows(at: [indexPath], with: .fade)
                        if PlantStore.shared.userFavoritesCount == 0 {
                           self.addNoDataView()
                        }
                    }
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "取关"
    }
}
