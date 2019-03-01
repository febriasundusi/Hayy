//
//  AppDelegate.swift
//  Hayy
//
//  Created by Herlangga Wibi Yandi Nasution on 25/01/19.
//  Copyright © 2019 PT. Buana Kebenaran Informatika. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

var currentUser: [String: String] = [:]

var data_user: NSDictionary?

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    
    
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        let error1 = error
        if error1 != nil {
            print(error!.localizedDescription)
        }
        
        
        
        
        guard let user1 = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: user1.idToken,
                                                       accessToken: user1.accessToken)
        
        
        
        let gender = "m"
        let fullName = user.profile.name ?? ""
        let image = "-"
        let fcm = UUID().uuidString
        let notif_on_like = "0"
        let notif_on_dislike = "0"
        let notif_on_comment = "0"
        let userId = user.userID ?? "No User Id"
        let email = user.profile.email ?? "No Email"
        let token = user.authentication.idToken
        let update = 1
        
       
        
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            // User is signed in
            // ...
            
            
            
            
            
        }
        //window?.rootViewController?.performSegue(withIdentifier: "TabBar", sender: nil)
        self.createUser(gender: gender, fullName: fullName, image: image, fcm: fcm, notif_on_like: notif_on_like, notif_on_dislike: notif_on_dislike, notif_on_comment: notif_on_comment, user_id: userId, email: email, update: update)
    }
    
    
    func createUser(gender: String, fullName: String, image: String, fcm: String, notif_on_like: String, notif_on_dislike: String, notif_on_comment: String, user_id: String, email: String, update: Int){
        
        let gender = gender
        let fullName = fullName
        let image = image
        let fcm = fcm
        let notif_on_like = notif_on_like
        let notif_on_dislike = notif_on_dislike
        let notif_on_comment = notif_on_comment
        let user_id = user_id
        let email = email
        let update = String(update)
        
        
        let url = URL(string: "https://hayy-226108.appspot.com/api/profile")!
        //let url2 = URL(string: "https://hayy-226108.appspot.com/api/profile")
        let body = "gender=\(gender)&name=\(fullName)&image=\(image)&fcm_registration_id=\(fcm)&notification_on_like=\(notif_on_like)&notification_on_dislike=\(notif_on_dislike)&notification_on_comment=\(notif_on_comment)&user_id=\(user_id)&email=\(email)&update=\(update)"
        
       
        
        var request = URLRequest(url: url)
        request.httpBody = body.data(using: .utf8)
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            DispatchQueue.main.async {
                
            
            
            let response = response as? HTTPURLResponse
            
            if response?.statusCode != 200 {
                print("status dari server adalah: \(String(describing: response?.statusCode))")
                print(error ?? "No Error")
            }
            else{
                
                guard let data = data else { return }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary
                
                guard let resultJSON = json else { return }
                
                    let id = resultJSON["id"]
                    let user_id = resultJSON["user_id"]
                    let name = resultJSON["name"]
                    let email = resultJSON["email"]
                    let image = resultJSON["image"]
                    let gender = resultJSON["gender"]
                    let fcm_registration_id = resultJSON["fcm_registration_id"]
                    let notification_on_like = resultJSON["notification_on_like"]
                    let notification_on_dislike = resultJSON["notification_on_dislike"]
                    let notification_on_comment = resultJSON["notification_on_comment"]
                    let is_admin = resultJSON["is_admin"]
                    let is_paid = resultJSON["is_paid"]
                    let created_at = resultJSON["created_at"]
                    let updated_at = resultJSON["updated_at"]
                    let subscribing = resultJSON["subscribing"]
                    let type = resultJSON["type"]
                    let status = resultJSON["status"]
                    let phone = resultJSON["phone"]
                    let is_following = resultJSON["is_following"]
                    let following_count = resultJSON["following_count"]
                    let followers_count = resultJSON["followers_count"]
                    
                    
                    
                    
                    let dataUser = ["id" : id, "user_Id" : user_id, "name": name, "email" : email, "image" : image, "gender" : gender, "fcm_registration_id" : fcm_registration_id, "notification_on_like" : notification_on_like, "notification_on_dislike" : notification_on_dislike, "notification_on_comment" : notification_on_comment, "is_admin" : is_admin, "is_paid" : is_paid, "created_at" : created_at, "updated_at" : updated_at, "subscribing" : subscribing, "type" : type, "status" : status, "phone" : phone, "is_following" : is_following, "following_count" : following_count, "followers_count" : followers_count]
                    
                    
                    
                
                    data_user = dataUser as NSDictionary
                    UserDefaults.standard.set(currentUser, forKey: "currentUser")
                    UserDefaults.standard.synchronize()
                    
                    let tabBar = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBar")
                    self.window?.rootViewController?.present(tabBar, animated: true, completion: nil)
                    
                }
                
                
                catch {
                    fatalError("Failed to Retrieve data")
                }
            }
            }
        }.resume()
        
        
    }
    
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
        -> Bool {
            return GIDSignIn.sharedInstance().handle(url,
                                                sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                    annotation: [:])
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: sourceApplication,
                                                 annotation: annotation)
    }
    

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
       
        
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        UITabBar.appearance().barTintColor = UIColor.black
        //UITabBar.appearance().barTintColor = UIColor.white
        UITabBar.appearance().tintColor = UIColor.green
        
        return true
    }
    
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
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

