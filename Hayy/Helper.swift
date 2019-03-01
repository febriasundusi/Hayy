//
//  Helper.swift
//  Hayy
//
//  Created by Herlangga Wibi Yandi Nasution on 26/01/19.
//  Copyright © 2019 PT. Buana Kebenaran Informatika. All rights reserved.
//

import UIKit

class Helper {
    
    
    func showAlert(title: String, message: String, in vc: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let oke = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
        
        alert.addAction(oke)
        vc.present(alert, animated: true, completion: nil)
    }
    

func instantiateViewController(name: String, identifier: String, animate: Bool, in vc: UIViewController, completion: @escaping (() -> Void)){
    
    let iVC = UIStoryboard(name: name, bundle: nil).instantiateViewController(withIdentifier: identifier)
    vc.present(iVC, animated: animate, completion: completion)
}
    
    
func downloadImage(from path: String, showIn imageView: UIImageView, orShow placeholder: String) {
        
        // if avaPath string is having a valid url, IT'S NOT EMPTY (e.g. if ava isn't assigned, than in DB the link is stored as blank string)
        if String(describing: path).isEmpty == false {
            DispatchQueue.main.async {
                
                // converting url string to the valid URL
                if let url = URL(string: path) {
                    
                    // downloading all data from the URL
                    guard let data = try? Data(contentsOf: url) else {
                        imageView.image = UIImage(named: placeholder)
                        return
                    }
                    
                    // converting donwloaded data to the image
                    guard let image = UIImage(data: data) else {
                        imageView.image = UIImage(named: placeholder)
                        return
                    }
                    
                    // assigning image to the imageView
                    imageView.image = image
                    
                }
            }
        }
    } // penutup fungsi downloadImage
    


    
    func loadUser(fullName:UILabel, avatar: UIImageView){
        
        guard let id = data_user?["id"] else {return}
        
        
        let url = URL(string: "https://hayy-226108.appspot.com/api/profile/get")!
        let body = "user_id=\(String(describing: id))"
        
        
        
        var request = URLRequest(url: url)
        request.httpBody = body.data(using: .utf8)
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            DispatchQueue.main.async {
               
            
            let response = response as? HTTPURLResponse
            
            
            if response?.statusCode != 200 {
                print("status response data JSON :\(String(describing: response?.statusCode))")
            }
                
            else {
                
                do{
                    let dataJSON = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary
                    
                    guard let result = dataJSON else {
                        return
                    }
                    
                    
                    fullName.text = result["name"] as? String
                    
                    let imageUrl = result["image"] as? String
                    
                    if imageUrl != "-"
                    {
                        avatar.kf.setImage(with: URL(string: imageUrl!))
                    }
                    else{
                        avatar.image = UIImage(named: "user.png")
                    }
                    
                    
                    
                }
                catch {
                    return
                }
                
                
            }
            }
            
            }.resume()
        
        
    }
    
    
    
    func createPost(title: String, text: String, type: String, media_url: String, status: Int, method: String){
        let url = URL(string: "https://hayy-226108.appspot.com/api/posts")!
        let token = "9D55D308E01806EF0227CF5A3AC90F4E"
        guard let user_id = data_user?["user_Id"] else {return}
        let title = title
        let text = text
        let fixedURL = media_url
        let type = type
        let user_profile_id = 16
        let status = status
        let method = method
        
        
        
        let body = "token=\(token)&user_id=\(String(describing: user_id))&title=\(title)&text=\(text)&media_url=\(fixedURL)&type=\(type)&user_profile_id=\(user_profile_id)&status=\(status)"
        
        var request = URLRequest(url: url)
        request.httpBody = body.data(using: .utf8)
        request.httpMethod = method
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            let response = response as? HTTPURLResponse
            
            guard let data = data else {
                return
            }
            
            if response?.statusCode != 200  {
                print("status response saat posting: \(String(describing: response?.statusCode)) ")
            }
            else {
                if data.isEmpty {
                    print("Gagal Posting")
                }
                else {
                    print("Berhasil Posting")
                        
                }
            }
            
        }.resume()
        
        
    }
    
    
    
} //penutup Class Helper


//
//  Helper.swift
//  FaceBook
//
//  Created by MacBook Pro on 3/17/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

//import UIKit



