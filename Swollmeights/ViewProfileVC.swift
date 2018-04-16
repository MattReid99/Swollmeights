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

    @IBOutlet weak var imgView : UIImageView?
    @IBOutlet weak var nameLabel : UILabel?
    @IBOutlet weak var bioView : UITextView?
    @IBOutlet weak var expLabel : UILabel?
    @IBOutlet weak var ageLabel : UILabel?
    @IBOutlet weak var goalLabel : UILabel?
    
    var user : User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.isUserInteractionEnabled = true
        let swipe = UIPanGestureRecognizer.init(target: self, action: #selector(backPressed))
        //        let swipe = UITapGestureRecognizer.init(target: self, action: #selector(backPressed))
        //        swipe.numberOfTapsRequired = 1
        
        self.view.addGestureRecognizer(swipe)
        
        guard user != nil else {return}
        imgView?.downloadImage(from: user?.pathToImage)
        nameLabel?.text = user!.name
        expLabel?.text = "\(user!.exp)"
        ageLabel?.text = "\(user!.age)"
        bioView?.text = "\(user!.bio)"
        goalLabel?.text = "\(user!.goals)"
        
    }
    
    @objc func backPressed() {
        self.dismiss(animated: true, completion: nil)
    }
}
