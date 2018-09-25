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
        if let data = plantData {
            plantImageView.kf.setImage(with: data.url)
            navigationItem.title = data.name
            name_enLabel.text = data.name_en
            name_enLabel.adjustsFontSizeToFitWidth = true
            taxonomyLabel.text = data.taxonomy
            descTextView.text = data.description.desc
            usageTextView.text = data.description.usage
            
            distributionLabel.text = data.description.distribution
            distributionLabel.preferredMaxLayoutWidth = distributionLabel.frame.size.width
        }
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.tableView.separatorStyle = .none
        self.tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
//        self.tableView.cellForRow(at: IndexPath(row: 3, section: 0))
    }
    
    @IBAction func clickCollectionButton(_ sender: Any) {
        
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
