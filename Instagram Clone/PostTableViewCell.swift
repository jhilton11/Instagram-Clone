//
//  NewPostTableViewCell.swift
//  Instagram Clone
//
//  Created by APPLE on 5/20/19.
//  Copyright © 2019 appify. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var lastCommentImageView: UILabel!
    
    var delegate: PostTableViewCellDelegate?
    var imageCache = NSCache<AnyObject, AnyObject>()
    var postId: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //postImageView.image = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(post: Post)->Void {
        print("The cell loading has begun")
        nameLabel.text = post.name
        
        if let location = post.location {
            locationLabel.text = location
        } else {
            //locationLabel.isHidden = true
        }
        
        if let lastComment = post.lastComment {
            lastCommentImageView.text = lastComment
        } else {
            //lastCommentImageView.isHidden = true
        }
        
        //TODO: add code for downloading post image and image url
        if let profilePicUrl = post.authorImageUrl {
            let url = URL(string: profilePicUrl)
            let session = URLSession.shared
            let task = session.dataTask(with: url!) { (data, response, error) in
                if (data != nil) {
                    let image = UIImage(data: data!)
                    DispatchQueue.main.async {
                        self.postImageView.image = image
                    }
                }
            }
            task.resume()
        } else {
            
        }
        
        let postImageUrl = post.imageUrl
        print("Image Url: \(postImageUrl)")
        if let cachedImage = imageCache.object(forKey: postImageUrl as AnyObject) as? UIImage {
            postImageView.image = cachedImage
            print("Image loaded from cache")
        } else {
            let storageRef = Storage.storage().reference(forURL: postImageUrl)
            storageRef.getData(maxSize: 3 * 1024 * 1024) { (data, error) in
                if let e = error {
                    print("Error has occured: \(e)")
                } else {
                    if (data != nil) {
                        let image = UIImage(data: data!)
                        self.imageCache.setObject(image!, forKey: postImageUrl as AnyObject)
                        self.postImageView.image = image
                        print("Image successfully loaded")
                    } else {
                        print("Data is nil")
                    }
                }
            }
        }
    }
    
    @IBAction func likePost(_ Sender: Any) {
        self.delegate?.likeAndUnlikePost(self, PostId: postId)
    }

}

protocol PostTableViewCellDelegate {
    func likeAndUnlikePost(_ tableViewCell: UITableViewCell, PostId postId: String)
    
    func commentOnPost(_ tableViewCell: UITableViewCell, PostId postId: String)
}
