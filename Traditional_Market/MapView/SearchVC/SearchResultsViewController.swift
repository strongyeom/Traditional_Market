//
//  ExampleVC.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/10/06.
//

import UIKit
import RealmSwift


class SearchResultsViewController : BaseViewController {
    
    let tableView = UITableView(frame: .zero, style: .grouped)

    var filterData: Results<TraditionalMarketRealm>?
    
    var completion: ((TraditionalMarketRealm) -> Void)?
    
    override func configureView() {
        super.configureView()
        print("ExampleVC")
        setTableView()
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
  
    func setTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 54
        tableView.register(SearchCell.self, forCellReuseIdentifier: SearchCell.identifier)
    }
    
    
}

extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("SearchResultsViewController - didSelectRowAt")
        guard let filterData else { return }
        let aa = filterData[indexPath.row]
        print("SearchResultsViewController - \(aa.marketName)")
        completion?(aa)
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let filterData else { return 0}
        return filterData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let filterData else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchCell.identifier, for: indexPath) as! SearchCell
        let data = filterData[indexPath.row]
        cell.marketName.text = data.marketName
        cell.marketAddress.text = data.address
        return cell
    }
}
