//
//  SearchModel.swift
//  Smart Movie
//
//  Created by Phuong on 14/03/2022.
//

import Foundation

final class SearchModel {
    // Convert to dependencies injection
    private let listMovieServices: ListMoviesServices = ListMoviesServices()
    private let listGenresServices: ListGenresServices = ListGenresServices()
}

extension SearchModel: SearchModelProtocol {
    func fetchListgenres(result: @escaping (Result<ListGenresResponseEntity, Error>) -> Void) {
        listGenresServices.getListGenres { [weak self] response in
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

    func fetchListMovies(query: String, result: @escaping (Result<ListMovieResponseEntity, Error>) -> Void) {
        listMovieServices.getListMoviesIsSearched(query: query) { [weak self] response in
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
