//
//  NetworkService.swift
//  Smart Movie
//
//  Created by Phuong on 09/03/2022.
//

import Foundation
import Alamofire

struct NetworkService {
    public enum NetworkServicesType {
        case Alamofire
        case URLSession
    }
    
    private let networkService: NetworkServiceProtocol
    
    init(_ networkService: NetworkServiceProtocol = AlamofireNetworkService()) {
        self.networkService = networkService
//        If wanna use json mock data. use mock data services
//        self.networkService = MockServerNetworkService()
    }
}

extension NetworkService: NetworkServiceProtocol {
//    func request(info: RequestInfo, result: @escaping (Result<Data, NetworkServiceError>) -> Void) {
//
//    }
//
    func requestAPI<T>(info: RequestInfo, params: T, result: @escaping (Result<Data, NetworkServiceError>) -> Void) where T: Decodable, T: Encodable {
        networkService.requestAPI(info: info, params: params, result: result)
    }
}
