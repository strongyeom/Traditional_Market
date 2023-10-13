//
//  SavedDetailViewController.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/10/13.
//

import UIKit
import RealmSwift

class SavedDetailViewController : BaseViewController {
    
    let savedDetailView = SavedDetailView()
    
    let realmManager = RealmManager()
    
    var savedSelectedData: FavoriteTable?
    
    var editState: Bool = true
    
    override func configureView() {
        super.configureView()
        guard let savedSelectedData else { return }
        settupNavigationBar()
        view.addSubview(savedDetailView)
        savedDetailView.savedImageView.image = loadImageFromDocument(fileName: "myPhoto_\(savedSelectedData.marketName)_\(savedSelectedData.latitude).jpg")
        savedDetailView.configureSavedView(market: savedSelectedData)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.rightBarButtonItem?.isHidden = editState
    }
    
    func settupNavigationBar() {
        navigationItem.title = "상세 페이지"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveBtnClicked(_:)))
    }
    
    @objc func saveBtnClicked(_ seder: UIBarButtonItem) {
        print("저장 버튼 눌림")
        guard let savedSelectedData else { return }
        
        
        realmManager.updateItem(id: savedSelectedData._id, memoText: savedDetailView.memoTextView.text!)
        
        savedDetailView.memoTextView.isEditable = false
        navigationItem.rightBarButtonItem?.isHidden = true
        navigationController?.popViewController(animated: true)
    }
    
    override func setConstraints() {
        savedDetailView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    
}

