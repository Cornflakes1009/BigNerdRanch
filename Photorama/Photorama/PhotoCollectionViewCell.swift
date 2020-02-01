//
//  PhotoCollectionViewCell.swift
//  Photorama
//
//  Created by HaroldDavidson on 1/22/20.
//  Copyright © 2020 HaroldDavidson. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    var photoDescription: String?
    
    // start the spinner for the image
    func update(with image: UIImage?) {
        if let imageToDisplay = image {
            spinner.stopAnimating()
            imageView.image = imageToDisplay
        } else {
            spinner.startAnimating()
            imageView.image = nil
        }
    }
    
    // when the cell is first being created. this will reset the spinning state
    override func awakeFromNib() {
        super.awakeFromNib()
        update(with: nil)
    }
    
    // when the cell is being reused. this will reset the spinning state
    override func prepareForReuse() {
        super.prepareForReuse()
        
        update(with: nil)
    }
    
    // enabling accessibility
    override var isAccessibilityElement: Bool {
        get {
            return true
        } set {
            super.isAccessibilityElement = newValue
        }
    }
    
    // getting the accessibility string
    override var accessibilityLabel: String? {
        get {
            return photoDescription
        } set {
            // ignore attempts to set
        }
    }
    
    // letting users know that cells have images
    override var accessibilityTraits: UIAccessibilityTraits {
        get {
            return UIAccessibilityTraits(rawValue: super.accessibilityTraits.rawValue | UIAccessibilityTraits.image.rawValue)
        } set {
            // ignore attempt to set
        }
    }
}
