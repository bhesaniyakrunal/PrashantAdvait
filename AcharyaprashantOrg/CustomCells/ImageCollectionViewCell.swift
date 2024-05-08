//
//  ImageCollectionViewCell.swift
//  AcharyaprashantOrg
//
//  Created by MacBook on 5/6/24.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .medium

    }
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}
