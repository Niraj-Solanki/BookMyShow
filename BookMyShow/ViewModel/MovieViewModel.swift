//
//  MovieViewModel.swift
//  BookMyShow
//
//  Created by Neeraj Solanki on 10/10/20.
//  Copyright © 2020 Mr.Solanki. All rights reserved.
//

import UIKit
enum MovieObserverEnum {
    case dataLoading
    case dataLoaded
    case dataFailed
    case networkErroor
}

class MovieViewModel : NSObject {
    
    var observerBlock:((_ observerType:MovieObserverEnum)->Void)?
    private var moviesModel:MoviesModel?
    private var lastSearchPage = 0
    
    private var isApiRunning = false
    
    override init() {
        super.init()
        self.getMoviesList(pageNo: currentPage + 1)
    }
    
    var nib:UINib{
        return UINib.init(nibName: "MovieTableCell", bundle: nil)
    }
    
    var reusableIdentifier:String{
        return "MovieTableCell"
    }
    
    var items:[Movie] {
        return moviesModel?.movies ?? []
    }
    
    var currentPage:Int{
        return moviesModel?.page ?? 0
    }
    
    var totalPages:Int{
        return moviesModel?.total_pages ?? 0
    }
    
    func loadMore() {
        getMoviesList(pageNo: currentPage + 1)
    }
    
    //MARK:- API Work
    private func getMoviesList(pageNo:Int) {
        if isApiRunning || lastSearchPage == pageNo {
            return
        }
        
        lastSearchPage = pageNo
        
        self.observerBlock?(.dataLoading)
        let httpClient = HTTPClient.init(session: URLSession.shared)
        httpClient.dataTask(MovieDB.nowPlayings(pageNo)) { [weak self] (result) in
            self?.isApiRunning = false
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                guard let data = data else { self.observerBlock?(.dataFailed); return }
                
                let jsonDecoder = JSONDecoder()
                do {
                    let moviesData = try jsonDecoder.decode(MoviesModel.self, from: data)
                    if moviesData.page ?? 1 == 1 {
                        self.moviesModel = moviesData
                    }
                    else{
                        self.moviesModel?.movies?.append(contentsOf: moviesData.movies ?? [])
                        self.moviesModel?.page = moviesData.page
                    }
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
