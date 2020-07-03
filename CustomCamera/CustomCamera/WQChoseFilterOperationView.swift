//
//  WQChoseFilterOperationView.swift
//  CustomCamera
//
//  Created by kris.wang on 2020/7/3.
//  Copyright © 2020 kris.wang. All rights reserved.
//

import UIKit

let ScreenWidth = UIScreen.main.bounds.width

protocol WQChoseFilterOperationViewDataProtocol {
    func getTitle() -> String
}

/// 选择基础滤镜的
class WQChoseFilterOperationView: UIView {

    var collectionV: UICollectionView!
    let Identifier = "CollectionViewCell"
    
    var dataArr: [WQChoseFilterOperationViewDataProtocol] = []
    
    var didSelectFilter: ((Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 60, height: 60)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
        collectionV = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionV.backgroundColor = .white
        collectionV.register(ChoseFilterCell.self, forCellWithReuseIdentifier: ChoseFilterCell.description())
        collectionV.delegate = self
        collectionV.dataSource = self
        self.addSubview(collectionV)
        collectionV.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
    }
}


extension WQChoseFilterOperationView: UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ChoseFilterCell = collectionView.dequeueReusableCell(withReuseIdentifier: ChoseFilterCell.description(), for: indexPath) as! ChoseFilterCell
        cell.backgroundColor = .red
        cell.model = dataArr[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      print(indexPath.row)
        didSelectFilter?(indexPath.row)
    }
}

