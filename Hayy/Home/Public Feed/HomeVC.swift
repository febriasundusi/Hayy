//
//  HomeVC.swift
//  Hayy
//
//  Created by Herlangga Wibi Yandi Nasution on 12/02/19.
//  Copyright © 2019 PT. Buana Kebenaran Informatika. All rights reserved.
//

import UIKit
import Kingfisher
import XLPagerTabStrip
import Floaty


class HomeVC: UITableViewController, IndicatorInfoProvider {
    
    var actionButton : ActionButton!
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .orange
        refreshControl.attributedTitle = NSAttributedString(string: "Segarkan..")
        refreshControl.addTarget(self, action: #selector(requestData), for: .valueChanged)
        return refreshControl
    }()
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
            return IndicatorInfo(title: "Public Feed")
    }
    
    let userId = data_user?["user_Id"] as! String
    
    var posts = [NSDictionary?]()
    var skip = 10
    var limit = 10

    override func viewDidLoad() {
        
        
        super.viewDidLoad()

        loadPost()
        
        
        if #available(iOS 10.0, *){
            tableView.refreshControl = refresher
        }
        else {
            tableView.addSubview(refresher)
        }
    }
    
    @objc
    func requestData(){
        viewDidLoad()
        let deadLine = DispatchTime.now() + .milliseconds(700)
        DispatchQueue.main.asyncAfter(deadline: deadLine) {
            self.refresher.endRefreshing()
        }
        
    }
    
    
    
    func loadPost() {
        
        let userId = data_user?["user_Id"] as! String
        let url = URL(string: "https://hayy-226108.appspot.com/api/posts?treding=1&page=1&user_id=\(userId)")!
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
        
        
        
    } //Load Post
    
    

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
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoPicCell", for: indexPath) as! HomeNoPicCell
            
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
            else {
                cell.likeButton.setImage(UIImage(named: "unlike.png"), for: .normal)
            }
            
            
            return cell
        
        } // penutup IF
            
        else if type == "image" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PicCell", for: indexPath) as! HomePicCell
            
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
            //cell.commentButton.setTitle
            
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
            else {
                cell.likeButton.setImage(UIImage(named: "unlike.png"), for: .normal)
            }
            return cell
            }
            
            else if type == "video" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath) as! HomeVideoCell
                
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
                //cell.commentButton.setTitle
                
                cell.fullNameLabel.text = getName as? String
                cell.avaImageView.kf.setImage(with: URL(string: getImage as! String))
                cell.dateLabel.text = formatterShow.string(from: date)
                //cell.videoView
                cell.textPost.text = textPost as? String
                cell.likeButton.tag = indexPath.row
                
                let liked = posts[indexPath.row]?["liked"] as! Int
                
                if liked > 0  {
                    cell.likeButton.setImage(UIImage(named: "like.png"), for: .normal)
                }
                else {
                    cell.likeButton.setImage(UIImage(named: "unlike.png"), for: .normal)
                }
                return cell
            }
            
            
        
        
         // penutup else IF
        
        
        
        
        return UITableViewCell()
        
        
        
    } // penutup function cellForRowAt
    
    @IBAction func likeButton_Clicked(_ likeButton: UIButton) {
        
        let indexPathRow = likeButton.tag
        
        let is_liked = posts[indexPathRow]?["liked"] as! Int
        // ganti icon jika tombol like di klik
        
        
        
        guard let post_id = posts[indexPathRow]?["id"] else {
            return
        }
        
        if is_liked == 0 {
            
            likeButton.setImage(UIImage(named: "like.png"), for: .normal)
            
            let url = URL(string: "https://hayy-226108.appspot.com/api/posts/\(post_id)/\(userId)/like")!
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
                        //self.tableView.reloadRows(at: [IndexPath(row: indexPathRow, section: 0)], with: .fade)
                        
                        
                        
                    }
                    
                    
                }
                }.resume()
        //print(self.posts[indexPathRow])
            
        } // Penutup IF
            
        else{
            
            likeButton.setImage(UIImage(named: "unlike.png"), for: .normal)
            
            let url = URL(string: "https://hayy-226108.appspot.com/api/posts/\(post_id)/\(userId)/like")!
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
                            //self.tableView.reloadRows(at: [IndexPath(row: indexPathRow, section: 0)], with: .fade)
                            
                        }
                    
                    
                   
                    
                } // Penutup DispatchQueue
                }.resume()
            //print(self.posts[indexPathRow])
        } // Penutup Else
        
        
        
        //self.tableView.reloadRows(at: [IndexPath(row: indexPathRow, section: 0)], with: .fade)
        
        
        
        
    }

    

} // PENUTUP CLASS
