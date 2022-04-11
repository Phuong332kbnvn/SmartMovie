//
//  GenresViewController.swift
//  Smart Movie
//
//  Created by Phuong on 10/03/2022.
//

import UIKit

class GenresViewController: UIViewController {
    // MARK: - Variables
    private var presenter = GenresPresenter(model: GenresModel())
    
    
    // MARK: - IBOutlet
    @IBOutlet weak var genresTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.attach(view: self)
        
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    func setupTableView() {
        genresTableView.dataSource = self
        genresTableView.delegate = self
        genresTableView.separatorStyle = .none
        
        genresTableView.register(UINib(nibName: "GenresTableViewCell", bundle: nil), forCellReuseIdentifier: "GenresTableViewCell")
    }
}
// MARK: - UITableViewDataSource
extension GenresViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GenresTableViewCell", for: indexPath) as? GenresTableViewCell else {
            return UITableViewCell()
        }
        cell.bindDat(data: presenter.cellForRowAt(indexPath: indexPath))
        return cell
    }
}
// MARK: - UITableViewDelegate
extension GenresViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.frame.height/3.5 - 5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "GenresDetailViewController", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "GenresDetailViewController") as? GenresDetailViewController else {
            return
        }
        viewController.id = presenter.getIDGenre(indexPath: indexPath)
        viewController.nameGenre = presenter.getNameGenre(indexPath: indexPath)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
// MARK: - Extension
extension GenresViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.viewDidAppear()
    }
}

extension GenresViewController: GenresViewProtocol {
    
    func refeshView() {
        genresTableView.reloadData()
    }

    func showErrorMessage(_ message: String) {
        Logger.debug(message)
    }
    
    func displayListGenres(_ listGenres: [GenreEntity]) {
        Logger.debug(listGenres)
    }
}
