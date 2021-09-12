//
//  CharacterImageView.swift
//  RickAndMorty
//
//  Created by Максим Изварин on 12.09.2021.
//

import UIKit



class CharacterImageView: UIImageView {
    
    private let imageCache = NSCache<NSString, UIImage>()
    
    public func loadImage(from url: String) {
        if let cachedImage = imageCache.object(forKey: url as NSString) {
            image = cachedImage
            return
        }
        
        NetworkManager.shared.loadData(from: url) { result in
            guard let image = UIImage(data: result) else { return }
            self.image = image
            self.imageCache.setObject(image, forKey: url as NSString)
        }
    }
}
