//
//  SignUpVC.swift
//  Swollmeights
//
//  Created by Matthew Reid on 2/9/18.
//  Copyright © 2018 Matthew Reid. All rights reserved.
//

import UIKit
import Firebase


class SignUpVC: UIViewController, UITextFieldDelegate
    {
    
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var signInView: UIView!
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var pwField: UITextField!
    
    @IBOutlet weak var buttonContainer: UIView!
    
    //@IBOutlet weak var signInIndicator: UIView!
    //@IBOutlet weak var signUpIndicator: UIView!
    
    var signInIndicator: UIView?
    var signUpIndicator: UIView?
    
    
    override func viewDidLoad() {
        
        emailField.delegate = self
        pwField.delegate = self
        
        emailField.layer.cornerRadius = 8.0
        emailField.clipsToBounds = false
        
        pwField.layer.cornerRadius = 8.0
        pwField.clipsToBounds = false
        
        containerView.isHidden = true
        
        signInIndicator = UIView.init()
        self.buttonContainer.addSubview(signInIndicator!)
        
        
        signInIndicator?.frame = CGRect.init(x: 0, y: 0, width: signInBtn.frame.width, height: 3)
        
        signUpIndicator = UIView.init()
        self.buttonContainer.addSubview(signUpIndicator!)
        
        
        signUpIndicator?.frame = CGRect.init(x: signUpBtn.frame.minX, y: 0, width: signUpBtn.frame.width, height: 3)
        
        signInIndicator?.alpha = 1.0
        signUpIndicator?.alpha = 0.0
        signInIndicator?.backgroundColor = signInBtn.titleColor(for: UIControlState.normal)
        signUpIndicator?.backgroundColor = signInBtn.titleColor(for: UIControlState.normal)
        
        
        let defaults = UserDefaults.standard
        
        let uid = Auth.auth().currentUser?.uid
        if uid != nil {self.dismiss(animated: true, completion: nil)}
        
        
        if defaults.string(forKey: "uid") != nil && defaults.string(forKey: "email") != nil && defaults.string(forKey: "password") != nil {
            self.emailField.text = defaults.string(forKey: "email")
            self.pwField.text = defaults.string(forKey: "password")
        }
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.emailField.frame = CGRect.init(x: 40, y: 30, width: self.view.frame.maxX - 40, height: 40)
            self.pwField.frame = CGRect.init(x: 40, y: 90, width: self.view.frame.maxX - 40, height: 40)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func signUpPressed() {
        signInIndicator?.alpha = 0.0
        signUpIndicator?.fadeIn(duration: 0.6)
        containerView.isHidden = false
        signInView.isHidden = true
        
    }
    
    @IBAction func signInPressed() {
        signUpIndicator?.alpha = 0.0
        signInIndicator?.fadeIn(duration: 0.6)
        containerView.isHidden = true
        signInView.isHidden = false
        
    }

    @IBAction func signInAttempt() {
        let auth = Auth.auth()
        let ref = Database.database().reference()
        let defaults = UserDefaults.standard

        
        auth.signIn(withEmail: emailField.text!, password: pwField.text!) { (user, error) in
            
            if error == nil {
                let user = Auth.auth().currentUser!
                
                defaults.set(self.emailField.text, forKey: "email")
                defaults.set(self.pwField.text, forKey: "password")
                defaults.set(user.uid, forKey: "uid")
                
                defaults.synchronize()
                ref.child("users").child(user.uid).child("uid").setValue(user.uid)
                self.dismiss(animated: true, completion: nil)
            } else {
                let alert = UIAlertController.init(title: "Failed to sign-in to account", message: error!.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction.init(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
                    }
                }
            }
    
    }
