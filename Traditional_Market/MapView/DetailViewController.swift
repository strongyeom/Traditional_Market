//
//  DetailViewController.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/09/29.
//

import UIKit
import RealmSwift

class DetailViewController: BaseViewController {
    
    let label = UILabel()
   
    var selectedMarket: TraditionalMarketRealm? {
        didSet {
            // 데이터가 바뀔때마다 VC를 갱신
            
            // 데이터가 갱신 될떄마다 CompositionalLayout 갱신
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func configureView() {
        super.configureView()
        sheetPresent()

        
      
       
    }
}

extension DetailViewController {
    func sheetPresent() {
        if let sheetPresentationController {
            sheetPresentationController.detents = [.medium(), .large()]
            // dim 처리를 하지 않기 때문에 유저 인터렉션에 반응할 수 있음
            sheetPresentationController.largestUndimmedDetentIdentifier = .medium
            // grabber 설정
            sheetPresentationController.prefersGrabberVisible = true
            // 코너 주기
            sheetPresentationController.preferredCornerRadius = 20
        }
    }
}
