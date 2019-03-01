//
//  PostVC.swift
//  Hayy
//
//  Created by Herlangga Wibi Yandi Nasution on 05/02/19.
//  Copyright © 2019 PT. Buana Kebenaran Informatika. All rights reserved.
//

import UIKit
import FirebaseStorage

class PostVC: UIViewController, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    @IBOutlet weak var avaImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var uploadImage: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var labelApaYgDipikirkan: UILabel!
    @IBOutlet weak var titleView: UITextField!
    
    
   
    
    let helper = Helper()
    
    let imageUniqueName = UUID().uuidString
    
    
    
    var imageReference : StorageReference {
        return Storage.storage().reference().child("images\(imageUniqueName)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loadUser()
      
    }
    
    override func viewDidLayoutSubviews() {
        avaImageView.layer.cornerRadius = avaImageView.frame.width / 2
        avaImageView.clipsToBounds = true
        textView.delegate = self
        textView.layer.borderWidth = 0.4
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.cornerRadius = 4
        textView.clipsToBounds = true
    }
    
    
    @IBAction func share(_ sender: Any) {
        createPost()
    }
    
    @IBAction func cancel(_ sender: Any) {
        let home = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBar")
        present(home, animated: true, completion: nil)
    }
    
    @IBAction func addPicture(_ sender: Any) {
        //showAction()
        showAction()
    }
    
    
    @IBAction func uploadImage_Tapped(_ sender: Any) {
        
        
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let delete = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            self.uploadImage.image = UIImage()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        sheet.addAction(delete)
        sheet.addAction(cancel)
        
        self.present(sheet, animated: true, completion: nil)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textView.resignFirstResponder()
    }
    
    
    func loadUser(){
        helper.loadUser(fullName: fullNameLabel, avatar: avaImageView)
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            labelApaYgDipikirkan.isHidden = false
        }
        else {
            labelApaYgDipikirkan.isHidden = true
        }
    }
    
    
    
    func showAction() {
        
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        
        let camera = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.showImagePicker(with: .camera)
        }
        
        let library = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            self.showImagePicker(with: .photoLibrary)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            //self.dismiss(animated: true, completion: nil)
        }
        
        sheet.addAction(camera)
        sheet.addAction(library)
        sheet.addAction(cancel)
        
        self.present(sheet, animated: true, completion: nil)
        
        
    } //PENUTUP FUNCTION SHOWACTION
    
    
    func showImagePicker(with source: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = source
        
        self.present(picker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        
        uploadImage.image = image
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func createPost() {
        
        guard let title = titleView.text else {return}
        guard let text = textView.text else {return}
        let images = self.uploadImage.image
        
        if images != nil {
            
            let imageData = images?.jpegData(compressionQuality: 1.0)
            let uploadImageRef = imageReference
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            let upload = uploadImageRef.putData(imageData!, metadata: metadata) { (metadata, error) in
                self.getURL_Image()
            }
            
            upload.resume()

        } // Penutup IF
        
        else {
        let media_url_teks = ""
        
            helper.createPost(title: title, text: text, type: "text", media_url: media_url_teks, status: 0, method: "POST")
            let homeVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBar")
            self.present(homeVC, animated: true, completion: nil)

        } //penutup else
        
    } // penutup fungsi untuk createPost
    
    
    func getURL_Image() {
        
            guard let title = titleView.text else {return}
            guard let text = textView.text else {return}
        
            let uploadImageRef = imageReference
        
            uploadImageRef.downloadURL { (media_url, error) in
            
            guard let media_url = media_url else {
                return
            }
            
            let getURL = media_url.absoluteString
                
            print(getURL)
            
            self.helper.createPost(title: title, text: text, type: "image", media_url: getURL, status: 0, method: "POST")
            let homeVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeID")
            self.present(homeVC, animated: true, completion: nil)
        }
    }

}
