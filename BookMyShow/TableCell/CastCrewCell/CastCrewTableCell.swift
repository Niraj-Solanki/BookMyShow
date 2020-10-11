//
//  CastCrewTableCell.swift
//  BookMyShow
//
//  Created by Neeraj Solanki on 10/10/20.
//  Copyright © 2020 Mr.Solanki. All rights reserved.
//

import UIKit

class CastCrewTableCell: UITableViewCell {
    //MARK:- Outlets
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var profileCllectionView: UICollectionView!
    
    //MARK:- Objects
    var viewModel:CastCrewCellViewModel = CastCrewCellViewModel()
    
    //MARK:- LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        titleView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        titleView.layer.cornerRadius = 12.5
        // Gallery Cell
        let profileCellNib = viewModel.nib
        profileCllectionView.register(profileCellNib, forCellWithReuseIdentifier: "ProfileCell")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureCell(_ viewModelData:CastCrewCellViewModel) {
        viewModel = viewModelData
        
        titleLabel.text = viewModel.title
        profileCllectionView.register(viewModel.nib, forCellWithReuseIdentifier: "PeopleCell")
        profileCllectionView.delegate = self
        profileCllectionView.dataSource = self
        profileCllectionView.reloadData()
    }
    
}
//MARK:- CollectionView Delegate & DataSource
extension CastCrewTableCell : UICollectionViewDelegate,UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (viewModel.cellType == .cast) ? viewModel.castItems.count : viewModel.crewItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let profileCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
        
        profileCell.tag = indexPath.row
        // Cast Work
        if viewModel.cellType == .cast {
            profileCell.configureCell(viewModel: ProfileCellViewModel(viewModel.castItems[indexPath.row])){ (image) in
                if profileCell.tag == indexPath.row
                {
                    profileCell.userImageView?.image = image
                }
                else{
                    print("Not Same")
                }
            }
        }
        else{ // Crew Work
            profileCell.configureCell(viewModel: ProfileCellViewModel(viewModel.crewItems[indexPath.row])){ (image) in
                if profileCell.tag == indexPath.row
                {
                    profileCell.userImageView?.image = image
                }
                else{
                    print("Not Same")
                }
            }
        }
        
        return profileCell
    }
    
}

extension CastCrewTableCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return  viewModel.cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return viewModel.minLineSpacing
    }
}





