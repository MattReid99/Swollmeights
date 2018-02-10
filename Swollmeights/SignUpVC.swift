//
//  SignUpVC.swift
//  Swollmeights
//
//  Created by Matthew Reid on 2/9/18.
//  Copyright © 2018 Matthew Reid. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class SignUpVC: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    
    override func viewDidAppear(_ animated: Bool) {

        GIDSignIn.sharedInstance().uiDelegate = self
        
        let uid = Auth.auth().currentUser?.uid
        if uid != nil {self.dismiss(animated: true, completion: nil)}
        
        btn1.addTarget(self, action: #selector(setupGoogleLogin), for: .touchUpInside)

        
        btn1.layer.cornerRadius = 7.0
        btn2.layer.cornerRadius = 7.0
        btn3.layer.cornerRadius = 7.0
        
        btn1.clipsToBounds = false
        btn2.clipsToBounds = false
        btn3.clipsToBounds = false
    }
    
    @objc func setupGoogleLogin() {
        let defaults = UserDefaults.standard
        guard defaults.string(forKey: "GoogleIDToken") == nil else {
            return
        }
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    @IBAction func completed(_ sender: UIButton) {
        let uid = Auth.auth().currentUser?.uid
        if uid != nil {self.dismiss(animated: true, completion: nil)}
    }
    
    
}
