//
//  NewCommentViewController.swift
//  Instagram Clone
//
//  Created by APPLE on 5/20/19.
//  Copyright © 2019 appify. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class NewCommentViewController: UITableViewController, UITextViewDelegate {

    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var table: UITableView!
    
    var commentsRef: DatabaseReference!
    var comments = [Comment]()
    var name: String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tempName = Auth.auth().currentUser?.displayName {
            name = tempName
        } else {
            name = "Guest"
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        table.dataSource = self
        table.delegate = self
        
        commentTextView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData() -> Void{
        commentsRef = Database.database().reference().child("comments")
        
        comments = []
        commentsRef.observe(.value) { (snapshot) in
                for child in snapshot.children {
                    let childSnapshot = child as! DataSnapshot
                    let value = childSnapshot.value as? NSDictionary
                    let profilePicUrl = value?["imageUrl"] as? String
                    let comment = value?["comment"] as? String
                    let name = value?["comment"] as! String
                    let temp = Comment(comment: comment!, imageUrl: profilePicUrl, authorName: name)
                    self.comments.append(temp)
            }
        }
        
        self.table.reloadData()
    }
    
    func addNewComment(comment: String?) {
        guard comment != nil else{
            //println("You have not entered your comment")
            return
        }
        
        commentsRef = Database.database().reference().child("comments")
        let key = commentsRef.childByAutoId().key!
        
        //TODO: Update code to load profile pic of post's author
        commentsRef.child(key).setValue(["comment": comment, "imageUrl": nil, "authorName": name!])
        {(error: Error?, ref: DatabaseReference) in
            if (error == nil) {
                print("Comment added successfully")
                self.commentTextView.text = ""
            } else {
                print("There was an error: \(error!)")
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        addNewComment(comment: textView.text)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return comments.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentTableViewCell

        let comment = comments[indexPath.row]
        cell.setCell(comment: comment)

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
