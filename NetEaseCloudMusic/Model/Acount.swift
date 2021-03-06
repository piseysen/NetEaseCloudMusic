//
//  Acount.swift
//  NetEaseCloudMusic
//
//  Created by Dan.Lee on 2016/12/7.
//  Copyright © 2016年 Ampire_Dan. All rights reserved.
//

import Foundation
import RealmSwift

class LoginData: Object {
    dynamic var loginName: String?
    dynamic var loginPwd: String?
    dynamic var userID: Int = 0
    
    override static func primaryKey() -> String? {
        return "userID"
    }
}

class Level: Object {
    dynamic var userId: Int = 0
    dynamic var info: String?
    dynamic var progress: Double = 0
    dynamic var nextPlayCount: Int = 0
    dynamic var nextLoginCount: Int = 0
    dynamic var nowPlayCount: Int = 0
    dynamic var nowLoginCount: Int = 0
    dynamic var level: Int = 0
    dynamic var full: Bool = false
    
    override static func primaryKey() -> String? {
        return "userId"
    }
}

class AccountData: Object {
    dynamic var loginType: Int = 0
    dynamic var clientId: String?
    dynamic var effectTime: TimeInterval = 0
    dynamic var account: Account?
    dynamic var profile: Profile?
    dynamic var userID: Int = 0
    dynamic var isCurrentUser: Bool = false
    
    override static func primaryKey() -> String? {
        return "userID"
    }
}

class Account : Object {
    let belongTo = LinkingObjects(fromType: AccountData.self, property: "account")
    
    dynamic var anonimousUser : Bool = false
    dynamic var ban : Int = 0
    dynamic var baoyueVersion : Int = 0
    dynamic var createTime : Int = 0
    dynamic var donateVersion : Int = 0
    dynamic var id : Int = 0
    dynamic var salt : String = ""
    dynamic var status : Int = 0
    dynamic var tokenVersion : Int = 0
    dynamic var type : Int = 0
    dynamic var userName : String = ""
    dynamic var vipType : Int = 0
    dynamic var whitelistAuthority : Int = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class Profile : Object {
    let belongTo = LinkingObjects(fromType: AccountData.self, property: "profile")
    
    dynamic var accountStatus : Int = 0
    dynamic var authStatus : Int = 0
    dynamic var authority : Int = 0
    dynamic var avatarImgId : Int = 0
    dynamic var avatarImgIdStr : String = ""
    dynamic var avatarUrl : String = ""
    dynamic var backgroundImgId : Int = 0
    dynamic var backgroundImgIdStr : String = ""
    dynamic var backgroundUrl : String = ""
    dynamic var birthday : Int = 0
    dynamic var city : Int = 0
    dynamic var defaultAvatar : Bool = false
    dynamic var descriptionField : String = ""
    dynamic var detailDescription : String = ""
    dynamic var djStatus : Int = 0
//    dynamic var expertTags : AnyObject?
    dynamic var followed : Bool = false
    dynamic var gender : Int = 0
    dynamic var mutual : Bool = false
    dynamic var nickname : String = ""
    dynamic var province : Int = 0
//    dynamic var remarkName : AnyObject?
    dynamic var signature : String = ""
    dynamic var userId : Int = 0
    dynamic var userType : Int = 0
    dynamic var vipType : Int = 0
    
    override static func primaryKey() -> String? {
        return "userId"
    }
}
