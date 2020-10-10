//
//  GenreModel.swift
//  BookMyShow
//
//  Created by Neeraj Solanki on 10/10/20.
//  Copyright © 2020 Mr.Solanki. All rights reserved.
//

import UIKit
class GenreModel {
    static let shared = GenreModel()
    
    var genreTypes:[Genre] = []
    
    private init() {
        if let data = Constants.StaticData.genreString.data(using: .utf8) {
            
            do {
                let genreData =  try JSONSerialization.jsonObject(with: data, options: []) as! [[String:Any]]
                
                for item in genreData {
                    genreTypes.append(Genre(dict: item))
                }
                
            } catch let error as NSError {
                print(error)
            }
        }
    }
    
}
struct Genre {
    var id:Int = 0
    var name:String = ""
    
    init(dict:[String:Any]) {
        if let idValue = dict["id"] as? Int {
            id = idValue
        }
        
        if let nameValue = dict["name"] as? String {
            name = nameValue
        }
    }
}
