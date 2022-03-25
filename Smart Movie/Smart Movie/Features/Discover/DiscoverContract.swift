//
//  DiscoverContract.swift
//  Smart Movie
//
//  Created by Phuong on 08/03/2022.
//

import Foundation

protocol DiscoverContract {
    typealias Model = DiscoverModelProtocol
    typealias View = DiscoverViewProtocol
    typealias Presenter = DiscoverPresenterProtocol
}

protocol DiscoverModelProtocol {
    func fetchListPopularMovies() -> [MovieEntity]?
    func fetchListPopularMovies(page: Int, result: @escaping (Result<ListMovieResponseEntity, Error>) -> Void)
    func fetchListTopRatedMovies(page: Int, result: @escaping (Result<ListMovieResponseEntity, Error>) -> Void)
    func fetchListUpcommingMovies(page: Int, result: @escaping (Result<ListMovieResponseEntity, Error>) -> Void)
    func fetchListNowPlayingMovies(page: Int, result: @escaping (Result<ListMovieResponseEntity, Error>) -> Void)
    
    func fetchMovieDetail(id: Int, result: @escaping (Result<MovieDetailEntity, Error>) -> Void)
    
}

protocol DiscoverViewProtocol: AnyObject {
    func showErrorMessage(_ message: String)
    func displayListMovie(_ listMovie: [MovieEntity])
    func refeshView()
    func showAlert()
}

protocol DiscoverPresenterProtocol {
    func viewDidAppear()
    
    func fetchData(page: Int)
    func fetchListPopularMovies(page: Int)
    func fetchListTopRatedMovies(page: Int)
    func fetchListUpcommingMovies(page: Int)
    func fetchListNowPlayingMovies(page: Int)
    func fetchMovieDetail(id: Int)
    
    func attach(view: DiscoverContract.View)
    func detachView()
    
    func numberOfSections() -> Int
    func numberOfItemsInSection(section: Int) -> Int
    func cellForRowAt(indexPath: IndexPath) -> MovieEntity
    
    func numberOfRowsInPopular(section: Int) -> Int
    func cellForRowAtPopular(indexPath: IndexPath) -> MovieEntity

    func numberOfRowsInTopRated(section: Int) -> Int
    func cellForRowAtTopRated(indexPath: IndexPath) -> MovieEntity

    func numberOfRowsInUpcomming(section: Int) -> Int
    func cellForRowAtUpcomming(indexPath: IndexPath) -> MovieEntity

    func numberOfRowsInNowPlaying(section: Int) -> Int
    func cellForRowAtNowPlaying(indexPath: IndexPath) -> MovieEntity
    
    func getIDMovie(indexPath: IndexPath) -> Int
    func getIDMovieOfPopular(indexPath: IndexPath) -> Int
    func getIDMovieOfTopRated(indexPath: IndexPath) -> Int
    func getIDMovieOfUpcomming(indexPath: IndexPath) -> Int
    func getIDMovieOfNowPlaying(indexPath: IndexPath) -> Int
    
    func getRunTimeMovie(data: MovieEntity, id: Int) -> Int
    
    func checkLoadMorePopular(indexPath: IndexPath)
    func checkLoadMoreTopRated(indexPath: IndexPath)
    func checkLoadMoreUpcomming(indexPath: IndexPath)
    func checkLoadMoreNowPlaying(indexPath: IndexPath)
    
    func refreshMovie()
    func refreshPopular()
    func refreshTopRated()
    func refreshUpcomming()
    func refreshNowPlaying()
    
}
