//
//  CastTableViewCell.swift
//  Smart Movie
//
//  Created by Phuong on 17/03/2022.
//

import UIKit

class CastTableViewCell: UITableViewCell {
    // MARK: - Variables
    private var presenter = MovieDetailPresenter(model: MovieDetailModel())
    var data: [CastEntity] = []
    
    // MARK: - IBOutlet
    @IBOutlet weak var castCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setupCollectionView() {
        castCollectionView.dataSource = self
        castCollectionView.delegate = self
        
        castCollectionView.register(UINib(nibName: "CastCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CastCollectionViewCell")
    }
    
}
// MARK: - UICollectionViewDataSource
extension CastTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CastCollectionViewCell", for: indexPath) as? CastCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.bindData(data[indexPath.row])
        return cell
    }
    
    
}
// MARK: - UICollectionViewDelegateFlowLayout
extension CastTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: castCollectionView.bounds.width/3 - 10, height: castCollectionView.bounds.height/2 - 5)
    }
}


