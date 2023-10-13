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
        view.addSubview(savedDetailView)
        settupNavigationBar()
        addKeyboardNotifications()
       
        
        savedDetailView.savedImageView.image = loadImageFromDocument(fileName: "myPhoto_\(savedSelectedData._id).jpg")
        savedDetailView.configureSavedView(market: savedSelectedData)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.rightBarButtonItem?.isHidden = editState
    }
    
    func settupNavigationBar() {
        navigationItem.title = "상세 페이지"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(cancelBtnClicked))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveBtnClicked(_:)))
    }
    
    @objc func cancelBtnClicked() {
        dismiss(animated: true)
    }
    
    @objc func saveBtnClicked(_ seder: UIBarButtonItem) {
        print("저장 버튼 눌림")
        guard let savedSelectedData else { return }
        
        
        realmManager.updateItem(id: savedSelectedData._id, memoText: savedDetailView.memoTextView.text!)
        
        savedDetailView.memoTextView.isEditable = false
        navigationItem.rightBarButtonItem?.isHidden = true
        dismiss(animated: true)
    }
    
    override func setConstraints() {
        savedDetailView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    
}

