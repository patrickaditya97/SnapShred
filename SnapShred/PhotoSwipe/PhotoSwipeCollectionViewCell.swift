//
//  PhotoSwipeCollectionViewCell.swift
//  SnapShred
//
//  Created by Aditya on 5/24/24.
//

import UIKit

class PhotoSwipeCollectionViewCell: UICollectionViewCell {

    static let cellIdentifier = "PhotoSwipeCollectionViewCell"
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configure(image: UIImage) {
        imageView.image = image
    }
    
    static func nib() -> UINib {
        return UINib(nibName: cellIdentifier, bundle: nil)
    }

}
