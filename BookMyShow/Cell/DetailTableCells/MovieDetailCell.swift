//
//  MovieDetailCell.swift
//  BookMyShow
//
//  Created by Neeraj Solanki on 10/10/20.
//  Copyright © 2020 Mr.Solanki. All rights reserved.
//

import UIKit

class MovieDetailCell: UITableViewCell {
    
    //MARK:- Outlets
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var storyLineLabel: UILabel!
    
    @IBOutlet weak var movieGradientView: UIView!
    //MARK:- LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code'
        createGradientLayer()
    }
    
    func createGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: movieGradientView.frame.size.height)
        gradientLayer.colors = [UIColor.black.withAlphaComponent(0.0).cgColor, UIColor.black.withAlphaComponent(0.7).cgColor,UIColor.black.withAlphaComponent(1).cgColor]
        gradientLayer.zPosition = -1
        movieGradientView.layer.addSublayer(gradientLayer)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK:- Custom Methods
    func configureCell(movie:MovieCellViewModel) {
        genreLabel.text = movie.genre
        storyLineLabel.text = movie.storyline
        movieTitleLabel.text = movie.movieTitle
        overviewLabel.text = movie.releaseDate
        movie.downloadImage(completion: { [weak self] (image) in
            let ratio = image?.size.width ?? 0 / (image?.size.height)!
            self?.posterImageView.widthAnchor
                .constraint(equalTo: (self?.posterImageView.heightAnchor)!, multiplier: ratio).isActive = true
            self?.posterImageView.image = image
            
        })
    }
    
    //MARK:- Actions
    @IBAction func playAction(_ sender: UIButton) {
    }
}
