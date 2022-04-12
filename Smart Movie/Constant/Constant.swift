//
//  Constant.swift
//  Smart Movie
//
//  Created by Phuong on 12/04/2022.
//

import Foundation

let subdomain = "api.backendless.com"
let app_id = "3492EC0C-2CE6-806E-FF11-CD4FA856AA00"
let api_key = "6D02E696-49FD-4F03-B313-4C566A0687CD"
let base_url = "https://\(subdomain)/\(app_id)/\(api_key)/users"
let register_url = "\(base_url)/register"
let login_url = "\(base_url)/login"
let logout_url = "\(base_url)/logout"

let successfulRegistrationMessage = "Successfully Registered a New Account. Please proceed to Sign in"
let failedRegistrationMessage = "Could not successfully perform this request. Please try again later"
