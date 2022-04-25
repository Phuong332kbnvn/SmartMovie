//
//  ReviewModel.swift
//  Smart Movie
//
//  Created by Phuong on 24/04/2022.
//

import Foundation

final class ReviewModel {
    private let listMoviesServices: ListMoviesServices = ListMoviesServices()
}

extension ReviewModel: ReviewModelProtocol {
    func fetchReview(id: Int, result: @escaping (Result<ReviewResponseEntity, Error>) -> Void) {
        listMoviesServices.getReview(id: id) { [weak self] response in
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
