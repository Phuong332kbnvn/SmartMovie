//
//  UserAPIFetcher.swift
//  Smart Movie
//
//  Created by Phuong on 12/04/2022.
//

import Foundation
import Alamofire

enum APIErrors: Error {
    case custom(message: String)
}

typealias Handler = (Swift.Result<Any?, APIErrors>) -> Void

protocol UsersAPIFetcherProtocol {
    func fetchRegister(user: RegisterModel, completionHandler: @escaping (Bool) ->())
    func fetchLogin(user: LoginModel, completionHandler: @escaping Handler)
    func fetchLogout()
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
    
    func fetchLogin(user: LoginModel, completionHandler: @escaping Handler) {
        let header: HTTPHeaders = [
            .contentType("application/json")
        ]
        
        AF.request(login_url, method: .post, parameters: user, encoder: JSONParameterEncoder.default, headers: header).response { response in
            debugPrint(response)
            switch response.result {
            case .success(let data):
                guard let data = data else {
                    return
                }
                do {
                    let json = try JSONDecoder().decode(ResponseUserModel.self, from: data)
                    print(json)
                    if response.response?.statusCode == 200 {
                        completionHandler(.success(json))
                    } else {
                        completionHandler(.failure(.custom(message: errorNetworkMessage)))
                    }
                } catch {
                    print(error.localizedDescription)
                    completionHandler(.failure(.custom(message: errorMessage)))
                }
            case .failure(let err):
                print(err.localizedDescription)
                completionHandler(.failure(.custom(message: errorMessage)))
            }
        }
    }
    
    func fetchLogout() {
        let header: HTTPHeaders = [
            "user-token": "\(TokenService.share.getToken())"
        ]
        AF.request(logout_url, method: .get, headers: header).response { response in
            switch response.result {
            case .success(let data):
                TokenService.share.removeToken()
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    func fetchChangePassword(user: ChangePassword, completionHandler: @escaping (Bool) -> ()) {
        let header: HTTPHeaders = [
            "Content-Type" : "application/json",
            "Accept" : "application/json",
            "user-token": "\(TokenService.share.getToken())"
        ]
        
        AF.request(changePassword_url, method: .post, parameters: user, encoder: JSONParameterEncoder.default, headers: header).response { response in
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
}
