//
//  CastTableViewHeaderFooterView.swift
//  Smart Movie
//
//  Created by Phuong on 17/03/2022.
//

import UIKit

class CastTableViewHeaderFooterView: UITableViewHeaderFooterView {

    @IBOutlet var mainView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("CastTableViewHeaderFooterView", owner: self, options: nil)
        addSubview(mainView)
        mainView.frame = self.bounds
        mainView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
