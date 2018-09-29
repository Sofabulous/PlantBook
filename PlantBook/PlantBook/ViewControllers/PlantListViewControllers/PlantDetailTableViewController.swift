//
//  PlantDetailTableViewController.swift
//  PlantBook
//
//  Created by yukun on 2018/9/7.
//  Copyright © 2018 SouthWest University-yukun. All rights reserved.
//

import UIKit
import Kingfisher
class PlantDetailTableViewController: UITableViewController {
    
    @IBOutlet weak var collectionButton: UIBarButtonItem!
    
    @IBOutlet weak var plantImageView: UIImageView!
    
    @IBOutlet weak var name_enLabel: UILabel!
    
    @IBOutlet weak var taxonomyLabel: UILabel!
    
    @IBOutlet weak var descTextView: UITextView!
    
    @IBOutlet weak var usageTextView: UITextView!
    
    @IBOutlet weak var distributionLabel: UILabel!
    
    var plantData:PlantData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    private func setUpUI() {
        self.tabBarController?.tabBar.isHidden = true
        if let data = plantData {
            let placeholderImage = UIImage(named: "noPicture_big")
            plantImageView.kf.setImage(with: data.url, placeholder: placeholderImage, options: nil, progressBlock: nil, completionHandler: nil)
            navigationItem.title = data.name
            name_enLabel.text = data.name_en
            name_enLabel.adjustsFontSizeToFitWidth = true
            taxonomyLabel.text = data.taxonomy
            descTextView.text = data.description.desc
            usageTextView.text = data.description.usage
            
            distributionLabel.text = data.description.distribution
            distributionLabel.preferredMaxLayoutWidth = distributionLabel.frame.size.width
            
            if PlantStore.shared.isFavoritePlant(name: data.name){
                collectionButton.image = UIImage(named: "solid-heart")
            }else {
                collectionButton.image = UIImage(named: "hollow-heart")
            }
        }
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            // Fallback on earlier versions
        }
        self.tableView.separatorStyle = .none
        self.tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    @IBAction func clickCollectionButton(_ sender: Any) {
        if collectionButton.image == UIImage(named: "solid-heart") {
            collectionButton.image = UIImage(named: "hollow-heart")
            if let name = plantData?.name {
                PlantStore.shared.removeFavoritePlant(name: name) { [weak self] (error) in
                    guard let `self` = self else {return}
                    if let _ = error {
                        self.view.show(text: "🤨取关失败，在试一试吧")
                    }
                }
            }
        }else {
            collectionButton.image = UIImage(named: "solid-heart")
            if let name = plantData?.name {
                PlantStore.shared.addFavoritePlant(name: name) { [weak self] (error) in
                    guard let `self` = self else {return}
                    if let _ = error {
                        self.view.show(text: "🤨关注失败，在试一试吧")
                    }
                }
            }
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// 交由autolayout计算UITextView的高度
//extension UITextView {
//    func heightForTextView() -> CGFloat {
//        let width = self.frame.width
//        let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
//        let constraint = self.sizeThatFits(size)
//        return constraint.height
//    }
//}
