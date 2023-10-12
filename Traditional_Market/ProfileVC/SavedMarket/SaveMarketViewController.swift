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
      //  guard let saveRealmMarket else { return }
    }
}

extension SaveMarketViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let saveRealmMarket else { return  }
        let selectedMarket = saveRealmMarket[indexPath.row]
        let savedView = SavedDetailViewController()
        savedView.savedSelectedData = selectedMarket
//        let savedDatailView = SavedDetailView()
//        savedDatailView.savedImageView.image = loadImageFromDocument(fileName: "myPhoto_\(selectedMarket.date).jpg")
//        savedDatailView.configureSavedView(market: selectedMarket)
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
        cell.saveImageView.image = loadImageFromDocument(fileName: "myPhoto_\(data.marketName)_\(data.latitude).jpg")
        return cell
    }
}
