//
//  GenresDetailViewController.swift
//  Smart Movie
//
//  Created by Phuong on 15/03/2022.
//

import UIKit

class GenresDetailViewController: UIViewController {
    // MARK: - Variables
    private var presenter = GenresPresenter(model: GenresModel())
    var nameGenre: String = ""
    var id: Int = 0
    
    // MARK: - IBOutlet
    @IBOutlet weak var genresNameLabel: UILabel!
    @IBOutlet weak var genresDetailCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.attach(view: self)
        
        setupCollectionView()
        
        genresNameLabel.text = nameGenre
        
        presenter.fetchGenreDetail(id: self.id)
        
    }
    
    func setupCollectionView() {
        genresDetailCollectionView.dataSource = self
        genresDetailCollectionView.delegate = self
        
        genresDetailCollectionView.register(UINib(nibName: "ListStyleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ListStyleCollectionViewCell")
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
// MARK: - UICollectionViewDataSource
extension GenresDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.numberOfRowsDetail(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListStyleCollectionViewCell", for: indexPath) as? ListStyleCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.idMovie = presenter.getIDMovie(indexPath: indexPath)
        cell.bindData(data: presenter.cellForRowDetail(indexPath: indexPath))
        return cell
    }
}
// MARK: - UICollectionViewDelegate
extension GenresDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "MovieDetail", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController else {
            return
        }
        viewController.idMovie = presenter.getIDMovie(indexPath: indexPath)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
// MARK: - UICollectionViewDelegateFlowLayout
extension GenresDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: collectionView.frame.height/4.5)
    }
}
// MARK: - Extension
extension GenresDetailViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.viewDidAppear()
    }
}

extension GenresDetailViewController: GenresViewProtocol {
    
    func refeshView() {
        genresDetailCollectionView.reloadData()
    }

    func showErrorMessage(_ message: String) {
        Logger.debug(message)
    }
    
    func displayListGenres(_ listGenres: [GenreEntity]) {
        Logger.debug(listGenres)
    }
}
