//
//  PostViewController.swift
//  Kuva
//
//  Created by Shane DeWael on 2/5/17.
//  Copyright © 2017 kuva. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
import SwiftyJSON

class PostViewController: PrimaryViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {

    @IBOutlet var captionTextView: UITextView!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var selectImageButton: UIButton!
    var locationManager = CLLocationManager()
    
    @IBAction func selectImagePressed(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
        
    }
    
    
    @IBAction func postButtonPressed(_ sender: Any) {
        
        let caption = captionTextView.text

        //we need auth
    }
    

    //Uploads the selected image
    func uploadImage(image: UIImage) {
        
        let img = UIImageJPEGRepresentation(image, 1.0)
        let caption = captionTextView.text
        let loc:CLLocationCoordinate2D = locationManager.location!.coordinate
        print (loc.latitude)
        print (loc.longitude)
        let tok = super.getToken()
        
        let parameters: Parameters = [
            "photo": img,
            "caption": caption,
            "lat": loc.latitude,
            "lan": loc.longitude
        ]
        
        Alamofire.request("http://kuva.jakebrabec.me/api/user/photos/create", method: .post, parameters: parameters, headers: ["Authorization": "Bearer \(tok)"]).responseJSON{ res in
            let json = JSON(res.value)
            print(json)
            
            
        }
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.previewImageView.image = img
            self.selectImageButton.isEnabled = false
            self.selectImageButton.isHidden = true
            uploadImage(image: img)
            picker.dismiss(animated: true, completion: nil)
            
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        locationManager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
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
