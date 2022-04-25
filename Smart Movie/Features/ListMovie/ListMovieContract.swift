//
//  ListMovieContract.swift
//  Smart Movie
//
//  Created by Phuong on 25/04/2022.
//

import Foundation

protocol ListMovieContract {
    typealias Model = ListMovieModelProtocol
    typealias View = ListMovieViewProtocol
    typealias Presenter = ListMoviePresenterProtocol
}

protocol ListMovieModelProtocol {
    func fetchMovie(id: Int, result: @escaping (Result<MovieDetailEntity, Error>) -> Void)
}

protocol ListMovieViewProtocol: AnyObject {
    func refreshView()
}

protocol ListMoviePresenterProtocol {
    func viewDidAppear()
    func fetchMovie(id: Int)
    func attach(view: ListMovieContract.View)
    func detachView()
}
