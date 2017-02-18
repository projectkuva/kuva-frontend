//
//  ProfileViewController.swift
//  Kuva
//
//  Created by Shane DeWael on 2/8/17.
//  Copyright © 2017 kuva. All rights reserved.
//

import UIKit

class ProfileViewController: PrimaryViewController {

    @IBOutlet weak var username: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUsername()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        super.logOut()
        let view = self.storyboard?.instantiateViewController(withIdentifier: "loginVC")
        self.present(view!, animated:true, completion:nil)
    }
    
    func setUsername() {
        let id = self.getUserID()!
        username.title = "\(id)"
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
