//
//  SearchViewModel.swift
//  BookMyShow
//
//  Created by Neeraj Solanki on 11/10/20.
//  Copyright © 2020 Mr.Solanki. All rights reserved.
//

import UIKit

enum SearchObserverEnum {
    case dataLoading
    case dataLoaded
    case dataFailed
    case networkErroor
    case searchUpdated
}

class SearchViewModel : NSObject {
    
    var observerBlock:((_ observerType:SearchObserverEnum)->Void)?
    private var moviesModel:MoviesModel?
    private var isApiRunning = false
    var isSearchBarHighlited = false
    private var lastSearchPage = 0
    
    private var movieItems:[Movie]? {
        didSet{
            observerBlock?(.searchUpdated)
        }
    }
    
    override init() {
        super.init()
        self.getMoviesList(pageNo: currentPage + 1)
    }
    
    private var searchValue:String = ""
    func updateSearch(text:String) {
        searchValue = text
        searchAlgo()
    }
    
    var nib:UINib{
        return UINib.init(nibName: "MovieTableCell", bundle: nil)
    }
    
    var reusableIdentifier:String{
        return "MovieTableCell"
    }
    
    var headerNib:UINib{
        return UINib.init(nibName: "SearchHeaderView", bundle: nil)
    }
    
    var reuseableHeaderIdentifier:String{
        return "SearchHeaderView"
    }
    
    var headerHeight:CGFloat{
        if !isSearchBarHighlited && RecentSearchDataManager.shared.getRecentSearch().count > 0 {
            return 60
        }
        return 0
    }
    
    
    
    var items:[Movie] {
        // If searrchbar is highlighted return filtered movies ootherwise return recent search
        if !isSearchBarHighlited && RecentSearchDataManager.shared.getRecentSearch().count > 0{
            return RecentSearchDataManager.shared.getRecentSearch()
        }
        else
        {
            return movieItems ?? []
        }
        
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
    
    
    //Search Algorithm
    private func searchAlgo() {
        let searchTextArray = searchValue.split(separator: " ")
        movieItems = moviesModel?.movies?.filter({ (movie) -> Bool in
            let movieNameArr = (movie.title ?? "").split(separator: " ")
            for searchWord in searchTextArray
            {
                var isMatch = false
                for word in movieNameArr
                {
                    if word.prefix(searchWord.count).lowercased() == searchWord.lowercased() { isMatch = true; break}
                }
                if !isMatch {
                    return false
                }
            }
            return true
        })
    }
    
    //MARK:- API Work
    private func getMoviesList(pageNo:Int) {
        if isApiRunning || pageNo == lastSearchPage{
            return
        }
        
        lastSearchPage = pageNo
        
        self.observerBlock?(.dataLoading)
        let httpClient = HTTPClient.init(session: URLSession.shared)
        httpClient.dataTask(MovieDB.nowPlayings(pageNo)) { [weak self] (result) in
            
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
                    self.searchAlgo()
                    self.isApiRunning = false
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

