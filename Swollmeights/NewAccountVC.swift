//
//  NewAccountVC.swift
//  Swollmeights
//
//  Created by Matthew Reid on 7/30/18.
//  Copyright © 2018 Matthew Reid. All rights reserved.
//

import UIKit
import Firebase

class NewAccountVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var pwField: UITextField!
    @IBOutlet weak var confirmPWfield: UITextField!
    
    @IBOutlet weak var signUpBtn: UIButton!
    
    override func viewDidLoad() {
        
        emailField.delegate = self
        pwField.delegate = self
        confirmPWfield.delegate = self
        
        //print("sign up btn frame:\n\(self.signUpBtn.frame)")
        
        emailField.layer.cornerRadius = 8.0
        emailField.clipsToBounds = false
        
        pwField.layer.cornerRadius = 8.0
        pwField.clipsToBounds = false
        
        confirmPWfield.layer.cornerRadius = 8.0
        confirmPWfield.clipsToBounds = false
    
        print("max Y for view = \(view.frame.maxY)")
        self.signUpBtn.frame = CGRect.init(x: 0, y: self.signUpBtn.frame.minY, width: self.containerView.frame.width, height: 50)
        
        self.emailField.frame = CGRect.init(x: 50, y: 0, width: view.frame.width-100, height: max(20, view.frame.height/10))
        
        self.pwField.frame = CGRect.init(x: 50, y: self.emailField.frame.maxY + 20, width: view.frame.width-100, height: max(20, view.frame.height/10))
        
        self.confirmPWfield.frame = CGRect.init(x: 50, y: self.pwField.frame.maxY + 20, width: view.frame.width-100, height: max(20, view.frame.height/10))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func signUpPressed() {
        guard emailField.text != nil && pwField.text! == confirmPWfield.text! && (emailField.text?.contains("@"))! && (emailField.text?.count)! < 30 && (emailField.text?.count)! > 4 && (confirmPWfield.text?.count)! >= 5  else {
            return
        }
        let defaults = UserDefaults.standard
        
        let ref = Database.database().reference()

        Auth.auth().createUser(withEmail: emailField.text!, password: pwField.text!) { (user, error) in
            
            if error == nil {
                let user = Auth.auth().currentUser!
                
                defaults.set(self.emailField.text, forKey: "email")
                defaults.set(self.pwField.text, forKey: "password")
                defaults.set(user.uid, forKey: "uid")
                defaults.synchronize()
                ref.child("users").child(user.uid).child("uid").setValue(user.uid)
                
                
                let alert = UIAlertController.init(title: "Created account successfully", message: "Now, sign-in and find your Swollmeight!", preferredStyle: UIAlertControllerStyle.actionSheet)
                alert.addAction(UIAlertAction.init(title: "Done", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            } else {
                let alert = UIAlertController.init(title: "Account creation failed", message: error!.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction.init(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
                }
            }
        }
    }
