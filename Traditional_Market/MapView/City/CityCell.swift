//
//  CityCell.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/09/29.
//

import UIKit

class CityCell : UICollectionViewCell {
    
    let imageView = {
       let view = UIImageView()
        return view
    }()
    let baseImageView = UIView()
    
    let label = {
        let view = UILabel()
        view.text = "안녕하세요"
        view.clipsToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        contentView.addSubview(baseImageView)
        contentView.addSubview(label)
        baseImageView.addSubview(imageView)
    }
    
    func setConstraints() {
        baseImageView.layer.borderColor = UIColor.blue.cgColor
        baseImageView.layer.borderWidth = 2
        
        baseImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(15)
           
        }
        DispatchQueue.main.async {
            self.baseImageView.layer.cornerRadius = self.baseImageView.frame.width / 2
           // self.imageView.clipsToBounds = true
        }
    }
}
