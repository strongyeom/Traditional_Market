//
//  FullImageViewController.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/10/10.
//

import UIKit
import Kingfisher

class FullImageViewController : BaseViewController {
    
    let selectedImage = {
       let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    let cancelBtn = {
       let view = UIButton()
        view.setImage(UIImage(systemName: "xmark"), for: .normal)
        view.tintColor = .systemBlue
        view.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 23), forImageIn: .normal)
        return view
    }()
    
    
    var imageUrl: String?
    
    
    override func configureView() {
        super.configureView()
        view.addSubview(selectedImage)
        selectedImage.addSubview(cancelBtn)
        
        guard let url = imageUrl, let urlString = URL(string: url) else { return }
        selectedImage.kf.setImage(with: urlString)
        self.cancelBtn.addTarget(self, action: #selector(cancelBtnClicked), for: .touchUpInside)
    }
    
    @objc func cancelBtnClicked() {
        dismiss(animated: true)
        print("cancelBtnClicked")
    }
    
    override func setConstraints() {
        selectedImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        cancelBtn.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.leading.top.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
    }
}
