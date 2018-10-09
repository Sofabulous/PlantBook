//
//  PlantMapViewController.swift
//  PlantBook
//
//  Created by yukun on 2018/9/7.
//  Copyright © 2018 SouthWest University-yukun. All rights reserved.
//

import UIKit

class PlantMapViewController: UIViewController,BMKMapViewDelegate,BMKLocationManagerDelegate, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
    
    var searchController: UISearchController?
    var resultsController: SearchResultViewController?
    // 百度定位服务
    var locationManager: BMKLocationManager!
    var userLocation: BMKUserLocation!
    
    @IBOutlet weak var contentView: UIView!
    
    var mapView: BMKMapView?
    var animatedAnnotation: BMKPointAnnotation?
    var animatedAnnotations: [BMKPointAnnotation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PlantStore.shared.getUserFavorites(nil)
        // 初始化地图
        setUpMapView()
        // 初始化定位服务
        setUpLocation()
        // 添加搜索框，会使得整个navigationBar大10个point
        addSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 地图不采用大标题样式
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
        } else {
            // Fallback on earlier versions
        }
        self.tabBarController?.tabBar.isHidden = false
        mapView?.viewWillAppear()
        mapView?.delegate = self // 此处记得不用的时候需要置nil，否则影响内存的释放
        addLocationAnimatedAnnotations()
        getUserLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mapView?.viewWillDisappear()
        mapView?.delegate = nil // 不用时，置nil
    }
    
    // MARK:- 设置BMKMapView
    private func setUpMapView() {
        mapView = BMKMapView(frame: CGRect(x: 0, y: 0, width: self.contentView.frame.width, height: self.contentView.frame.height))
        mapView?.zoomLevel = 20
        self.contentView.addSubview(mapView!)
        self.contentView.sendSubviewToBack(mapView!)
    }
    
    
    // MARK:- SearchController method
    private func addSearchController() {
        let resultsController = SearchResultViewController()
        let searchController = UISearchController(searchResultsController: resultsController)
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.sizeToFit()
        
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "请输入植物名称"
        resultsController.searchBar = searchController.searchBar
        resultsController.rootNavigationController = self.navigationController
        
        self.resultsController = resultsController
        self.searchController = searchController
        
        self.navigationItem.titleView = searchController.searchBar
        self.definesPresentationContext = true
    }
    
    //MARK:- UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        //TODO:切换用户到对应的地点
    }
    
    //MARK:- location method
    private func setUpLocation() {
        locationManager = BMKLocationManager()
        locationManager.delegate = self
        locationManager.coordinateType = BMKLocationCoordinateType.BMK09LL
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = CLActivityType.automotiveNavigation
        locationManager.locationTimeout = 10
        locationManager.allowsBackgroundLocationUpdates = false
        locationManager.startUpdatingHeading()
        userLocation = BMKUserLocation()
        
    }
    
    private func getUserLocation() {
        mapView?.showsUserLocation = false//先关闭显示的定位图层
        mapView?.userTrackingMode = BMKUserTrackingModeFollowWithHeading;//设置定位的状态
        mapView?.showsUserLocation = true//显示定位图层
        locationManager.requestLocation(withReGeocode: true, withNetworkState: true) { [weak self] (location, networkState, error) in
            guard let `self` = self else {return}
            if let _ = error {
                self.contentView.show(text: "🤔获取定位出现了一些小意外")
                return
            }
            if let myLocation = location {
                if self.judgeLocation(myLocation) {
                    self.userLocation.location = myLocation.location
                }else {
                    let fixLocation = CLLocation(latitude: 29.828382, longitude: 106.430651)
                    self.userLocation.location = fixLocation
                    DispatchQueue.once(token: "com.yukun.swu.showTips", block: {
                        self.contentView.show(text: "不在学校会自动定位回学校噢")
                    })
                }
                self.mapView?.updateLocationData(self.userLocation)
            }
        }
    }
    
    private func judgeLocation(_ location: BMKLocation) -> Bool{
        if let realLocation = location.location?.coordinate {
            if realLocation.longitude < 106.45, realLocation.longitude > 106.40, realLocation.latitude < 29.85, realLocation.latitude > 29.79{
                return true
            }
        }
        return false
    }
    
    
    // MARK: - BMKlocationManagerDelegate
    func bmkLocationManager(_ manager: BMKLocationManager, didUpdate heading: CLHeading?) {
        if let tempHeading = heading {
            userLocation.heading = tempHeading
            self.mapView?.updateLocationData(userLocation)
        }
    }
    
    
    
    @IBAction func clickLocationButton(_ sender: Any) {
        getUserLocation()
    }
    
    //MARK:- locationAnimatedAnnotations method
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
        animatedAnnotation?.title = "查询"
        if number < 34 {
            animatedAnnotation?.subtitle = "\(number)号点"
        }else {
            animatedAnnotation?.subtitle = "\(number + 1)号点"
        }
        mapView?.addAnnotation(animatedAnnotation)
    }
    
    //MARK:- BMKMapViewDelegate
    func mapView(_ mapView: BMKMapView!, viewFor annotation: BMKAnnotation!) -> BMKAnnotationView! {
        // 动画标注
        if let point = annotation as? BMKPointAnnotation {
            let AnnotationViewID = point.subtitle
            let annotationView = AnimatedAnnotationView(annotation: annotation, reuseIdentifier: AnnotationViewID)
            let image = UIImage(named: "point.png")
            let images = [image!]
            annotationView.setImages(images)
            let stringTag = point.subtitle.filter{
                let str = String($0)
                if let _ = Int(str) {
                    return true
                }
                return false
            }
            guard stringTag.count > 0 else {return nil}
            if let tag = Int.init(stringTag) {
                annotationView.tag = tag
            }
            return annotationView
        }
        return nil
    }
    
    //MARK:- BMKMapViewDelegate
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
        PlantStore.shared.getPlantDataWith(location: String(view.tag)) { [weak self](datas, error) in
            if let plantDatas = datas {
                self?.showPlantListTVC(plantDatas,with: "\(view.tag)号点")
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
    
    func showPlantListTVC (_ plantDatas: [PlantData],with title:String) {
        let MainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        let plantListTVC = MainStoryboard.instantiateViewController(withIdentifier: "PlantListTableViewController") as? PlantListTableViewController
        if let VC = plantListTVC {
            VC.sourceData = plantDatas
            VC.navigationItem.title = title
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
}

