//
//  ExternalProfileViewController.swift
//  Kuva
//
//  Created by Shane DeWael on 3/2/17.
//  Copyright © 2017 kuva. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON
import KeychainSwift
import JWTDecode


class ExternalProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate {
    
    @IBOutlet weak var profileCollectionView: UICollectionView!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var username: UINavigationItem!
    @IBOutlet weak var noProfile: UILabel!
    
    
    let keychain = KeychainSwift()
    var photos = NSMutableArray()
    var path:URL!
    var profileID:Int = 0
    
    struct PhotoItem {
        var id: Int = 0
        var userID: Int = 0
    }
    
    private let reuseIdentifier = "ProfileCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.profileCollectionView.delegate = self
        self.profileCollectionView.dataSource = self
        // Do any additional setup after loading the view.
        getUserPhotos()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getUserPhotos() {
        self.photos = NSMutableArray()
        let tok = self.getToken()!
        
        Alamofire.request("http://kuva.jakebrabec.me/api/user/\(self.profileID)/profile", headers: ["Authorization": "Bearer \(tok)"]).responseJSON{ res in
            
            let json = JSON(res.value)
            print(json)
            
            //update username
            self.username.title = json["name"].stringValue
            
            
            //update photo if there is one
            
            print(json["profile_photo"])
            if json["profile_photo"].null != nil {
                self.noProfile.isHidden = false
            } else {
                self.noProfile.isHidden = true
                //get image
                self.updateProfileImage(url: json["profile_photo"].stringValue)
            }
            
            //add the photos to photo array
            for (index, object) in json["photos"] {
                var post = PhotoItem()
                post.id = object["id"].intValue
                post.userID = object["user_id"].intValue
                self.photos.add(post)
            }
            self.profileCollectionView.reloadData()
        }
    }
    
    func updateProfileImage(url : String) {
        let fixedURL:String = "http://kuva.jakebrabec.me/storage/uploads/profile/\(url)"
        print(fixedURL)
        Alamofire.request(fixedURL).responseImage { res in
            if let image = res.result.value {
                self.profilePicture.image = image
            }
        }
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCell", for: indexPath) as! ProfileCollectionViewCell
        
        let post:PhotoItem = self.photos[indexPath.item] as! ExternalProfileViewController.PhotoItem
        Alamofire.request("http://kuva.jakebrabec.me/storage/uploads/\(post.id).jpg").responseImage { res in
            if let image = res.result.value {
                cell.photoImage.image = image
                cell.id = post.id
                cell.userID = post.userID
                cell.ready = true
            }
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ProfileCollectionViewCell
        if !cell.ready {
            print("not ready sad:(")
            return
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailView = storyboard.instantiateViewController(withIdentifier: "detailView") as! PostDetailViewController
        detailView.id = cell.id
        detailView.userID = cell.userID
        detailView.postImage = cell.photoImage.image
        self.navigationController?.pushViewController(detailView, animated: true)
    }
    
    func logOut() {
        keychain.delete("token")
    }
    
    func getToken() -> String? {
        return keychain.get("token")
    }


}
