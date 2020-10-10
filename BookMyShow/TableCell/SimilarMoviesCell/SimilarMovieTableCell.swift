//
//  SimilarMovieTableCell.swift
//  BookMyShow
//
//  Created by Neeraj Solanki on 11/10/20.
//  Copyright © 2020 Mr.Solanki. All rights reserved.
//

import UIKit

class SimilarMovieTableCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var movieCollectionView: UICollectionView!
    
    //MARK:- Objects
    var viewModel:SimilarTableCellViewModel = SimilarTableCellViewModel()
    //MARK:- Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let similarMoviewCellNib = viewModel.nib
        movieCollectionView.register(similarMoviewCellNib, forCellWithReuseIdentifier: viewModel.reusableIdentifier)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK:- Custom Methods
    func configureCell(_ viewModelData:SimilarTableCellViewModel) {
        viewModel = viewModelData
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
        movieCollectionView.reloadData()
    }
    
}

//MARK:- CollectionView Delegate & DataSource
extension SimilarMovieTableCell : UICollectionViewDelegate,UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let movieCell = collectionView.dequeueReusableCell(withReuseIdentifier: viewModel.reusableIdentifier, for: indexPath) as! SimilarMovieCollectionCell
        movieCell.configureCell(viewModel: MovieCellViewModel(movie: viewModel.items[indexPath.row]))
        return movieCell
    }
    
}

extension SimilarMovieTableCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return  viewModel.cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return viewModel.minLineSpacing
    }
}
