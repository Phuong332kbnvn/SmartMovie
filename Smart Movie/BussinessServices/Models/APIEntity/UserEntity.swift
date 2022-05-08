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

// MARK: - Change Password
struct ChangePassword: Encodable {
    let oldPassword: String
    let newPassword: String
}

// MARK: - Response User Model
struct ResponseUserModel: Codable {
    let lastLogin: Int
    let created: Int
    let id: String
    let name, userToken: String
    let email: String

    enum CodingKeys: String, CodingKey {
        case lastLogin, created
        case id = "ownerId"
        case name
        case userToken = "user-token"
        case email
    }
}

// MARK: - Request Review Model
struct RequestReviewModel: Encodable {
    let idUser: String
    let idMovie: Int
    let userName: String
    let vote: Int?
    let content: String
    let time: String
}

// MARK: - Response Review Model
struct ResponseReviewModel: Codable {
    let idUser: String
    let idMovie: Int
    let created: Int
    let time: String
//    let avatar: Int?
    let userName: String
    let vote: Int
    let content: String

}

