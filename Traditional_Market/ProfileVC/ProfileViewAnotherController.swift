//
//  ProfileViewAnotherController.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/10/05.
//

import UIKit
import RealmSwift

class ProfileViewAnotherController : BaseViewController {
    
    let topView = UIView()
    
    let realmManager = RealmManager()
    
    let helloTitle = {
       let view = UILabel()
        view.text = "안녕하세요"
        view.textAlignment = .left
        view.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        view.textColor = .gray
        return view
    }()
    
    let nickName = {
       let view = UILabel()
        view.text = "백반기행"
        view.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        return view
    }()
    
    let stampCountLabel = {
       let view = UILabel()
       // view.text = "시장 스탬프 3개"
        view.font = UIFont.systemFont(ofSize: 13)
        return view
    }()
    
    
    let tableList = [
    "내가 방문한 시장",
    "최근 방문한 시장",
    "앱 소개",
    "개인정보방침",
    "버전 정보"
    ]
    
    var realmFavorite: Results<FavoriteTable>? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    let tableView = UITableView(frame: .zero, style: .plain)
    
    
    override func configureView() {
        super.configureView()
        navigationItem.title = "마이페이지"
        
        topView.backgroundColor = .lightGray
        view.addSubview(topView)
        
        [helloTitle, nickName, stampCountLabel].forEach {
            topView.addSubview($0)
        }
        
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 50
        tableView.separatorStyle = .none
        tableView.register(ExampleCell.self, forCellReuseIdentifier: String(describing: ExampleCell.self))
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        realmFavorite = realmManager.allOfFavoriteRealmCount()
        let bb = realmFavorite?.count ?? 0
        stampCountLabel.text = "시장 스탬프 : \(bb)"
    }
    
    override func setConstraints() {
        
        topView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(view.snp.height).multipliedBy(0.2)
        }
        
        helloTitle.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }
        
        nickName.snp.makeConstraints { make in
            make.leading.equalTo(helloTitle)
            make.top.equalTo(helloTitle.snp.bottom).offset(5)
        }
        
        stampCountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(nickName)
            make.trailing.equalToSuperview().inset(10)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(10)
            make.bottom.horizontalEdges.equalToSuperview().inset(10)
        }
        
        
    }
    
    
}

extension ProfileViewAnotherController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return realmFavorite?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ExampleCell.self)) as! ExampleCell
        guard let realmFavorite else { return UITableViewCell() }
        cell.infoText.text = realmFavorite[indexPath.row].marketName
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
