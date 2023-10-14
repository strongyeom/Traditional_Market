//
//  DetailCell.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/09/29.
//

import UIKit
import Kingfisher

final class DetailMarketInfoCell : BaseColletionViewCell {
    
    
    private let imageView = {
       let view = UIImageView()
        view.basicSettingImageView()
        return view
    }()
    
    var ImageUrl: String? {
        didSet {
             loadImage()
        }
    }
    
    override func configureView() {
        contentView.addSubview(imageView)
    }
    
    override func setConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func loadImage() {

        guard let url = URL(string: ImageUrl ?? "") else { return }
        imageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "downloadingImage"),
            options: [
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        {
            result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
}
