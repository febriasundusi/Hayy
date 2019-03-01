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

class PrivateVC: UITableViewController, IndicatorInfoProvider {
    
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Private Feed")
    }
    
    
    
    var posts = [NSDictionary?]()
    var skip = 10
    var limit = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPost()
    }
    
    
    func loadPost() {
        
        let userId = data_user?["user_Id"] as! String
        
        
        let url = URL(string: "https://api.hayy.app/api/posts?page=1&user_id=\(userId)")!
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
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if posts.count > 0 {
            tableView.restore()
            
        }
        else {
            tableView.setEmptyView(title: "Private Feed Kosong", message: "Follow ustad terlebih dahulu", messageImage: #imageLiteral(resourceName: "information"))
        }
        
        
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let type = posts[indexPath.row]?["type"] as! String
        
        if type == "text" {
            var getImage = ""
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "PrivateNoPicCell", for: indexPath) as! PrivateNoPicCell
            
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
            
            
            let like = posts[indexPath.row]?["like_count"] ?? "0"
            
            
            let comment = posts[indexPath.row]?["comment_count"] ?? "0"
            let share = posts[indexPath.row]?["share_count"] ?? "0"
            
            
            cell.shareButton.setTitle(" \(share) Bagikan", for: .normal)
            cell.commentButton.setTitle(" \(comment) Komentar", for: .normal)
            cell.likeButton.setTitle(" \(like) Suka", for: .normal)
            
            
            
            cell.fullNameLabel.text = getName as? String
            
            if getImage != "-"
            {
                cell.avaImageView.kf.setImage(with: URL(string: getImage))
            }
            else{
                cell.avaImageView.image = UIImage(named: "user.png")
            }
            
            //cell.avaImageView.kf.setImage(with: URL(string: getImage as! String))
            cell.dateLabel.text = formatterShow.string(from: date)
            cell.titlePost.text = title as? String
            cell.textPost.text = text as? String
            return cell
            
        } // penutup IF
            
        else if type == "image" {
            var getImage = ""
            let cell = tableView.dequeueReusableCell(withIdentifier: "PrivatePicCell", for: indexPath) as! PrivatePicCell
            
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
            return cell
            
        } // penutup else IF
        
        
        
        
        return UITableViewCell()
        
        
        
    } // penutup function cellForRowAt
    
    
} // PENUTUP CLASS


extension UITableView {
    
    func setEmptyView(title: String, message: String, messageImage: UIImage) {
        
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
//        (frame: CGRect(x: 90, y: 50, width: 50, height: 50))
        //
        
        let messageImageView = UIImageView()
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        
        messageImageView.backgroundColor = .clear
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageImageView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        
        messageLabel.textColor = UIColor.lightGray
        messageLabel.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
        
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageImageView)
        emptyView.addSubview(messageLabel)
        
        messageImageView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        messageImageView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor, constant: -100).isActive = true
        messageImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        messageImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: messageImageView.bottomAnchor, constant: 10).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        messageLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        
        messageImageView.image = messageImage
        titleLabel.text = title
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        
        UIView.animate(withDuration: 1, animations: {
            
            messageImageView.transform = CGAffineTransform(rotationAngle: .pi / 10)
        }, completion: { (finish) in
            UIView.animate(withDuration: 1, animations: {
                messageImageView.transform = CGAffineTransform(rotationAngle: -1 * (.pi / 10))
            }, completion: { (finishh) in
                UIView.animate(withDuration: 1, animations: {
                    messageImageView.transform = CGAffineTransform.identity
                })
            })
            
        })
        
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    
    func restore() {
        
        self.backgroundView = nil
        self.separatorStyle = .singleLine
        
    }
    
}

