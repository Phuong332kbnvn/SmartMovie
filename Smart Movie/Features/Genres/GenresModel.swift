//
//  GenresModel.swift
//  Smart Movie
//
//  Created by Phuong on 14/03/2022.
//

import Foundation

final class GenresModel {
    // Convert to dependencies injection
    private let listGenresServices: ListGenresServices = ListGenresServices()
}

extension GenresModel: GenresModelProtocol {

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

    func fetchGenreDetail(id: Int, result: @escaping (Result<ListMovieResponseEntity, Error>) -> Void) {
        listGenresServices.getGenreDetail(id: id) { [weak self] response in
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
