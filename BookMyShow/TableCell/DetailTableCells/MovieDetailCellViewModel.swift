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
    
    var languages:String{
        return movieModel?.spokenLanguages?.map({ (language) -> String in
            return " " + Constants.StaticData.bulletSymbol + " " + (language.name ?? "")
        }).joined() ?? ""
    }
    
    
    var moviePosterUrl:String {
        return "\(Constants.Service.imageBaseUrl)\(movieModel?.poster_path ?? (movieModel?.backdrop_path ?? ""))"
    }
    
    var storyline:String {
        return movieModel?.overview ?? ""
    }
    
    
    var genre:String {
        return movieModel?.genres?.map({ (genre) -> String in
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
