//
//  TokenService.swift
//  Smart Movie
//
//  Created by Phuong on 15/04/2022.
//

import Foundation
import SwiftKeychainWrapper

class TokenService {
    static let share = TokenService()
    
    func saveToken(token: String) {
        KeychainWrapper.standard.set(token, forKey: tokenKey)
    }

    func getToken() -> String {
        if let token = KeychainWrapper.standard.string(forKey: tokenKey) {
            return token
        } else {
            return ""
        }
    }

    func checkForLogin() -> Bool {
        if getToken() == "" {
            return false
        } else {
            return true
        }
    }

    func removeToken() {
        KeychainWrapper.standard.removeObject(forKey: tokenKey)
    }
}
