//
//  TabsView.swift
//  Smart Movie
//
//  Created by Phuong on 11/03/2022.
//

import UIKit

protocol TabsDelegate: NSObjectProtocol{
    func tabsViewDidSelectItemAt(position: Int)
}

enum TabMode {
    case fixed
    case scrollable
}

struct Tab {
    var title: String
    var type: PageType
}

class TabsView: UIView {
    var tabMode: TabMode = .scrollable {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    var tabs: [Tab] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    var titleColor: UIColor = .black {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    var titleFont: UIFont = UIFont.systemFont(ofSize: 20, weight: .regular) {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    var indicatorColor: UIColor = .black {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    var collectionView: UICollectionView!
    
    weak var delegate: TabsDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createView()
    }
    
    private func createView() {
        // Create Flow Layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        // Create CollectionView
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TabCollectionViewCell.self, forCellWithReuseIdentifier: "TabCollectionViewCell")
        addSubview(collectionView)
        
        // ColletionView Constraints
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}

extension TabsView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TabCollectionViewCell", for: indexPath) as? TabCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.tabViewModel = Tab(title: tabs[indexPath.item].title, type: tabs[indexPath.item].type)
        
        // Change Title Color
        cell.tabTitle.font = titleFont
        cell.tabTitle.textColor = titleColor
        cell.indicatorColor = indicatorColor
        return cell
    }
    
}

extension TabsView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let delegate = delegate else {
            return
        }
        delegate.tabsViewDidSelectItemAt(position: indexPath.item)
    }
}

extension TabsView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch tabMode {
        case .scrollable:
            let tabSize = CGSize(width: 500, height: self.frame.height)
            let tabTitle = tabs[indexPath.item].title
            
            // Calculate the width of the Tab Title string
            let titleWidth = NSString(string: tabTitle).boundingRect(with: tabSize, options: .usesLineFragmentOrigin, attributes: [.font: titleFont], context: nil).size.width
            
            let tabWidth = titleWidth
            
            return CGSize(width: tabWidth, height: self.frame.height)
        case .fixed:
            return CGSize(width: self.frame.width / CGFloat(tabs.count), height: self.frame.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
}
