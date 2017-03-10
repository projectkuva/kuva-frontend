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
import Sharaku

class PostViewController: PrimaryViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, UITextViewDelegate, SHViewControllerDelegate {

    @IBOutlet weak var textviewLabel: UILabel!
    @IBOutlet var captionTextView: UITextView!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var selectImageButton: UIButton!
    var path:URL!
    var cameraImage: UIImage? = nil
    
    var locationManager = CLLocationManager()
    
    @IBAction func selectImagePressed(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
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
    
    @IBAction func postButtonPressed(_ sender: Any) {
        if self.selectImageButton.isEnabled {
            let alert:UIAlertController = UIAlertController(title: "Select an image", message: "pls", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: ":/", style: UIAlertActionStyle.default, handler: self.resetFeedView))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let caption:String = captionTextView.text
        let loc:CLLocationCoordinate2D = locationManager.location!.coordinate
        let tok = super.getToken()!
        
        //Latitude
        let lat:String = String(loc.latitude)
        //Longitude
        let lng:String = String(loc.longitude)

        //Authorization token
        let headers = ["Authorization": "Bearer \(tok)"]
        //Request URL
        let URL = try! URLRequest(url: "http://kuva.jakebrabec.me/api/user/photos/create", method: .post, headers: headers)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(self.path, withName: "photo", fileName: self.path.path, mimeType: "image/jpg")
            multipartFormData.append(caption.data(using: .utf8)!, withName: "caption")
            multipartFormData.append(lat.data(using: .utf8)!, withName: "lat")
            multipartFormData.append(lng.data(using: .utf8)!, withName: "lng")
        }, with: URL, encodingCompletion: { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { res in
                    if let data = res.result.value {
                        print("JSON: \(data)")
                        let json = JSON(data)
                        let msg:String = json["message"].stringValue
                        if msg == "success" {
                            let alert:UIAlertController = UIAlertController(title: "Image posted", message: "Image was successfully posted", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: self.resetFeedView))
                            self.present(alert, animated: true, completion: nil)
                        } else {
                            let alert:UIAlertController = UIAlertController(title: "Upload failed", message: "sad", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: ":(", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }

                    }
                }
                
            case .failure(let encodingError):
                print(encodingError)
            }
        })
        

       
    }
    
    func resetFeedView(alert: UIAlertAction!) {
        let view = self.storyboard?.instantiateViewController(withIdentifier: "tabbar")
        self.present(view!, animated:true, completion:nil)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    //Uploads the selected image
    func uploadImage(image: UIImage) {
        if let data = UIImageJPEGRepresentation(image, 1.0) {
            let filename = getDocumentsDirectory().appendingPathComponent("copy.jpg")
            try? data.write(to: filename)
            
            //Filepath
            self.path = filename
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            picker.dismiss(animated: true, completion: { _ in
                self.filterImage(image: img)
            })
        }
    }
    
    func filterImage(image: UIImage) {
        // filtering
        let imageToBeFiltered = image
        let vc = SHViewController(image: imageToBeFiltered)
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func shViewControllerImageDidFilter(image: UIImage) {
        self.previewImageView.image = image
        self.selectImageButton.isEnabled = false
        self.selectImageButton.isHidden = true
        uploadImage(image: image)
    }
    
    func shViewControllerDidCancel() {
        // ¯\_(ツ)_/¯
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        locationManager.delegate = self
        captionTextView.delegate = self
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        if (self.cameraImage != nil) {
            cameraImage = resizeImage(image: cameraImage!, newWidth: 400)
            previewImageView.contentMode = .scaleAspectFit
            previewImageView.image = self.cameraImage
            self.selectImageButton.isEnabled = false
            self.selectImageButton.isHidden = true
            uploadImage(image: cameraImage!)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.cameraImage != nil {
            self.cameraImage = nil
            self.previewImageView.image = nil
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.textviewLabel.isHidden = true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if (textView.text == "") {
            self.textviewLabel.isHidden = false
        }
        print(textView.text)
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
