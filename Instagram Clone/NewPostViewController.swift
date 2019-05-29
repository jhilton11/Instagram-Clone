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
    @IBOutlet weak var saveButton: UIBarButtonItem!
    var spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    
    var postsRef: DatabaseReference!
    var storageRef: StorageReference!
    var imagePicker = UIImagePickerController()
    var image: UIImage?
    var id: String = ""
    var name: String = ""
    var location: String?
    var lastComment: String?
    var authorImageUrl: String?
    var isKeyboardDisplayed: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initializaComp()
        presentImagePicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func handleTapGesture() {
        if (isKeyboardDisplayed) {
            self.view.endEditing(true)
        } else {
            presentImagePicker()
        }
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        isKeyboardDisplayed = true;
        guard let keyboardinfo = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let keyboardFrame = keyboardinfo.cgRectValue
        
        if (self.view.frame.origin.y == 0) {
            self.view.frame.origin.y -= keyboardFrame.height
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        isKeyboardDisplayed = false
        if (self.view.frame.origin.y != 0) {
            self.view.frame.origin.y = 0
        }
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
        
        //add tap gesture recognizer to imageView
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
        
        // setup the loading activity indicator
        spinner.hidesWhenStopped = true;
        spinner.center = view.center
        spinner.stopAnimating()
        view.addSubview(spinner)
    }
    
    func presentImagePicker()->Void {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated:true, completion:nil)
    }

    @IBAction func savePost(_ sender: Any) {
        spinner.startAnimating()
        saveButton.isEnabled = false
        postsRef = Database.database().reference().child("post")
        let key = postsRef.childByAutoId().key!
        id = key
        storageRef = Storage.storage().reference().child("post-images").child("\(key).jpg")
        
        if let tempImage = image {
            if let data = UIImageJPEGRepresentation(tempImage, 0.75){
                let mData = StorageMetadata()
                mData.contentType = "image/jpeg";
                print("Image has been successfully converted to data")
                storageRef.putData(data, metadata: mData) {(metadata, error) in
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
                                self.spinner.stopAnimating()
                                self.saveButton.isEnabled = true
                            } else {
                                //Data saved successfully
                                self.performSegue(withIdentifier: "unwindToPosts", sender: self)
                                self.spinner.stopAnimating()
                                self.saveButton.isEnabled = true
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
