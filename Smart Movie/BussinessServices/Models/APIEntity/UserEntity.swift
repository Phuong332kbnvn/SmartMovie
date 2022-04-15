//
//  UserEntity.swift
//  Smart Movie
//
//  Created by Phuong on 12/04/2022.
//

import Foundation

// MARK: - Register Model
struct RegisterModel: Encodable {
    let name: String
    let email: String
    let password: String
}

// MARK: - Login Model
struct LoginModel: Encodable {
    let login: String
    let password: String
}

// MARK: - Response User Model
struct ResponseUserModel: Codable {
    let lastLogin: Int
    let userStatus: String
    let created: Int
    let accountType, ownerID, socialAccount: String
    let name, welcomeClass, blUserLocale, userToken: String
    let email, objectID: String

    enum CodingKeys: String, CodingKey {
        case lastLogin, userStatus, created, accountType
        case ownerID = "ownerId"
        case socialAccount, name
        case welcomeClass = "___class"
        case blUserLocale
        case userToken = "user-token"
        case email
        case objectID = "objectId"
    }
}
