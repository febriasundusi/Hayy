//
//  ProfilePage.swift
//  Hayy
//
//  Created by Herlangga Wibi Yandi Nasution on 26/01/19.
//  Copyright © 2019 PT. Buana Kebenaran Informatika. All rights reserved.
//

import UIKit
import Kingfisher


class ProfilePage: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var avatarImage: UIImageView!
    
    @IBOutlet weak var postView: UIView!
    
    @IBOutlet weak var followersView: UIView!
    
    @IBOutlet weak var followingView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    //DEKLARASI VARIABEL
    var userPicker : String?
    var isAva: Bool?
    var isCover: Bool?
    
    
    var posts = [NSDictionary?]()
    var skip = 10
    var limit = 10
    
    let helper = Helper()
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Segarkan")
        refreshControl.tintColor = .orange
        refreshControl.addTarget(self, action: #selector(requestData), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure_Avatar()
        configure_View()
        loadUser()
        loadPost()
        
        if #available(iOS 10.0, *){
            tableView.refreshControl = refresher
        }
        else {
            tableView.addSubview(refresher)
        }
        
    }
    
    
    @objc func requestData() {
        
        let deadline = DispatchTime.now() + .milliseconds(700)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.viewDidLoad()
            self.refresher.endRefreshing()
        }
        
    }
    
    
    // Tap Gesture
    
    @IBAction func tapOnProfilPicture(_ sender: Any) {
        showActionSheet()
        //showPickerImage(with: .camera)
        
        //mengisi variabel userPicker
        userPicker = "avatar"
    }
    
    
    @IBAction func tapOnBackground(_ sender: Any) {
        showActionSheet()
       
        
        userPicker = "cover"
    }
    
    
    
    func configure_Avatar() {
        avatarImage.makeRounded()
    }
    
    func configure_View() {
        postView.makeRoundedView()
        followersView.makeRoundedView()
        followingView.makeRoundedView()
    }
    
    
    func loadUser(){
        
        
        helper.loadUser(fullName: nameLabel, avatar: avatarImage)
    
    
    } // penutup method loadUser
    
    
    
    
    func loadPost() {
        
        let userId = data_user?["user_Id"] as! String
        
        let url = URL(string: "https://hayy-226108.appspot.com/api/posts/me/\(userId)")!
        //let body = ""
        var request = URLRequest(url: url)
        //request.httpBody = body.data(using: .utf8)
        request.httpMethod = "GET"
        
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            DispatchQueue.main.async {
                
                if error != nil {
                    print("Data JSON tidak dapat di download")
                    return
                }
                
                do {
            
                    guard let data = data else {return}
            
            
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary
                
                    guard let dataJSON = json?["data"] as? [NSDictionary] else {
                        return
                    }
                    
                    self.posts = dataJSON
                    
                    
                    
                    self.skip = dataJSON.count
                    
                    self.tableView.reloadData()
                    
                    
                    
            }
                catch{
                    return
                }
                
            }
            
        }.resume()
        
        
        
    } //Penutup Load POST
    
   
    
    
    
    // take us to the picker controller (Controller that allows us to select picture)
    func showPickerImage(with source: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = source
        self.present(picker, animated: true, completion: nil)
    }
    
    
    // method untuk mengambil gambar yang telah di edit atau di pilih oleh user, method ini telah disediakan oleh protocol UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // mengambil gambar yang telah dipilih lalu memasukkan ke variabel image
        let image = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        
        
        // Menentukan gambar yang sesuai dengan user mengklik, jika klik avatar, maka gambar avatar yang terganti. begitu sebaliknya
        
        if userPicker == "avatar" {
            
            //memasukkan gambar ke avatar
            avatarImage.image = image
            
        }
        
        else if userPicker == "cover" {
        
            //memasukkan gambar ke cover picture
            backgroundImage.image = image
        }
            
        //setelah berhasil memasukkan gambar di cover, lalu kita panggil fungsi dismiss agar menyingkirkan frame edit photo
        dismiss(animated: true) {
            if self.userPicker == "avatar" {
                
                self.isAva = true
                
            }
                
            else if self.userPicker == "cover" {
                
                self.isCover = true
            }
        }
    } //Penutup Function
    
    
    
    
    
    
    // memunculkan alert seperti options agar user dapat memilih Camera, Photo Library, Cancel, Delete
    func showActionSheet() {
        
        //declaring action sheet
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // declaring camera button
        let camera = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.showPickerImage(with: .camera) }
            
            // declaring library photo button
            let library = UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
            self.showPickerImage(with: .photoLibrary)
        })
            
            //declaring cancel button
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                //self.dismiss(animated: true, completion: nil)
        })
            
            // declaring delete button
            let delete = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                
                if self.userPicker  == "avatar" {
                    self.avatarImage.image = UIImage(named: "user.png")
                    self.isAva = false
                }
                else if self.userPicker == "cover" {
                    self.backgroundImage.image = UIImage(named: "HomeCover.jpg")
                    self.isCover = false
                }
        })
        
        
        if userPicker == "avatar" && isAva == false {
            delete.isEnabled = false
        }
        else if userPicker == "cover" && isCover == false {
            delete.isEnabled = false
        }
        
        
        
        
        // adding buttons to the sheet
        sheet.addAction(camera)
        sheet.addAction(library)
        sheet.addAction(cancel)
        sheet.addAction(delete)
        
        self.present(sheet, animated: true, completion: nil)
        
    } // penutup method showActionSheet
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return posts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let type = posts[indexPath.row]?["type"] as! String
        
        
        if type == "text" {
            
            var getImage = ""
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoPicCell", for: indexPath) as! NoPicCell
            
            let title = posts[indexPath.row]?["title"]
            
            let text = posts[indexPath.row]?["text"]
            
            let name = posts[indexPath.row]?["user_profile_id"] as? NSDictionary
            let getName = name?["name"]
            
            let image = posts[indexPath.row]?["user_profile_id"] as? NSDictionary
            
            if image != nil {
                getImage = image?["image"] as! String
            }
            else {
                
            }
            
            //let getImage = image?["image"]
            
            let dateString = posts[indexPath.row]!["created_at"] as! String
            
            // TAKING THE DATE RECEIVED FROM THE SERVER AND PUTTING IT IN THE FOLLOWING FORMAT RECOGNIZED AS BEING DATE()
            let formatterGet = DateFormatter()
            formatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = formatterGet.date(from: dateString)!
            
            //we are writing a new readable format and putting date() into this format and the string to be shown to the user
            let formatterShow = DateFormatter()
            formatterShow.dateFormat = "dd MMMM yyyy - HH:mm"
            
            
            
            
            
            
            cell.fullNameLabel.text = getName as? String
            
            
            //cell.avaImageView.kf.setImage(with: URL(string: getImage as! String))
            if getImage != "-"
            {
                cell.avaImageView.kf.setImage(with: URL(string: getImage))
            }
            else{
                cell.avaImageView.image = UIImage(named: "user.png")
            }
            let like = posts[indexPath.row]?["like_count"] ?? "0"
            
            
            let comment = posts[indexPath.row]?["comment_count"] ?? "0"
            let share = posts[indexPath.row]?["share_count"] ?? "0"
            
            
            cell.shareButton.setTitle(" \(share) Bagikan", for: .normal)
            cell.commentButton.setTitle(" \(comment) Komentar", for: .normal)
            cell.likeButton.setTitle(" \(like) Suka", for: .normal)
            
            cell.dateLabel.text = formatterShow.string(from: date)
            cell.titlePost.text = title as? String
            cell.textPost.text = text as? String
            
            let liked = posts[indexPath.row]?["liked"] as! Int
           
            if liked > 0  {
            cell.likeButton.setImage(UIImage(named: "like.png"), for: .normal)
            }
            else {
            cell.likeButton.setImage(UIImage(named: "unlike.png"), for: .normal)
            }
            
            // GET THE INDEX OF THE CELL IN ORDER TO GET THE CERTAIN POST'S id
            cell.likeButton.tag = indexPath.row
            
            return cell
        }
        
        else if type == "image" {
            var getImage = ""
            let cell = tableView.dequeueReusableCell(withIdentifier: "PicCell", for: indexPath) as! PicCell
            
            let name = posts[indexPath.row]?["user_profile_id"] as? NSDictionary
            let getName = name?["name"]
            
            let image = posts[indexPath.row]?["user_profile_id"] as? NSDictionary
            if image != nil {
                getImage = image?["image"] as! String
            }
            else {
                
            }
            
            let dateString = posts[indexPath.row]!["created_at"] as! String
            
            // TAKING THE DATE RECEIVED FROM THE SERVER AND PUTTING IT IN THE FOLLOWING FORMAT RECOGNIZED AS BEING DATE()
            let formatterGet = DateFormatter()
            formatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = formatterGet.date(from: dateString)!
            
            //we are writing a new readable format and putting date() into this format and the string to be shown to the user
            let formatterShow = DateFormatter()
            formatterShow.dateFormat = "dd MMMM yyyy - HH:mm"
            
            let imagePost = posts[indexPath.row]?["media_url"] as? String
            
            let textPost = posts[indexPath.row]?["title"]
            
            cell.fullNameLabel.text = getName as? String
            
            if getImage != "-"
            {
                cell.avaImageView.kf.setImage(with: URL(string: getImage))
            }
            else{
                cell.avaImageView.image = UIImage(named: "user.png")
            }
            
            let like = posts[indexPath.row]?["like_count"] ?? "0"
            
            
            let comment = posts[indexPath.row]?["comment_count"] ?? "0"
            let share = posts[indexPath.row]?["share_count"] ?? "0"
            
            
            cell.shareButton.setTitle(" \(share) Bagikan", for: .normal)
            cell.commentButton.setTitle(" \(comment) Komentar", for: .normal)
            cell.likeButton.setTitle(" \(like) Suka", for: .normal)
            
            //cell.avaImageView.kf.setImage(with: URL(string: getImage )) ?? UIImage(named: "user.png")
            cell.dateLabel.text = formatterShow.string(from: date)
            cell.imagePostView.kf.setImage(with: URL(string: imagePost!))
            cell.textPost.text = textPost as? String
            
            // GET THE INDEX OF THE CELL IN ORDER TO GET THE CERTAIN POST'S id
            cell.likeButton.tag = indexPath.row
            
            let liked = posts[indexPath.row]?["liked"] as! Int
           
            if liked > 0  {
                cell.likeButton.setImage(UIImage(named: "like.png"), for: .normal)
            }
            
            else {
                cell.likeButton.setImage(UIImage(named: "unlike.png"), for: .normal)
            }
            
            return cell
            
        } // penutup else IF
        
        
        
        
        return UITableViewCell()
        
      
       
    } //PENUTUP FUNCTION
    
    
    // EXEC-ED WHEN LIKE BUTTON HAS BEEN CLICKED
    @IBAction func likeButton_Clicked(_ likeButton: UIButton) {
        
        let indexPathRow = likeButton.tag
        
        let is_liked = posts[indexPathRow]?["liked"] as! Int
        // ganti icon jika tombol like di klik
        
        
        guard let user_id = data_user?["user_Id"] else {
            return
        }
        guard let post_id = posts[indexPathRow]?["id"] else {
            return
        }
        
        if is_liked == 0 {
        
            likeButton.setImage(UIImage(named: "like.png"), for: .normal)
            
            let url = URL(string: "https://hayy-226108.appspot.com/api/posts/\(post_id)/\(user_id)/like")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                DispatchQueue.main.async {
                    //guard let error = error else {return}
                    if error != nil {
                        print("error: \(error ?? "No Error" as! Error)")
                    }
                    let response = response as! HTTPURLResponse
                    if response.statusCode != 200 {
                        print("Status Response Server untuk API Like: \(response.statusCode)")
                    }
                    else {
                        print("Like")
                        print(post_id)
                        self.loadPost()
                        self.viewDidLoad()
                        
                    }
                    
                    
                }
                }.resume()
            
        } // Penutup IF
        
        else{
            
            likeButton.setImage(UIImage(named: "unlike.png"), for: .normal)
            
            let url = URL(string: "https://hayy-226108.appspot.com/api/posts/\(post_id)/\(user_id)/like")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                DispatchQueue.main.async {
                    //guard let error = error else {return}
                    if error != nil {
                        print("error: \(error ?? "No Error" as! Error)")
                    }
                    let response = response as! HTTPURLResponse
                    if response.statusCode != 200 {
                        print("Status Response Server untuk API Like: \(response.statusCode)")
                    }
                    else {
                        print("Dislike")
                        print(post_id)
                        self.loadPost()
                        self.viewDidLoad()
                        
                    }
                    
                }
                }.resume()
            
        } // Penutup Else
            
        
        
        
        
        
        
    }
    
    

} // PENUTUP CLASS

extension UIImageView {
    
    func makeRounded() {
        let radius = self.frame.width / 8
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 2
    }
}


extension UIView {
    
    func makeRoundedView() {
        let radius = self.frame.width/4.0
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1
    }
}
