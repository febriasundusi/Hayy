//
//  ViewController.swift
//  Hayy
//
//  Created by Herlangga Wibi Yandi Nasution on 25/01/19.
//  Copyright © 2019 PT. Buana Kebenaran Informatika. All rights reserved.
//

import UIKit
import GoogleSignIn




class LoginPage: UIViewController, GIDSignInUIDelegate  {
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        //GIDSignIn.sharedInstance().signIn()
        
        
        let buttonSignIn = GIDSignInButton()
        buttonSignIn.center = view.center
        view.addSubview(buttonSignIn)
        
    }


    @IBAction func loginButton(_ sender: Any) {
        let tabBar = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBar")
        self.present(tabBar, animated: true, completion: nil)
    }
    
    
    
}

