//
//  TopView.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/10/12.
//

import UIKit


protocol ActionDelegate: AnyObject {
    func mySavedMarketList()
}

class ProfileBaseView : BaseView {
    
    let infoList = [
    "앱 소개",
    "개인정보방침",
    "버전 1.0.0"
    ]
    
    let profileBaseView = {
       let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.cornerCurve = .continuous
        view.clipsToBounds = true
        view.backgroundColor = UIColor(named: "selectedColor")
        return view
    }()
    
    let tableView = UITableView(frame: .zero, style: .plain)
    
    let profileImageView = {
        let view = UIImageView()
        view.basicSettingImageView()
        return view
    }()
    
    let profileNickName = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        view.text = "식도락 여행가"
        return view
    }()
    
    let infoBaseView = UIView()
    
    let stampLabel = {
        let view = UILabel()
        view.text = "스탬프 갯수"
        view.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        view.textColor = .gray
        return view
    }()
    
    let stampCountLabel = {
        let view = UILabel()
        view.text = "00000000개"
        view.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        view.adjustsFontSizeToFitWidth = true
        return view
    }()
    
    let levelLabel = {
        let view = UILabel()
        view.text = "레벨"
        view.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        view.textColor = .gray
        return view
    }()
    
    let levelCountLabel = {
        let view = UILabel()
        view.text = "LV.1000"
        view.font = UIFont.systemFont(ofSize: 15, weight: .bold)
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
 
    lazy var verticalLevelStackView = {
        let stack = UIStackView(arrangedSubviews: [levelLabel, levelCountLabel])
        stack.mypageSetupStackView()
        return stack
    }()
    

    
    lazy var stampInfoHorizantalStackView = {
        let stack = UIStackView(arrangedSubviews: [verticalStampeStackView, verticalLevelStackView, likeBtn])
        stack.basicSettingStackView(axis: .horizontal, spacing: 10, alignment: .fill, distribution: .fillEqually)
        return stack
    }()
    
   
    weak var likeBtnDelegate: ActionDelegate?
    
    override func configureView() {
        
        self.addSubview(profileBaseView)
        [profileHorizatalStackView, stampInfoHorizantalStackView].forEach {
            profileBaseView.addSubview($0)
        }
        self.addSubview(tableView)
        setupButtonTarget()
        setupTableView()
    }
    
    func setupButtonTarget() {
        self.likeBtn.addTarget(self, action: #selector(likeBtnClicked(_:)), for: .touchUpInside)
    }
    
    @objc func likeBtnClicked(_ sender: UIButton) {
        print("내가 저장한 시장 버튼 눌림 - TopView")
        likeBtnDelegate?.mySavedMarketList()
    }

    override func setConstraints() {
        
        profileBaseView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(10)
        }
   
        profileImageView.image = UIImage(named: "profileImage")
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(60)
        }
        
        stampLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        
        levelLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        
        profileHorizatalStackView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(profileBaseView).inset(10)
        }
        
        stampInfoHorizantalStackView.snp.makeConstraints { make in
            make.top.equalTo(profileHorizatalStackView.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(profileHorizatalStackView)
            make.bottom.equalToSuperview().inset(10)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(profileBaseView.snp.bottom).offset(7)
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
