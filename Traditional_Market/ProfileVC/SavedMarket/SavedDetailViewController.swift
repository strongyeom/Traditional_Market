//
//  SavedDetailViewController.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/10/13.
//

import UIKit

class SavedDetailViewController : BaseViewController {
    
    let savedDetailView = SavedDetailView()
    
    var savedSelectedData: FavoriteTable?
    
    override func configureView() {
        super.configureView()
        guard let savedSelectedData else { return }
        view.addSubview(savedDetailView)
        savedDetailView.savedImageView.image = loadImageFromDocument(fileName: "myPhoto_\(savedSelectedData.marketName)_\(savedSelectedData.latitude).jpg")
        savedDetailView.configureSavedView(market: savedSelectedData)
    }
    
    override func setConstraints() {
        savedDetailView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    
}

