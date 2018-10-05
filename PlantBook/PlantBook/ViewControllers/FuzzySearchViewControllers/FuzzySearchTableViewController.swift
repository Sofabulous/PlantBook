//
//  FuzzySearchTableViewController.swift
//  PlantBook
//
//  Created by yukun on 2018/9/29.
//  Copyright © 2018 SouthWest University-yukun. All rights reserved.
//

import UIKit

class FuzzySearchTableViewController: UITableViewController,UITextFieldDelegate {
    
    /// 习性
    @IBOutlet weak var habitTextField: UITextField!
    
    /// 茎
    @IBOutlet weak var stemTextField: UITextField!
    
    /// 刺
    @IBOutlet weak var thornTextField: UITextField!
    
    /// 乳汁
    @IBOutlet weak var milkTextField: UITextField!
    
    /// 托叶
    @IBOutlet weak var stipuleTextField: UITextField!
    
    /// 叶外观
    @IBOutlet weak var leafTextField: UITextField!
    
    /// 叶着生
    @IBOutlet weak var leafGrowthTextField: UITextField!
    
    /// 叶柄
    @IBOutlet weak var leafPetioleTextField: UITextField!
    
    /// 叶脉
    @IBOutlet weak var leafVeinTextField: UITextField!
    
    /// 叶缘
    @IBOutlet weak var leafMarginTextField: UITextField!
    
    /// 花序
    @IBOutlet weak var inflorescenceTextField: UITextField!
    
    /// 果实
    @IBOutlet weak var friutTextField: UITextField!
    
    var textFields:[UITextField] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = true
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
        } else {
            // Fallback on earlier versions
        }
    }
    
    func setUpUI() {
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorStyle = .none
        self.textFields = [habitTextField,stemTextField,thornTextField,milkTextField,stipuleTextField,leafTextField,leafGrowthTextField,leafPetioleTextField,leafVeinTextField,leafMarginTextField,inflorescenceTextField,friutTextField]
        for textField in self.textFields {
            textField.inputView = UIView()
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        var choices = ["均不符合"]
        switch textField {
        case habitTextField:
            choices.append(contentsOf: ["草本","灌木","藤本","乔木"])
        case stemTextField:
            choices.append(contentsOf: ["圆柱形","具棱","根状茎"])
        case thornTextField:
            choices.append(contentsOf: ["有刺","无刺"])
        case milkTextField:
            choices.append(contentsOf: ["有乳汁","无乳汁"])
        case stipuleTextField:
            choices.append(contentsOf: ["有托叶","无托叶"])
        case leafTextField:
            choices.append(contentsOf: ["单叶","复叶"])
        case leafGrowthTextField:
            choices.append(contentsOf: ["叶互生","叶对生","叶基生","叶簇生","叶轮生","叶丛生"])
        case leafPetioleTextField:
            choices.append(contentsOf: ["叶柄无明显特征","叶柄有腺体","叶柄有毛"])
        case leafVeinTextField:
            choices.append(contentsOf: ["网状脉","平行脉","掌状网脉"])
        case leafMarginTextField:
            choices.append(contentsOf: ["全缘","有齿","缺刻或分裂"])
        case inflorescenceTextField:
            choices.append(contentsOf: ["单花","花序"])
        case friutTextField:
            choices.append(contentsOf: ["聚合果","聚花果","单果","果实未见"])
        default:
            break
        }
        let builder = JYKPickerBuilder()
        builder.isShowMask = true
        builder.cancelTextColor = UIColor.red
        self.tableView.isScrollEnabled = false
        JYKPicker.showSinglePicker(in: self.tableView, withBulider: builder, strings: choices, confirm: { [weak self] (strings, indexs) in
            textField.text = strings.first
            self?.tableView.isScrollEnabled = true
        }) { [weak self] in
            self?.tableView.isScrollEnabled = true
        }
    }
    
    
    @IBAction func clickDoneButton(_ sender: Any) {
        var conditions:[String] = []
        for textField in self.textFields {
            if let text = textField.text, text != "未指定", text != "均不符合" {
               conditions.append(text)
            }
        }
        PlantStore.shared.getPlantDataWith(conditions: conditions, type: .angiosperms) { [weak self] (datas, error) in
            guard let `self` = self else {return}
            if let plantDatas = datas, plantDatas.count > 0{
                self.pushPlantListTVC(plantDatas)
            }else {
                self.view.show(text: "🧐没有查到您要的植物，换个条件再试一试吧")
            }
        }
    }
    
    func pushPlantListTVC (_ plantDatas: [PlantData]) {
        let MainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        let plantListTVC = MainStoryboard.instantiateViewController(withIdentifier: "PlantListTableViewController") as? PlantListTableViewController
        if let VC = plantListTVC {
            VC.sourceData = plantDatas
            VC.navigationItem.title = "搜索结果"
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
