//
//  ChoseFilterCell.swift
//  CustomCamera
//
//  Created by kris.wang on 2020/7/3.
//  Copyright © 2020 kris.wang. All rights reserved.
//

import UIKit

class ChoseFilterCell: UICollectionViewCell {
    
    var titleLb: UILabel!
    
    var model: WQChoseFilterOperationViewDataProtocol? {
        didSet {
            self.titleLb.text = model?.getTitle()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLb = UILabel()
        titleLb.font = UIFont.systemFont(ofSize: 15)
        titleLb.textColor = .blue
        contentView.addSubview(titleLb)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
