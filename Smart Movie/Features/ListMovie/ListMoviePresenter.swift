//
//  ListMoviePresenter.swift
//  Smart Movie
//
//  Created by Phuong on 25/04/2022.
//

import Foundation

final class ListMoviePresenter {
    private weak var contentView: ListMovieContract.View?
    private var model: ListMovieContract.Model
    var movies: [MovieDetailEntity] = []
    
    init(model: ListMovieContract.Model) {
        self.model = model
    }
}

extension ListMoviePresenter: ListMoviePresenterProtocol {
    func viewDidAppear() {
        
    }
    
    func fetchMovie(id: Int) {
        model.fetchMovie(id: id) { [weak self] result in
            switch result {
            case .success(let entity):
                self?.movies.append(entity)
                self?.contentView?.refreshView() 
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func attach(view: ListMovieViewProtocol) {
        contentView = view
    }
    
    func detachView() {
        contentView = nil
    }
}
