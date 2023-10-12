//
//  ProfileViewAnotherController.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/10/05.
//

import UIKit
import RealmSwift

class ProfileViewController : BaseViewController {

    
    let topView = TopView()
    
//    override func loadView() {
//        self.view = topView
//    }
    
    let realmManager = RealmManager()
    
    let infoList = [
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
        setupTableView()
        view.addSubview(topView)
        topView.levelDelegate = self
    }
    
    func setupTableView() {
        
        view.addSubview(tableView)
       tableView.dataSource = self
       tableView.delegate = self
       tableView.rowHeight = 50
       tableView.alwaysBounceVertical = false
       tableView.separatorStyle = .none
       tableView.register(ExampleCell.self, forCellReuseIdentifier: String(describing: ExampleCell.self))
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // MARK: - FavoriteData를 가져오고 있음
        realmFavorite = realmManager.allOfFavoriteRealmCount()
        let favoriteDataCount = realmFavorite?.count ?? 0
       // stampCountLabel.text = "시장 스탬프 : \(favoriteDataCount)"
    }
    
    override func setConstraints() {
        
        topView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
    
        tableView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(10)
            make.bottom.horizontalEdges.equalToSuperview().inset(10)
        }
        
        
    }
    
    
}

extension ProfileViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ExampleCell.self)) as! ExampleCell
        guard let realmFavorite else { return UITableViewCell() }
        cell.infoText.text = infoList[indexPath.row]
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 해당 Cell을 눌렀을때 분기 처리해주기 -> Enum 만들기
    }
}

extension ProfileViewController : LevelDelegate {
    func levelInfo() {
        let levelInfoVC = LevelInfoViewController()
        present(levelInfoVC, animated: true)
    }
    
    
}
