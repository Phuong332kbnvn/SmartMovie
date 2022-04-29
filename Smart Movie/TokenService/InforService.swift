//
//  PasswordService.swift
//  Smart Movie
//
//  Created by Phuong on 29/04/2022.
//

import Foundation
import SwiftKeychainWrapper

class InforService {
    static let share = InforService()
    
    func savePassword(password: String) {
        KeychainWrapper.standard.set(password, forKey: passwordKey)
    }
    
    func getPassword() -> String {
        if let password = KeychainWrapper.standard.string(forKey: passwordKey) {
            return password
        } else {
            return ""
        }
    }
}
