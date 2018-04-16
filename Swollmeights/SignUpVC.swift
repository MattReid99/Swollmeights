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

    let gradient = CAGradientLayer()
    var gradientSet = [[CGColor]]()
    var currentGradient: Int = 0
    
    let gradientOne = UIColor(red: 237/255, green: 243/255, blue: 255/255, alpha: 1).cgColor
    let gradientTwo = UIColor(red: 74/255, green: 183/255, blue: 247/255, alpha: 1).cgColor
    let gradientThree = UIColor(red: 22/255, green: 76/255, blue: 180/255, alpha: 1).cgColor
    
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        let uid = Auth.auth().currentUser?.uid
        if uid != nil {self.dismiss(animated: true, completion: nil)}
        
        gradientSet.append([gradientOne, gradientTwo])
        gradientSet.append([gradientTwo, gradientThree])
        gradientSet.append([gradientThree, gradientOne])
        
        
        gradient.frame = self.gradientView.bounds
        gradient.colors = gradientSet[currentGradient]
        gradient.startPoint = CGPoint(x:0, y:0)
        gradient.endPoint = CGPoint(x:1, y:1)
        gradient.drawsAsynchronously = true
        self.gradientView.layer.addSublayer(gradient)
        
        animateGradient()
        
        
        btn1.addTarget(self, action: #selector(setupGoogleLogin), for: .touchUpInside)

        
        btn1.layer.cornerRadius = 7.0
        btn2.layer.cornerRadius = 7.0
        btn3.layer.cornerRadius = 7.0
        
        btn1.clipsToBounds = false
        btn2.clipsToBounds = false
        btn3.clipsToBounds = false
    }
    
    
    func animateGradient() {
        if currentGradient < gradientSet.count - 1 {
            currentGradient += 1
        } else {
            currentGradient = 0
        }
        
        let gradientChangeAnimation = CABasicAnimation(keyPath: "colors")
        gradientChangeAnimation.duration = 3.0
        gradientChangeAnimation.toValue = gradientSet[currentGradient]
        gradientChangeAnimation.fillMode = kCAFillModeForwards
        gradientChangeAnimation.isRemovedOnCompletion = false
        gradient.add(gradientChangeAnimation, forKey: "colorChange")
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

extension SignUpVC: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        print("finished animation, didnt throw flag")
        if flag {
            
            print("switched gradient")
            gradient.colors = gradientSet[currentGradient]
            animateGradient()
        }
    }
}
