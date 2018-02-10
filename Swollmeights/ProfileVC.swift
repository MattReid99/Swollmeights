//
//  ProfileVC.swift
//  Swollmeights
//
//  Created by Matthew Reid on 2/8/18.
//  Copyright © 2018 Matthew Reid. All rights reserved.
//

import UIKit
import Firebase

class ProfileVC: UIViewController {
    
    
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var updateProfLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var editImgView: UIImageView!
    @IBOutlet weak var open: UIButton!
    @IBOutlet weak var ageLabel: UILabel!
    
    @IBOutlet weak var yearsLabel: UILabel!
    
    @IBOutlet weak var fitnessGoalLabel: UILabel!
    
    @IBOutlet weak var imageDisplay: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        
        ref.child("users").child(uid!).observeSingleEvent(of: .value, with: { snapshot in
            guard snapshot.exists() else {
                self.updateProfLabel.animateInAndOut()
                return
            }
            let data = snapshot.value as! [String : AnyObject]
            
            if let name = data["full name"] as? String, let age=data["age"] as? Int, let years=data["experience"] as? Int, let imagePath = data["pathToImage"] as? String, let fitnessGoal = data["fitnessGoal"] as? String {
                
                self.nameLabel.text = name
                self.ageLabel.text = "\(age)"
                self.fitnessGoalLabel.text = fitnessGoal
                self.yearsLabel.text = "\(years)"
                self.imageDisplay.downloadImage(from: imagePath)
                if let bio = data["bio"] as? String {
                    self.bioLabel.text = bio
                }
            }
            else {
                self.updateProfLabel.animateInAndOut()
            }
            ref.removeAllObservers()
        })
        
        editImgView.maskCircle(anyImage: editImgView.image!)
        editImgView.layer.shadowRadius = 2.0
        imageDisplay.maskCircle(anyImage: imageDisplay.image!)
                open.addTarget(self.revealViewController(), action:#selector(SWRevealViewController.revealToggle(_:)), for:UIControlEvents.touchUpInside)
       self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
}

extension UIImageView {
    public func maskCircle(anyImage: UIImage) {
        self.contentMode = UIViewContentMode.scaleAspectFill
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = false
        self.clipsToBounds = true
        
        // make square(* must to make circle),
        // resize(reduce the kilobyte) and
        // fix rotation.
        self.image = anyImage
    }
    
}

extension UIView {
    
    func animateInAndOut() {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: {
            (finished: Bool) -> Void in
            
            UIView.animate(withDuration: 1.0, delay: 5.5, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.alpha = 0.0
            }, completion: nil)
        })
    }
    
}

extension UIImageView {
    
    func downloadImage(from imgURL: String!) {
        let url = URLRequest(url: URL(string: imgURL)!)
        
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
        }
        task.resume()
    }
}

