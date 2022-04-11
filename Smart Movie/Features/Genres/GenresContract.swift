//
//  GenresContract.swift
//  Smart Movie
//
//  Created by Phuong on 14/03/2022.
//

import Foundation

protocol GenresContract {
    typealias Model = GenresModelProtocol
    typealias View = GenresViewProtocol
    typealias Presenter = GenresPresenterProtocol
}

protocol GenresModelProtocol {
    func fetchListgenres(result: @escaping (Result<ListGenresResponseEntity, Error>) -> Void)
    func fetchGenreDetail(id: Int, result: @escaping (Result<ListMovieResponseEntity, Error>) -> Void)
}

protocol GenresViewProtocol: AnyObject {
    func showErrorMessage(_ message: String)
    func displayListGenres(_ listGenres: [GenreEntity])
    func refeshView()
}

protocol GenresPresenterProtocol {
    func viewDidAppear()
    func fetchListgenres()
    func fetchGenreDetail(id: Int)
    func attach(view: GenresContract.View)
    func detachView()
    func numberOfRowsInSection(section: Int) -> Int
    func cellForRowAt(indexPath: IndexPath) -> GenreEntity
    func numberOfRowsDetail(section: Int) -> Int
    func cellForRowDetail(indexPath: IndexPath) -> MovieEntity
    func getIDMovie(indexPath: IndexPath) -> Int
    func getIDGenre(indexPath: IndexPath) -> Int
    func getNameGenre(indexPath: IndexPath) -> String
}
