//
//  Constants.swift
//  BookMyShow
//
//  Created by Neeraj Solanki on 10/10/20.
//  Copyright © 2020 Mr.Solanki. All rights reserved.
//

import Foundation
struct Constants {
    struct Service {
        static let baseURL = "https://api.themoviedb.org/"
        static let ApiKey = "47624b1f7412efdc3555610c02779db3"
        static let imageBaseUrl = "https://image.tmdb.org/t/p/w500/"
        static let timeout: TimeInterval = 30.0
    }
    
    struct StaticData {
        static let recentSearchLimit = 5
        static let bulletSymbol = "•"
        static let genreString = """
        [
                {
                    "id" : 28,
                    "name": "Action"
                  },
                  {
                    "id": 12,
                    "name": "Adventure"
                  },
                  {
                    "id": 16,
                    "name": "Animation"
                  },
                  {
                    "id": 35,
                    "name": "Comedy"
                  },
                  {
                    "id": 80,
                    "name": "Crime"
                  },
                  {
                    "id": 99,
                    "name": "Documentary"
                  },
                  {
                    "id": 18,
                    "name": "Drama"
                  },
                  {
                    "id": 10751,
                    "name": "Family"
                  },
                  {
                    "id": 14,
                    "name": "Fantasy"
                  },
                  {
                    "id": 36,
                    "name": "History"
                  },
                  {
                    "id": 27,
                    "name": "Horror"
                  },
                  {
                    "id": 10402,
                    "name": "Music"
                  },
                  {
                    "id": 9648,
                    "name": "Mystery"
                  },
                  {
                    "id": 10749,
                    "name": "Romance"
                  },
                  {
                    "id": 878,
                    "name": "Science Fiction"
                  },
                  {
                    "id": 10770,
                    "name": "TV Movie"
                  },
                  {
                    "id": 53,
                    "name": "Thriller"
                  },
                  {
                    "id": 10752,
                    "name": "War"
                  },
                  {
                    "id" : 37,
                    "name": "Western"
                  }
                ]
"""
    }
}

