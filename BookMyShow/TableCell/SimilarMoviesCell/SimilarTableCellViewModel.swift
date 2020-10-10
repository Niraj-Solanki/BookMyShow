//
//  SimilarTableCellViewModel.swift
//  BookMyShow
//
//  Created by Neeraj Solanki on 11/10/20.
//  Copyright © 2020 Mr.Solanki. All rights reserved.
//

import UIKit
class SimilarTableCellViewModel {
    
    private var moviesModel:MoviesModel?
    init(){}
    init(modelData:MoviesModel) {
        moviesModel = modelData
    }
    
    var nib:UINib{
        return UINib.init(nibName: "SimilarMovieCollectionCell", bundle: Bundle.main)
    }
    
    var reusableIdentifier:String{
        return "SimilarMovieCollectionCell"
    }
    
    var items:[Movie] {
        return moviesModel?.movies ?? []
    }
    
    var cellSize:CGSize
    {
        let remainSpace = UIScreen.main.bounds.size.width - 30
        return CGSize(width: remainSpace / 2.5, height: 280)
    }
    
    var minLineSpacing:CGFloat
    {
        return 10
    }
}
