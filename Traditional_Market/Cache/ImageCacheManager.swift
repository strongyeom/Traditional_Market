//
//  ImageCacheManager.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/10/05.
//

import UIKit

final class ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
    
    private init() { }
    
}
