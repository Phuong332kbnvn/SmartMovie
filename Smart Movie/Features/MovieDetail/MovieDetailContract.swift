//
//  MovieDetailContract.swift
//  Smart Movie
//
//  Created by Phuong on 16/03/2022.
//

import Foundation

protocol MovieDetailContract {
    typealias Model = MovieDetailModelProtocol
    typealias View = MovieDetailViewProtocol
    typealias Presenter = MovieDetailPresenterProtocol
}

protocol MovieDetailModelProtocol {
    func fetchMovieDetail(id: Int, result: @escaping (Result<MovieDetailEntity, Error>) -> Void)
    func fetchListCasts(id: Int, result: @escaping (Result<ListCastsResponseEntity, Error>) -> Void)
    func fetchListSimilars(id: Int, result: @escaping (Result<ListMovieResponseEntity, Error>) -> Void)
    func fetchTrailer(id: Int, result: @escaping (Result<TrailerResponseEntity, Error>) -> Void)
    func fetchCastDetail(id: Int, result: @escaping (Result<CastDetailEntity, Error>) -> Void)
}

protocol MovieDetailViewProtocol: AnyObject {
    func showErrorMessage(_ message: String)
    func displayListMovie(_ movieDetail: MovieDetailEntity)
    func refeshView()
}

protocol MovieDetailPresenterProtocol {
    func viewDidAppear()
    func fetchMovieDetail(id: Int)
    func fetchTrailer(id: Int)
    func fetchListCasts(id: Int)
    func fetchListSimilar(id: Int)
    func fetchCastDetail(idCast: Int)
    func attach(view: MovieDetailContract.View)
    func detachView()
    func numberOfRowsInSection() -> Int
    func cellForRowAt(indexPath: IndexPath) -> MovieEntity
    func numberOfRowsInCasts() -> Int
    func cellForRowCastAt(indexPath: IndexPath) -> [CastEntity]
    func getIDMovie(indexPath: IndexPath) -> Int
    func getIDCast(indexPath: IndexPath) -> Int
}
