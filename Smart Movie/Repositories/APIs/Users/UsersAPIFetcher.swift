//
//  UserAPIFetcher.swift
//  Smart Movie
//
//  Created by Phuong on 12/04/2022.
//

import Foundation
import Alamofire

protocol UsersAPIFetcherProtocol {
    func fetchRegister(user: RegisterModel, completionHandler: @escaping (Bool) ->())
//    func fetchLogin(user: LoginModel, completionHandler: @escaping (Bool) ->())
}

class UsersAPIFetcher {
    static let share = UsersAPIFetcher()
}

extension UsersAPIFetcher: UsersAPIFetcherProtocol {
    func fetchRegister(user: RegisterModel, completionHandler: @escaping (Bool) -> ()) {
        let header: HTTPHeaders = [
            .contentType("application/json")
        ]
        
        AF.request(register_url, method: .post, parameters: user, encoder: JSONParameterEncoder.default, headers: header).response { response in
            debugPrint(response)
            switch response.result {
            case .success(let data):
                guard let data = data else {
                    return
                }
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                    if response.response?.statusCode == 200 {
                        completionHandler(true)
                    } else {
                        completionHandler(false)
                    }
                } catch {
                    print(error.localizedDescription)
                    completionHandler(false)
                }
            case .failure(let err):
                print(err.localizedDescription)
                completionHandler(false)
            }
        }
    }
    
//    func fetchLogin(user: LoginModel, completionHandler: @escaping (Bool) -> ()) {
//        <#code#>
//    }
}
