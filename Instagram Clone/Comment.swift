//
//  Comment.swift
//  Instagram Clone
//
//  Created by APPLE on 5/20/19.
//  Copyright © 2019 appify. All rights reserved.
//

import Foundation

class Comment {
    var comment: String
    var imageUrl: String?
    var authorName: String
    
    //MARK: Initialization
    init(comment: String, imageUrl: String?, authorName: String) {
        self.comment = comment
        self.imageUrl = imageUrl
        self.authorName = authorName
    }
}
