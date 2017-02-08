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
    
    var id: Int = 0
    var numComments: Int = 0
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
        let liked_i = self.liked ? 1 : 0
        let tok = self.getToken()
        let parameters: Parameters = [
            "liked": liked_i
        ]
        let headers = ["Authorization": "Bearer \(tok!)"]
        
        //Do this before request so there's not a huge delay
        if self.liked {
            self.numLikes += 1
            self.likesButton.imageView?.image = likeIMG
        } else {
            self.numLikes -= 1
            self.likesButton.imageView?.image = unlikeIMG
        }
        self.likesLabel.text = "\(self.numLikes) likes"
        
        Alamofire.request("http://kuva.jakebrabec.me/api/user/photos/like/\(self.id)", method: .post, parameters: parameters, headers: headers).responseJSON { res in
            let json = JSON(res.value)
            let msg:String = json["message"].stringValue
            print(msg)
            if msg != "success" {
                
                self.liked = !self.liked
                
            } else {
                print(self.liked)
            }
            self.likesButton.isEnabled = true
        }
        
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
                if msg != "success" {
                    let fail_alert = UIAlertController(title: "Failure", message: "Could not post comment", preferredStyle: .alert)
                    fail_alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                        // dismiss
                    }))
                    self.present(fail_alert, animated: true, completion: nil)
                } else {
                    let succ_alert = UIAlertController(title: "Success", message: "Comment posted!", preferredStyle: .alert)
                    succ_alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                        // dismiss
                    }))
                    self.present(succ_alert, animated: true, completion: nil)
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [weak alert] (_) in
            // dismiss
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.likesLabel.text = "\(self.numLikes) likes"
        self.commentsLabel.text = "\(self.numComments)"
        self.captionLabel.text = self.caption
        self.captionLabel.numberOfLines = 0
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US")
        self.dateLabel.text = dateFormatter.string(from: self.created!)
        self.postImageView.image = self.postImage
        self.commentTable.delegate = self
        self.commentTable.dataSource = self
        self.commentTable.rowHeight = UITableViewAutomaticDimension
        self.commentTable.estimatedRowHeight = 43
        for obj in likes {
            if obj["user_id"].intValue == self.getUserID() {
                self.liked = true
                self.likesButton.imageView?.image = likeIMG
            }
        }
        // Do any additional setup after loading the view.
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
        cell.userLabel.text = comments[indexPath.row]["user"][0]["name"].stringValue
        cell.commentLabel.text = comments[indexPath.row]["text"].stringValue
        cell.commentLabel.numberOfLines = 0
        return cell
    }
    
    func updateCurentImage(id: Int) {
        //Updates number of likes, comments, etc.
        
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
