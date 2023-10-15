//
//  ProfileViewAnotherController.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/10/05.
//

import UIKit
import RealmSwift

class ProfileViewController : BaseViewController {

    
    let viewModel = TraditionalMarketViewModel()
    
    let profileBaseView = ProfileBaseView()

    override func loadView() {
        self.view = profileBaseView
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
        profileBaseView.stampCountLabel.text = "\(viewModel.myFavoriteMarketList.value.count)개"
    }
    
}

extension ProfileViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileBaseView.infoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: InfomationCell.self)) as! InfomationCell
        let infoList = profileBaseView.infoList[indexPath.row]
        cell.configureCell(infoList: infoList)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 해당 Cell을 눌렀을때 분기 처리해주기 -> Enum 만들기
    }
}

extension ProfileViewController : ActionDelegate {
    func mySavedMarketList() {
        let saveMarket = SaveMarketViewController()
        navigationController?.pushViewController(saveMarket, animated: true)
    }
    
    func levelInfo() {
        let levelInfoVC = LevelInfoViewController()
        present(levelInfoVC, animated: true)
    }
}
