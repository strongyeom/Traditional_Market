//
//  SaveTableView.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/10/12.
//

import UIKit

class SaveTableView : BaseView {
    
    let tableView = UITableView(frame: .zero, style: .plain)
    
    
    override func configureView() {
        self.addSubview(tableView)
        tableView.rowHeight = 80
        tableView.backgroundColor = .orange
        tableView.register(SaveMarketCell.self, forCellReuseIdentifier: SaveMarketCell.identifier)
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
