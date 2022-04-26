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

// MARK: - Message
let successfulRegistrationMessage = "Successfully Registered a New Account. Please proceed to Sign in"
let failedRegistrationMessage = "Could not successfully perform this request. Please try again later"
let errorMessage = "Please try again"
let errorLoginMessage = "Email or password is incorrected"
let errorNetworkMessage = "Please check your network connectivity"


// MARK: - Key
let tokenKey = "tokenKey"


