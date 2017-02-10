//
//  ViewController.swift
//  Kuva
//
//  Created by Matthew on 1/30/17.
//  Copyright © 2017 kuva. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import JWTDecode
import CoreLocation

class LoginViewController: PrimaryViewController, CLLocationManagerDelegate {

    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        if CLLocationManager.authorizationStatus() == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        }
        
        if super.loggedIn() {
            let view = self.storyboard?.instantiateViewController(withIdentifier: "tabbar")
            self.present(view!, animated:true, completion:nil)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }

    @IBAction func signinButtonPressed(_ sender: Any) {
        let username = usernameTextField.text
        let password = passwordTextField.text
        
        let parameters: Parameters = [
            "loginfield": username,
            "password": password
        ]
        
        //use AlamoFire to login with backend
        Alamofire.request("http://kuva.jakebrabec.me/api/user/auth", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON{ res in
            
            let json = JSON(res.value)
            let msg:String = json["message"].stringValue
            
            
            if msg == "success" {
                //successful login, save auth token
                let tok:String = json["token"].stringValue
                
                if !super.setToken(token: tok) {
                    print("couldn't set token")
                }
                
                let view = self.storyboard?.instantiateViewController(withIdentifier: "tabbar")
                self.present(view!, animated:true, completion:nil)
                
            } else {
                let alert:UIAlertController = UIAlertController(title: "bad!!!", message: "Invalid Credentials", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "☹️", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                self.passwordTextField.text = ""
            }
            
        }

    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

