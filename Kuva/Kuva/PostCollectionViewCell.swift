//
//  PostCollectionViewCell.swift
//  Kuva
//
//  Created by Shane DeWael on 2/5/17.
//  Copyright © 2017 kuva. All rights reserved.
//

import UIKit

class PostCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var postImageView: UIImageView!
    var id: Int = 0
    var numComments: String? = nil
    var numLikes: String? = nil
    var caption: String? = nil
    var created: Date? = nil
}
