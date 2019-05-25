//
//  Post.swift
//  Instagram Clone
//
//  Created by APPLE on 5/20/19.
//  Copyright © 2019 appify. All rights reserved.
//

import Foundation

class Post {
    //MARK: Properties
    var id: String
    var name: String
    var location: String?
    var lastComment: String?
    var imageUrl: String
    var authorImageUrl: String?
    
    //MARK: Initialization
    init(id: String, name: String, location: String?, lastComment: String?, imageUrl: String, authorImageUrl: String?) {
        self.id = id
        self.name = name
        self.imageUrl = imageUrl
        self.authorImageUrl = authorImageUrl
        self.location = location
        self.lastComment = lastComment
    }
}
