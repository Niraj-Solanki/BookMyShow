//
//  MovieListingAPI.swift
//  BookMyShow
//
//  Created by Neeraj Solanki on 10/10/20.
//  Copyright © 2020 Mr.Solanki. All rights reserved.
//

import Foundation

enum MovieListing {
    case nowPlayings(Int) // Page No
}

extension MovieListing: RequestProtocol {
   
    
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
            return "3/movie/now_playing"
    }
    
    //Returns HTTP Method for Movie Listing APIs
    var httpMethod: HTTPMethod {
        switch self {
        case .nowPlayings:
            return .get
        }
    }
    
    //Encode and Returns Encoded Data
    var parameters: BMSParameters? {
        var params:BMSParameters = [:]
        params[MovieListingKeys.ApiKey] = Constants.Service.ApiKey
        
        switch self {
        case .nowPlayings(let pageNo):
            params[MovieListingKeys.page] = pageNo
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
