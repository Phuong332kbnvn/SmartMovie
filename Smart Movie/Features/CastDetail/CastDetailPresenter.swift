//
//  CastDetailPresenter.swift
//  Smart Movie
//
//  Created by Phuong on 26/04/2022.
//

import Foundation

final class CastDetailPresenter {
    private weak var contentView: CastDetailContract.View?
    private var model: CastDetailContract.Model
    private var moviesOfCast: [MovieOfCastEntity] = []
    var castDetail: CastDetailEntity?
    var needReloadCastDetail: (() -> Void)?
    init(model: CastDetailContract.Model) {
        self.model = model
    }
}

extension CastDetailPresenter: CastDetailPresenterProtocol {
    func viewDidLoad() {
        
    }
    
    func fetchCastDetail(idCast: Int) {
        model.fetchCastDetail(id: idCast) { [weak self] result in
            switch result {
            case .success(let entity):
                self?.castDetail = entity
                self?.needReloadCastDetail?()
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func fetchMovieOfCast(idCast: Int) {
        model.fetchMovieOfCast(id: idCast) { [weak self] result in
            switch result {
            case .success(let entity):
                self?.moviesOfCast = entity.cast
                self?.contentView?.refreshView()
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func attach(view: CastDetailContract.View) {
        contentView = view
    }
    
    func detachView() {
        contentView = nil
    }
    
    func numberOfItemsInSection() -> Int {
        return moviesOfCast.count
    }
    
    func cellForItemAt(indexPath: IndexPath) -> MovieOfCastEntity {
        return moviesOfCast[indexPath.row]
    }
    
    func getIDMovie(indexPath: IndexPath) -> Int {
        return moviesOfCast[indexPath.row].id
    }
}
