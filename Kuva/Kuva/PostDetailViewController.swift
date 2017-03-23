//
//  PostDetailViewController.swift
//  Kuva
//
//  Created by Matthew on 2/7/17.
//  Copyright © 2017 kuva. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class PostDetailViewController: PrimaryViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var commentTable: UITableView!
    @IBOutlet weak var likesButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var deletePhotoButton: UIBarButtonItem!
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var usernameButton: UIButton!
    
    
    
    var id: Int = 0
    var numComments: Int = 0
    var userID: Int = 0
    var numLikes: Int = 0
    var caption: String? = nil
    var created: Date? = nil
    var postImage: UIImage? = nil
    var comments: [JSON] = []
    var likes: [JSON] = []
    var liked: Bool = false
    let likeIMG: UIImage = UIImage(named: "heart-cl")!
    let unlikeIMG: UIImage = UIImage(named: "heart-gr")!
    
    @IBAction func likeButtonPressed(_ sender: Any) {
        self.liked = !self.liked
        self.likesButton.isEnabled = false
        print(self.liked)
        let liked_i = self.liked ? 1 : 0
        print(liked_i)
        let tok = self.getToken()
        let parameters: Parameters = [
            "liked": liked_i
        ]
        let headers = ["Authorization": "Bearer \(tok!)"]
        
        Alamofire.request("http://kuva.jakebrabec.me/api/user/photos/like/\(self.id)", method: .post, parameters: parameters, headers: headers).responseJSON { res in
            let json = JSON(res.value)
            print(json)
            let msg:String = json["message"].stringValue
            if msg != "success" {
                self.liked = !self.liked
            } else {
                //print(self.liked)
            }
            self.likesButton.isEnabled = true
            self.updateCurrentView()
        }
        
    }
    @IBAction func deletePhotoPressed(_ sender: Any) {
        let tok = self.getToken()
        let headers = ["Authorization": "Bearer \(tok!)"]
        
        Alamofire.request("http://kuva.jakebrabec.me/api/user/photos/\(self.id)/delete", method: .post, headers: headers).responseJSON { res in
            let json = JSON(res.value)

            
            //WE NEED TO RELOAD DATA OMG
            let view = self.storyboard?.instantiateViewController(withIdentifier: "tabbar")
            self.present(view!, animated:true, completion:nil)
        }
        

    }
    
    @IBAction func reportButtonPressed(_ sender: Any) {
        //api/users/photos/{photoID}/report
        let alert:UIAlertController = UIAlertController(title: "Report Photo", message: "Are you sure you want to report this photo?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { action in
            self.reportPhoto()
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func reportPhoto() {
        let tok = self.getToken()
        let headers = ["Authorization": "Bearer \(tok!)"]
        let parameters: Parameters = [
            "message": "Photo is inappropriate for kuva"
        ]
        
        Alamofire.request("http://kuva.jakebrabec.me/api/user/photos/\(self.id)/report", method: .post, parameters: parameters, headers: headers).responseJSON { res in
            let json = JSON(res.value)
            print(json)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "externalProfileSegue" {
            let dvc = segue.destination as! ExternalProfileViewController
            dvc.profileID = userID
            //dvc.blah blah bla
            //var profileID:Int = 0
            //var profileUsername:String? = nil
            //performSegue(withIdentifier: "externalProfileSegue", sender: nil)
        }
    }
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        
        var url = "http://kuva.jakebrabec.me/storage/uploads/\(getTrueID()).jpg"
        UIPasteboard.general.string = url
        let alert:UIAlertController = UIAlertController(title: "Share Photo", message: "Link to image copied to clipboard", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func getTrueID() -> Int {
        if id == 1 {
            return id
        }
        return id - 1
    }

    
    @IBAction func commentButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Post Comment", message: "Enter comment text", preferredStyle: .alert)
        alert.addTextField{ (textField) in
            textField.text = ""
        }
        alert.addAction(UIAlertAction(title: "Post", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            let commentText: String = textField!.text!
            let tok = self.getToken()
            let parameters: Parameters = [
                "text": commentText
            ]
            let headers = ["Authorization": "Bearer \(tok!)"]
            Alamofire.request("http://kuva.jakebrabec.me/api/user/photos/comment/\(self.id)", method: .post, parameters: parameters, headers: headers).responseJSON{ res in
                let json = JSON(res.value)
                let msg:String = json["message"].stringValue
                let succ_alert = UIAlertController(title: "Success", message: "Comment posted", preferredStyle: .alert)
                succ_alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                        // dismiss
                }))
                self.present(succ_alert, animated: true, completion: nil)
                
                self.updateCurrentView()
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [weak alert] (_) in
            // dismiss
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func replyButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Reply", message: "Enter your reply", preferredStyle: .alert)
        alert.addTextField{ (textField) in
            textField.text = ""
        }
        
        var indexPath: Int!
        
        if let button = sender as? UIButton {
            if let superview = button.superview {
                if let cell = superview.superview as? CommentTableViewCell {
                    indexPath = cell.id
                }
            }
        }
        
        let username = comments[indexPath]["user"]["name"].stringValue
        
        alert.addAction(UIAlertAction(title: "Post", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            let commentText: String = textField!.text!
            let tok = self.getToken()
            let parameters: Parameters = [
                "text": "@"+username+" " + commentText
            ]
            
            if (commentText == "" ) {
                let fail_alert = UIAlertController(title: "Invalid Reply", message: "Reply cannot be empty", preferredStyle: .alert)
                fail_alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                }))
            }
            
            let headers = ["Authorization": "Bearer \(tok!)"]
            Alamofire.request("http://kuva.jakebrabec.me/api/user/photos/comment/\(self.id)", method: .post, parameters: parameters, headers: headers).responseJSON{ res in
                let json = JSON(res.value)
                let msg:String = json["message"].stringValue
                if msg != "success" {
                    let fail_alert = UIAlertController(title: "Invalid Comment", message: "Comment cannot be empty", preferredStyle: .alert)
                    fail_alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                        // dismiss
                    }))
                    self.present(fail_alert, animated: true, completion: nil)
                } else {
                    let succ_alert = UIAlertController(title: "Success", message: "Comment posted", preferredStyle: .alert)
                    succ_alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                        // dismiss
                    }))
                    self.present(succ_alert, animated: true, completion: nil)
                }
                self.updateCurrentView()
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [weak alert] (_) in
            // dismiss
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Delete button
        if (self.getUserID() != self.userID) {
            disableDeleteIcon()
        }
        
        
        self.postImageView.image = self.postImage
        self.commentTable.delegate = self
        self.commentTable.dataSource = self
        self.commentTable.rowHeight = UITableViewAutomaticDimension
        self.commentTable.estimatedRowHeight = 43
        
        updateCurrentView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //        self.updateCurentImage()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numComments
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentTableViewCell
        cell.userLabel.text = comments[indexPath.row]["user"]["name"].stringValue
        cell.commentLabel.text = comments[indexPath.row]["text"].stringValue
        cell.commentLabel.numberOfLines = 0
        cell.id = indexPath.row
        return cell
    }
    
    
    
    func updateCurrentView() {
        let tok = super.getToken()
        let headers = ["Authorization": "Bearer \(tok!)"]
        
        Alamofire.request("http://kuva.jakebrabec.me/api/photos/\(self.id)", headers: headers).responseJSON { res in
            
            let json = JSON(res.value)
            print(json)
            self.liked = (json["user_liked"].intValue) == 1 ? true : false
            print(self.liked)
            self.likesButton.imageView?.image = self.liked ? self.likeIMG : self.unlikeIMG
            self.likesButton.accessibilityIdentifier = self.liked ? "liked" : "unliked"
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            self.created = dateFormatter.date(from: json["0"]["created_at"].stringValue)
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            dateFormatter.locale = Locale(identifier: "en_US")
            self.dateLabel.text = dateFormatter.string(for: self.created!)
            self.usernameButton.setTitle(json["0"]["user"]["name"].string, for: .normal)
            self.comments = json["0"]["comments"].array!
            self.likes = json["0"]["likes"].array!
            self.numLikes = 0
            for like in self.likes {
                if (like["liked"] == 1) {
                    self.numLikes += 1
                }
            }
            self.numComments = self.comments.count
            self.likesLabel.text = (self.numLikes == 1) ? "\(self.numLikes) like" : "\(self.numLikes) likes"
            self.commentsLabel.text = "\(self.numComments) comments"
            self.caption = json["0"]["caption"].stringValue
            self.captionLabel.text = self.caption
            self.captionLabel.numberOfLines = 0
            
            self.commentTable.reloadData()
            
        }
        
    }
    
    
    @IBAction func usernameButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "externalProfileSegue", sender: nil)

    }
    
    func disableDeleteIcon() {
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.clear
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
