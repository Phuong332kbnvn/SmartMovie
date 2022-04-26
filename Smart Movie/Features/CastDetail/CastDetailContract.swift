//
//  CastDetailContract.swift
//  Smart Movie
//
//  Created by Phuong on 26/04/2022.
//

import Foundation

protocol CastDetailContract {
    typealias Model = CastDetailModelProtocol
    typealias View = CastDetailViewProtocol
    typealias Presenter = CastDetailPresenterProtocol
}

protocol CastDetailPresenterProtocol {
    func viewDidLoad()
    func fetchCastDetail(idCast: Int)
    func fetchMovieOfCast(idCast: Int)
    func attach(view: CastDetailContract.View)
    func detachView()
    func numberOfItemsInSection() -> Int
    func cellForItemAt(indexPath: IndexPath) -> MovieOfCastEntity
    func getIDMovie(indexPath: IndexPath) -> Int
}

protocol CastDetailViewProtocol: AnyObject {
    func refreshView()
}

protocol CastDetailModelProtocol {
    func fetchCastDetail(id: Int, result: @escaping (Result<CastDetailEntity, Error>) -> Void)
    func fetchMovieOfCast(id: Int, result: @escaping (Result<MovieOfCastResponseEntity, Error>) -> Void)
}
