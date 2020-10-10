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
    private var cellViewModels:[AnyObject] = [AnyObject]()
    
    override init() {
    }
    
    init(movieId:Int) {
        super.init()
        self.getMovieDetails(movieId: movieId)
        self.getMovieCredits(movieId: movieId)
    }
    
    //NIB
    var detailCellNib:UINib{
        return UINib.init(nibName: "MovieDetailCell", bundle: nil)
    }
    
    var detailCellIdentifier:String{
      return "MovieDetailCell"
    }
    
    var castCrewCellNib:UINib{
        return UINib.init(nibName: "CastCrewTableCell", bundle: nil)
    }
    
    var castCrewCellIdentifier:String{
      return "CastCrewTableCell"
    }
    
    var similarMovieCellNib:UINib{
        return UINib.init(nibName: "MovieDetailCell", bundle: nil)
    }
    
    var similarMovieCellIdentifier:String{
      return "MovieDetailCell"
    }
    
    
    
    var items:[AnyObject] {
        return cellViewModels
    }
    
//    
    //MARK:- API Work
    private func getMovieDetails(movieId:Int) {

        self.observerBlock?(.dataLoading)
        let httpClient = HTTPClient.init(session: URLSession.shared)
        httpClient.dataTask(MovieDB.movieDetails(movieId)) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                guard let data = data else { self.observerBlock?(.dataFailed); return }
                
                let jsonDecoder = JSONDecoder()
                do {
                    let movieDetailedModel = try jsonDecoder.decode(MovieDetailedModel.self, from: data)
                    self.cellViewModels.insert(movieDetailedModel as AnyObject, at: 0)
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
    
    private func getMovieCredits(movieId:Int) {

          self.observerBlock?(.dataLoading)
        let httpClient = HTTPClient.init(session: URLSession.shared)
          httpClient.dataTask(MovieDB.movieCredits(movieId)) { [weak self] (result) in
              guard let self = self else { return }
              
              switch result {
              case .success(let data):
                  guard let data = data else { self.observerBlock?(.dataFailed); return }
                  
                  DispatchQueue.main.async {
                    let jsonDecoder = JSONDecoder()
                    do {
                        let creditsData = try jsonDecoder.decode(CreditsModel.self, from: data)
                      if let cast = creditsData.cast {
                          self.cellViewModels.append(CastCrewCellViewModel.init(castArray: cast) as AnyObject)
                      }
                      
                      if let crew = creditsData.crew {
                          self.cellViewModels.append(CastCrewCellViewModel.init(crewArray: crew) as AnyObject)
                      }
                      
                        self.observerBlock?(.dataLoaded)
                    } catch {
                        print(error.localizedDescription)
                        self.observerBlock?(.dataFailed)
                    }
                  }
              case .failure(_):
                  self.observerBlock?(.dataFailed)
              }
          }
      }
    
}
