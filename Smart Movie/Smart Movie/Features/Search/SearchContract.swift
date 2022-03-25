//
//  SearchContract.swift
//  Smart Movie
//
//  Created by Phuong on 14/03/2022.
//

import Foundation

protocol SearchContract {
    typealias Model = SearchModelProtocol
    typealias View = SearchViewProtocol
    typealias Presenter = SearchPresenterProtocol
}

protocol SearchModelProtocol {
    func fetchListMovies(query: String, result: @escaping (Result<ListMovieResponseEntity, Error>) -> Void)
    func fetchListgenres(result: @escaping (Result<ListGenresResponseEntity, Error>) -> Void)
}

protocol SearchViewProtocol: AnyObject {
    func showErrorMessage(_ message: String)
    func displayListMovie(_ listMovie: [MovieEntity])
    func refeshView()
}

protocol SearchPresenterProtocol {
    func viewDidAppear()
    func fetchListgenres()
    func fetchListSearch(query: String)
    func attach(view: SearchContract.View)
    func detachView()
    func getIDMovie(indexPath: IndexPath) -> Int
    func getNameGenre(id: Int) -> String
    func numberOfRowsInSection() -> Int
    func cellForRowAt(indexPath: IndexPath) -> MovieEntity
}
