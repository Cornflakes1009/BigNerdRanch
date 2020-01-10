//
//  ImageStore.swift
//  Homepwner
//
//  Created by HaroldDavidson on 1/3/20.
//  Copyright © 2020 HaroldDavidson. All rights reserved.
//

import UIKit

class ImageStore {
    let cache = NSCache<NSString,UIImage>()
    
    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
        
        // create full image url for image
        let url = imageURL(forKey: key)
        
        // turn image into png data - this was a challenge in the book
        if let data = image.pngData() {
            try? data.write(to: url, options: [.atomic])
        }
        
        // turn image into jpeg data
//        if let data = image.jpegData(compressionQuality: 0.5) {
//            // write it to full URL
//            try? data.write(to: url, options: [.atomic])
//        }
    }
    
    func image(forKey key: String) -> UIImage? {
        if let existingImage = cache.object(forKey: key as NSString) {
            return existingImage
        }
        
        let url = imageURL(forKey: key)
        guard let imageFromDisk = UIImage(contentsOfFile: url.path) else {
            return nil
        }
        
        cache.setObject(imageFromDisk, forKey: key as NSString)
        return imageFromDisk
    }
    
    func deleteImage(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
        
        let url = imageURL(forKey: key)
        do {
            try FileManager.default.removeItem(at: url)
        } catch let deleteError {
            print("Error removing image from disk: \(deleteError)")
        }
    }
    
    func imageURL(forKey key: String) -> URL {
        let documentDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentDirectories.first!
        
        return documentDirectory.appendingPathComponent(key)
    }
}
