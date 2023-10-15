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
       let view = UIImageView(image: UIImage(named: "basicStamp2"))
        view.isUserInteractionEnabled = true
        return view
    }()
    
    let marketTitle = {
       let view = UILabel()
        view.text = "시장 이름"
        view.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        return view
    }()
    
    let marketName = {
       let view =  UILabel()
        view.text = "둔촌시장"
        view.font = .systemFont(ofSize: 17, weight: .medium)
        view.textAlignment = .center
        return view
    }()
    
    let memo = {
       let view = UILabel()
        view.text = "기록하기"
        view.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        return view
    }()
    
    let memoTextView = {
       let view = UITextView()
        view.stampTextViewLayout()
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
        self.addSubview(bgView)
        [stampImage, marketTitle, marketName, memo, memoTextView, stackView].forEach {
            bgView.addSubview($0)
        }
        //stampImageBgView.addSubview(stampImage)
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
            make.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            make.height.equalToSuperview().multipliedBy(0.35)
        }
        
        marketTitle.snp.makeConstraints { make in
            make.top.equalTo(stampImage.snp.bottom).offset(6)
            make.horizontalEdges.equalToSuperview().inset(10)
           // make.height.equalTo(20)
        }
        
        marketName.snp.makeConstraints { make in
            make.top.equalTo(marketTitle.snp.bottom).offset(6)
            make.leading.equalTo(marketTitle)
        }
        
        memo.snp.makeConstraints { make in
            make.top.equalTo(marketName.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(marketName)
        }
        
        memoTextView.snp.makeConstraints { make in
            make.top.equalTo(memo.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(11)
           // make.height.equalTo(self).multipliedBy(0.3)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(memoTextView.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(memoTextView)
            make.bottom.equalToSuperview().inset(20)
        }
    }
}
