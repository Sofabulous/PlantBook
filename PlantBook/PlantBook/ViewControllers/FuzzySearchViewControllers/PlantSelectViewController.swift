//
//  PlantSelectViewController.swift
//  PlantBook
//
//  Created by yukun on 2018/9/7.
//  Copyright © 2018 SouthWest University-yukun. All rights reserved.
//

import UIKit

class PlantSelectViewController: UIViewController {
    var plantType: PlantType? {
        willSet {
            if let type = newValue,type != .angiosperms{
                self.view.startLoading()
                PlantStore.shared.getPlantDataWith(type: type, handler: { [weak self] (plantDatas, error) in
                    self?.view.endLoading()
                    if let _ = error {
                        self?.view.show(text: "植物被火星人带走了！")
                    }else {
                        if let plantDatas = plantDatas {
                            self?.pushPlantListTVC(plantDatas)
                        }else {
                            self?.view.show(text: "🙁似乎遇到了一些小问题")
                        }
                    }
                })
            }else if newValue == .angiosperms {
                pushFuzzySearchTVC()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.title = "模糊搜索"
    }
    
    @IBAction func clickGymnospermsButton(_ sender: Any) {
        plantType = .gymnosperms
    }
    
    @IBAction func clickAngiospermsButton(_ sender: Any) {
        plantType = .angiosperms
        
    }
    
    
    @IBAction func clickFernsButton(_ sender: Any) {
        plantType = PlantType.fern
    }
    
    @IBAction func clickBambooButton(_ sender: Any) {
        plantType = PlantType.bamboo
    }
        
    func pushPlantListTVC (_ plantDatas: [PlantData]) {
        let MainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        let plantListTVC = MainStoryboard.instantiateViewController(withIdentifier: "PlantListTableViewController") as? PlantListTableViewController
        if let VC = plantListTVC {
            VC.sourceData = plantDatas
            VC.navigationItem.title = plantType?.getCHSName()
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    func pushFuzzySearchTVC () {
        let MainStoryboard = UIStoryboard.init(name: "FuzzySearch", bundle: nil)
        let fuzzySearchTVC = MainStoryboard.instantiateInitialViewController() as? FuzzySearchTableViewController
        if let VC = fuzzySearchTVC {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.navigationController?.pushViewController(VC, animated: true)
        }
    
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
