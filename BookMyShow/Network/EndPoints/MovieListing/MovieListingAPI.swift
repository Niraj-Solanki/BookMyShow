//
//  MovieListingAPI.swift
//  BookMyShow
//
//  Created by Neeraj Solanki on 10/10/20.
//  Copyright © 2020 Mr.Solanki. All rights reserved.
//

import Foundation

enum MovieDB {
    case nowPlayings(Int) // Page No
    case movieDetails(Int) // Movie ID
    case movieCredits(Int) // MovieID
}

extension MovieDB: RequestProtocol {
   
    
    struct MovieListingKeys {
       static let ApiKey = "api_key"
       static let page = "page"
    }
    
    //Set Base URL
    var baseURL: URL {
        guard let url = URL(string: Constants.Service.baseURL) else {
            fatalError("BaseURL could not be configured.")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .nowPlayings( _):
            return "3/movie/now_playing"
        case .movieDetails(let movieId):
            return "3/movie/\(movieId)"
        case .movieCredits(let movieId):
            return "3/movie/\(movieId)/credits"
        }
    }
    
    //Returns HTTP Method for Movie Listing APIs
    var httpMethod: HTTPMethod {
            return .get
    }
    
    //Encode and Returns Encoded Data
    var parameters: BMSParameters? {
        var params:BMSParameters = [:]
        params[MovieListingKeys.ApiKey] = Constants.Service.ApiKey
        
        switch self {
        case .nowPlayings(let pageNo):
            params[MovieListingKeys.page] = pageNo
        default:
            print("")
        }
        
        return params
    }
    
    //Return APIs Specific Headers
    var headers: HTTPHeaders? {
        return nil
    }
    
    var encoding: RequestEncoder {
        return URLParameterEncoder()
       }
       
}
