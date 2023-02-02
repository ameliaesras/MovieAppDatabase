//
//  MoviesCollectionCell.swift
//  TMDB
//
//  Created by Amelia Esra S on 01/02/23.
//  Copyright © 2023 Amelia Esra S. All rights reserved.
//

import UIKit
import Kingfisher

class MoviesCollectionCell: UICollectionViewCell {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var labelTitle: UILabel!
   
    func setData(movie: Movie, size: String) {
        let stringUrlImage = APIConstants.imagesBaseURL + size + movie.posterPath
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: URL(string: stringUrlImage))
        labelTitle.text = movie.title
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.cornerRadius = 12
    }

}
