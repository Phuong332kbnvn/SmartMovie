//
//  ListMovieModel.swift
//  Smart Movie
//
//  Created by Phuong on 25/04/2022.
//

import Foundation

final class ListMovieModel {
    private let listMovie: ListMoviesServices = ListMoviesServices()
}

extension ListMovieModel: ListMovieModelProtocol {
    func fetchMovie(id: Int, result: @escaping (Result<MovieDetailEntity, Error>) -> Void) {
        listMovie.getMovieDetail(id: id, result: { [weak self] response in
            switch response {
            case .success(let entity):
                Logger.debug(entity)
                result(.success(entity))
            case .failure(let err):
                Logger.debug(err)
                result(.failure(err))
            }
        })
    }
}
