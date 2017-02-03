//
//  RegisterViewController.swift
//  Kuva
//
//  Created by Shane DeWael on 2/3/17.
//  Copyright © 2017 kuva. All rights reserved.
//

import UIKit
import Alamofire

class RegisterViewController: UIViewController {

    
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createPressed(_ sender: Any) {
        let username = usernameTextField.text
        let email = emailTextField.text
        let password = passwordTextField.text
        
        let parameters: Parameters = [
            "name": username,
            "password": password,
            "email": email
        ]
        
        Alamofire.request("http://kuva.jakebrabec.me/api/user/register", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON{ response in
            
            if let auth = response.result.value {
                print("AUTH: \(auth)")
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
