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
    let email: String
    let password: String
}
