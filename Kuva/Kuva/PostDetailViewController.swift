//
//  PostDetailViewController.swift
//  Kuva
//
//  Created by Matthew on 2/7/17.
//  Copyright © 2017 kuva. All rights reserved.
//

import UIKit
import SwiftyJSON

class PostDetailViewController: PrimaryViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var commentTable: UITableView!
    
    var id: Int = 0
    var numComments: String? = nil
    var numLikes: String? = nil
    var caption: String? = nil
    var created: Date? = nil
    var postImage: UIImage? = nil
    var comments: [JSON] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.likesLabel.text = self.numLikes
        self.commentsLabel.text = self.numComments
        self.captionLabel.text = self.caption
        self.captionLabel.numberOfLines = 0
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.dateLabel.text = dateFormatter.string(from: self.created!)
        self.postImageView.image = self.postImage
        self.commentTable.delegate = self
        self.commentTable.dataSource = self
        self.commentTable.rowHeight = UITableViewAutomaticDimension
        self.commentTable.estimatedRowHeight = 43
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(self.numComments!)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentTableViewCell
        cell.userLabel.text = comments[indexPath.row]["user"][0]["name"].stringValue
        cell.commentLabel.text = comments[indexPath.row]["text"].stringValue
        cell.commentLabel.numberOfLines = 0
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
