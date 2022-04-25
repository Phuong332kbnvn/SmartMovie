//
//  ReviewContract.swift
//  Smart Movie
//
//  Created by Phuong on 24/04/2022.
//

import Foundation

protocol ReviewContract {
    typealias Model = ReviewModelProtocol
    typealias View = ReviewViewProtocol
    typealias Presenter = ReviewPresenterProtocol
}

protocol ReviewPresenterProtocol {
    func viewDidAppear()
    
    func fetchReview(id: Int)
    func attach(view: ReviewContract.View)
    func detachView()
    func numberOfRowsInSection() -> Int
    func cellForRowAt(indexPath: IndexPath) -> AuthorReview
}

protocol ReviewViewProtocol: AnyObject {
    func refreshView()
}

protocol ReviewModelProtocol {
    func fetchReview(id: Int, result: @escaping (Result<ReviewResponseEntity, Error>) -> Void)
}
