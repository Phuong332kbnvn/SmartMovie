//
//  MovieDetailPresenter.swift
//  Smart Movie
//
//  Created by Phuong on 16/03/2022.
//

import Foundation

final class MovieDetailPresenter {
    private weak var contentView: MovieDetailContract.View?
    private var model: MovieDetailContract.Model
    private var listCastsResponseEntity: [CastEntity] = []
    private var listSimilarsResponseEntity: [MovieEntity] = []
    private var listTrailerEntity: [TrailerEntity] = []
    var castDetail: CastDetailEntity?
    var movieDetailEntity: MovieDetailEntity?
    var needReload: (() -> Void)?
    var needReloadCast: (() -> Void)?
    var needReloadCastDetail: (() -> Void)?
    var getListTrailers: (([TrailerEntity]) -> Void)?
    
    init(model: MovieDetailContract.Model) {
        self.model = model
    }
}

extension MovieDetailPresenter: MovieDetailPresenterProtocol {
    
    func viewDidAppear() {
        
    }
    
    func fetchMovieDetail(id: Int) {
        model.fetchMovieDetail(id: id) { [weak self] result in
            switch result {
            case .success(let entity):
                self?.movieDetailEntity = entity
                self?.needReload?()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchTrailer(id: Int) {
        model.fetchTrailer(id: id) { [weak self] result in
            switch result {
            case .success(let entity):
                self?.listTrailerEntity = entity.results
                self?.getListTrailers?(entity.results)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchListCasts(id: Int) {
        model.fetchListCasts(id: id) { [weak self] result in
            switch result {
            case .success(let entity):
                self?.listCastsResponseEntity = entity.cast
                self?.needReloadCast?()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchListSimilar(id: Int) {
        model.fetchListSimilars(id: id) { [weak self] result in
            switch result {
            case .success(let entity):
                self?.listSimilarsResponseEntity = entity.results
                self?.contentView?.refeshView()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchCastDetail(idCast: Int) {
        model.fetchCastDetail(id: idCast) { [weak self] result in
            switch result {
            case .success(let entity):
                self?.castDetail = entity
                self?.needReloadCastDetail?()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func attach(view: MovieDetailViewProtocol) {
        contentView = view
    }
    
    func detachView() {
        contentView = nil
    }
    
    func numberOfRowsInSection() -> Int {
        return listSimilarsResponseEntity.count
    }
    
    func cellForRowAt(indexPath: IndexPath) -> MovieEntity {
        return listSimilarsResponseEntity[indexPath.row]
    }
    
    func numberOfRowsInCasts() -> Int {
        return listCastsResponseEntity.count
    }
    
    func cellForRowCastAt(indexPath: IndexPath) -> [CastEntity] {
        return listCastsResponseEntity
    }
    
    func getIDMovie(indexPath: IndexPath) -> Int {
        return listSimilarsResponseEntity[indexPath.row].id
    }
    
    func getIDCast(indexPath: IndexPath) -> Int {
        return listCastsResponseEntity[indexPath.row].id
    }
}

