//
//  TokenResetViewController.swift
//  Kuva
//
//  Created by Shane DeWael on 3/1/17.
//  Copyright © 2017 kuva. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class TokenResetViewController: PrimaryViewController {

    @IBOutlet weak var resetToken: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    
    @IBAction func resetPasswordPressed(_ sender: Any) {
        
        let token = resetToken.text
        let password = newPassword.text
        
        let parameters: Parameters = [
            "token": token,
            "password": password
        ]
        
        Alamofire.request("http://kuva.jakebrabec.me/api/user/reset/store", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON{ res in
            
            print(res)
            let json = JSON(res.value)
            print(json)
            let msg:String = json["message"].stringValue
            print(msg)
            
            if msg == "success" {
                //successful login, save auth token
                let alert:UIAlertController = UIAlertController(title: "Password Reset", message: "Password successfully reset", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Go to login", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                let view = self.storyboard?.instantiateViewController(withIdentifier: "loginVC")
                self.present(view!, animated:true, completion:nil)
                
            } else {
                let alert:UIAlertController = UIAlertController(title: "Invalid Token", message: "Token must be valid and password must be at least 6 characters", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                self.newPassword.text = ""
            }
            
            
        }

        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
