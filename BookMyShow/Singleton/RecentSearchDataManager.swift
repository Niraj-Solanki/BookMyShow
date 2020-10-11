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
    
    func updateRecentSearch(newSearch: Movie) {
        if !(movies.contains(where: { (movie) -> Bool in
            if (movie.id ?? 0) == (newSearch.id ?? 0)
            {
                return true
            }
            return false
        }))
        {
            if movies.count < 5 {
                movies.insert(newSearch, at: 0)
            }
            else{
                movies.remove(at: 4)
                movies.insert(newSearch, at: 0)
            }
            
        }
        
    }
    
    func getRecentSearch() -> [Movie] {
        return movies
    }
    
}
