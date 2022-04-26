//
//  ListMoviesServices.swift
//  Smart Movie
//
//  Created by Phuong on 08/03/2022.
//

import Foundation

protocol ListMoviesServicesProtocol {
    func getListMovies(type: String, page: Int, result: @escaping (Result<ListMovieResponseEntity, Error>) -> Void)
    func getListMoviesIsSearched(query: String, result: @escaping (Result<ListMovieResponseEntity, Error>) -> Void)
    func getMovieDetail(id: Int, result: @escaping (Result<MovieDetailEntity, Error>) -> Void)
    func getListCasts(id: Int, result: @escaping (Result<ListCastsResponseEntity, Error>) -> Void)
    func getListSimilars(id: Int, result: @escaping (Result<ListMovieResponseEntity, Error>) -> Void)
    func getTrailer(id: Int, result: @escaping (Result<TrailerResponseEntity, Error>) -> Void)
    func getCastDetail(id: Int, result: @escaping (Result<CastDetailEntity, Error>) -> Void)
    func getReview(id: Int, result: @escaping (Result<ReviewResponseEntity, Error>) -> Void)
    func getMovieOfCast(id: Int, result: @escaping (Result<MovieOfCastResponseEntity, Error>) -> Void)
}

final class ListMoviesServices {
    // POP Protocol oriented
    private let listMovieAPIFetcher: ListMoviesAPIFetcherProtocol!
    
    // Dependency injection
    init(_ apiFetcher: ListMoviesAPIFetcherProtocol = ListMoviesAPIFetcher()) {
        listMovieAPIFetcher = apiFetcher
    }
}

extension ListMoviesServices: ListMoviesServicesProtocol {
    
    func getListMovies(type: String, page: Int, result: @escaping (Result<ListMovieResponseEntity, Error>) -> Void) {
        listMovieAPIFetcher.fetchListMovies(type: type, page: page) { response in
            switch response {
            case .success(let entity):
                Logger.debug(entity)
                result(.success(entity))
            case .failure(let error):
                Logger.debug(error)
                result(.failure(error))
            }
        }
    }
    
    func getListMoviesIsSearched(query: String, result: @escaping (Result<ListMovieResponseEntity, Error>) -> Void) {
        listMovieAPIFetcher.fetchListMoviesSearch(query: query) { response in
            switch response {
            case .success(let entity):
                Logger.debug(entity)
                result(.success(entity))
            case .failure(let error):
                Logger.debug(error)
                result(.failure(error))
            }
        }
    }
    
    func getMovieDetail(id: Int, result: @escaping (Result<MovieDetailEntity, Error>) -> Void) {
        listMovieAPIFetcher.fetchMovieDetail(id: id) { response in
            switch response {
            case .success(let entity):
                Logger.debug(entity)
                result(.success(entity))
            case .failure(let error):
                Logger.debug(error)
                result(.failure(error))
            }
        }
    }
    
    func getListCasts(id: Int, result: @escaping (Result<ListCastsResponseEntity, Error>) -> Void) {
        listMovieAPIFetcher.fetchListCasts(id: id) { response in
            switch response {
            case .success(let entity):
                Logger.debug(entity)
                result(.success(entity))
            case .failure(let error):
                Logger.debug(error)
                result(.failure(error))
            }
        }
    }
    
    func getListSimilars(id: Int, result: @escaping (Result<ListMovieResponseEntity, Error>) -> Void) {
        listMovieAPIFetcher.fetchListSimilars(id: id) { response in
            switch response {
            case .success(let entity):
                Logger.debug(entity)
                result(.success(entity))
            case .failure(let error):
                Logger.debug(error)
                result(.failure(error))
            }
        }
    }
    
    func getTrailer(id: Int, result: @escaping (Result<TrailerResponseEntity, Error>) -> Void) {
        listMovieAPIFetcher.fetchTrailer(id: id) { response in
            switch response {
            case .success(let entity):
                Logger.debug(entity)
                result(.success(entity))
            case .failure(let error):
                Logger.debug(error)
                result(.failure(error))
            }
        }
    }
    
    func getCastDetail(id: Int, result: @escaping (Result<CastDetailEntity, Error>) -> Void) {
        listMovieAPIFetcher.fetchCastDetail(id: id) { response in
            switch response {
            case .success(let entity):
                Logger.debug(entity)
                result(.success(entity))
            case .failure(let error):
                Logger.debug(error)
                result(.failure(error))
            }
        }
    }
    
    func getReview(id: Int, result: @escaping (Result<ReviewResponseEntity, Error>) -> Void) {
        listMovieAPIFetcher.fetchReview(id: id) { response in
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
    
    func getMovieOfCast(id: Int, result: @escaping (Result<MovieOfCastResponseEntity, Error>) -> Void) {
        listMovieAPIFetcher.fetchMovieOfCast(id: id) { response in
            switch response {
            case . success(let entity):
                Logger.debug(entity)
                result(.success(entity))
            case .failure(let err):
                Logger.debug(err)
                result(.failure(err))
            }
        }
    }
}
