//
//  NetworkServiceDefinations.swift
//  Smart Movie
//
//  Created by Phuong on 09/03/2022.
//

import Foundation

public enum HTTPMethod: String {
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
    case patch  = "PATCH"
    case delete = "DELETE"
}

public enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
    case apiVersion = "apiVersion"
}

public enum HTTPHeaderValue: String {
    case applicationJson = "application/json"
}

public enum APIError: Error {
    case encodeParamsFailed
    case decodeDataFailed
    case apiError1
    case apiError2
    case apiError3
}

// Example
public enum APIErrorCode: Int {
    case unknow = -1
    case apiError1 = 1_234
    case apiError2 = 1_235
    case apiError3 = 1_236
}

public enum NetworkServiceError: Error {
    case serverError
    case authenError
    case noData
    case encodeFailed
}

public typealias HTTPHeader = [String: String]

public struct RequestInfo {
    let urlInfo: URL
    let httpMethod: HTTPMethod
    let headers: HTTPHeader?
    
    init(urlInfo: URL, httpMethod: HTTPMethod, headers: HTTPHeader? = nil) {
        self.urlInfo = urlInfo
        self.httpMethod = httpMethod
        self.headers = headers
    }
}
