//
//  RootPlantBookViewController.swift
//  PlantBook
//
//  Created by yukun on 2018/9/21.
//  Copyright © 2018 SouthWest University-yukun. All rights reserved.
//

import UIKit
extension UIImage {
    class func imageWithColor(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}


class RootPlantBookViewController: UIViewController {

    @IBOutlet weak var searchBarView: UIView!
    
    private let SeguePlantBook = "SeguePlantBook"

    override func viewDidLoad() {
        super.viewDidLoad()
        setMockNavigationBar()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func setMockNavigationBar() {
        let color = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 0.8)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.imageWithColor(color), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.navigationItem.title = "植物图志"
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            // Fallback on earlier versions
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case SeguePlantBook:
            guard let destination = segue.destination as? PlantBookTableViewController else {
                fatalError("Invalid destination view controller!")
            }
            
            destination.searchBarView = searchBarView
            // A default created view model
        default:
            break
        }
        
    }

}
