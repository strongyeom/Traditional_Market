//
//  DetailConditionViewController.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/10/25.
//

import UIKit

class DetailConditionViewController: BaseViewController {
    
    let detailView = DetailConditionView()
    
    var detailBtnDay: String?
    
    let viewmodel = RealmManager()
    
    var completion: ((String) -> Void)?
    
    override func loadView() {
        self.view = detailView
    }
    
    
    override func configureView() {
        super.configureView()
        self.view.backgroundColor = .clear
        detailView.delegate = self
        
        detailView.completion = { value in
            print("어떤 버튼이 눌렸나? DetailConditionViewController : \(value)")
            self.detailBtnDay = value
        }
        print(#function)
    }
}

extension DetailConditionViewController: ApplyBtnAction {
    func cancelBtnClicked() {
        dismiss(animated: true)
    }
    
    func applyBtnClicked() {
        guard let detailBtnDay else { return }
        print("DetailConditionViewController - applyBtnClicked")
        
        if !detailBtnDay.isEmpty {
            // detailBtnDay에 버튼에 눌린 일자가 담긴다면 dismiss
            completion?(detailBtnDay)
            dismiss(animated: true)
        }
        
    }
    
    
}
