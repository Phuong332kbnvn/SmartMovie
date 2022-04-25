//
//  ReviewViewController.swift
//  Smart Movie
//
//  Created by Phuong on 24/04/2022.
//

import UIKit

final class ReviewViewController: UIViewController {

    private var presenter = ReviewPresenter(model: ReviewModel())
    var idMovie: Int = 0
    
    @IBOutlet private weak var reviewTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.attach(view: self)
        presenter.fetchReview(id: idMovie)
        
        setupTableView()
    }
    
    func setupTableView() {
        reviewTableView.dataSource = self
        reviewTableView.delegate = self
        
        reviewTableView.register(UINib(nibName: "ReviewTableViewCell", bundle: nil), forCellReuseIdentifier: "ReviewTableViewCell")
    }
    
    @IBAction func invokeBackButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
}

extension ReviewViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTableViewCell", for: indexPath) as? ReviewTableViewCell else {
            return UITableViewCell()
        }
        cell.bindData(data: presenter.cellForRowAt(indexPath: indexPath))
        return cell
    }
}

extension ReviewViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height/6.5
    }
}

extension ReviewViewController: ReviewViewProtocol {
    func refreshView() {
        reviewTableView.reloadData()
    }
}
