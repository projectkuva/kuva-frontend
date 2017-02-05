//
//  ViewController.swift
//  Kuva
//
//  Created by Matthew on 1/30/17.
//  Copyright © 2017 kuva. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: PrimaryViewController {

    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func signinButtonPressed(_ sender: Any) {
        let username = usernameTextField.text
        let password = passwordTextField.text
        
        let parameters: Parameters = [
            "loginfield": username,
            "password": password
        ]
        
        //use AlamoFire to login with backend
        Alamofire.request("http://kuva.jakebrabec.me/api/user/auth", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON{ response in
            
            if let auth = response.result.value {
                print("AUTH: \(auth)")
            }
            
        }

    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

