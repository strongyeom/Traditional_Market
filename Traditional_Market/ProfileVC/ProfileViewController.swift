//
//  ProfileViewAnotherController.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/10/05.
//

import UIKit
import RealmSwift

class ProfileViewController : BaseViewController {

    let realmManager = RealmManager()
    
    let profileBaseView = ProfileBaseView()

    override func loadView() {
        self.view = profileBaseView
    }
    
    override func configureView() {
        super.configureView()
        navigationItem.title = "마이페이지"
        navigationItem.backButtonDisplayMode = .minimal
        // 상위 VC에 색상 설정하면 하위VC에도 적용됌
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(named: "brandColor")
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        configureTableView()
    }
    
    func configureTableView() {
        profileBaseView.tableView.dataSource = self
        profileBaseView.tableView.delegate = self
        profileBaseView.likeBtnDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        profileBaseView.stampCountLabel.text = "\(realmManager.allOfFavoriteRealmCount().count)개"
        profileBaseView.levelCountLabel.text = realmManager.calculateStampCountToLevelLabel()
    }
    
    // 버전 정보 끌어오는 코드
    func currentAppVersion() -> String {
      if let info: [String: Any] = Bundle.main.infoDictionary,
          let currentVersion: String
            = info["CFBundleShortVersionString"] as? String {
            return currentVersion
      }
      return "nil"
    }
    
}

extension ProfileViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileBaseView.infoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: InfomationCell.self)) as! InfomationCell
        let infoList = profileBaseView.infoList[indexPath.row]
        
        
        if indexPath.row == 2 {
            cell.infoText.text = "버전 " + currentAppVersion()
            cell.accessoryType = .none
            cell.selectionStyle = .none
            cell.infoText.textColor = .lightGray
        } else {
            cell.configureCell(infoList: infoList)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 해당 Cell을 눌렀을때 분기 처리해주기 -> Enum 만들기
        
        let webView = WebViewController()
        switch indexPath.row {
        case 0:
            present(webView, animated: true)
        case 1:
            present(webView, animated: true)
        default:
            break
        }
    }
}

extension ProfileViewController : ActionDelegate {
    func mySavedMarketList() {
        let saveMarket = SaveMarketViewController()
        navigationController?.pushViewController(saveMarket, animated: true)
    }
}
