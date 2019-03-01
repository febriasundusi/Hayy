//
//  UstadPage.swift
//  Hayy
//
//  Created by Herlangga Wibi Yandi Nasution on 28/01/19.
//  Copyright © 2019 PT. Buana Kebenaran Informatika. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher

class UstadPage: UITableViewController {
    
  
    
    var arrData = [JsonModel]()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        //loadUstad()
        //print(namaUstad)
        
        
        
        loadUstad()
        
        //print(namaUstad)
       
        
        //print(namaUstad)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cellIdentifier = "DaftarUstad"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DaftarUstad
           
        
        
        //let daftar = namaUstad[indexPath.row]
        
        cell.namaUstad.text = arrData[indexPath.row].name
        cell.avatarUstad.kf.setImage(with: URL(string: arrData[indexPath.row].image))
        
        cell.avatarUstad.layer.cornerRadius = cell.avatarUstad.frame.size.width/2
        cell.avatarUstad.clipsToBounds = true
        // cell.avatarUstad.kf.setImage(with: URL(string: arrData[indexPath.row].image))
        return cell
        
        
        
        // let data = coba["name"]
        
        //cell.namaUstad.text = DaftarUstad[IndexPath.row].
        
       
    }
    
//     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//        let data = arrData[indexPath.row].name
//        
//        let alert = UIAlertController(title: "Notice", message: "U have been select \(data)", preferredStyle: .alert)
//        let actionAlert = UIAlertAction(title: "Success", style: .default) { (alert) in
//            print("wow")
//        
//            
//        }
//        let visited = UIAlertAction(title: "I have Been Here", style: .default) { (alert) in
//            let cell = tableView.cellForRow(at: indexPath)
//            
//            
//        }
//        
//        alert.addAction(actionAlert)
//        alert.addAction(visited)
//        self.present(alert, animated: true, completion: nil)
//
//    }
    

    func loadUstad() {
        
        
        
        let url = URL(string: "https://hayy-226108.appspot.com/api/admin/ustadzs")!
        let body = "token=9D55D308E01806EF0227CF5A3AC90F4E"
        var request = URLRequest(url: url)
        request.httpBody = body.data(using: .utf8)
        request.httpMethod = "POST"
        
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            DispatchQueue.main.async {
                
                do {

                    guard let json = data else {
                        print(error!.localizedDescription)
                        return
                }
                
                    //let parsedJSON = try JSONSerialization.jsonObject(with: json, options: .allowFragments) as! NSDictionary
                    
                    
                    
                    let data = try JSON(data: json)
                    let result = data["message"]
                    for arr in result.arrayValue {
                        self.arrData.append(JsonModel.init(json: arr))
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                
                }
                
                catch{
                    print(error.localizedDescription)
                }
                
            }
            
            
        }.resume()
        
        
        
    } // penutup fungsi loadUstad
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let indexPath = tableView.indexPathForSelectedRow else {
            return
        }
        
        if segue.identifier == "GuestID" {
            let guestvc = segue.destination as! GuestVC
            
            
            let id = arrData[indexPath.row].id
            let name = arrData[indexPath.row].name
            let image = arrData[indexPath.row].image
            let user_id = arrData[indexPath.row].user_id
            let posts = arrData[indexPath.row].posts
            let following = arrData[indexPath.row].following
            let followers = arrData[indexPath.row].followers
           
            
            // assigning values to the GuestPage
            guestvc.id = id
            guestvc.fullName = name
            guestvc.avaPath = image
            guestvc.user_id = user_id
            guestvc.posts_Count = posts
            guestvc.following_Count = following
            guestvc.followers_Count = followers
            
        }
        
        
        
        
        
    } // penutup function prepare
    

}


