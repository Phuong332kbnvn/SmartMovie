//
//  CastDetailViewController.swift
//  Smart Movie
//
//  Created by Phuong on 30/03/2022.
//

import UIKit
import Kingfisher

final class CastDetailViewController: UIViewController {

    // MARK: - Variables
//    private var presenter = MovieDetailPresenter(model: MovieDetailModel())
    
    private var presenter = CastDetailPresenter(model: CastDetailModel())

    var idCast: Int = 0
    
    // MARK: - IBOutlet
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet weak var castNameLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var placeOfBirthLabel: UILabel!
    @IBOutlet weak var biographyLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIView!
    @IBOutlet weak var movieOfCastCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.attach(view: self)
        presenter.fetchCastDetail(idCast: idCast)
        presenter.fetchMovieOfCast(idCast: idCast)
        
        setupCollectionView()
        setupData()
        setupUI()
    }
    
    private func setupCollectionView() {
        movieOfCastCollectionView.dataSource = self
        movieOfCastCollectionView.delegate = self
        
        movieOfCastCollectionView.register(UINib(nibName: "MovieOfCastCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MovieOfCastCollectionViewCell")
    }
    
    private func setupData() {
        presenter.needReloadCastDetail = { [weak self] in
            guard let self = self else {
                return
            }
            guard let data = self.presenter.castDetail else {
                return ()
            }
            self.castNameLabel.text = data.name
            self.birthdayLabel.text = "(\(data.birthday))"
            self.placeOfBirthLabel.text = data.placeOfBirth
            self.biographyLabel.text = data.biography
            if let url = URL(string: "https://image.tmdb.org/t/p/w500\(data.profilePath)") {
                let processor = DownsamplingImageProcessor(size: self.profileImageView.bounds.size)
                |> RoundCornerImageProcessor(cornerRadius: 5)
                self.profileImageView.kf.setImage(with: url,
                                                placeholder: nil,
                                                options: [
                                                    .processor(processor),
                                                    .scaleFactor(UIScreen.main.scale),
                                                    .transition(.fade(1)),
                                                    .cacheOriginalImage
                                                ])
            }
        }
    }
    
    private func setupUI() {
        backgroundImageView.layer.cornerRadius = 30
        backgroundImageView.layer.shadowColor = UIColor.gray.cgColor
        backgroundImageView.layer.shadowOpacity = 0.5
        backgroundImageView.layer.shadowOffset = CGSize(width: 0, height: 0)
    }

    @IBAction func invokeBackButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension CastDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfItemsInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieOfCastCollectionViewCell", for: indexPath) as? MovieOfCastCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.bindData(data: presenter.cellForItemAt(indexPath: indexPath))
        return cell
    }
}

extension CastDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "MovieDetail", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController else {
            return
        }
        viewController.idMovie = presenter.getIDMovie(indexPath: indexPath)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension CastDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/3 - 5, height: collectionView.frame.height/1.2)
    }
}

extension CastDetailViewController: CastDetailViewProtocol {
    func refreshView() {
        movieOfCastCollectionView.reloadData()
    }
}
