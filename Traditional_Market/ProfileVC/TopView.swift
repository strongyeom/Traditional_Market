//
//  TopView.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/10/12.
//

import UIKit


protocol LevelDelegate: AnyObject {
    func levelInfo()
}

class TopView : BaseView {
    
    let profileImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.layer.cornerCurve = .continuous
        view.backgroundColor = .lightGray
        return view
    }()
    
    let profileNickName = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        view.text = "나의 백반 기행"
        view.backgroundColor = .green
        return view
    }()
    
    let infoBaseView = UIView()
    
    let stampLabel = {
        let view = UILabel()
        view.text = "스탬프 갯수"
        view.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        return view
    }()
    
    let stampCountLabel = {
        let view = UILabel()
        view.text = "8개"
        return view
    }()
    
    let levelLabel = {
        let view = UILabel()
        view.text = "레벨"
        view.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        return view
    }()
    
    let infoLevelBtn = {
       let view = UIButton()
        view.setImage(UIImage(systemName: "info.circle"), for: .normal)
        return view
    }()
    
    let levelCountLabel = {
        let view = UILabel()
        view.text = "양민"
        return view
    }()
 
    let likeBtn = {
        let view = UIButton()
        var config = UIButton.Configuration.plain()
        config.title = "내가 저장한 사진"
        config.titleAlignment = .center
        config.buttonSize = .medium
        config.image = UIImage(systemName: "arrow.forward")
        config.imagePadding = 7
        config.imagePlacement = .trailing
        config.baseForegroundColor = .black
        view.configuration = config
        return view
    }()
    
    lazy var verticalStampeStackView = {
        let stack = UIStackView(arrangedSubviews: [stampLabel, stampCountLabel])
        stack.axis = .vertical
        stack.spacing = 5
        stack.alignment = .center
        stack.distribution = .fill
        stack.backgroundColor = .yellow
        return stack
    }()
    
    lazy var levelInfoStackView = {
        let stack = UIStackView(arrangedSubviews: [levelLabel, infoLevelBtn])
        stack.axis = .horizontal
        stack.spacing = 1
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }()
    
    lazy var verticalLevelStackView = {
        let stack = UIStackView(arrangedSubviews: [levelInfoStackView, levelCountLabel])
        stack.axis = .vertical
        stack.spacing = 5
        stack.alignment = .center
        stack.distribution = .fill
        stack.backgroundColor = .yellow
        return stack
    }()
    
    lazy var profileHorizatalStackView = {
        let stack = UIStackView(arrangedSubviews: [profileImageView, profileNickName])
        stack.axis = .horizontal
        stack.spacing = 5
        stack.alignment = .center
        stack.distribution = .fill
        return stack
    }()
    
    lazy var stampInfoHorizantalStackView = {
        let stack = UIStackView(arrangedSubviews: [verticalStampeStackView, verticalLevelStackView, likeBtn])
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.backgroundColor = .red
        return stack
    }()
    
    
    weak var levelDelegate: LevelDelegate?
    
    
    
    override func configureView() {
        self.addSubview(profileHorizatalStackView)
        self.addSubview(stampInfoHorizantalStackView)
        setupButtonTarget()
    }
    
    func setupButtonTarget() {
        self.infoLevelBtn.addTarget(self, action: #selector(infoLevelBtnClicked(_:)), for: .touchUpInside)
       // self.likeBtn.addTarget(self, action: #selector(<#T##@objc method#>), for: .touchUpInside)
    }
    
    @objc func infoLevelBtnClicked(_ sender: UIButton) {
        print("레벨 정보 버튼 눌림 - TopView")
        levelDelegate?.levelInfo()
    }
    
    override func setConstraints() {
        
        stampCountLabel.snp.makeConstraints { make in
            make.height.equalTo(30)
        }
        
        levelCountLabel.snp.makeConstraints { make in
            make.height.equalTo(stampCountLabel).priority(.high)
        }
        
        
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(60)
        }
        
        profileHorizatalStackView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(10)
        }
        
        stampInfoHorizantalStackView.snp.makeConstraints { make in
            make.top.equalTo(profileHorizatalStackView.snp.bottom).offset(10)
            make.horizontalEdges.bottom.equalToSuperview().inset(10)
        }
    }
}
