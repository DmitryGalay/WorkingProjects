//
//  CollectionViewCell.swift
//  CollectionView
//
//  Created by Dima on 4.10.21.
//

import UIKit
import Gemini

class MyImageViewCell:
    UICollectionViewCell {
//    GeminiCell {
    
    @IBOutlet weak var imageView: UIImageView!
//    func setCell(imageName: String ) {
//        imageView.image = UIImage(named: imageName)
//    }
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}