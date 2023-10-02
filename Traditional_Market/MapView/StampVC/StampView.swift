//
//  StampView.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/10/02.
//

import UIKit

class StampView : BaseView {
    
    let view = UIView()
    
    let stampImage = UIImageView()
    
    let marketTitle = {
       let view =  UILabel()
        view.text = "둔촌시장"
        view.font = .systemFont(ofSize: 17, weight: .medium)
        view.textAlignment = .center
        return view
    }()
    
    let memo = {
       let view = UILabel()
        view.text = "기록하기"
        return view
    }()
    
    let memoTextView = {
       let view = UITextView()
        view.layer.borderColor = UIColor.red.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    override func configureView() {
        view.backgroundColor = .yellow
        [view, stampImage, marketTitle, memo, memoTextView].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        view.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        
        stampImage.backgroundColor = .gray
        stampImage.snp.makeConstraints { make in
            make.centerX.equalTo(self.safeAreaLayoutGuide)
            make.centerY.equalTo(self.safeAreaLayoutGuide).offset(-100)
            make.width.equalTo(self.snp.width).multipliedBy(0.6)
            make.height.equalTo(stampImage.snp.width)
        }
        
        marketTitle.snp.makeConstraints { make in
            make.top.equalTo(stampImage.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(stampImage)
        }
        
        memo.snp.makeConstraints { make in
            make.top.equalTo(marketTitle.snp.bottom).offset(15)
            make.leading.equalTo(self.safeAreaLayoutGuide).inset(13)
        }
        
        memoTextView.snp.makeConstraints { make in
            make.top.equalTo(memo.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(13)
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(13)
        }
    }
}
