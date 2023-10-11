//
//  StampView.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/10/02.
//

import UIKit

class StampView : BaseView {
    
    let bgView = {
       let view = UIView()
        view.backgroundColor = UIColor.bgViewColor()
        return view
    }()
    
    
    
    lazy var stampImage = {
       let view = UIImageView(image: UIImage(named: "basicStamp"))
        view.isUserInteractionEnabled = true
        return view
    }()
    
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
        view.setTextViewLayout()
        return view
    }()
    
    let cancelButton = {
       let view = UIButton()
        view.stampBtnLayout(text: "취소")
        return view
    }()
    
    let saveButton = {
        let view = UIButton()
        view.stampBtnLayout(text: "저장")
        return view
    }()
    
    lazy var stackView = {
        let stack = UIStackView(arrangedSubviews: [cancelButton, saveButton])
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .fill
        stack.distribution = .fillEqually
        return stack
    }()
    
    var cancelCompletion: (() -> Void)?
    
    var saveCompletion: (() -> Void)?
    
    override func configureView() {
        [bgView, stampImage, marketTitle, memo, memoTextView, stackView].forEach {
            self.addSubview($0)
        }
        cancelButton.addTarget(self, action: #selector(cancelBtnClicked), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveBtnClicked(_:)), for: .touchUpInside)
    }
    
    @objc func cancelBtnClicked() {
        print("StampView - 취소 버튼 눌림 ")
        cancelCompletion?()
    }
    
    @objc func saveBtnClicked(_ sender: UIButton) {
        print("StampView - 저장 버튼 눌림 ")
        saveCompletion?()
    }
    
    override func setConstraints() {
        bgView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        
        stampImage.snp.makeConstraints { make in
            make.centerX.equalTo(self.safeAreaLayoutGuide)
            make.centerY.equalTo(self.safeAreaLayoutGuide).offset(-150)
            make.width.equalTo(self.snp.width).multipliedBy(0.6)
            make.height.equalTo(stampImage.snp.width)
        }
        
        marketTitle.snp.makeConstraints { make in
            make.top.equalTo(stampImage.snp.bottom).offset(2)
            make.horizontalEdges.equalTo(stampImage)
        }
        
        memo.snp.makeConstraints { make in
            make.top.equalTo(marketTitle.snp.bottom).offset(15)
            make.leading.equalTo(self.safeAreaLayoutGuide).inset(16)
        }
        
        memoTextView.snp.makeConstraints { make in
            make.top.equalTo(memo.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(13)
            make.height.equalTo(self).multipliedBy(0.3)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(memoTextView.snp.bottom).offset(10)
            make.horizontalEdges.bottom.equalTo(self.safeAreaLayoutGuide).inset(10)
            
        }
    }
}
