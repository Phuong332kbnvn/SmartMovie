//
//  AlamofireNetworkService.swift
//  Smart Movie
//
//  Created by Phuong on 09/03/2022.
//

import Foundation
import Alamofire

struct AlamofireNetworkService {
    static func defaultSession() -> Session {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 60

        let session = Session(configuration: configuration)

        return session
    }
    
    private let sessionManager: Session

    init(with session: Session = defaultSession()) {
        sessionManager = session
    }
}

extension AlamofireNetworkService: NetworkServiceProtocol {
//    func request(info: RequestInfo, result: @escaping (Result<Data, NetworkServiceError>) -> Void) {
//
//    }
    
    func requestAPI<T>(info: RequestInfo, params: T, result: @escaping (Result<Data, NetworkServiceError>) -> Void) where T: Decodable, T: Encodable {
        let httpMethod: Alamofire.HTTPMethod = getHTTPMethod(info.httpMethod)
        
        var paramsEncoder: ParameterEncoder = JSONParameterEncoder.default
        
        if httpMethod == Alamofire.HTTPMethod.get {
            paramsEncoder = URLEncodedFormParameterEncoder.default
        }
                
        // Convert requestinfo.header into Alamofire header
        let afHeaders: Alamofire.HTTPHeaders? = convertHeaders(info.headers)
        
        sessionManager.request(info.urlInfo, method: httpMethod, parameters: params, encoder: paramsEncoder, headers: afHeaders)
//            .validate(statusCode: 200..<300)
            .response { (response) in
            Logger.server(response)
            switch response.result {
            case .success(let data):
                if let data = data {
                    result(.success(data))
                } else {
                    result(.failure(NetworkServiceError.noData))
                }
            case .failure(let error):
                Logger.debug(error)
                
                if let httpStatusCode = response.response?.statusCode, httpStatusCode == 401 {
                    result(.failure(NetworkServiceError.authenError))
                    return
                }
                
                result(.failure(NetworkServiceError.serverError))
            }
        }
    }
}

extension AlamofireNetworkService {
    private func getHTTPMethod(_ method: HTTPMethod) -> Alamofire.HTTPMethod {
        var returnMethod: Alamofire.HTTPMethod
        
        switch method {
        case .get:
            returnMethod = Alamofire.HTTPMethod.get
        case .post:
            returnMethod = Alamofire.HTTPMethod.post
        case .put:
            returnMethod = Alamofire.HTTPMethod.put
        case .patch:
            returnMethod = Alamofire.HTTPMethod.patch
        case .delete:
            returnMethod = Alamofire.HTTPMethod.delete
        }
        
        return returnMethod
    }
    
    private func convertHeaders(_ headers: HTTPHeader?) -> Alamofire.HTTPHeaders? {
        guard let headers: HTTPHeader = headers else {
            Logger.debug("Headers nil")
            return nil
        }
        
        return Alamofire.HTTPHeaders(headers)
    }
}
