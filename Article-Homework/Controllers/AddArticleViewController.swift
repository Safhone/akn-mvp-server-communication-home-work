//
//  AddArticleViewController.swift
//  Article-Homework
//
//  Created by Safhone Oung on 12/26/17.
//  Copyright © 2017 Safhone Oung. All rights reserved.
//

import UIKit
import Photos
import Kingfisher

class AddArticleViewController: UIViewController {

    @IBOutlet weak var uploadImageImgaeView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var articleTextView: UITextView!
    @IBOutlet weak var barNavigationItem: UINavigationItem!
    
    var newsID: Int?
    var newsImage: String?
    var newsTitle: String?
    var newsDescription: String?
    var isUpdate: Bool = false
    var isSave: Bool?
    
    var articlePresenter = ArticlePresenter()
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkPhotoLibraryPermission()
        imagePicker.delegate = self
        
        let imageLongPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(imageLongPressed))
        imageLongPressGesture.minimumPressDuration = 0.5
        imageLongPressGesture.delegate = self
        uploadImageImgaeView.isUserInteractionEnabled = true
        uploadImageImgaeView.addGestureRecognizer(imageLongPressGesture)
        
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillShowForResizing), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideForResizing), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        if isUpdate {
            titleTextField.text = newsTitle!
            articleTextView.text = newsDescription!
            uploadImageImgaeView.kf.setImage(with: URL(string: newsImage! ), placeholder: #imageLiteral(resourceName: "no image"))
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if isUpdate {
            self.navigationController?.navigationBar.topItem?.title = "Update"
            self.barNavigationItem.title = "Update"
            isSave = false
            return
        } else {
            self.navigationController?.navigationBar.topItem?.title = "Add"
            self.barNavigationItem.title = "Add"
            isSave = true
        }
    }
    
    @IBAction func saveArticleContent(_ sender: Any) {
        let image = UIImageJPEGRepresentation(self.uploadImageImgaeView.image!, 1)
        var article = Article()
        if titleTextField.text == nil || titleTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            titleTextField.text = "Untitle"
        }
        if articleTextView.text == nil || articleTextView.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            articleTextView.text = "Don't have article"
        }
        if isUpdate {
            article.id = newsID!
        }
        article.title = titleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        article.description = articleTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        articlePresenter.saveArticle(article: article, image: image!, isSave: isSave!)
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func keyboardWillShowForResizing(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let window = self.view.window?.frame {
            self.view.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.width, height: window.origin.y + window.height - keyboardSize.height)
        }
    }
    
    @objc func keyboardWillHideForResizing(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let viewHeight = self.view.frame.height
            self.view.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.width, height: viewHeight + keyboardSize.height)
        }
    }
    
}

extension AddArticleViewController: UIGestureRecognizerDelegate {
    @objc func imageLongPressed(press: UILongPressGestureRecognizer) {
        if press.state == .began {
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .photoLibrary
            present(self.imagePicker, animated: true, completion: nil)
        }
    }
}

extension AddArticleViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func checkPhotoLibraryPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch photoAuthorizationStatus {
        case .authorized:
            print("Access is granted by user")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                }
            })
            print("It is not determined until now")
        case .restricted:
            print("User do not have access to photo album.")
        case .denied:
            print("User has denied the permission.")
        }
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.uploadImageImgaeView.image = pickedImage
        } else{
            print("Something went wrong")
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
