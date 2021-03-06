//
//  DiscoverModel.swift
//  Smart Movie
//
//  Created by Phuong on 08/03/2022.
//

import Foundation

struct DiscoverViewEntity {
    
}

final class DiscoverModel {
    // Convert to dependencies injection
    private let listMovieServices: ListMoviesServices = ListMoviesServices()
    
}

extension DiscoverModel: DiscoverModelProtocol {
    
    func fetchListPopularMovies() -> [MovieEntity]? {
        return nil
    }
    
    func fetchListPopularMovies(page: Int, result: @escaping (Result<ListMovieResponseEntity, Error>) -> Void) {
        listMovieServices.getListMovies(type: MovieType.popular.rawValue, page: page) { response in
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
    
    func fetchListTopRatedMovies(page: Int, result: @escaping (Result<ListMovieResponseEntity, Error>) -> Void) {
        listMovieServices.getListMovies(type: MovieType.topRate.rawValue, page: page) { response in
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

    func fetchListUpcommingMovies(page: Int, result: @escaping (Result<ListMovieResponseEntity, Error>) -> Void) {
        listMovieServices.getListMovies(type: MovieType.upcomming.rawValue, page: page) { response in
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
    // Asyn
    func fetchListNowPlayingMovies(page: Int, result: @escaping (Result<ListMovieResponseEntity, Error>) -> Void) {
        listMovieServices.getListMovies(type: MovieType.nowPlaying.rawValue, page: page) { response in
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
   
    func fetchMovieDetail(id: Int, result: @escaping (Result<MovieDetailEntity, Error>) -> Void) {
        listMovieServices.getMovieDetail(id: id) { response in
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
