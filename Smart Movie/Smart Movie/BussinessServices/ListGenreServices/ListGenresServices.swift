//
//  ListGenresServices.swift
//  Smart Movie
//
//  Created by Phuong on 15/03/2022.
//

import Foundation

protocol ListGenresServicesProtocol {
    func getListGenres(result: @escaping (Result<ListGenresResponseEntity, Error>) -> Void)
    func getGenreDetail(id : Int, result: @escaping (Result<ListMovieResponseEntity, Error>) -> Void)
}

final class ListGenresServices {
    private let listGenresAPIFetcher: ListMoviesAPIFetcherProtocol!
    
    // Dependency injection
    init(_ apiFetcher: ListMoviesAPIFetcherProtocol = ListMoviesAPIFetcher()) {
        listGenresAPIFetcher = apiFetcher
    }
}

extension ListGenresServices: ListGenresServicesProtocol {
    func getListGenres(result: @escaping (Result<ListGenresResponseEntity, Error>) -> Void) {
        listGenresAPIFetcher.fetchListGenres { [weak self] response in
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
    
    func getGenreDetail(id: Int, result: @escaping (Result<ListMovieResponseEntity, Error>) -> Void) {
        listGenresAPIFetcher.fetchGenresDetail(id: id) { [weak self] response in
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
}
