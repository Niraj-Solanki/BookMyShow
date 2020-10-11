//
//  MovieDetailCellViewModel.swift
//  BookMyShow
//
//  Created by Neeraj Solanki on 10/10/20.
//  Copyright © 2020 Mr.Solanki. All rights reserved.
//

import UIKit
class MovieDetailCellViewModel {
    
    private var movieModel:MovieDetailedModel?
    
    init(movie:MovieDetailedModel?) {
        movieModel = movie
    }
    
    var movieTitle:String {
        return movieModel?.title ?? "Untitled"
    }
    
    var releaseDate:String{
        return movieModel?.release_date?.convertDateFormater() ?? "Update Soon!"
    }
    
    var rating:String{
          return "\(movieModel?.vote_average ?? 0)"
      }
    
    var languages:String{
        var bulletAtFirst = true
        return movieModel?.spokenLanguages?.map({ (language) -> String in
            if bulletAtFirst
            {
                bulletAtFirst = false
                return (language.name ?? "")
            }
            return " " + Constants.StaticData.bulletSymbol + " " + (language.name ?? "")
        }).joined() ?? ""
    }
    
    var langAndRuntine:String{
        
        // If Have Duration
        if let runDuration = movieModel?.runtime, runDuration > 0 {
            return languages + " \(Constants.StaticData.bulletSymbol) " + "\(runDuration) Mins"
        }
        return languages
    }
    
    
    
    var moviePosterUrl:String {
        return "\(Constants.Service.imageBaseUrl)\(movieModel?.poster_path ?? (movieModel?.backdrop_path ?? ""))"
    }
    
    var storyline:String {
        if let overView = movieModel?.overview,overView.count > 0 {
            return overView
        }
        return "No Story line Available."
    }
    
    
    var genre:String {
        var bulletAtFirst = true
        return movieModel?.genres?.map({ (genre) -> String in
            if bulletAtFirst
            {
                bulletAtFirst = false
                return (genre.name ?? "")
            }
            return " " + Constants.StaticData.bulletSymbol + " " + (genre.name ?? "")
        }).joined() ?? ""
    }
    
    func downloadImage(completion:@escaping (UIImage?) -> Void)
    {
        if let imageUrl = URL.init(string: "\(Constants.Service.imageBaseUrl)\(movieModel?.poster_path ?? "")")
        {
            // Caching Images
            if ImageCache.shared.imageExist(url: imageUrl) {
                completion(ImageCache.shared.getImage(url: imageUrl))
            }
            else{
                URLSession.shared.dataTask(with: imageUrl, completionHandler: { (data, response, error) in
                    guard let data = data, error == nil else { return print("Not Available") }
                    
                    DispatchQueue.main.async {
                        ImageCache.shared.saveImage(url: imageUrl, image: UIImage(data: data))
                        completion(UIImage(data: data))
                    }
                }).resume()
            }
        }
    }
}
