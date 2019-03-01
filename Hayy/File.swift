//
//  File.swift
//  Hayy
//
//  Created by Herlangga Wibi Yandi Nasution on 27/01/19.
//  Copyright © 2019 PT. Buana Kebenaran Informatika. All rights reserved.
//

import Foundation
struct Json4Swift_Base : Codable {
    let id : Int?
    let user_id : String?
    let name : String?
    let email : String?
    let image : String?
    let gender : String?
    let fcm_registration_id : String?
    let notification_on_like : Bool?
    let notification_on_dislike : Bool?
    let notification_on_comment : Bool?
    let is_admin : Int?
    let is_paid : Int?
    let created_at : String?
    let updated_at : String?
    let subscribing : Int?
    let type : Int?
    let status : Int?
    let phone : String?
    let posts_count : Int?
    let like_count : Int?
    let dislike_count : Int?
    let comment_count : Int?
    let is_following : Int?
    let following_count : Int?
    let followers_count : Int?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case user_id = "user_id"
        case name = "name"
        case email = "email"
        case image = "image"
        case gender = "gender"
        case fcm_registration_id = "fcm_registration_id"
        case notification_on_like = "notification_on_like"
        case notification_on_dislike = "notification_on_dislike"
        case notification_on_comment = "notification_on_comment"
        case is_admin = "is_admin"
        case is_paid = "is_paid"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case subscribing = "subscribing"
        case type = "type"
        case status = "status"
        case phone = "phone"
        case posts_count = "posts_count"
        case like_count = "like_count"
        case dislike_count = "dislike_count"
        case comment_count = "comment_count"
        case is_following = "is_following"
        case following_count = "following_count"
        case followers_count = "followers_count"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        gender = try values.decodeIfPresent(String.self, forKey: .gender)
        fcm_registration_id = try values.decodeIfPresent(String.self, forKey: .fcm_registration_id)
        notification_on_like = try values.decodeIfPresent(Bool.self, forKey: .notification_on_like)
        notification_on_dislike = try values.decodeIfPresent(Bool.self, forKey: .notification_on_dislike)
        notification_on_comment = try values.decodeIfPresent(Bool.self, forKey: .notification_on_comment)
        is_admin = try values.decodeIfPresent(Int.self, forKey: .is_admin)
        is_paid = try values.decodeIfPresent(Int.self, forKey: .is_paid)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        subscribing = try values.decodeIfPresent(Int.self, forKey: .subscribing)
        type = try values.decodeIfPresent(Int.self, forKey: .type)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        posts_count = try values.decodeIfPresent(Int.self, forKey: .posts_count)
        like_count = try values.decodeIfPresent(Int.self, forKey: .like_count)
        dislike_count = try values.decodeIfPresent(Int.self, forKey: .dislike_count)
        comment_count = try values.decodeIfPresent(Int.self, forKey: .comment_count)
        is_following = try values.decodeIfPresent(Int.self, forKey: .is_following)
        following_count = try values.decodeIfPresent(Int.self, forKey: .following_count)
        followers_count = try values.decodeIfPresent(Int.self, forKey: .followers_count)
    }
    
}

