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
        settuptableView()
        navigationItem.title = "내가 저장한 시장"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        saveRealmMarket = realmManager.allOfFavoriteRealmCount()
    }
    
    
    func settuptableView() {
        
        saveTableView.tableView.delegate = self
        saveTableView.tableView.dataSource = self
    }
}

extension SaveMarketViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let saveRealmMarket else { return 0 }
        return saveRealmMarket.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SaveMarketCell.identifier, for: indexPath) as? SaveMarketCell,
            let saveRealmMarket = saveRealmMarket
        else { return UITableViewCell() }
        //let row = list[indexPath.row]
        let data = saveRealmMarket[indexPath.row]
        cell.marketTitle.text = data.marketName
        cell.marketDescription.text = data.memo
        cell.saveImageView.image = loadImageFromDocument(fileName: "myPhoto_ \(data.date).jpg")
        return cell
    }
}
