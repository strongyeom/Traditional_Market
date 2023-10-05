//
//  DetailCell.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/09/29.
//

import UIKit

final class DetailMarketInfoCell : BaseColletionViewCell {
    
    
    private let imageView = {
       let view = UIImageView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    var ImageUrl: String? {
        didSet {
            // kingFisherLoadImage()
            // imageLoadSDWebImage()
             loadImage()
            //nukeImageLoad()
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
    
    // NSCache 사용
    func loadImage() {
        guard let urlString = ImageUrl, let url = URL(string: urlString) else { return }
        // 이미지 캐시
        let cacheKey = NSString(string: urlString) // 캐시에 사용될 key 값

       //  해당 key에 캐시 이미지가 저장되어 있으면 이미지를 사용
        if let cachedImage = ImageCacheManager.shared.object(forKey: cacheKey) {
            print("imageIconUrl - ⭐️ 해당 이미지가 캐시이미지에 저장되어 있음")
            self.imageView.image = cachedImage
            return
        }
        
        

        DispatchQueue.global().async {
//            guard let data = try? Data(contentsOf: url) else {
//                return
//            }
            
            do {
                let data = try Data(contentsOf: url)
                
                DispatchQueue.main.async {
                    guard let image = UIImage(data: data) else { return }
                    // 다운로드된 이미지를 캐시에 저장
                    print("imageIconUrl - ❗️캐시 이미지에 이미지가 없다면 다운로드된 이미지를 캐시에 저장")
                    ImageCacheManager.shared.setObject(image, forKey: cacheKey)
                    self.imageView.image = image
                }
            } catch {
                print("올바르지 않은 URL 입니다.")
            }

            guard urlString == url.absoluteString else { return }

          
           
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
}
