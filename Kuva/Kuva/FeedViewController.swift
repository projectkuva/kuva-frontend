//
//  FeedViewController.swift
//  Kuva
//
//  Created by Shane DeWael on 2/5/17.
//  Copyright © 2017 kuva. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import JWTDecode
import KeychainSwift
import CoreLocation
import AlamofireImage
import Sharaku

private let reuseIdentifier = "Cell"

class FeedViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, SHViewControllerDelegate {
    
    let keychain = KeychainSwift()
    var posts = NSMutableArray()
    var locationManager = CLLocationManager()
    var cameraImage: UIImage? = nil
    
    struct PostItem {
        var id: Int = 0
        var userID: Int = 0
        var numComments: Int = 0
        var numLikes: Int = 0
        var caption: String? = nil
        var created: Date? = nil
        var comments: [JSON] = []
        var likes: [JSON] = []
    }

    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var composeButton: UIBarButtonItem!
    
    
    @IBOutlet weak var postsCollectionView: UICollectionView!
    
    @IBAction func cameraButtonPressed(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.cameraCaptureMode = .photo
            imagePicker.modalPresentationStyle = .fullScreen
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func pressedCompose(_ sender: Any) {
        self.tabBarController?.selectedIndex = 1;
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let img = info[UIImagePickerControllerOriginalImage] as! UIImage? {
            self.dismiss(animated: true, completion: { _ in
                let fixedImg = self.fixOrientation(img: img)
                self.filterImage(image: fixedImg)
            });
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPostViewSegue" {
            let dvc = segue.destination as! PostViewController
            dvc.cameraImage = cameraImage
            cameraImage = nil
        }
    }
    
    func fixOrientation(img:UIImage) -> UIImage {
        
        if (img.imageOrientation == UIImageOrientation.up) {
            return img;
        }
        
        UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale);
        let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
        img.draw(in: rect)
        
        let normalizedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        return normalizedImage;
        
    }
    
    func filterImage(image: UIImage) {
        // filtering
        let imageToBeFiltered = image
        let vc = SHViewController(image: imageToBeFiltered)
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    func shViewControllerImageDidFilter(image: UIImage) {
        cameraImage = image
        performSegue(withIdentifier: "showPostViewSegue", sender: nil)
    }
    
    func shViewControllerDidCancel() {
        // ¯\_(ツ)_/¯
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PostCollectionViewCell
        if !cell.ready {
            return
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailView = storyboard.instantiateViewController(withIdentifier: "detailView") as! PostDetailViewController
        detailView.id = cell.id
        detailView.userID = cell.userID
        detailView.numLikes = cell.numLikes
        detailView.numComments = cell.numComments
        detailView.caption = cell.caption
        detailView.created = cell.created
        detailView.postImage = cell.postImageView.image
        detailView.comments = cell.comments
        detailView.likes = cell.likes
        self.navigationController?.pushViewController(detailView, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 25))
        imageView.contentMode = .scaleAspectFit
        let logo = UIImage(named: "kuva-logo")
        imageView.image = logo
        navigationItem.titleView = imageView
        
       self.postsCollectionView.delegate = self
       self.postsCollectionView.dataSource = self
        locationManager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        cameraButton.accessibilityIdentifier = "camerabutton"
        composeButton.accessibilityIdentifier = "composebutton"
        //self.postsCollectbionView!.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        
        updateCurrentView()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.posts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PostCollectionViewCell
    
        // Configure the cell
        let post:PostItem = self.posts[indexPath.item] as! FeedViewController.PostItem
        Alamofire.request("http://kuva.jakebrabec.me/storage/uploads/\(post.id).jpg").responseImage { res in
            if let image = res.result.value {
                cell.postImageView.image = image
                cell.id = post.id
                cell.userID = post.userID
                cell.numLikes = post.numLikes
                cell.numComments = post.numComments
                cell.caption = post.caption
                cell.created = post.created
                cell.comments = post.comments
                cell.likes = post.likes
                cell.ready = true
            }
        }
        return cell
    }
    
    func updateCurrentView() {
        self.posts = NSMutableArray()
        let tok = self.getToken()!
        let loc:CLLocationCoordinate2D = locationManager.location!.coordinate
        
        //Latitude
        let lat:String = String(loc.latitude)
        //Longitude
        let lng:String = String(loc.longitude)
        
        let parameters: Parameters = [
            "lat": lat,
            "lng": lng
        ]

        Alamofire.request("http://kuva.jakebrabec.me/api/user/photos/feed", parameters: parameters, headers: ["Authorization": "Bearer \(tok)"]).responseJSON{ res in
            
            let json = JSON(res.value)
            
            var dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            //add the photos to posts array
            for (index, object) in json {
                var post = PostItem()
                post.id = object["id"].intValue
                post.userID = object["user_id"].intValue
                post.numLikes = object["numLikes"].intValue
                post.numComments = object["numComments"].intValue
                post.caption = object["caption"].stringValue
                post.created = dateFormatter.date(from: object["created_at"].stringValue)
                post.comments = object["comments"].array!
                post.likes = object["likes"].array!
                self.posts.add(post)
            }
            self.postsCollectionView.reloadData()
        }
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


    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
