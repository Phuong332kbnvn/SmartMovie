//
//  CastDetailModel.swift
//  Smart Movie
//
//  Created by Phuong on 26/04/2022.
//

import Foundation

final class CastDetailModel {
    private let listMoviesServices: ListMoviesServices = ListMoviesServices()
}

extension CastDetailModel: CastDetailModelProtocol {
    func fetchCastDetail(id: Int, result: @escaping (Result<CastDetailEntity, Error>) -> Void) {
        listMoviesServices.getCastDetail(id: id) { response in
            switch response {
            case .success(let entity):
                Logger.debug(entity)
                result(.success(entity))
            case .failure(let err):
                Logger.debug(err)
                result(.failure(err))
            }
        }
    }
    
    func fetchMovieOfCast(id: Int, result: @escaping (Result<MovieOfCastResponseEntity, Error>) -> Void) {
        listMoviesServices.getMovieOfCast(id: id) { response in
            switch response {
            case .success(let entity):
                Logger.debug(entity)
                result(.success(entity))
            case .failure(let err):
                Logger.debug(err)
                result(.failure(err))
            }
        }
    }
}
