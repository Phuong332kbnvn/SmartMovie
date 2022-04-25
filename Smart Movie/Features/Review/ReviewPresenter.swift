//
//  ReviewPresenter.swift
//  Smart Movie
//
//  Created by Phuong on 24/04/2022.
//

import Foundation

final class ReviewPresenter {
    private weak var contentView: ReviewContract.View?
    private var model: ReviewContract.Model
    private var authorReviews: [AuthorReview] = []
    
    init(model: ReviewContract.Model) {
        self.model = model
    }
}

extension ReviewPresenter: ReviewPresenterProtocol {
    func viewDidAppear() {
        
    }
    
    func fetchReview(id: Int) {
        model.fetchReview(id: id) { [weak self] result in
            switch result {
            case .success(let entity):
                self?.authorReviews = entity.results
                self?.contentView?.refreshView()
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func attach(view: ReviewViewProtocol) {
        contentView = view
    }
    
    func detachView() {
        contentView = nil
    }
    
    func numberOfRowsInSection() -> Int {
        return authorReviews.count
    }
    
    func cellForRowAt(indexPath: IndexPath) -> AuthorReview {
        return authorReviews[indexPath.row]
    }
    
}
