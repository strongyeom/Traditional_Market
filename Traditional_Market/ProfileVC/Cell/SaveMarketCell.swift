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
    
    let marketTitle = {
        let view = UILabel()
        view.text = "자갈치시장"
        view.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        return view
    }()
    
    let createdDate = {
       let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 13)
        view.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        view.textColor = .lightGray
        return view
    }()
    
    let marketDescription = {
       let view = UILabel()
        view.text = "여기 진짜 맛있음여기 진짜 맛있음여기 진짜 맛있음여기 진짜 맛있음여기 진짜 맛있음여기 진짜 맛있음여기 진짜 맛있음여기 진짜 맛있음여기 진짜 맛있음여기 진짜 맛있음여기 진짜 맛있음여기 진짜 맛있음"
        view.font = UIFont.systemFont(ofSize: 13)
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        view.numberOfLines = 2
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        [saveImageView, marketTitle, marketDescription, createdDate].forEach {
            contentView.addSubview($0)
        }
    }
    
    func setConstraints() {
        
   
        saveImageView.snp.makeConstraints { make in
            make.leading.verticalEdges.equalToSuperview().inset(10)
            make.width.equalTo(self.saveImageView.snp.height)
        }
        
        marketTitle.snp.makeConstraints { make in
            make.top.equalTo(saveImageView)
            make.leading.equalTo(saveImageView.snp.trailing).offset(10)
           
        }
        
        createdDate.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.centerY.equalTo(marketTitle)
            
        }
        
        marketDescription.snp.makeConstraints { make in
            make.top.equalTo(marketTitle.snp.bottom).offset(5)
            make.leading.equalTo(marketTitle)
            make.trailing.equalTo(createdDate.snp.leading).offset(-10)
            make.bottom.lessThanOrEqualTo(saveImageView)
           
        }

    }
    
    func configureView(data: FavoriteTable) {
        self.selectionStyle = .none
        self.marketTitle.text = data.marketName
        self.marketDescription.text = data.memo
        self.createdDate.text = dateFormmeted(data: data)
    }
    
}

extension SaveMarketCell {
    func dateFormmeted(data: FavoriteTable) -> Date.FormatStyle.FormatOutput {
        let locale = Locale(identifier: "ko-KR")
        let result = data.date.formatted(.dateTime.locale(locale).day().month(.twoDigits).year())
        return result
    }
}
