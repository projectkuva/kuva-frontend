//
//  ProfileViewController.swift
//  Kuva
//
//  Created by Shane DeWael on 2/8/17.
//  Copyright © 2017 kuva. All rights reserved.
//

import UIKit

class ProfileViewController: PrimaryViewController, UICollectionViewDelegate, UICollectionViewDataSource  {

    @IBOutlet weak var username: UINavigationItem!
    @IBOutlet weak var profileCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUsername()
        
        self.profileCollectionView.delegate = self
        self.profileCollectionView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        super.logOut()
        let view = self.storyboard?.instantiateViewController(withIdentifier: "loginVC")
        self.present(view!, animated:true, completion:nil)

    }
    
    func setUsername() {
        let id = self.getUserID()!
        username.title = "\(id)"
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCell", for: indexPath) as! ProfileCollectionViewCell

        return cell
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
