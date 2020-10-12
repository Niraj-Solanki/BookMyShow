//
//  RecentSearchDataManager.swift
//  BookMyShow
//
//  Created by Neeraj Solanki on 12/10/20.
//  Copyright © 2020 Mr.Solanki. All rights reserved.
//

import UIKit
protocol RecentSearchManagerProtocol {
    func getRecentSearch() -> [Movie]
    func updateRecentSearch(newSearch:Movie)
}

class RecentSearchDataManager : RecentSearchManagerProtocol {
    static let shared = RecentSearchDataManager()
    private var movies:[Movie]
    
    private init() { movies = [] }
    
    // Update Movie
    func updateRecentSearch(newSearch: Movie) {
        // If movie already in list can't do anything
        if !(movies.contains(where: { (movie) -> Bool in
            if (movie.id ?? 0) == (newSearch.id ?? 0)
            {
                return true
            }
            return false
        }))
        {
            // If Movie is not in list then check trash hold and update movie
            if movies.count < Constants.StaticData.recentSearchLimit {
                movies.insert(newSearch, at: 0)
            }
            else{ // If Movie is not in list and limit is reached By 5 then remove last one and add new.
                movies.remove(at: Constants.StaticData.recentSearchLimit - 1)
                movies.insert(newSearch, at: 0)
            }
        }
        
    }
    
    func getRecentSearch() -> [Movie] {
        return movies
    }
    
}
