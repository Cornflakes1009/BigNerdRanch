//
//  PhotosViewController.swift
//  Photorama
//
//  Created by HaroldDavidson on 1/16/20.
//  Copyright © 2020 HaroldDavidson. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var store: PhotoStore!
    
    func updateImageView(for photo: Photo) {
        store.fetchImage(for: photo) {
            (ImageResult) -> Void in
            
            switch ImageResult {
            case let .success(image):
                self.imageView.image = image
            case let .failure(error):
                print("error downloading image: \(error)")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        store.fetchInterestingPhotos {
            (photosResult) -> Void in
            
            switch photosResult {
            case let .success(photos):
                print("Successfully found \(photos.count) photos")
                if let firstPhoto = photos.first {
                    self.updateImageView(for: firstPhoto)
                }
            case let .failure(error):
                print("error fetching interesting photos: \(error)")
            }
        }
    }
}
