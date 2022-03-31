//
//  CastDetailViewController.swift
//  Smart Movie
//
//  Created by Phuong on 30/03/2022.
//

import UIKit
import Kingfisher

class CastDetailViewController: UIViewController {

    // MARK: - Variables
    private var presenter = MovieDetailPresenter(model: MovieDetailModel())
    var idCast: Int = 0
    
    // MARK: - IBOutlet
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet weak var castNameLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var placeOfBirthLabel: UILabel!
    @IBOutlet weak var biographyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.fetchCastDetail(idCast: idCast)
        setupData()
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
            self.birthdayLabel.text = data.birthday
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

    @IBAction func invokeBackButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
