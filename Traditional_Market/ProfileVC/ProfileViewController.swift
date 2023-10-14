//
//  ProfileViewAnotherController.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/10/05.
//

import UIKit
import RealmSwift

class ProfileViewController : BaseViewController {

    
    let profileBaseView = ProfileBaseView()

    let realmManager = RealmManager()

    override func loadView() {
        self.view = profileBaseView
    }
    
    var realmFavorite: Results<FavoriteTable>? {
        didSet {
            self.profileBaseView.tableView.reloadData()
        }
    }
    
    override func configureView() {
        super.configureView()
        navigationItem.title = "마이페이지"
        configureTableView()
    }
    
    func configureTableView() {
        profileBaseView.tableView.dataSource = self
        profileBaseView.tableView.delegate = self
        profileBaseView.levelDelegate = self
        profileBaseView.likeBtnDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // MARK: - FavoriteData를 가져오고 있음
        realmFavorite = realmManager.allOfFavoriteRealmCount()
        let favoriteDataCount = realmFavorite?.count ?? 0
        
        profileBaseView.stampCountLabel.text = "\(favoriteDataCount)개"
    }
    
}

extension ProfileViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileBaseView.infoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: InfomationCell.self)) as! InfomationCell
        cell.infoText.text = profileBaseView.infoList[indexPath.row]
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 해당 Cell을 눌렀을때 분기 처리해주기 -> Enum 만들기
    }
}

extension ProfileViewController : ActionDelegate {
    func likeBtnClicked() {
        let saveMarket = SaveMarketViewController()
        navigationController?.pushViewController(saveMarket, animated: true)
    }
    
    func levelInfo() {
        let levelInfoVC = LevelInfoViewController()
        present(levelInfoVC, animated: true)
    }
}
