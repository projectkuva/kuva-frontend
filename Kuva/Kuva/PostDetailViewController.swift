//
//  PostDetailViewController.swift
//  Kuva
//
//  Created by Matthew on 2/7/17.
//  Copyright © 2017 kuva. All rights reserved.
//

import UIKit

class PostDetailViewController: PrimaryViewController {
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    
    var id: Int = 0
    var numComments: String? = nil
    var numLikes: String? = nil
    var caption: String? = nil
    var created: Date? = nil
    var postImage: UIImage? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        likesLabel.text = self.numLikes
        commentsLabel.text = self.numComments
        captionLabel.text = self.caption
        captionLabel.numberOfLines = 0
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateLabel.text = dateFormatter.string(from: self.created!)
        postImageView.image = postImage
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
