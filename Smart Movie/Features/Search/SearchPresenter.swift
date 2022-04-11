//
//  SearchPresenter.swift
//  Smart Movie
//
//  Created by Phuong on 14/03/2022.
//

import Foundation

final class SearchPresenter {
    private weak var contentView: SearchContract.View?
    private var model: SearchContract.Model
    
    private var movieEntity: [MovieEntity] = []
    private var genresEntity: [GenreEntity] = []
    private var query: String = ""
    var needReload: (() -> Void)?

    init(model: SearchContract.Model) {
        self.model = model
    }
}

extension SearchPresenter: SearchPresenterProtocol {
    
    func viewDidAppear() {
        
    }
    
    func fetchListgenres() {
        model.fetchListgenres { [weak self] result in
            switch result {
            case .success(let entity):
                self?.genresEntity = entity.genres
                self?.contentView?.refeshView()
                self?.needReload?()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchListSearch(query: String) {
        model.fetchListMovies(query: query) { [weak self] result in
            switch result {
            case .success(let entity):
                self?.movieEntity = entity.results
                self?.contentView?.refeshView()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func attach(view: SearchContract.View) {
        contentView = view
    }
    
    func detachView() {
        contentView = nil
    }
    
    
    func numberOfRowsInSection() -> Int {
        return movieEntity.count
    }

    func cellForRowAt(indexPath: IndexPath) -> MovieEntity {
        return movieEntity[indexPath.row]
    }
    
    func getIDMovie(indexPath: IndexPath) -> Int {
        return movieEntity[indexPath.row].id
    }
    
    func getNameGenre(id: Int) -> String {
        for genre in genresEntity {
            if genre.id == id {
                return genre.name
            }
        }
        return ""
    }

}

