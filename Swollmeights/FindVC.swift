//
//  FindVC.swift
//  Swollmeights
//
//  Created by Matthew Reid on 1/14/18.
//  Copyright © 2018 Matthew Reid. All rights reserved.
//

import UIKit

class FindVC: UIViewController {

    @IBOutlet weak var open: UIButton!
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var imageStrings = [String]()
    
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.revealViewController().revealToggle(animated: true)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
        
        imageStrings = ["IMG-6709.PNG", "IMG-7211.JPG"]
        
        btn1.layer.cornerRadius = 4.0
        btn1.clipsToBounds = false
        btn2.layer.cornerRadius = 4.0
        btn2.clipsToBounds = false
        
        let gradient = CAGradientLayer()
        
        gradient.frame = view.bounds
        gradient.colors = [UIColor.init(red: 46/255, green: 47/255, blue: 50/255, alpha: 0.95).cgColor, UIColor.init(red: 92/255, green: 94/255, blue: 102/255, alpha: 0.8).cgColor]
        
        self.view.layer.insertSublayer(gradient, at: 0)
        
        open.addTarget(self.revealViewController(), action:#selector(SWRevealViewController.revealToggle(_:)), for:UIControlEvents.touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension FindVC : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageStrings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCVCell
        
        cell.backgroundColor = UIColor.clear
        cell.imgView.image = UIImage.init(named: imageStrings[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // potentially expand image
    }
    
    
    
}
