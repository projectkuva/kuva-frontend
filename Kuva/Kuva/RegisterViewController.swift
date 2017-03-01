//
//  RegisterViewController.swift
//  Kuva
//
//  Created by Shane DeWael on 2/3/17.
//  Copyright © 2017 kuva. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RegisterViewController: PrimaryViewController {

    
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        UIApplication.shared.statusBarStyle = .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        
    }
    
    @IBAction func createButtonPressed(_ sender: Any) {
        let username = usernameTextField.text
        let email = emailTextField.text
        let password = passwordTextField.text
        
        let parameters: Parameters = [
            "name": username,
            "password": password,
            "email": email
        ]
        
        Alamofire.request("http://kuva.jakebrabec.me/api/user/register", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON{ res in
            
            let json = JSON(res.value)
            let msg:String = json["message"].stringValue
            let token:String = json["token"].stringValue
            
            
            if msg == "success" {
                //successful login, save auth token
                
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
