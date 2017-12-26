//
//  NewsViewController.swift
//  Article-Homework
//
//  Created by Safhone Oung on 12/25/17.
//  Copyright © 2017 Safhone Oung. All rights reserved.
//

import UIKit
import Photos
import Kingfisher

class NewsViewController: UIViewController {

    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var newsDateLabel: UILabel!
    @IBOutlet weak var newsDescriptionTextView: UITextView!
    
    var newsTitle: String?
    var newsDate: String?
    var newsImage: String?
    var newsDescription: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsImageView.kf.setImage(with: URL(string: newsImage ?? "Not Available"), placeholder: #imageLiteral(resourceName: "no image"))
        newsTitleLabel.text = newsTitle
        newsDateLabel.text = newsDate
        newsDescriptionTextView.text = newsDescription
        
        let imageLongPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(imageLongPressed))
        imageLongPressGesture.minimumPressDuration = 0.5
        imageLongPressGesture.delegate = self
        newsImageView.isUserInteractionEnabled = true
        newsImageView.addGestureRecognizer(imageLongPressGesture)
    }

}

extension NewsViewController : UIImagePickerControllerDelegate {
    @objc func saveImage(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: "Saved!", message: "Image saved successfully", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
}

extension NewsViewController: UIGestureRecognizerDelegate {
    @objc func imageLongPressed(press: UILongPressGestureRecognizer) {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        if press.state == .began {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action) in
                switch photoAuthorizationStatus {
                case .authorized :
                    UIImageWriteToSavedPhotosAlbum(self.newsImageView.image!, self, #selector(self.saveImage(_:didFinishSavingWithError:contextInfo:)), nil)
                case .notDetermined:
                    PHPhotoLibrary.requestAuthorization({ (newStatus) in
                        if newStatus == PHAuthorizationStatus.authorized {
                            DispatchQueue.main.async {
                                UIImageWriteToSavedPhotosAlbum(self.newsImageView.image!, self, #selector(self.saveImage(_:didFinishSavingWithError:contextInfo:)), nil)
                            }
                        }
                    })
                case .restricted: break
                case .denied: break
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
}
