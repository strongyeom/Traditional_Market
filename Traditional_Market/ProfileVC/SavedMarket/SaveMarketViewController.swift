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
    
    var saveRealmMarket: Results<FavoriteTable>?
    
    override func loadView() {
        self.view = saveTableView
    }
    
    override func configureView() {
        super.configureView()
        print("SaveMarketViewController - configureView")
        settuptableView()
        navigationItem.title = "내가 저장한 시장"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("SaveMarketViewController - viewWillAppear")
        saveRealmMarket = realmManager.allOfFavoriteRealmCount()
    }

    
    func settuptableView() {
        saveTableView.tableView.delegate = self
        saveTableView.tableView.dataSource = self
    }
}

extension SaveMarketViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let saveRealmMarket else { return  }
        let selectedMarket = saveRealmMarket[indexPath.row]
        let savedView = SavedDetailViewController()
        savedView.savedSelectedData = selectedMarket
        navigationController?.pushViewController(savedView, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("SaveMarketViewController - numberOfRowsInSection")
        guard let saveRealmMarket else { return 0 }
        return saveRealmMarket.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("SaveMarketViewController - cellForRowAt")
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SaveMarketCell.identifier, for: indexPath) as? SaveMarketCell,
            let saveRealmMarket = saveRealmMarket
        else { return UITableViewCell() }
        //let row = list[indexPath.row]
        let data = saveRealmMarket[indexPath.row]
        cell.marketTitle.text = data.marketName
        cell.marketDescription.text = data.memo // "myPhoto_\(favoriteMarket._id).jpg"
        cell.saveImageView.image = loadImageFromDocument(fileName: "myPhoto_\(data._id).jpg")
        return cell
    }
 
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let saveRealmMarket else { return UISwipeActionsConfiguration() }
        let data = saveRealmMarket[indexPath.row]
        
        let edit = UIContextualAction(style: .normal, title: "편집") { _, _, _ in
            
        }
        
        let delete = UIContextualAction(style: .destructive, title: "삭제") { _, _, _ in
            self.removeImageFromDocument(fileName: "myPhoto_\(data._id).jpg")
            self.realmManager.selectedRemoveData(market: data)
            self.saveTableView.tableView.reloadData()
        }
        
        return UISwipeActionsConfiguration(actions: [delete, edit])
    }
}

// 삭제하기 전에 이미지 먼저 지우고 그 다음에 Cell 지우기
