//
//  GenresPresenter.swift
//  Smart Movie
//
//  Created by Phuong on 14/03/2022.
//

import Foundation

final class GenresPresenter {
    private weak var contentView: GenresContract.View?
    private var model: GenresContract.Model
    private var genresEntity: [GenreEntity] = []
    private var genresDetail: [MovieEntity] = []
    private var nameGenre: String = ""

    init(model: GenresContract.Model) {
        self.model = model
    }
}

extension GenresPresenter: GenresPresenterProtocol {

    func viewDidAppear() {
        
        fetchListgenres()
    }
    
    func fetchListgenres() {
        model.fetchListgenres { [weak self] result in
            switch result {
            case .success(let entity):
                self?.genresEntity = entity.genres
                self?.contentView?.refeshView()
            case .failure(let error):
                print(error)
            }
        }
        
        
    }
    func fetchGenreDetail(id: Int) {
        model.fetchGenreDetail(id: id) { [weak self] result in
            switch result {
            case .success(let entity):
                self?.genresDetail = entity.results
                self?.contentView?.refeshView()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func attach(view: GenresContract.View) {
        contentView = view
    }
    
    func detachView() {
        contentView = nil
    }
    
    
    func numberOfRowsInSection(section: Int) -> Int {
        return genresEntity.count
    }

    func cellForRowAt(indexPath: IndexPath) -> GenreEntity {
        return genresEntity[indexPath.row]
    }
    
    func numberOfRowsDetail(section: Int) -> Int {
        return genresDetail.count
    }
    
    func cellForRowDetail(indexPath: IndexPath) -> MovieEntity {
        return genresDetail[indexPath.row]
    }
    
    func getIDMovie(indexPath: IndexPath) -> Int {
        return genresDetail[indexPath.row].id
    }
    
    func getIDGenre(indexPath: IndexPath) -> Int {
        return genresEntity[indexPath.row].id
    }
    
    func getNameGenre(indexPath: IndexPath) -> String {
        return genresEntity[indexPath.row].name
    }
}

