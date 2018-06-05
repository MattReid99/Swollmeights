//
//  ViewProfileVC.swift
//  Swollmeights
//
//  Created by Matthew Reid on 3/26/18.
//  Copyright © 2018 Matthew Reid. All rights reserved.
//

import UIKit
import Firebase

class ViewProfileVC: UIViewController {

    @IBOutlet weak var imgView : UIImageView!
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var expLabel : UILabel!
    @IBOutlet weak var ageLabel : UILabel!
    @IBOutlet weak var txtView : UITextView!
    
    
    @IBOutlet weak var goalOverlay: UIView!
    @IBOutlet weak var bioOverlay: UIView!
    
    var user : User?
    var bioTxt : String?
    var goalTxt : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.isUserInteractionEnabled = true
        let swipe = UIPanGestureRecognizer.init(target: self, action: #selector(backPressed))
        //        let swipe = UITapGestureRecognizer.init(target: self, action: #selector(backPressed))
        //        swipe.numberOfTapsRequired = 1
        
        self.view.addGestureRecognizer(swipe)
        
        guard user != nil else {return}
        imgView.downloadImage(from: user?.pathToImage)
        nameLabel.text = user!.name
        expLabel.text = "\(user!.exp) years"
        ageLabel.text = "\(user!.age)"
        bioTxt = "\(user!.bio)"
        txtView.text = "\(user!.goals)"
        
        UIView.animate(withDuration: 0.5, animations: {
            self.goalOverlay.alpha = 0.4
        })
    }
    
    @IBAction func bioPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 1.0, animations: {
            self.bioOverlay.alpha = 0.4
        })
        UIView.animate(withDuration: 1.0, animations: {
            self.goalOverlay.alpha = 0
        })
        guard bioTxt != nil else {
            return
        }
        txtView.text = bioTxt!
    }
    
    @IBAction func goalsPressed(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.goalOverlay.alpha = 0.4
        })
        UIView.animate(withDuration: 0.5, animations: {
            self.bioOverlay.alpha = 0
        })
        guard goalTxt != nil else {
            return
        }
        txtView.text = goalTxt!
    }
    
    
    @IBAction func moreOptionsPressed(_ sender: UIButton) {
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        
        let options = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let report = UIAlertAction.init(title: "Report user", style: .destructive, handler: { (action:UIAlertAction!) in
            ref.child("users").child((self.user?.userID)!).child("reported").setValue((self.user?.numReports)!+1)
            })
        let block = UIAlertAction.init(title: "Block user", style: .default, handler: { (action:UIAlertAction!) in
            
            let defaults = UserDefaults.standard
            var blocked = [String]()
            
            if defaults.array(forKey: "blockedUsers") != nil {
                blocked = defaults.array(forKey: "blockedUsers") as! [String]
            }
            blocked.append((self.user?.userID)!)
            defaults.set(blocked, forKey: "blockedUsers")
            
            ref.child("matches").child((self.user?.userID)!).child(uid!).removeValue()
            ref.child("matches").child(uid!).child((self.user?.userID)!).removeValue()
            
            ref.child("messages").child((self.user?.userID)!).child(uid!).removeValue()
            
            ref.child("messages").child(uid!).child((self.user?.userID)!).removeValue()
            ref.child("users").child((self.user?.userID)!).child("blockedBy").updateChildValues([uid! : uid!])
        })
        let cancel = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        
        options.addAction(report)
        options.addAction(block)
        options.addAction(cancel)
        self.present(options, animated: true, completion: nil)
    }
    
    
    @objc @IBAction func backPressed(_sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
