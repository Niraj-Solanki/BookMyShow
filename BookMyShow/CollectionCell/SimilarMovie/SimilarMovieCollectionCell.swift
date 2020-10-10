//
//  SimilarMovieCollectionCell.swift
//  BookMyShow
//
//  Created by Neeraj Solanki on 11/10/20.
//  Copyright © 2020 Mr.Solanki. All rights reserved.
//

import UIKit

class SimilarMovieCollectionCell: UICollectionViewCell {
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overViewlabel: UILabel!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var mainView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(viewModel:MovieCellViewModel) {
        titleLabel.text = viewModel.movieTitle
        overViewlabel.text = viewModel.releaseDate
        self.posterImageView.image = nil
        
        viewModel.downloadImage { [weak self] (image) in
            self?.posterImageView.image = image
        }
    }
}
