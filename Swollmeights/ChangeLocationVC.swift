//
//  ChangeLocationVC.swift
//  Swollmeights
//
//  Created by Matthew Reid on 4/16/18.
//  Copyright © 2018 Matthew Reid. All rights reserved.
//

import UIKit
import Firebase

class ChangeLocationVC: UIViewController {
    
    @IBOutlet weak var didYouMeanLabel: UILabel!
    
    @IBOutlet weak var l1 : UIView!
    @IBOutlet weak var l2 : UIView!
    @IBOutlet weak var l3 : UIView!
    var views = [UIView]()
    
    @IBOutlet weak var t1 : UILabel!
    @IBOutlet weak var t2 : UILabel!
    @IBOutlet weak var t3 : UILabel!
    var labels = [UILabel]()
    
    @IBOutlet weak var b1 : UIButton!
    @IBOutlet weak var b2 : UIButton!
    @IBOutlet weak var b3 : UIButton!
    var buttons = [UIButton]()
    
    @IBOutlet weak var searchField: UITextField!
    
    var locations = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        views.append(l1)
        views.append(l2)
        views.append(l3)
        labels.append(t1)
        labels.append(t2)
        labels.append(t3)
        buttons.append(b1)
        buttons.append(b2)
        buttons.append(b3)
        
        for elem in buttons {
            elem.addTarget(self, action: #selector(locationPressed), for: .touchUpInside)
        }
        
        self.view.isUserInteractionEnabled = true
        let swipe = UIPanGestureRecognizer.init(target: self, action: #selector(backPressed))
        self.view.addGestureRecognizer(swipe)
    }
    
    
    @IBAction func searchPressed(_ sender: UIButton) {
        locations.removeAll()
        
        didYouMeanLabel.text = "No results found"
        didYouMeanLabel.isHidden = false
        
        let searchTxt = searchField.text!
        
        let ref = Database.database().reference()
        
        var currQuery : DatabaseQuery?
        
              currQuery = Database.database().reference().child("users").queryOrdered(byChild: "location").queryStarting(atValue: searchTxt).queryEnding(atValue: searchTxt + "\u{f8ff}")
        
        var counter = 0
        
        currQuery?.observe(.childAdded, with: { snapshot in
            
            if let element = snapshot.value as? [String: AnyObject] {
                
                if let temp = element["location"] as? String {
                   
                    guard counter < 3 else {
                       return }
                    
                    self.locations.append(temp)
                    counter = counter + 1
                    self.updateResults()
                }
            }
        })
    }
    
    @objc func locationPressed(_ sender: UIButton) {
        let max = locations.count
        var counter = 0
        
        while counter < max {
            if sender == buttons[counter] {
                let defaults = UserDefaults.standard
                defaults.set(true, forKey: "customLocation")
                defaults.set(locations[counter], forKey: "location")
                self.dismiss(animated: true, completion: nil)
            }
            counter = counter + 1
        }
    }
    
    func updateResults() {
        var set = Set(locations)
        locations.removeAll()
        
        for val in set {
            locations.append(val)
        }
        
        let max = locations.count
        var c1 = 0
        
        while c1 < max {
            views[c1].isHidden = true
            labels[c1].isHidden = true
            buttons[c1].isHidden = true
            c1 = c1+1
        }
        
        didYouMeanLabel.isHidden = false
        didYouMeanLabel.text = "Did you mean"
        var counter = 0
        
        while counter < max {
            views[counter].isHidden = false
            labels[counter].isHidden = false
            labels[counter].text = locations[counter]
            buttons[counter].isHidden = false
            counter = counter+1
        }
        
    }
    
    @objc @IBAction func backPressed(_sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
