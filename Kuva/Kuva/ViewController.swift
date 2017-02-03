//
//  ViewController.swift
//  Kuva
//
//  Created by Matthew on 1/30/17.
//  Copyright © 2017 kuva. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func signinPressed(_ sender: Any) {
        let username = usernameTextField.text
        let password = passwordTextField.text
        
        //use AlamoFire to login with backend
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

