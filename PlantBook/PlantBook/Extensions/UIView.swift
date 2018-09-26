//
//  UIView.swift
//  PlantBook
//
//  Created by yukun on 2018/9/26.
//  Copyright © 2018 SouthWest University-yukun. All rights reserved.
//

import Foundation

extension UIView {
    func show(text:String){
        //初始化对话框，置于当前的View当中
        let hud = MBProgressHUD.showAdded(to: self, animated: true)
        hud.label.text = text
        hud.hide(animated: true, afterDelay: 1.5)
    }
    func startLoading() {
        MBProgressHUD.showAdded(to: self, animated: true)
    }
    func endLoading() {
        MBProgressHUD.hide(for: self, animated: true)
    }
}
