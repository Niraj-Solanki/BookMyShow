//
//  MovieDetailViewModel.swift
//  BookMyShow
//
//  Created by Neeraj Solanki on 10/10/20.
//  Copyright © 2020 Mr.Solanki. All rights reserved.
//

import UIKit

enum MovieDetailObserverEnum {
    case dataLoading
    case dataLoaded
    case dataFailed
    case networkErroor
}

class MovieDetailViewModel : NSObject {
    
    var observerBlock:((_ observerType:MovieDetailObserverEnum)->Void)?
    private var movieDetailedModel:MovieDetailedModel?
    private var cellViewModels:[AnyObject] = [AnyObject]()
    
    private var isApiRunning = false
    private let loaderAlert = UIAlertController(title: nil, message: "Fetching Data...", preferredStyle: .alert)
    
    override init() {
    }
    
    init(movieId:Int) {
        super.init()
        self.getMovieDetails(movieId: movieId)
    }
    
    var detailCellNib:UINib{
        return UINib.init(nibName: "MovieDetailCell", bundle: nil)
    }
    
    var reusableIdentifier:String{
        return "MovieDetailCell"
    }
    
    var items:[AnyObject] {
        return cellViewModels
    }
    
//    
    //MARK:- API Work
    private func getMovieDetails(movieId:Int) {

        self.observerBlock?(.dataLoading)
        HTTPClient.shared.dataTask(MovieDB.movieDetails(movieId)) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                guard let data = data else { self.observerBlock?(.dataFailed); return }
                
                let jsonDecoder = JSONDecoder()
                do {
                    self.movieDetailedModel = try jsonDecoder.decode(MovieDetailedModel.self, from: data)
                    self.cellViewModels.append(self.movieDetailedModel as AnyObject)
                    self.observerBlock?(.dataLoaded)
                } catch {
                    print(error.localizedDescription)
                    self.observerBlock?(.dataFailed)
                }
                
            case .failure(_):
                self.observerBlock?(.dataFailed)
            }
        }
    }
    
}
