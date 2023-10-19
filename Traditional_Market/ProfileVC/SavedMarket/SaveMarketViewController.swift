//
//  SaveMarketViewController.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/10/12.
//

import UIKit
import RealmSwift

class SaveMarketViewController : BaseViewController {

    let saveTableView = SaveTableView()
    
    let realmManager = RealmManager()
    
    override func loadView() {
        self.view = saveTableView
    }
    
    override func configureView() {
        super.configureView()
        print("SaveMarketViewController - configureView")
        settuptableView()
        navigationItem.title = "시장 컬렉션"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.saveTableView.tableView.reloadData()
    }
    
    func settuptableView() {
        saveTableView.tableView.delegate = self
        saveTableView.tableView.dataSource = self
    }
}

extension SaveMarketViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedMarket =  realmManager.allOfFavoriteRealmCount()[indexPath.row]
        let savedView = SavedDetailViewController()
        savedView.savedSelectedData = selectedMarket
        let nav = UINavigationController(rootViewController: savedView)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return realmManager.allOfFavoriteRealmCount().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SaveMarketCell.identifier, for: indexPath) as? SaveMarketCell else { return UITableViewCell() }
        let data = realmManager.allOfFavoriteRealmCount()[indexPath.row]
        cell.configureView(data: data)
        cell.saveImageView.image = loadImageFromDocument(fileName: "myPhoto_\(data._id).jpg")
        return cell
    }
    
 
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let data = realmManager.allOfFavoriteRealmCount()[indexPath.row]
        
        // 스와이핑 편집
        let edit = UIContextualAction(style: .normal, title: "편집") { _, _, _ in
            // 아무 작업도 하지 않았을때 스와이프 액션이 취소 됨 즉, 원래상태로 돌아감
            self.saveTableView.tableView.setEditing(false, animated: true)
            let savedView = SavedDetailViewController()
            savedView.savedSelectedData = self.realmManager.allOfFavoriteRealmCount()[indexPath.row]
            savedView.savedDetailView.memoTextView.isEditable = true
            savedView.editState = false
            
            let nav = UINavigationController(rootViewController: savedView)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
            
        }
        
        // 스와이핑 삭제
        let delete = UIContextualAction(style: .destructive, title: "삭제") { action, _, _ in
            self.showAlert(title: "삭제하시겠습니까?", btnTitle: "삭제", message: "삭제하시면 데이터는 영구히 삭제됩니다.", style: .destructive) { _ in
                print("삭제 버튼 눌림")
                self.removeImageFromDocument(fileName: "myPhoto_\(data._id).jpg")
                self.realmManager.selectedRemoveData(market: data)
                self.saveTableView.tableView.reloadData()
            }
        }
        
        let config = UISwipeActionsConfiguration(actions: [delete, edit])
        // 끝까지 swipe 안되게 설정
        config.performsFirstActionWithFullSwipe = false
        
        return config
    }
}
