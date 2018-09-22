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
            if let type = newValue {
                MBProgressHUD.showAdded(to: self.view, animated: true)
                PlantStore.shared.getPlantDataWith(type: type, handler: { [weak self] (plantDatas, error) in
                    if let view = self?.view {
                        MBProgressHUD.hide(for: view, animated: true)
                    }
                    if let _ = error {
                        self?.show(text: "植物被火星人带走了！")
                    }else {
                        if let plantDatas = plantDatas {
                            self?.showPlantListTVC(plantDatas)
                        }else {
                            self?.show(text: "似乎遇到了一些小问题")
                        }
                    }
                })
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
    
    func show(text:String){
        //初始化对话框，置于当前的View当中
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = text
        hud.hide(animated: true, afterDelay: 1.5)
    }
    
    func showPlantListTVC (_ plantDatas: [PlantData]) {
        let MainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        let plantListTVC = MainStoryboard.instantiateViewController(withIdentifier: "PlantListTableViewController") as? PlantListTableViewController
        if let VC = plantListTVC {
            VC.sourceData = plantDatas
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
