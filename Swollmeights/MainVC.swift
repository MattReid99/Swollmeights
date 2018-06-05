//
//  MainVC.swift
//  Swollmeights
//
//  Created by Matthew Reid on 1/12/18.
//  Copyright © 2018 Matthew Reid. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase
import CloudKit
//import MapKit
import CoreLocation
//import PlaygroundSupport
//PlaygroundPage.current.needsIndefiniteExecution = true

class MainVC: UIViewController, SWRevealViewControllerDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var open: UIButton!
    @IBOutlet weak var locationBtn: UIButton!
    
    var trainingDays = [String]()
    var images = [UIImage]()
    var prevSelectedIndex : IndexPath?
    var months = [String]()
    var days = [UIButton]()
    
    @IBOutlet weak var mapViewFrame: UIView!
    @IBOutlet weak var currDayIndicator: UIView!
    
    var calendarToggled : Bool = false
    var location : String?
    
    @IBOutlet weak var dayLabel: UILabel!
    
    let locationManager = CLLocationManager()
//    @IBOutlet weak var d1: UIButton!
//    @IBOutlet weak var d2: UIButton!
//    @IBOutlet weak var d3: UIButton!
//    @IBOutlet weak var d4: UIButton!
//    @IBOutlet weak var d5: UIButton!
//    @IBOutlet weak var d6: UIButton!
//    @IBOutlet weak var d7: UIButton!
    

    override func viewWillAppear(_ animated: Bool) {
        let uid = Auth.auth().currentUser?.uid
        
        let defaults = UserDefaults.standard
        
        guard uid != nil else {
            let signUp = self.storyboard?.instantiateViewController(withIdentifier: "signUp") as! SignUpVC
            self.present(signUp, animated: true, completion: nil)
            return
        }
        
        locationBtn.layer.cornerRadius = 12
        
        writeBlockedBy()
        
        // Ask for Authorisation from the User.
        
        // For use in foreground
        
        // before updating database, check if user wants to use custom location
        
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            
        }
        
        let ref = Database.database().reference()
        
        
        // if location in defaults is current, keep button state as "current location", else, upload new location, change
        
        
        geocode(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!) { placemark, error in
            guard let placemark = placemark, error == nil else {
                return }
            // you should always update your UI in the main thread
            DispatchQueue.main.async {
                //  update UI here

                if (!defaults.bool(forKey: "customLocation")) {
                
                self.location = placemark.locality!+", "+placemark.administrativeArea!
                let feed = ["location" : self.location!]
                ref.child("users").child(uid!).updateChildValues(feed)
                                let defaults = UserDefaults.standard
                                defaults.set(self.location!, forKey: "location")
                }
                else {
                    
                    guard defaults.string(forKey: "location") != nil else {
                        self.location = placemark.locality!+", "+placemark.administrativeArea!
                        let feed = ["location" : self.location!]
                        ref.child("users").child(uid!).updateChildValues(feed)
                        let defaults = UserDefaults.standard
                        defaults.set(self.location!, forKey: "location")
                        
                        return
                    }
                    
                    self.locationBtn.setTitle("\(defaults.string(forKey: "location")!.substring(to: (defaults.string(forKey: "location")!.index(of: ","))!))", for: .normal)
        
                }
            }
        }
        
       
        let camera = GMSCameraPosition.camera(withLatitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!, zoom: 8.0)
        var mapView = GMSMapView.map(withFrame: mapViewFrame.frame, camera: camera)
        
        if let jsonMap = Bundle.main.path(forResource: "jsonMap", ofType: "txt") {
            do {
                let contents = try String(contentsOfFile: jsonMap)
                do {
                    // Set the map style by passing a valid JSON string.
                    
                    mapView.mapStyle = try GMSMapStyle(jsonString: contents)
                } catch {
                    NSLog("One or more of the map styles failed to load. \(error)")
                }
            }
            catch {
                NSLog("One or more of the map styles failed to load. \(error)")
            }
        }
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        
        var markerImage = UIImage.init(named: "icons8-marker-90.png")
        markerImage = self.imageWithImage(image: markerImage!, scaledToSize: .init(width: 40, height: 40))
        
        marker.position = (locationManager.location?.coordinate)!
        marker.map = mapView
        marker.icon = markerImage!
        marker.appearAnimation = .pop
        
        view.addSubview(mapView)
        view.sendSubview(toBack: mapView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.backgroundColor = UIColor.clear
        
        trainingDays = ["Arms", "Chest", "Back", "Legs", "Cardio", "Core", "Push", "Pull", "Other"]
        
        months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
        
        //        days = [d1, d2, d3, d4, d5, d6, d7]
        //
        //        var counter = 0
        //
        //        for elem in days {
        //
        //            elem.addTarget(self, action: #selector(MainVC.dayChanged), for: .touchUpInside)
        //
        //            if counter != 0 {
        //            elem.frame = CGRect.init(x: elem.frame.origin.x, y: days[counter-1].frame.origin.y+50, width: elem.frame.width, height: elem.frame.height)
        //            }
        //            counter = counter + 1
        //        }
        
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
        gradient.colors = [UIColor.init(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0).cgColor,
                           UIColor.init(red: 82/255, green: 150/255, blue: 213/255, alpha: 0.6).cgColor]
        
        self.view.layer.insertSublayer(gradient, at: 0)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        open.addTarget(self.revealViewController(), action:#selector(SWRevealViewController.revealToggle(_:)), for:UIControlEvents.touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        // Do any additional setup after loading the view.
        ref.child("users").child(uid!).child("full name").observeSingleEvent(of: .value, with: { snapshot in
            
            guard snapshot.exists() else {
                defaults.set(" ", forKey: "full name")
                return
            }
            let name = snapshot.value as! String
            defaults.set(name, forKey: "full name")
        })
        ref.removeAllObservers()
    }
    
    @IBAction func locationBtnPressed(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        let uid =  Auth.auth().currentUser?.uid
        let isCustom = defaults.bool(forKey: "customLocation")
        
        if isCustom {
            defaults.set(false, forKey: "customLocation")
            locationBtn.setTitle("Your location", for: .normal)
            
            let ref = Database.database().reference()
            geocode(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!) { placemark, error in
                guard let placemark = placemark, error == nil else {
                    return }
                // you should always update your UI in the main thread
                DispatchQueue.main.async {
                    //  update UI here
                        
                        self.location = placemark.locality!+", "+placemark.administrativeArea!
                        let feed = ["location" : self.location!]
                        ref.child("users").child(uid!).updateChildValues(feed)
                        let defaults = UserDefaults.standard
                        defaults.set(self.location!, forKey: "location")
                }
            }
        }
        else {
            
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            
            let changeLocVC = storyboard.instantiateViewController(withIdentifier: "changeLocation") as! ChangeLocationVC
            
            self.present(changeLocVC, animated: true, completion: nil)
            }
        }
    
    // write any users who curr user is blocked by to userdefaults
    func writeBlockedBy() {
        let defaults = UserDefaults.standard
        var blockedUsers = [String]()
        
        if defaults.array(forKey: "blockedUsers") != nil {
            blockedUsers = defaults.array(forKey: "blockedUsers") as! [String]
        }
        
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        
        ref.child("users").child(uid!).child("blockedBy").observeSingleEvent(of: .value, with: { snapshot in
            
            guard snapshot.exists() else { return }
            
            if let list = snapshot.value as? [String : String] {
                for (_, elem) in list {
                    blockedUsers.append(elem)
                }
            }
            ref.removeAllObservers()
            ref.child("users").child(uid!).child("blockedBy").removeValue()
        })
    }
    
    func geocode(latitude: Double, longitude: Double, completion: @escaping (CLPlacemark?, Error?) -> ())  {
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { completion($0?.first, $1) }
    }
    
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.draw(in: CGRect.init(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//
//    }
    
//    @IBAction func showDatePressed(_ sender: UIButton) {
//        if calendarToggled {
//        for elem in days {
//            elem.isHidden = true
//            currDayIndicator.isHidden = true
//            calendarToggled = false
//            }
//        }
//        else {
//        for elem in days {
//            elem.isHidden = false
//            currDayIndicator.isHidden = false
//            calendarToggled = true
//            }
//        }
//    }
    
    
    
    
    // weekday is from 1-7,
    
//    @objc func dayChanged(_ sender: UIButton) {
//
//        currDayIndicator.alpha = 0.0
//        for elem in days {
//            if sender == elem {
//                currDayIndicator.frame = CGRect.init(x: sender.frame.origin.x, y: sender.frame.origin.y, width: currDayIndicator.frame.width, height: currDayIndicator.frame.height)
//                currDayIndicator.fadeIn(duration: 0.5)
//                let date = Date()
//
//            }
//        }
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
        
        let indicators = [cell.selectionIndicator, cell.topIndicator, cell.leftIndicator, cell.rightIndicator]
        
        for elem in indicators {
            elem?.alpha = 0
        }
        
        cell.layoutSubviews()
        cell.dayLabel.text = trainingDays[indexPath.row]
        
        if prevSelectedIndex == indexPath {
            for elem in indicators {
                elem?.fadeIn(duration: 0.4)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! LiftCell
        
        
        prevSelectedIndex = indexPath
        collectionView.reloadData()
    }
    
    
    func fetchCountryAndCity(location: CLLocation, completion: @escaping (String, String) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print(error)
            } else if let country = placemarks?.first?.country,
                let city = placemarks?.first?.locality {
                completion(country, city)
            }
        }
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
