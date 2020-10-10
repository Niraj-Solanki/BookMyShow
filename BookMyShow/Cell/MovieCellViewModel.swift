//
//  MovieCellViewModel.swift
//  BookMyShow
//
//  Created by Neeraj Solanki on 10/10/20.
//  Copyright © 2020 Mr.Solanki. All rights reserved.
//

import UIKit
class MovieCellViewModel: NSObject {
    
    private var movieModel:Movie?
    
    init(movie:Movie) {
        super.init()
        movieModel = movie
    }
    
    var movieTitle:String {
        return movieModel?.original_title ?? "Untitled"
    }
    
    var releaseDate:String{
        return movieModel?.release_date?.convertDateFormater() ?? "Update Soon!"
    }
    
    var moviePosterUrl:String {
        return "\(Constants.Service.imageBaseUrl)\(movieModel?.poster_path ?? (movieModel?.backdrop_path ?? ""))"
    }
    
    var genre:String {
        var genreArray:[String] = []
        for genreId in movieModel?.genre_ids ?? [] {
            
            if genreArray.count < 1 {
                genreArray.append(contentsOf: GenreModel.shared.genreTypes.filter { $0.id == genreId }.map { $0.name })
            }
            else if genreArray.count < 3
            {
             genreArray.append(contentsOf: GenreModel.shared.genreTypes.filter { $0.id == genreId }.map { " \(Constants.StaticData.bulletSymbol) " + $0.name })
            }
            else{
                return genreArray.joined()
            }
        }
        
        return genreArray.joined()
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
