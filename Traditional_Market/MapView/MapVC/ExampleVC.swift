//
//  ExampleVC.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/10/06.
//

import UIKit
import RealmSwift

class ExampleVC : BaseViewController {
    
    let tableView = UITableView(frame: .zero, style: .grouped)
    
    let label = UILabel()
    
    var data: Results<TraditionalMarketRealm>?
    
    override func configureView() {
        super.configureView()
       
        guard let data else { return }
        view.addSubview(label)
        label.text = data.first!.marketName
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        print("ExampleVC - \(label.text)")
    }
    
    func setTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.rowHeight = 44
    }
    
    
}

extension ExampleVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
