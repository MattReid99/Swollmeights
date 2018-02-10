//
//  AppDelegate.swift
//  Swollmeights
//
//  Created by Matthew Reid on 1/11/18.
//  Copyright © 2018 Matthew Reid. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Firebase
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       

        GMSServices.provideAPIKey("AIzaSyCiT8zVnpjuvsVempLXCWReTof-NslIoO8")
        GMSPlacesClient.provideAPIKey("AIzaSyCiT8zVnpjuvsVempLXCWReTof-NslIoO8")
        
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        
        GIDSignIn.sharedInstance().delegate = self
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled = GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
        GIDSignIn.sharedInstance().handle(url,
                                          sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                          annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        return handled
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error) != nil {
            return
        }
        guard let id = user.authentication.idToken, let access = user.authentication.accessToken else {return}
        let credentials = GoogleAuthProvider.credential(withIDToken: id, accessToken: access)
        
        Auth.auth().signIn(with: credentials, completion: { (user, error) in
            if error != nil {
                return
            }
            
            let defaults = UserDefaults.standard
            
            if defaults.string(forKey: "GoogleIDToken") != id {
                
                // CLEAR PREVIOUS USER DATA + SET NAME
                let domain = Bundle.main.bundleIdentifier!

                
                let ref = Database.database().reference()
                ref.child("users").child((user?.uid)!).observeSingleEvent(of: .value, with: { snapshot in
                    
                    if !snapshot.exists() {
                        
                        let userInfo: [String : String] = ["uid" : (user?.uid)!, "full name" : (user?.displayName!)!, "bio" : " ", "fitnessGoals" : " "]
                        ref.child("users").child((user?.uid)!).setValue(userInfo)
                    }
                    
                })
            }
        })
    }
    
    func setupGoogleLogin() {
        let defaults = UserDefaults.standard
        guard defaults.string(forKey: "GoogleIDToken") == nil else {

            return
        }
        
        GIDSignIn.sharedInstance().signIn()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

