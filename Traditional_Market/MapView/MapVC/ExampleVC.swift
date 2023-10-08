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
    let exampleArray = [
    "123",
    "asdads",
    "agfg",
    "dadda"
    ]
    
    override func configureView() {
        super.configureView()
        print("ExampleVC")
        setTableView()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
      //  print("ExampleVC - \(label.text)")
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.tableView.reloadData()
//    }
//
    func setTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.rowHeight = 44
        tableView.register(ExampleTableCell.self, forCellReuseIdentifier: String(describing: ExampleTableCell.self))
    }
    
    
}

extension ExampleVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exampleArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ExampleTableCell.self), for: indexPath) as! ExampleTableCell
        cell.exampleText.text = exampleArray[indexPath.row]
        return UITableViewCell()
    }
}
