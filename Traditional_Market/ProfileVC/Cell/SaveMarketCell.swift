//
//  ListCell.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/10/04.
//

import UIKit

class SaveMarketCell : UITableViewCell {
    
    let saveImageView = {
       let view = UIImageView()
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.layer.cornerCurve = .continuous
        view.backgroundColor = .lightGray
        return view
    }()
    //
    let marketTitle = {
        let view = UILabel()
        view.text = "자갈치시장"
        view.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        return view
    }()
    
    let marketDescription = {
       let view = UILabel()
        view.text = "여기 진짜 맛있음여기 진짜 맛있음여기 진짜 맛있음여기 진짜 맛있음여기 진짜 맛있음여기 진짜 맛있음여기 진짜 맛있음여기 진짜 맛있음여기 진짜 맛있음여기 진짜 맛있음여기 진짜 맛있음여기 진짜 맛있음"
        view.font = UIFont.systemFont(ofSize: 13)
        view.numberOfLines = 0
      //  view.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        return view
    }()
    
//    lazy var stackView = {
//        let stack = UIStackView(arrangedSubviews: [marketTitle, marketDescription])
//        stack.axis = .vertical
//        stack.spacing = 5
//        stack.alignment = .fill
//        stack.distribution = .fill
//        return stack
//    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        contentView.addSubview(saveImageView)
        contentView.addSubview(marketTitle)
        contentView.addSubview(marketDescription)
    }
    
    func setConstraints() {
        
   
        saveImageView.snp.makeConstraints { make in
            make.leading.verticalEdges.equalToSuperview().inset(10)
            make.width.equalTo(self.saveImageView.snp.height)
        }
        
        marketTitle.snp.makeConstraints { make in
            make.top.equalTo(saveImageView)
            make.leading.equalTo(saveImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(10)
        }
        
        marketDescription.snp.makeConstraints { make in
            make.top.equalTo(marketTitle.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(marketTitle)
            make.bottom.lessThanOrEqualTo(saveImageView)
           
        }
        
        
//        stackView.snp.makeConstraints { make in
//            make.leading.equalTo(saveImageView.snp.trailing).offset(5)
//            make.verticalEdges.equalTo(saveImageView)
//            make.trailing.equalToSuperview().inset(5)
//        }
        
    }
    
}
