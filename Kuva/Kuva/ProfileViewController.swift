//
//  ProfileViewController.swift
//  Kuva
//
//  Created by Shane DeWael on 2/8/17.
//  Copyright © 2017 kuva. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class ProfileViewController: PrimaryViewController, UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate  {

    @IBOutlet weak var username: UINavigationItem!
    @IBOutlet weak var profileCollectionView: UICollectionView!
    @IBOutlet weak var changePictureButton: UIButton!
    @IBOutlet weak var profilePicture: UIImageView!
    
    var photos = NSMutableArray()
    var path:URL!
    
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
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        super.logOut()
        let view = self.storyboard?.instantiateViewController(withIdentifier: "loginVC")
        self.present(view!, animated:true, completion:nil)

    }
    
    @IBAction func changeProfilePicturePressed(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    
    func getUserPhotos() {
        self.photos = NSMutableArray()
        let tok = self.getToken()!
        
        Alamofire.request("http://kuva.jakebrabec.me/api/user/\(self.getUserID()!)/profile", headers: ["Authorization": "Bearer \(tok)"]).responseJSON{ res in
            
            let json = JSON(res.value)
            print(json)
            
            //update username
            let name = json["name"]
            self.username.title = "\(name)"
            
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
        
        let post:PhotoItem = self.photos[indexPath.item] as! ProfileViewController.PhotoItem
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
        print("here")
        let cell = collectionView.cellForItem(at: indexPath) as! ProfileCollectionViewCell
        if !cell.ready {
            return
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailView = storyboard.instantiateViewController(withIdentifier: "detailView") as! PostDetailViewController
        detailView.id = cell.id
        detailView.userID = cell.userID
        self.navigationController?.pushViewController(detailView, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            picker.dismiss(animated: true, completion: nil)
            self.profilePicture.image = img
            uploadImage(image: img)

        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func uploadImage(image: UIImage) {
        if let data = UIImageJPEGRepresentation(image, 1.0) {
            let filename = getDocumentsDirectory().appendingPathComponent("copy.jpg")
            try? data.write(to: filename)
            
            //Filepath
            self.path = filename
            
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
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
