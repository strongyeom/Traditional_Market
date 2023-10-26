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
        return view
    }()

    lazy var stampImage = {
       let view = UIImageView(image: UIImage(named: "downloadingImage"))
        view.isUserInteractionEnabled = true
        return view
    }()

    let marketType = {
        let view = UILabel()
        view.textColor = .lightGray
        view.font = UIFont.systemFont(ofSize: 13)
         return view
    }()
    
    let marketName = {
       let view =  UILabel()
        view.text = "둔촌시장"
        view.font = .systemFont(ofSize: 17, weight: .heavy)
        view.textAlignment = .center
        return view
    }()
    
    let memo = {
       let view = UILabel()
        view.text = "메모 작성"
        view.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        return view
    }()
    
    let memoTextView = {
       let view = UITextView()
        view.stampTextViewLayout()
        return view
    }()
 
    let saveButton = {
        let view = UIButton()
        view.stampBtnLayout(text: "저장", colorname: "btnColor")
        view.layer.cornerRadius = 16
        view.layer.cornerCurve = .continuous
        view.clipsToBounds = true
        view.backgroundColor = UIColor(named: "stampColor")
        return view
    }()

    var cancelCompletion: (() -> Void)?
    
    var saveCompletion: (() -> Void)?
    
    override func configureView() {
        self.addSubview(bgView)
        [stampImage, saveButton, marketName, memo, memoTextView, marketType].forEach {
            bgView.addSubview($0)
        }
  
        saveButton.addTarget(self, action: #selector(saveBtnClicked(_:)), for: .touchUpInside)
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
            make.height.equalTo(stampImage.snp.width)
        }
        
        marketName.snp.makeConstraints { make in
            make.top.equalTo(stampImage.snp.bottom).offset(9)
            make.leading.equalToSuperview().inset(10)
        }
        
        marketType.snp.makeConstraints { make in
            make.centerY.equalTo(marketName)
            make.leading.equalTo(marketName.snp.trailing).offset(6)
        }
        
        memo.snp.makeConstraints { make in
            make.top.equalTo(marketName.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(marketName)
        }
        
        memoTextView.snp.makeConstraints { make in
            make.top.equalTo(memo.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(11)
           // make.height.equalTo(self).multipliedBy(0.35)
        }

        saveButton.snp.makeConstraints { make in
            make.top.equalTo(memoTextView.snp.bottom).offset(15)
            make.horizontalEdges.equalTo(memoTextView)
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(15)
            make.height.equalTo(44)
        }
    }
}
