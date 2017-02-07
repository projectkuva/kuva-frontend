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

private let reuseIdentifier = "Cell"

class FeedViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
    
    let keychain = KeychainSwift()
    var posts = NSMutableArray()
    var locationManager = CLLocationManager()
    var cameraImage: UIImage? = nil
    
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        cameraImage = info[UIImagePickerControllerOriginalImage] as! UIImage?
        self.dismiss(animated: true, completion: nil);
        performSegue(withIdentifier: "showPostViewSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPostViewSegue" {
            let dvc = segue.destination as! PostViewController
            dvc.cameraImage = cameraImage
        }
    }
    
    func loadFeedData() {
        
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
            
            //add the photos to posts array
            for (index, object) in json {
                let photoID = object["id"].stringValue
                self.posts.add(photoID)
            }
            self.postsCollectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
        let cell = collectionView.cellForItem(at: indexPath) as! PostCollectionViewCell
        print(cell.postImageView)
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
        
        loadFeedData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")

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
        
        let post:String = self.posts[indexPath.row] as! String
        Alamofire.request("http://kuva.jakebrabec.me/storage/uploads/\(post).jpg").responseImage { res in
            if let image = res.result.value {
                cell.postImageView.image = image
            }
        }
        
    
        return cell
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
