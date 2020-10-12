//
//  ProfileCellViewModel.swift
//  BookMyShow
//
//  Created by Neeraj Solanki on 10/10/20.
//  Copyright © 2020 Mr.Solanki. All rights reserved.
//

import UIKit
class ProfileCellViewModel {
    
    private var type:CastCrewType = .cast
    private var castModel:CastModel?
    private var crewModel:CrewModel?
    
    // Init for Cast Profile
    init(_ castModelData:CastModel) {
        castModel = castModelData
        type = .cast
    }
    
    // Init for Crew Profile
    init(_ crewModelData:CrewModel) {
        crewModel = crewModelData
        type = .crew
    }
    
    var userName:String{
        return (type == .cast) ? castModel?.name ?? "" :  crewModel?.name ?? ""
    }
    
    var aliasName:String{
        return (type == .cast) ? " as " + (castModel?.character ?? "-") :  crewModel?.job ?? "-"
    }
    
    func downloadImage(completion:@escaping (UIImage?) -> Void)
    {
        if let path = (type == .cast) ? castModel?.profile_path :crewModel?.profile_path, path.count > 0
        {
            if let imageUrl = URL.init(string: "\(Constants.Service.imageBaseUrl)\(path)")
            {
                // Caching Images
                if ImageCache.shared.imageExist(url: imageUrl) {
                    completion(ImageCache.shared.getImage(url: imageUrl))
                }
                else{
                    URLSession.shared.dataTask(with: imageUrl, completionHandler: { (data, response, error) in
                        guard let data = data, error == nil else { return print("Not Available") }
                        
                        DispatchQueue.main.async {
                            if let image = UIImage(data: data)
                            {
                                ImageCache.shared.saveImage(url: imageUrl, image: image)
                                completion(image)
                            }
                            else{
                                completion(UIImage(named: "1)") ?? nil)
                            }
                        }
                    }).resume()
                }
            }
        }
        else
        {
            if type == .cast {
                completion(UIImage(named: "\(castModel?.gender ?? 1)") ?? nil)
            }
            else{
                completion(UIImage(named: "\(crewModel?.gender ?? 1)") ?? nil)
            }
        }
    }
}
