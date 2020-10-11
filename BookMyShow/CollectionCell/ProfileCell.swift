//
//  ProfileCell.swift
//  BookMyShow
//
//  Created by Neeraj Solanki on 10/10/20.
//  Copyright © 2020 Mr.Solanki. All rights reserved.
//

import UIKit

class ProfileCell: UICollectionViewCell {

    //MARK:- Outlets
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userAliasLabel: UILabel!
    
    //MARK:- Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(viewModel:ProfileCellViewModel,completion:@escaping ((UIImage?) ->Void)) {
        userNameLabel.text = viewModel.userName
        userAliasLabel.text = viewModel.aliasName
        userImageView.image = nil
        viewModel.downloadImage {(image) in
             completion(image)
        }
    }
    
}
