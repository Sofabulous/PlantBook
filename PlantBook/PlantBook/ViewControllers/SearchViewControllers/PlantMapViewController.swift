//
//  PlantMapViewController.swift
//  PlantBook
//
//  Created by yukun on 2018/9/7.
//  Copyright © 2018 SouthWest University-yukun. All rights reserved.
//

import UIKit

class PlantMapViewController: UIViewController,BMKMapViewDelegate {
    var _mapView: BMKMapView?
    var animatedAnnotation: BMKPointAnnotation?
    var animatedAnnotations: [BMKPointAnnotation] = []
//    var locationManager: BMKLocationManager!
//    var userLocation: BMKUserLocation!
    override func viewDidLoad() {
        super.viewDidLoad()
        _mapView = BMKMapView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.view.addSubview(_mapView!)
        //TODO: 设置定位功能，由于目前百度不支持libc++，暂时不接入定位服务
//        _mapView?.showsUserLocation = true
//        _mapView?.userTrackingMode = BMKUserTrackingModeNone
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _mapView?.viewWillAppear()
        _mapView?.delegate = self // 此处记得不用的时候需要置nil，否则影响内存的释放
        addLocationAnimatedAnnotations()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        _mapView?.viewWillDisappear()
        _mapView?.delegate = nil // 不用时，置nil
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func addLocationAnimatedAnnotations() {
        for i in 1...PlantStore.plantLocations.count {
            addAnimatedAnnotation(number: i)
        }
    }
    
    // 添加动画Annotation
    func addAnimatedAnnotation(number: Int) {
        animatedAnnotation = BMKPointAnnotation()
        let location = PlantStore.plantLocations[number - 1]
        animatedAnnotation?.coordinate = CLLocationCoordinate2DMake(location.latitude, location.longitude)
        animatedAnnotation?.title = "\(number)号点"
        _mapView?.addAnnotation(animatedAnnotation)
    }
    
    func mapView(_ mapView: BMKMapView!, viewFor annotation: BMKAnnotation!) -> BMKAnnotationView! {
        // 动画标注
        if let point = annotation as? BMKPointAnnotation {
            let AnnotationViewID = point.title
            let annotationView = AnimatedAnnotationView(annotation: annotation, reuseIdentifier: AnnotationViewID)
            let image = UIImage(named: "point.png")
            let images = [image!]
            annotationView.setImages(images)
            guard let characterTag = point.title.first else {return nil} 
            let stringTag = String.init(characterTag)
            if let tag = Int.init(stringTag) {
                annotationView.tag = tag
            }
            return annotationView
        }
        return nil
    }
    
    /**
     *当mapView新添加annotation views时，调用此接口
     *@param mapView 地图View
     *@param views 新添加的annotation views
     */
    func mapView(_ mapView: BMKMapView!, didAddAnnotationViews views: [Any]!) {
        NSLog("didAddAnnotationViews")
    }
    
    /**
     *当点击annotation view弹出的泡泡时，调用此接口
     *@param mapView 地图View
     *@param view 泡泡所属的annotation view
     */
    func mapView(_ mapView: BMKMapView!, annotationViewForBubble view: BMKAnnotationView!) {
        print(view.tag)
        PlantStore.shared.getPlantDataWith(location: String(view.tag)) { (plantDatas, error) in
            if let plantData = plantDatas {
                for data in  plantData {
                    print(data)
                }
            }
        }
    }
    
    /**
     *当取消选中一个annotation views时，调用此接口
     *@param mapView 地图View
     *@param views 取消选中的annotation views
     */
    func mapView(_ mapView: BMKMapView!, didDeselect view: BMKAnnotationView!) {
        NSLog("取消选中标注")
    }
    
}

