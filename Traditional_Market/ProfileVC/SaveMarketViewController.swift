//
//  SaveMarketViewController.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/10/12.
//

import UIKit

class SaveMarketViewController : BaseViewController {
    
    let tableView = UITableView(frame: .zero, style: .plain)
    
    override func configureView() {
        super.configureView()
        settuptableView()
        navigationItem.title = "내가 저장한 시장"
        view.addSubview(tableView)
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func settuptableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80
        tableView.backgroundColor = .orange
        tableView.register(SaveMarketCell.self, forCellReuseIdentifier: SaveMarketCell.identifier)
    }
}

extension SaveMarketViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SaveMarketCell.identifier, for: indexPath) as? SaveMarketCell else { return UITableViewCell() }
        //let row = list[indexPath.row]
        
        return cell
    }
}
