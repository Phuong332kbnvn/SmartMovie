//
//  Constant.swift
//  Smart Movie
//
//  Created by Phuong on 12/04/2022.
//

import Foundation

//MARK: - Themoviedb
let apiKey = "d5b97a6fad46348136d87b78895a0c06"

//MARK: - Backendless
let subdomain = "api.backendless.com"
let app_id = "3492EC0C-2CE6-806E-FF11-CD4FA856AA00"
let api_key = "6D02E696-49FD-4F03-B313-4C566A0687CD"
let base_url = "https://\(subdomain)/\(app_id)/\(api_key)/users/"
let register_url = "\(base_url)register"
let login_url = "\(base_url)login"
let logout_url = "\(base_url)logout"
let changePassword_url = "https://stoutterritory.backendless.app/api/services/UserServices/changePassword"

// MARK: - Message
let successfulRegistrationMessage = "Register new account successfully. Please proceed to Sign in"
let successfulChangePasswordMessage = "Change password successfully"

let failedRegistrationMessage = "Could not successfully perform this request. Please try again later"
let failedChangePasawordMessage = "Could not successfully perform this request. Please try again later"

let errorMessage = "Please try again"
let errorLoginMessage = "Email or password is incorrected"
let errorNetworkMessage = "Please check your network connectivity"


// MARK: - Key
let tokenKey = "tokenKey"
let passwordKey = "passwordKey"
let idUser = "idUser"
let emailUser = "emailUser"
let fullnameUser = "fullnameUser"


