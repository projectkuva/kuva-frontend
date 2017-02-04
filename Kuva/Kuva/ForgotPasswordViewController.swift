//
//  ForgotPasswordViewController.swift
//  Kuva
//
//  Created by Matthew on 2/4/17.
//  Copyright © 2017 kuva. All rights reserved.
//

import UIKit
import Alamofire

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBAction func resetPressed(_ sender: Any) {
        let email = emailTextField.text
        
        let parameters: Parameters = [
            "email": email
        ]
        
        //use AlamoFire to send reset password request
        Alamofire.request("http://kuva.jakebrabec.me/api/user/reset", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON{ response in
            
            if let msg = response.result.value {
                print("RESPONSE: \(msg)")
            }
            
            let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
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
