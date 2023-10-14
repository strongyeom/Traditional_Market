//
//  TopView.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/10/12.
//

import UIKit


protocol ActionDelegate: AnyObject {
    func levelInfo()
    func likeBtnClicked()
}

class ProfileBaseView : BaseView {
    
    let infoList = [
    "앱 소개",
    "개인정보방침",
    "버전 정보"
    ]
    
    let tableView = UITableView(frame: .zero, style: .plain)
    
    let profileImageView = {
        let view = UIImageView()
        view.basicSettingImageView()
        return view
    }()
    
    let profileNickName = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        view.text = "나의 백반 기행"
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
        view.mypageSetupButton()
        return view
    }()
    
    lazy var profileHorizatalStackView = {
        let stack = UIStackView(arrangedSubviews: [profileImageView, profileNickName])
        stack.basicSettingStackView(axis: .horizontal, spacing: 5, alignment: .center, distribution: .fill)
        return stack
    }()
    
    
    
    lazy var verticalStampeStackView = {
        let stack = UIStackView(arrangedSubviews: [stampLabel, stampCountLabel])
        stack.mypageSetupStackView()
        return stack
    }()
    
    lazy var levelInfoStackView = {
        let stack = UIStackView(arrangedSubviews: [levelLabel, infoLevelBtn])
        stack.basicSettingStackView(axis: .horizontal, spacing: 2, alignment: .fill, distribution: .fill)
        return stack
    }()
    
    lazy var verticalLevelStackView = {
        let stack = UIStackView(arrangedSubviews: [levelInfoStackView, levelCountLabel])
        stack.mypageSetupStackView()
        return stack
    }()
    

    
    lazy var stampInfoHorizantalStackView = {
        let stack = UIStackView(arrangedSubviews: [verticalStampeStackView, verticalLevelStackView, likeBtn])
        stack.basicSettingStackView(axis: .horizontal, spacing: 10, alignment: .fill, distribution: .fillEqually)
        return stack
    }()
    
    
    weak var levelDelegate: ActionDelegate?
    
    weak var likeBtnDelegate: ActionDelegate?
    
    override func configureView() {
        self.addSubview(profileHorizatalStackView)
        self.addSubview(stampInfoHorizantalStackView)
        self.addSubview(tableView)
        setupButtonTarget()
        setupTableView()
    }
    
    func setupButtonTarget() {
        self.infoLevelBtn.addTarget(self, action: #selector(infoLevelBtnClicked(_:)), for: .touchUpInside)
        self.likeBtn.addTarget(self, action: #selector(likeBtnClicked(_:)), for: .touchUpInside)
    }
    
    @objc func likeBtnClicked(_ sender: UIButton) {
        print("내가 저장한 시장 버튼 눌림 - TopView")
        likeBtnDelegate?.likeBtnClicked()
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
        
        profileImageView.image = UIImage(systemName: "person")
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(60)
        }
        
        profileHorizatalStackView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(10)
        }
        
        stampInfoHorizantalStackView.snp.makeConstraints { make in
            make.top.equalTo(profileHorizatalStackView.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(profileHorizatalStackView)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(stampInfoHorizantalStackView.snp.bottom).offset(10)
            make.bottom.horizontalEdges.equalToSuperview().inset(10)
        }
    }
}

extension ProfileBaseView {
    func setupTableView() {
        tableView.rowHeight = 50
        tableView.alwaysBounceVertical = false
        tableView.separatorStyle = .none
        tableView.register(InfomationCell.self, forCellReuseIdentifier: String(describing: InfomationCell.self))
    }
}
