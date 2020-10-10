//
//  CastCrewCellViewModel.swift
//  BookMyShow
//
//  Created by Neeraj Solanki on 10/10/20.
//  Copyright © 2020 Mr.Solanki. All rights reserved.
//

import UIKit
enum CastCrewType {
    case cast
    case crew
}

class CastCrewCellViewModel{
    private var cast:[CastModel] = []
    private var crew:[CrewModel] = []
    private var type:CastCrewType = .cast
    
    init() {
        
    }
    
    init(castArray:[CastModel]) {
        cast = castArray
        type = .cast
    }
    
    init(crewArray:[CrewModel]) {
        crew = crewArray
        type = .crew
    }
    
    var cellType:CastCrewType{
      return type
    }
    
    
    var castItems:[CastModel]{
        return cast
    }
    
    var crewItems:[CrewModel]{
        return crew
    }
    
    var title:String{
        return (type == .cast) ? "Cast" : "Crew"
    }
    
    var cellSize:CGSize
    {
     let remainSpace = UIScreen.main.bounds.size.width - 30
        return CGSize(width: remainSpace / 4, height: 200)
    }
    
    var minLineSpacing:CGFloat
    {
        return 10
    }
    
    var nib:UINib{
        return UINib(nibName: String(describing: ProfileCell.self), bundle: Bundle.main)
    }
    
}

