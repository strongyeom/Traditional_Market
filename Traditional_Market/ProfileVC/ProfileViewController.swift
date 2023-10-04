//
//  ProfileViewController.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/10/03.
//

import UIKit

class ProfileViewController: BaseViewController {
    
    
    let myInfo = UIView()
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    
    let tableView = UITableView(frame: .zero, style: .grouped)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        super.configureView()
        [myInfo, collectionView, tableView].forEach {
            view.addSubview($0)
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(StampCell.self, forCellWithReuseIdentifier: StampCell.identifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 55
        tableView.register(ListCell.self, forCellReuseIdentifier: String(describing: ListCell.self))
    }
    
    override func setConstraints() {
        myInfo.backgroundColor = .yellow
        myInfo.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(100)
        }
        
        // MARK: - CollectionViewHeader 만들기
        collectionView.backgroundColor = .green
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(myInfo.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(myInfo)
            make.height.equalTo(UIScreen.main.bounds.height * 0.3)
        }
        
        
        // MARK: - TableCiewHeader 만들기
        tableView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(myInfo)
            make.height.equalTo(UIScreen.main.bounds.height * 0.3)
        }
    }
    
    static func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let spacing: CGFloat = 10
        let width = UIScreen.main.bounds.width
        print("가로 길이 :\(width)")
        layout.itemSize = CGSize(width: ((UIScreen.main.bounds.width - (spacing * 6)) / 3), height: ((UIScreen.main.bounds.width - (spacing * 6)) / 3))
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        return layout
    }
}

extension ProfileViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StampCell.identifier, for: indexPath) as? StampCell else { return UICollectionViewCell() }
        
        return cell
    }
}

extension ProfileViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ListCell.self), for: indexPath) as? ListCell else { return UITableViewCell() }
        cell.marketLabel.text = "123123"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}
