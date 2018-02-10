//
//  MenuTableVC.swift
//  Swollmeights
//
//  Created by Matthew Reid on 1/12/18.
//  Copyright © 2018 Matthew Reid. All rights reserved.
//

import UIKit

class MenuTableVC: UITableViewController {

    var tableValues = [String]()
    var imgs = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        tableValues = ["Home", "Find", "Profile", "Matches", "Invite"]
//        imgs = [UIImage.init(named: "home.png")!,
//            UIImage.init(named: "profile.png")!,
//            UIImage.init(named: "location.png")!,
//            UIImage.init(named: "settings.png")!,
//            UIImage.init(named: "invite.png")!]
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableValues.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
            if let home = self.storyboard?.instantiateViewController(withIdentifier: "home") as? MainVC {
                
                self.revealViewController().setFront(home, animated: true)
                //self.revealViewController().setFrontViewPosition(FrontViewPosition.right, animated: true)
            }
        }
        else if indexPath.row == 1 {
           if let find = self.storyboard?.instantiateViewController(withIdentifier: "find") as? FindVC {
                
                self.revealViewController().setFront(find, animated: true)
                //self.revealViewController().setFrontViewPosition(FrontViewPosition.right, animated: true)
            }
        }
        else if indexPath.row == 2 {
            if let profile = self.storyboard?.instantiateViewController(withIdentifier: "profile") as? ProfileVC {
                
                self.revealViewController().setFront(profile, animated: true)
                //self.revealViewController().setFrontViewPosition(FrontViewPosition.right, animated: true)
            }
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = tableValues[indexPath.row]
        //cell.textLabel?.font =
        
        cell.textLabel?.textColor = UIColor.init(red: 71/255, green: 72/255, blue: 72/255, alpha: 0.8)
        cell.textLabel?.textAlignment = .left
        cell.textLabel?.font = UIFont.init(name: "HelveticaNeue-Medium", size: 24)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
