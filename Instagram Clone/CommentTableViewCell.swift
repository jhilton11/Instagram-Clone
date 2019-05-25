//
//  CommentTableViewCell.swift
//  
//
//  Created by APPLE on 5/20/19.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(comment: Comment)->Void {
        commentLabel.text = comment.comment
        
        if let imageUrl = comment.imageUrl {
            let url = URL(string: imageUrl)
            URLSession.shared.dataTask(with: url!) { (data, response, error) in
                if (error != nil) {
                    if (data != nil) {
                        let image = UIImage(data: data!)
                        DispatchQueue.main.async {
                            self.commentImageView.image = image
                        }
                    }
                } else {
                    //println("There is an error \(error)")
                    return
                }
            }.resume()
        }
    }

}
