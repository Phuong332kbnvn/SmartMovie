//
//  DiscoverPresenter.swift
//  Smart Movie
//
//  Created by Phuong on 08/03/2022.
//

import Foundation

final class DiscoverPresenter {
    private weak var contentView: DiscoverContract.View?
    private var model: DiscoverContract.Model
    private var movieEntity: [[MovieEntity]] = [[MovieEntity]](repeating: [], count: 4)
    private var popularEntity: [MovieEntity] = []
    private var topRatedEntity: [MovieEntity] = []
    private var upcommingEntity: [MovieEntity] = []
    private var nowPlayingEntity: [MovieEntity] = []
    private var movieDetailEntity: MovieDetailEntity?
    private var pagePopular: Int = 1
    private var pageTopRated: Int = 1
    private var pageUpcomming: Int = 1
    private var pageNowPlaying: Int = 1
    private var isLoadingPopular: Bool = false
    private var isLoadingTopRated: Bool = false
    private var isLoadingUpcomming: Bool = false
    private var isLoadingNowPlaying: Bool = false
    private var numberOfError: Int = 0
    private var dispatch = DispatchGroup()
    var handleAPIError: ((Int, PageType) -> Void)?
    var hanđleAllAPIFail: (() -> Void)?
    var needReload: ((_ runTime: Int) -> Void)?
    var needReloadTopRated: (() -> Void)?
    var needReloadData: (() -> Void)?

    init(model: DiscoverContract.Model) {
        self.model = model
    }
}

extension DiscoverPresenter: DiscoverPresenterProtocol {
    
    func viewDidAppear() {
        
    }
    
    func fetchData(page: Int) {
        fetchListPopularMovies(page: page)
        fetchListTopRatedMovies(page: page)
        fetchListUpcommingMovies(page: page)
        fetchListNowPlayingMovies(page: page)
        dispatch.notify(queue: .main) {
            if self.numberOfError < 4 {
                self.needReloadData?()
            } else {
                self.hanđleAllAPIFail?()
            }
        }
    }
    
    func handleError(_ viewController: Int, _ pageType: PageType) {
        numberOfError += 1
        handleAPIError?(viewController, pageType)
        if numberOfError == 4 {
            hanđleAllAPIFail?()
        }
    }
    
    func recallApiError() {
        numberOfError = 0
        fetchData(page: 1)
    }
    
    func fetchListPopularMovies(page: Int) {
        dispatch.enter()
        model.fetchListPopularMovies(page: page) { [weak self] result in
            switch result {
            case .success(let entity):
                self?.popularEntity.append(contentsOf: entity.results)
                self?.movieEntity[0] = Array(entity.results.prefix(4))
                self?.contentView?.refeshView()
                self?.dispatch.leave()
            case .failure(let error):
                self?.handleError(1, .popular)
                print(error)
                self?.dispatch.leave()
            }
        }
    }
        
    func fetchListTopRatedMovies(page: Int) {
        dispatch.enter()
        model.fetchListTopRatedMovies(page: page) { [weak self] result in
            switch result {
            case .success(let entity):
                self?.topRatedEntity.append(contentsOf: entity.results)
                self?.movieEntity[1] = Array(entity.results.prefix(4))
                self?.contentView?.refeshView()
                self?.needReloadTopRated?()
                self?.dispatch.leave()
            case .failure(let error):
                self?.handleError(2, .topRated)
                print(error)
                self?.dispatch.leave()
            }
        }
    }
        
    func fetchListUpcommingMovies(page: Int) {
        dispatch.enter()
        model.fetchListUpcommingMovies(page: page) { [weak self] result in
            switch result {
            case .success(let entity):
                self?.upcommingEntity.append(contentsOf: entity.results)
                self?.movieEntity[2] = Array(entity.results.prefix(4))
                self?.contentView?.refeshView()
                self?.dispatch.leave()
            case .failure(let error):
                self?.handleError(3, .upcomming)
                print(error)
                self?.dispatch.leave()
            }
        }
    }
    
    func fetchListNowPlayingMovies(page: Int) {
        dispatch.enter()
        model.fetchListNowPlayingMovies(page: page) { [weak self] result in
            switch result {
            case .success(let entity):
                self?.nowPlayingEntity.append(contentsOf: entity.results)
                self?.movieEntity[3] = Array(entity.results.prefix(4))
                self?.contentView?.refeshView()
                self?.dispatch.leave()
            case .failure(let error):
                self?.handleError(4, .nowPlaying)
                print(error)
                self?.dispatch.leave()
            }
        }
    }
    
