//
//  ViewController.swift
//  Instagram Clone
//
//  Created by APPLE on 5/20/19.
//  Copyright © 2019 appify. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController {
    
    @IBOutlet weak var table: UITableView!
    
    var posts = [Post]()
    var postsRef: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.dataSource = self
        table.delegate = self
        print("Hello and welcome")
        // Do any additional setup after loading the view, typically from a nib.
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData()->Void{
        posts = []
        print("Trying to load posts")
        
        postsRef = Database.database().reference().child("post")
        postsRef.observeSingleEvent(of: .value, with: {(snapshot) in
            print("\(snapshot.childrenCount) snapshots loaded")
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let value = snap.value as? NSDictionary
                let id = value!["id"] as! String
                let name = value!["name"] as! String
                let imageUrl = value!["imageUrl"] as! String
                let location = value?["location"] as? String
                let authorImageUrl = value?["authorImageUrl"] as? String
                let lastComment = value?["lastComment"] as? String
                
                let post = Post(id: id, name: name, location: location, lastComment: lastComment, imageUrl: imageUrl, authorImageUrl: authorImageUrl)
                self.posts.append(post)
            }
            self.table.reloadData()
            print("Data loaded successfully")
            print("\(self.posts.count) items loaded into database")
        })
    }
    
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {
        if (segue.identifier == "unwindToPosts") {
            loadData()
        } else if (segue.identifier == "unwindfromComments") {
            
        }
        
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate, PostTableViewCellDelegate{
    
    func likeAndUnlikePost(_ tableViewCell: UITableViewCell, PostId postId: String) {
        
    }
    
    func commentOnPost(_ tableViewCell: UITableViewCell, PostId postId: String) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostTableViewCell
        let post = posts[indexPath.row]
        cell.setCell(post: post)
        cell.delegate = self
        cell.postId = post.id
        return cell
    }
    
}

