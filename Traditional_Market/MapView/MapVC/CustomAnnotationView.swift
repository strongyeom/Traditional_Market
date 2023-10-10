//
//  CustomAnnotationView.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/09/27.
//

import UIKit
import MapKit

class CustomAnnotationView : MKAnnotationView {
    
    let backgroundView = UIView()
    
    var titleLabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 9, weight: .regular)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    var customImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var stackView = {
        let view = UIStackView(arrangedSubviews: [customImageView, titleLabel])
        view.spacing = 5
        view.axis = .vertical
        return view
    }()
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        configureView()
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        // MKAnnotation의 크기를 정함
        bounds.size = CGSize(width: 70, height: 70)
        self.addSubview(backgroundView)
        backgroundView.addSubview(stackView)
    }
    
    func setConstraints() {
        backgroundView.snp.makeConstraints { make in
            make.size.equalTo(70)
        }
        
        customImageView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(40)
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
        }
    }
    
    // Annotation도 재사용을 하므로 재사용 전 값을 초기화 시켜서 다른 값이 들어가는 것을 방지
    override func prepareForReuse() {
        super.prepareForReuse()
        customImageView.image = nil
        titleLabel.text = nil
    }
    
    // 이 메서드는 annotation이 뷰에서 표시되기 전에 호출됩니다.
    // 즉, 뷰에 들어갈 값을 미리 설정할 수 있습니다
    override func prepareForDisplay() {
        super.prepareForDisplay()
        
        guard let annotation = annotation as? CustomAnnotation else { return }
        
        titleLabel.text = annotation.title
        if let imageName = annotation.imageName, let image = UIImage(named: imageName) {
            
            customImageView.image = image
        }
    }
}
