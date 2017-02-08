//
//  ParentViewController.swift
//  Kuva
//
//  Created by Matthew on 2/4/17.
//  Copyright © 2017 kuva. All rights reserved.
//

import UIKit
import KeychainSwift
import JWTDecode

class PrimaryViewController: UIViewController {

    let keychain = KeychainSwift()
    var user_id = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PrimaryViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
    }

    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setToken(token: String) -> Bool {
        return keychain.set(token, forKey: "token")
    }
    
    func loggedIn() -> Bool {
        return keychain.get("token") != nil && keychain.get("token") != ""
    }
    
    func logOut() {
        keychain.delete("token")
    }
    
    func getToken() -> String? {
        return keychain.get("token")
    }
    
    func getUserID() -> Int? {
        if self.user_id == -1 {
            do {
                let jwt = try decode(jwt: self.getToken()!)
                let claim = jwt.claim(name: "user_id")
                self.user_id = claim.integer!
                return self.user_id
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            return -1
        } else {
            return self.user_id
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
