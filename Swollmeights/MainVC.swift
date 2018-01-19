//
//  MainVC.swift
//  Swollmeights
//
//  Created by Matthew Reid on 1/12/18.
//  Copyright © 2018 Matthew Reid. All rights reserved.
//

import UIKit
import GoogleMaps

class MainVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var open: UIButton!
    
    var trainingDays = [String]()
    var images = [UIImage]()
    var prevSelectedIndex : IndexPath?
    var months = [String]()
    var days = [UIButton]()
    
    @IBOutlet weak var mapViewFrame: UIView!
    @IBOutlet weak var currDayIndicator: UIView!
    
    var calendarToggled : Bool = false
    
    @IBOutlet weak var dayLabel: UILabel!
    
    @IBOutlet weak var d1: UIButton!
    @IBOutlet weak var d2: UIButton!
    @IBOutlet weak var d3: UIButton!
    @IBOutlet weak var d4: UIButton!
    @IBOutlet weak var d5: UIButton!
    @IBOutlet weak var d6: UIButton!
    @IBOutlet weak var d7: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let camera = GMSCameraPosition.camera(withLatitude: 40.9312, longitude: -73.8987, zoom: 15.0)
        var mapView = GMSMapView.map(withFrame: mapViewFrame.frame, camera: camera)
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 40.9312, longitude: -73.8987)
        marker.title = "Yonkers"
        marker.snippet = "NY"
        marker.map = mapView
        
        view.addSubview(mapView)
        view.sendSubview(toBack: mapView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.backgroundColor = UIColor.clear
        
        trainingDays = ["Arms", "Chest", "Back", "Legs", "Cardio", "Core", "Push", "Pull", "Other"]
        
        months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
        
        days = [d1, d2, d3, d4, d5, d6, d7]
        
        var counter = 0
        
        for elem in days {

            elem.addTarget(self, action: #selector(MainVC.dayChanged), for: .touchUpInside)
            
            if counter != 0 {
            elem.frame = CGRect.init(x: elem.frame.origin.x, y: days[counter-1].frame.origin.y+50, width: elem.frame.width, height: elem.frame.height)
            }
            counter = counter + 1
        }
        
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let weekDay = calendar.component(.weekday, from: date)
        
        var dateSuffix : String = "th"
        
        if (day == 1 || day == 21 || day == 31) {
            dateSuffix = "st"
        }
        if (day == 2) {
            dateSuffix = "nd"
        }
        if (day == 1 || day == 21 || day == 31) {
            dateSuffix = "rd"
        }
        
        dayLabel.text = "\(months[month-1]) \(day)\(dateSuffix), \(year)"
        
        let gradient = CAGradientLayer()
        
        gradient.frame = view.bounds
        gradient.colors = [UIColor.init(red: 201/255, green: 255/255, blue: 209/255, alpha: 0.7).cgColor, UIColor.init(red: 53/255, green: 198/255, blue: 39/255, alpha: 0.6).cgColor]
        
        self.view.layer.insertSublayer(gradient, at: 0)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        open.addTarget(self.revealViewController(), action:#selector(SWRevealViewController.revealToggle(_:)), for:UIControlEvents.touchUpInside)
    self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        // Do any additional setup after loading the view.
    }
    
    @IBAction func showDatePressed(_ sender: UIButton) {
        if calendarToggled {
        for elem in days {
            elem.isHidden = true
            currDayIndicator.isHidden = true
            calendarToggled = false
            }
        }
        else {
        for elem in days {
            elem.isHidden = false
            currDayIndicator.isHidden = false
            calendarToggled = true
            }
        }
    }
    
    // weekday is from 1-7,
    
    @objc func dayChanged(_ sender: UIButton) {

        currDayIndicator.alpha = 0.0
        for elem in days {
            if sender == elem {
                currDayIndicator.frame = CGRect.init(x: sender.frame.origin.x, y: sender.frame.origin.y, width: currDayIndicator.frame.width, height: currDayIndicator.frame.height)
                currDayIndicator.fadeIn(duration: 0.5)
                let date = Date()
                
            }
        }
    }
    
//    override func loadView() {
//        // Create a GMSCameraPosition that tells the map to display the
//        // coordinate -33.86,151.20 at zoom level 6.
//
//        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
//        var mapView = GMSMapView.map(withFrame: CGRect.init(x: 32, y: 172, width: 310, height: 298), camera: camera)
//
//        // Creates a marker in the center of the map.
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: 40.9312, longitude: 73.8987)
//        marker.title = "Yonkers"
//        marker.snippet = "NY"
//        marker.map = mapView
//    }
    
}

extension MainVC : UICollectionViewDataSource, UICollectionViewDelegate
{

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trainingDays.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! LiftCell
        
        cell.selectionIndicator.alpha = 0.0
        cell.layoutSubviews()
        cell.dayLabel.text = trainingDays[indexPath.row]
        
        if prevSelectedIndex == indexPath {
            cell.selectionIndicator.fadeIn(duration: 0.5)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! LiftCell
        
        
        prevSelectedIndex = indexPath
        collectionView.reloadData()
    }
    
}

public extension UIView {
    
    /**
     Fade in a view with a duration
     
     - parameter duration: custom animation duration
     */
    func fadeIn(duration: TimeInterval = 1.0) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1.0
        })
    }
}
