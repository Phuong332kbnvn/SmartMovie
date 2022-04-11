//
//  BaseAPIFetcher.swift
//  Smart Movie
//
//  Created by Phuong on 08/03/2022.
//

import Foundation

class BaseAPIFetcher {
    public let networkService: NetworkService
    
    init(networkService: NetworkService = NetworkService()) {
        self.networkService = networkService
    }
    
    func apiURL(_ apiParams: String? = nil) -> URL? {
        fatalError("API URL must be override in child class")
    }
    
    func decodeData<T: Decodable>(_ data: Data, type: T.Type) throws -> T {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        do {
            let response: T = try JSONDecoder().decode(T.self, from: data)
            return response
        } catch let error {
            Logger.debug(error)
            throw APIError.decodeDataFailed
        }
    }
    
    func addDefaultParams(_ params: HTTPHeader) -> HTTPHeader {
        var returnParams = params
        
        returnParams.updateValue(HTTPHeaderValue.applicationJson.rawValue, forKey: HTTPHeaderField.acceptType.rawValue)
        returnParams.updateValue(HTTPHeaderValue.applicationJson.rawValue, forKey: HTTPHeaderField.acceptEncoding.rawValue)

        return returnParams
    }
}
