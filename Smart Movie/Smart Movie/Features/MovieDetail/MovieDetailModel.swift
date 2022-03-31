//
//  MovieDetailModel.swift
//  Smart Movie
//
//  Created by Phuong on 16/03/2022.
//

import Foundation

final class MovieDetailModel {
    // Convert to dependencies injection
    private let listMoviesServices: ListMoviesServices = ListMoviesServices()
}

extension MovieDetailModel: MovieDetailModelProtocol {
    
    func fetchMovieDetail(id: Int, result: @escaping (Result<MovieDetailEntity, Error>) -> Void) {
        listMoviesServices.getMovieDetail(id: id) { [weak self] response in
            switch response {
            case .success(let entity):
                Logger.debug(entity)
                result(.success(entity))
            case . failure(let error):
                Logger.debug(error)
                result(.failure(error))
            }
        }
    }
    
    func fetchListCasts(id: Int, result: @escaping (Result<ListCastsResponseEntity, Error>) -> Void) {
        listMoviesServices.getListCasts(id: id) { [weak self] response in
            switch response {
            case .success(let entity):
                Logger.debug(entity)
                result(.success(entity))
            case . failure(let error):
                Logger.debug(error)
                result(.failure(error))
            }
        }
    }
    
    func fetchListSimilars(id: Int, result: @escaping (Result<ListMovieResponseEntity, Error>) -> Void) {
        listMoviesServices.getListSimilars(id: id) { [weak self] response in
            switch response {
            case .success(let entity):
                Logger.debug(entity)
                result(.success(entity))
            case . failure(let error):
                Logger.debug(error)
                result(.failure(error))
            }
        }
    }
    
    func fetchTrailer(id: Int, result: @escaping (Result<TrailerResponseEntity, Error>) -> Void) {
        listMoviesServices.getTrailer(id: id) { [weak self] response in
            switch response {
            case .success(let entity):
                Logger.debug(entity)
                result(.success(entity))
            case . failure(let error):
                Logger.debug(error)
                result(.failure(error))
            }
        }
    }
    
    func fetchCastDetail(id: Int, result: @escaping (Result<CastDetailEntity, Error>) -> Void) {
        listMoviesServices.getCastDetail(id: id) { [weak self] response in
            switch response {
            case .success(let entity):
                Logger.debug(entity)
                result(.success(entity))
            case . failure(let error):
                Logger.debug(error)
                result(.failure(error))
            }
        }
    }
    
}
