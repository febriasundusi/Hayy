//
//  GuestVC.swift
//  Hayy
//
//  Created by Herlangga Wibi Yandi Nasution on 13/02/19.
//  Copyright © 2019 PT. Buana Kebenaran Informatika. All rights reserved.
//

import UIKit

class GuestVC: UITableViewController {
    
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var avatarImage: UIImageView!
    
    @IBOutlet weak var postView: UIView!
    
    @IBOutlet weak var followersView: UIView!
    
    @IBOutlet weak var followingView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var angka_Post: UILabel!
    
    @IBOutlet weak var angka_Followers: UILabel!
    
    @IBOutlet weak var angka_Following: UILabel!
    
    
    var id = Int()
    var fullName = String()
    var avaPath = String()
    var user_id = String()
    var posts_Count = Int()
    var following_Count = Int()
    var followers_Count = Int()
    
    var posts = [NSDictionary?]()
    var skip = 10
    
    lazy var refresh : UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Segarkan")
        refreshControl.tintColor = .orange
        refreshControl.addTarget(self, action: #selector(updateData), for: .valueChanged)
        
        return refreshControl
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUser()
        loadPost()
        configure_avatar()
        configure_View()
        
        if #available(iOS 10.0, *){
            tableView.refreshControl = refresh
        }
        else {
        tableView.addSubview(refresh)
        }
        
    }
    
    @objc func updateData() {
        let deadline = DispatchTime.now() + .milliseconds(700)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.viewDidLoad()
            self.refresh.endRefreshing()
        }
    }
    
    func configure_View() {
        postView.makeRoundedView()
        followersView.makeRoundedView()
        followingView.makeRoundedView()
    }
    
    
    func loadUser() {
        
        let coba = posts_Count
        
        
        nameLabel.text = fullName
        avatarImage.kf.setImage(with: URL(string: avaPath))
        angka_Post.text = String(coba)
        angka_Followers.text = String(followers_Count)
        angka_Following.text = String(following_Count)
        
        
    }
    
    
    
    
    func loadPost() {
        let url = URL(string: "https://hayy-226108.appspot.com/api/posts/me/\(user_id)")!
        
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
        
        
        
    }
    
    func configure_avatar() {
        avatarImage.makeRounded()
    }

    // MARK: - Table view data source

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = posts[indexPath.row]?["type"] as! String
        
        if type == "text" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GuestNoPicCell", for: indexPath) as! GuestNoPicCell
            
            let title = posts[indexPath.row]?["title"]
            
            let text = posts[indexPath.row]?["text"]
            
            let name = posts[indexPath.row]?["user_profile_id"] as? NSDictionary
            let getName = name?["name"]
            
            let image = posts[indexPath.row]?["user_profile_id"] as? NSDictionary
            let getImage = image?["image"]
            
            let dateString = posts[indexPath.row]!["created_at"] as! String
            
            // TAKING THE DATE RECEIVED FROM THE SERVER AND PUTTING IT IN THE FOLLOWING FORMAT RECOGNIZED AS BEING DATE()
            let formatterGet = DateFormatter()
            formatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = formatterGet.date(from: dateString)!
            
            //we are writing a new readable format and putting date() into this format and the string to be shown to the user
            let formatterShow = DateFormatter()
            formatterShow.dateFormat = "dd MMMM yyyy - HH:mm"
            
            
            
            
            let like = posts[indexPath.row]?["like_count"] ?? "0"
            
            
            let comment = posts[indexPath.row]?["comment_count"] ?? "0"
            let share = posts[indexPath.row]?["share_count"] ?? "0"
            
            
            cell.shareButton.setTitle(" \(share) Bagikan", for: .normal)
            cell.commentButton.setTitle(" \(comment) Komentar", for: .normal)
            cell.likeButton.setTitle(" \(like) Suka", for: .normal)
            
            cell.fullNameLabel.text = getName as? String
            cell.avaImageView.kf.setImage(with: URL(string: getImage as! String))
            cell.dateLabel.text = formatterShow.string(from: date)
            cell.titlePost.text = title as? String
            cell.textPost.text = text as? String
            
            cell.likeButton.tag = indexPath.row
            
            let liked = posts[indexPath.row]?["liked"] as! Int
            
            if liked > 0  {
                cell.likeButton.setImage(UIImage(named: "like.png"), for: .normal)
            }
            
            
            return cell
            
        } // penutup IF
            
        else if type == "image" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GuestPicCell", for: indexPath) as! GuestPicCell
            
            let name = posts[indexPath.row]?["user_profile_id"] as? NSDictionary
            let getName = name?["name"]
            
            let image = posts[indexPath.row]?["user_profile_id"] as? NSDictionary
            let getImage = image?["image"]
            
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
            
            let like = posts[indexPath.row]?["like_count"] ?? "0"
            
            
            let comment = posts[indexPath.row]?["comment_count"] ?? "0"
            let share = posts[indexPath.row]?["share_count"] ?? "0"
            
            
            cell.shareButton.setTitle(" \(share) Bagikan", for: .normal)
            cell.commentButton.setTitle(" \(comment) Komentar", for: .normal)
            cell.likeButton.setTitle(" \(like) Suka", for: .normal)
            cell.fullNameLabel.text = getName as? String
            cell.avaImageView.kf.setImage(with: URL(string: getImage as! String))
            cell.dateLabel.text = formatterShow.string(from: date)
            cell.imagePostView.kf.setImage(with: URL(string: imagePost!))
            cell.textPost.text = textPost as? String
            
            cell.likeButton.tag = indexPath.row
            
            let liked = posts[indexPath.row]?["liked"] as! Int
            
            if liked > 0  {
                cell.likeButton.setImage(UIImage(named: "like.png"), for: .normal)
            }
            
            return cell
            
        } // penutup else IF
        
        
        
        
        return UITableViewCell()
    }
    
    
    
    @IBAction func likeButton_Clicked(_ likeButton: UIButton) {
        
        let indexPathRow = likeButton.tag
        
        let is_liked = posts[indexPathRow]?["liked"] as! Int
        // ganti icon jika tombol like di klik
        
        
        
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
    

} // PENUTUP class
