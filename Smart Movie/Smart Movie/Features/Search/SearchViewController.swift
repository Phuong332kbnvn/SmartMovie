//
//  SearchViewController.swift
//  Smart Movie
//
//  Created by Phuong on 10/03/2022.
//

import UIKit

class SearchViewController: UIViewController {
    // MARK: - Variables
    private var presenter = SearchPresenter(model: SearchModel())
    private var listMovies: [MovieEntity] = []
    private var isSearch: Bool = false
    // MARK: - IBOutlet
    @IBOutlet weak var movieSearchBar: UISearchBar!
    @IBOutlet weak var movieTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.attach(view: self)
        
        setupTableView()
        setupSearchBar()
    }
    
    private func setupTableView() {
        movieTableView.dataSource = self
        movieTableView.delegate = self
        movieTableView.separatorStyle = .none
        movieTableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieTableViewCell")
    }
    
    private func setupSearchBar() {
        movieSearchBar.delegate = self
        movieSearchBar.placeholder = "Gone the with bomb..."
        movieSearchBar.searchBarStyle = .minimal
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

}
// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearch ? presenter.numberOfRowsInSection() : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isSearch {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as? MovieTableViewCell else {
                return UITableViewCell()
            }
            cell.bindData(presenter.cellForRowAt(indexPath: indexPath))
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.frame.height/3.5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "MovieDetail", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController else {
            return
        }
        viewController.idMovie = presenter.getIDMovie(indexPath: indexPath)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            isSearch = false
            self.movieSearchBar.showsCancelButton = false
            movieTableView.reloadData()
        } else {
            self.movieSearchBar.showsCancelButton = true
            isSearch = true
            presenter.fetchListSearch(query: searchText)
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.movieSearchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearch = false
        self.movieSearchBar.showsCancelButton = false
        searchBar.text = ""
        self.movieTableView.reloadData()
    }
}
// MARK: - Extension
extension SearchViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.viewDidAppear()
    }
}

extension SearchViewController: SearchViewProtocol {
    func refeshView() {
        movieTableView.reloadData()
    }

    func showErrorMessage(_ message: String) {
        Logger.debug(message)
    }

    func displayListMovie(_ listMovie: [MovieEntity]) {
        Logger.debug(listMovie)
    }

}
