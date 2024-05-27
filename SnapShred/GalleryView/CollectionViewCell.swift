//
//  CollectionViewCell.swift
//  SnapShred
//
//  Created by Aditya on 5/21/24.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    static let cellIdentifier = "CollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configure(with image: UIImage) {
        imageView.image = image
    }
    
    static func nib() -> UINib {
        return UINib(nibName: cellIdentifier, bundle: nil)
    }

}
