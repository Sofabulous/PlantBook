//
//  PlantTableViewCell.swift
//  PlantBook
//
//  Created by yukun on 2018/9/22.
//  Copyright © 2018 SouthWest University-yukun. All rights reserved.
//

import UIKit
import Kingfisher
class PlantTableViewCell: UITableViewCell {
    
    @IBOutlet weak var plantImageView: UIImageView!
    
    @IBOutlet weak var plantNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
