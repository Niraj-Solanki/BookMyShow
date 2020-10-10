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
    private var movieVideos:MovieVideosModel?
    
    override init() {
    }
    
    init(movieId:Int) {
        super.init()
        self.getMovieDetails(movieId: movieId)
        self.getMovieCredits(movieId: movieId)
        self.getSimilarMovies(movieId: movieId)
        self.getTrailerUrl(movieId: movieId)
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
        return UINib.init(nibName: "SimilarMovieTableCell", bundle: nil)
    }
    
    var similarMovieCellIdentifier:String{
        return "SimilarMovieTableCell"
    }
    
    
    
    var items:[AnyObject] {
        return cellViewModels
    }
    
    var trailerUrl:URL?{
        if let url = movieVideos?.trailers?.first, let videoURL = URL(string: url.urlString ?? "") {
            return videoURL
        }
        return nil
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
                        if let cast = creditsData.cast, cast.count > 0 {
                            if self.cellViewModels.count > 1 {
                                self.cellViewModels.insert(CastCrewCellViewModel(castArray: cast) as AnyObject, at: 1)
                            }
                            else
                            {                                self.cellViewModels.append(CastCrewCellViewModel(castArray: cast) as AnyObject)
                            }
                        }
                        
                        if let crew = creditsData.crew, crew.count > 0 {
                            if self.cellViewModels.count > 2 {
                                self.cellViewModels.insert(CastCrewCellViewModel(crewArray: crew) as AnyObject, at: 2)
                            }
                            else
                            {                                self.cellViewModels.append(CastCrewCellViewModel(crewArray: crew) as AnyObject)
                            }
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
    
    
    private func getSimilarMovies(movieId:Int) {
        self.observerBlock?(.dataLoading)
        let httpClient = HTTPClient.init(session: URLSession.shared)
        httpClient.dataTask(MovieDB.similarMoview(movieId)) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                guard let data = data else { return }
                
                let jsonDecoder = JSONDecoder()
                do {
                    let moviesData = try jsonDecoder.decode(MoviesModel.self, from: data)
                    if moviesData.movies?.count ?? 0 > 0 {
                        self.cellViewModels.append(moviesData as AnyObject)
                        self.observerBlock?(.dataLoaded)
                    }
                } catch {
                    print(error.localizedDescription)
                    self.observerBlock?(.dataFailed)
                }
                
            case .failure(_):
                self.observerBlock?(.dataFailed)
            }
        }
    }
    
    private func getTrailerUrl(movieId:Int) {
          self.observerBlock?(.dataLoading)
          let httpClient = HTTPClient.init(session: URLSession.shared)
          httpClient.dataTask(MovieDB.movieTrailer(movieId)) { [weak self] (result) in
              guard let self = self else { return }
              
              switch result {
              case .success(let data):
                  guard let data = data else { return }
                  
                  let jsonDecoder = JSONDecoder()
                  do {
                    self.movieVideos = try jsonDecoder.decode(MovieVideosModel.self, from: data)
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