    func fetchMovieDetail(id: Int) {
        model.fetchMovieDetail(id: id) { [weak self] result in
            switch result {
            case .success(let entity):
                self?.movieDetailEntity = entity
                self?.needReload?(entity.runtime)
                self?.contentView?.refeshView()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func attach(view: DiscoverContract.View) {
        contentView = view
    }
    
    func detachView() {
        contentView = nil
    }
    
    func numberOfSections() -> Int {
        return movieEntity.count
    }
    
    func numberOfItemsInSection(section: Int) -> Int {
        return movieEntity[section].count
    }
    
    func cellForRowAt(indexPath: IndexPath) -> MovieEntity {
        return movieEntity[indexPath.section][indexPath.row]
    }
    
    func numberOfRowsInPopular(section: Int) -> Int {
        return popularEntity.count
    }

    func cellForRowAtPopular(indexPath: IndexPath) -> MovieEntity {
        return popularEntity[indexPath.row]
    }
    
    func numberOfRowsInTopRated(section: Int) -> Int {
        return topRatedEntity.count
    }

    func cellForRowAtTopRated(indexPath: IndexPath) -> MovieEntity {
        return topRatedEntity[indexPath.row]
    }
    
    func numberOfRowsInUpcomming(section: Int) -> Int {
        return upcommingEntity.count
    }

    func cellForRowAtUpcomming(indexPath: IndexPath) -> MovieEntity {
        return upcommingEntity[indexPath.row]
    }

    func numberOfRowsInNowPlaying(section: Int) -> Int {
        return nowPlayingEntity.count
    }

    func cellForRowAtNowPlaying(indexPath: IndexPath) -> MovieEntity {
        return nowPlayingEntity[indexPath.row]
    }
    
    func getIDMovie(indexPath: IndexPath) -> Int {
        return movieEntity[indexPath.section][indexPath.row].id
    }
    
    func getIDMovieOfPopular(indexPath: IndexPath) -> Int {
        return popularEntity[indexPath.row].id
    }
    
    func getIDMovieOfTopRated(indexPath: IndexPath) -> Int {
        return topRatedEntity[indexPath.row].id
    }
    
    func getIDMovieOfUpcomming(indexPath: IndexPath) -> Int {
        return upcommingEntity[indexPath.row].id
    }
    
    func getIDMovieOfNowPlaying(indexPath: IndexPath) -> Int {
        return nowPlayingEntity[indexPath.row].id
    }
    
    func getRunTimeMovie(data: MovieEntity, id: Int) -> Int {
        guard let movieDetailEntity = movieDetailEntity else {
            return 0
        }
        if data.id == id {
            return movieDetailEntity.runtime
        }
        
        return 0
    }
    
    func checkLoadMorePopular(indexPath: IndexPath) {
        if indexPath.row == popularEntity.count - 1 && !self.isLoadingPopular {
            if !self.isLoadingPopular {
                self.isLoadingPopular = true
                self.pagePopular += 1
                DispatchQueue.global(qos: .userInitiated).async {
                    sleep(1)
                    self.fetchListPopularMovies(page: self.pagePopular)
                    DispatchQueue.main.async {
                        self.isLoadingPopular = false
                    }
                }
            }
        }
    }
    
    func checkLoadMoreTopRated(indexPath: IndexPath) {
        if indexPath.row == topRatedEntity.count - 1 && !self.isLoadingTopRated {
            if !self.isLoadingTopRated {
                self.isLoadingTopRated = true
                self.pageTopRated += 1
                DispatchQueue.global(qos: .userInitiated).async {
                    sleep(1)
                    self.fetchListTopRatedMovies(page: self.pageTopRated)
                    DispatchQueue.main.async {
                        self.isLoadingTopRated = false
                    }
                }
            }
        }
    }
    
    func checkLoadMoreUpcomming(indexPath: IndexPath) {
        if indexPath.row == upcommingEntity.count - 1 && !self.isLoadingUpcomming {
            if !self.isLoadingUpcomming {
                self.isLoadingUpcomming = true
                self.pageUpcomming += 1
                DispatchQueue.global(qos: .userInitiated).async {
                    sleep(1)
                    self.fetchListUpcommingMovies(page: self.pageUpcomming)
                    DispatchQueue.main.async {
                        self.isLoadingUpcomming = false
                    }
                }
            }
        }
    }
    
    func checkLoadMoreNowPlaying(indexPath: IndexPath) {
        if indexPath.row == nowPlayingEntity.count - 1 && !self.isLoadingNowPlaying {
            if !self.isLoadingNowPlaying {
                self.isLoadingNowPlaying = true
                self.pageNowPlaying += 1
                DispatchQueue.global(qos: .userInitiated).async {
                    sleep(1)
                    self.fetchListNowPlayingMovies(page: self.pageNowPlaying)
                    DispatchQueue.main.async {
                        self.isLoadingNowPlaying = false
                    }
                }
            }
        }
    }
    
    func refreshMovie() {
        movieEntity.removeAll()
        fetchData(page: 1)
    }
    
    func refreshPopular() {
        popularEntity.removeAll()
        fetchListPopularMovies(page: 1)
    }
    
    func refreshTopRated() {
        topRatedEntity.removeAll()
        fetchListTopRatedMovies(page: 1)
    }
    
    func refreshUpcomming() {
        upcommingEntity.removeAll()
        fetchListUpcommingMovies(page: 1)
    }
    
    func refreshNowPlaying() {
        nowPlayingEntity.removeAll()
        fetchListNowPlayingMovies(page: 1)
    }
    
    
}