//class Helper {
//
//
//    // colors
//    var facebookColor = UIColor(red: 65/255, green: 89/255, blue: 147/255, alpha: 1)
//
//
//    // validate email address function / logic
//    func isValid(email: String) -> Bool {
//
//        // declaring the rule of regular expression (chars to be used). Applying the rele to current state. Verifying the result (email = rule)
//        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
//        let test = NSPredicate(format: "SELF MATCHES %@", regex)
//        let result = test.evaluate(with: email)
//
//        return result
//    }
//
//
//    // validate name function / logic
//    func isValid(name: String) -> Bool {
//
//        // declaring the rule of regular expression (chars to be used). Applying the rele to current state. Verifying the result (email = rule)
//        let regex = "[A-Za-z]{2,}"
//        let test = NSPredicate(format: "SELF MATCHES %@", regex)
//        let result = test.evaluate(with: name)
//
//        return result
//    }
//
//
//    // show alert message to the user
//    func showAlert(title: String, message: String, in vc: UIViewController) {
//
//        // creating alertController; creating button to the alertController; assigning button to alertController; presenting alert controller
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
//        alert.addAction(ok)
//        vc.present(alert, animated: true, completion: nil)
//
//    }
//
//
//    // allows us to go to another ViewController programmatically
//    func instantiateViewController(identifier: String, animated: Bool, by vc: UIViewController, completion: (() -> Void)?) {
//
//        // accessing any ViewController from Main.storyboard via ID
//        let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
//
//        // presenting accessed ViewController
//        vc.present(newViewController, animated: animated, completion: completion)
//
//    }
//
//
//    // MIME for the Image
//    func body(with parameters: [String: Any]?, filename: String, filePathKey: String?, imageDataKey: Data, boundary: String) -> NSData {
//
//        let body = NSMutableData()
//
//        // MIME Type for Parameters [id: 777, name: michael]
//        if parameters != nil {
//            for (key, value) in parameters! {
//                body.append(Data("--\(boundary)\r\n".utf8))
//                body.append(Data("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".utf8))
//                body.append(Data("\(value)\r\n".utf8))
//            }
//        }
//
//
//        // MIME Type for Image
//        let mimetype = "image/jpg"
//
//        body.append(Data("--\(boundary)\r\n".utf8))
//        body.append(Data("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n".utf8))
//        body.append(Data("Content-Type: \(mimetype)\r\n\r\n".utf8))
//
//        body.append(imageDataKey)
//        body.append(Data("\r\n".utf8))
//        body.append(Data("--\(boundary)--\r\n".utf8))
//
//        return body
//    }
//
//
//    // allows us to download the image from certain url string
//    func downloadImage(from path: String, showIn imageView: UIImageView, orShow placeholder: String) {
//
//        // if avaPath string is having a valid url, IT'S NOT EMPTY (e.g. if ava isn't assigned, than in DB the link is stored as blank string)
//        if String(describing: path).isEmpty == false {
//            DispatchQueue.main.async {
//
//                // converting url string to the valid URL
//                if let url = URL(string: path) {
//
//                    // downloading all data from the URL
//                    guard let data = try? Data(contentsOf: url) else {
//                        imageView.image = UIImage(named: placeholder)
//                        return
//                    }
//
//                    // converting donwloaded data to the image
//                    guard let image = UIImage(data: data) else {
//                        imageView.image = UIImage(named: placeholder)
//                        return
//                    }
//
//                    // assigning image to the imageView
//                    imageView.image = image
//
//                }
//            }
//        }
//    }
//
//
//    // configure appearance of the fullname & fullname label
//    func loadFullname(firstName: String, lastName: String, showIn label: UILabel) {
//        DispatchQueue.main.async {
//            label.text = "\(firstName.capitalized) \(lastName.capitalized)"
//        }
//    }
//
//
//    // sends HTTP requests and return JSON results
//    func sendHTTPRequest(url: String, body: String, success: @escaping () -> Void, failure: @escaping () -> Void) -> NSDictionary {
//
//        // var to be returned
//        var result = NSDictionary()
//
//        // prerparing request
//        let url = URL(string: url)!
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.httpBody = body.data(using: .utf8)
//
//        // send request
//        URLSession.shared.dataTask(with: request) { (data, response, error) in
//            DispatchQueue.main.async {
//
//                // errors
//                if error != nil {
//                    failure()
//                    return
//                }
//
//                do {
//                    // casting data received from the server
//                    guard let data = data else {
//                        failure()
//                        return
//                    }
//
//                    // casting json from data
//                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary
//
//                    // safe mode of accessing json
//                    guard let parsedJSON = json else {
//                        failure()
//                        return
//                    }
//
//                    // completionHandler. This can be customized whenever this func is called from any other swift classes / files
//                    if parsedJSON["status"] as! String == "200" {
//                        success()
//                    } else {
//                        failure()
//                    }
//
//                    // assigning json data to the result var to be returned with the func
//                    result = parsedJSON
//
//                } catch {
//                    failure()
//                    return
//                }
//
//            }
//            }.resume()
//
//        // reutrning json
//        return result
//
//    }
//
//
//
//
//}
//
//
//
//
//
//
//
//
//
//
//
//
