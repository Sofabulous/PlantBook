//
//  FuzzySearchHelpViewController.swift
//  PlantBook
//
//  Created by yukun on 2018/10/7.
//  Copyright © 2018 SouthWest University-yukun. All rights reserved.
//

import UIKit

class FuzzySearchHelpViewController: UIViewController {
    @IBOutlet weak var helpWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let path = Bundle.main.bundlePath
        let baseUrl = URL(fileURLWithPath: path)
        let htmlPath = Bundle.main.path(forResource: "help", ofType: "html") ?? ""
        let htmlContent = try? String(contentsOfFile: htmlPath, encoding: .utf8)
        if let content = htmlContent {
            self.helpWebView.loadHTMLString(content, baseURL: baseUrl)
        }
//        NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"index1"
//            ofType:@"html"];
//        NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath
//            encoding:NSUTF8StringEncoding
//            error:nil];
//        [self.webView loadHTMLString:htmlCont baseURL:baseURL];
        
   
        // Do any additional setup after loading the view.
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
