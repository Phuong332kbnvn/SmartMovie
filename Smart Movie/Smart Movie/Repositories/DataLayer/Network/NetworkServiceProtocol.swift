//
//  NetworkServiceProtocol.swift
//  Smart Movie
//
//  Created by Phuong on 09/03/2022.
//

import Foundation

protocol NetworkServiceProtocol {
//    func request(info: RequestInfo, result: @escaping (Result<Data, NetworkServiceError>) -> Void)
    func requestAPI<T: Codable>(info: RequestInfo, params: T, result: @escaping (Result<Data, NetworkServiceError>) -> Void)
}
