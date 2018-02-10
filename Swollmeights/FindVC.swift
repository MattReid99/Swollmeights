//
//  FindVC.swift
//  Swollmeights
//
//  Created by Matthew Reid on 1/14/18.
//  Copyright © 2018 Matthew Reid. All rights reserved.
//

import UIKit
import Firebase

class FindVC: UIViewController {

    var currQuery : DatabaseQuery?
    @IBOutlet weak var open: UIButton!

    var endIndex : Int = 8
    
    @IBOutlet weak var matchBtn : UIButton!
    @IBOutlet weak var noBtn : UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!

    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        retrieveUsers()
        //self.revealViewController().revealToggle(animated: true)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
        
        self.noBtn.layer.cornerRadius = 7.0
        self.matchBtn.layer.cornerRadius = 7.0
        
        self.noBtn.layer.borderColor = UIColor.white.cgColor
        self.noBtn.layer.borderWidth = 1.0
        
        self.matchBtn.layer.borderColor = UIColor.white.cgColor
        self.matchBtn.layer.borderWidth = 1.0
        
        self.matchBtn.clipsToBounds = true
        self.noBtn.clipsToBounds = true
    
        
        open.addTarget(self.revealViewController(), action:#selector(SWRevealViewController.revealToggle(_:)), for:UIControlEvents.touchUpInside)
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    func retrieveUsers() {
        
        currQuery = Database.database().reference().child("users").queryLimited(toFirst: UInt(endIndex))
        
        currQuery?.observe(.childAdded, with: { snapshot in
            
            
            if let element = snapshot.value as? [String: AnyObject] {
                
                let user = User()
                if let n = element["full name"] as? String, let uid = element["uid"] as? String, let pti = element["pathToImage"] as? String, let e = element["experience"] as? Int, let a = element["age"] as? Int, let b = element["bio"] as? String, let g = element["fitnessGoal"] as? String {
                    user.name = n
                    user.userID = uid
                    user.pathToImage = pti
                    user.exp = e
                    user.age = a
                    user.bio = b
                    user.goals = g
                    
                    self.users.append(user)
                    self.collectionView.reloadData()
                }
            }
        })
    }
    
    
    @IBAction func matchPressed(_ sender: UIButton) {
        endIndex = endIndex+1
        
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        
        guard users.count != 0 else {return}
        let feed = ["full name" : users[0].name,
                    "age" : users[0].age,
        "pathToImage" : users[0].pathToImage,
        "uid" : users[0].userID] as! [String:Any]
        ref.child("matches").child(uid!).child(users[0].userID).updateChildValues(feed)
        
        users.remove(at: 0)
        collectionView.reloadData()
    }
    
    @IBAction func skipPressed(_ sender: UIButton) {
        users.remove(at: 0)
        collectionView.reloadData()
    }
    
    
    
    
    
}
    

extension FindVC : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCVCell
        
        cell.backgroundColor = UIColor.clear
        cell.imgView.downloadImage(from: users[indexPath.row].pathToImage)
        
        cell.nameLabel.text = users[indexPath.row].name
        cell.ageLabel.text =
            "\(users[indexPath.row].age)"
        cell.experienceLabel.text = "\(users[indexPath.row].exp)"
        cell.goalLabel.text = users[indexPath.row].goals
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // potentially expand image
    }
    
    
    
}
