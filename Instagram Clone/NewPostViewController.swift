//
//  NewPostViewController.swift
//  Instagram Clone
//
//  Created by APPLE on 5/20/19.
//  Copyright © 2019 appify. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class NewPostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    var postsRef: DatabaseReference!
    var storageRef: StorageReference!
    var imagePicker = UIImagePickerController()
    var image: UIImage?
    var id: String = ""
    var name: String = ""
    var location: String?
    var lastComment: String?
    var authorImageUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initializaComp()
        presentImagePicker()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializaComp()->Void {
        if let currentUser = Auth.auth().currentUser?.displayName {
            name = currentUser
        } else {
            name = "Guest"
            authorImageUrl = nil
        }
        print("Username is \(name)")
        location = nil
    }
    
    func presentImagePicker()->Void {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated:true, completion:nil)
    }

    @IBAction func savePost(_ sender: Any) {
        postsRef = Database.database().reference().child("post")
        let key = postsRef.childByAutoId().key!
        id = key
        storageRef = Storage.storage().reference().child("post-images").child("\(key).jpg")
        
        if let tempImage = image {
            if let data = UIImagePNGRepresentation(tempImage) {
                //let mData = StorageMetadata()
                //mData.contentType = "image/jpeg";
                print("Image has been successfully converted to data")
                storageRef.putData(data, metadata: nil) {(metadata, error) in
                    guard error == nil else {
                        print("Error has occurred")
                        return
                    }
                    self.storageRef.downloadURL{(url, err) in
                        print("Image saved successfully into Firebase storage")
                        self.postsRef.child(key).setValue(["id": self.id,
                                                           "name": self.name,
                                                           "location": self.location,
                                                           "lastComment": nil,
                                                           "imageUrl": url!.absoluteString,
                                                           "authorImageUrl": self.authorImageUrl])
                        {(error: Error?, ref: DatabaseReference) in
                            if let err = error {
                                print("\(err)")
                            } else {
                                //Data saved successfully
                                self.performSegue(withIdentifier: "unwindToPosts", sender: self)
                            }
                        }
                    }
                }
            }
        } else {
            print("You have not selected an image")
            presentImagePicker()
        }
    }
    
    @IBAction func cancelPost(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = img
            image = img
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
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
