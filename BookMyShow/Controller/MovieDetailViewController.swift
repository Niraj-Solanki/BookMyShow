//
//  MovieDetailViewController.swift
//  BookMyShow
//
//  Created by Neeraj Solanki on 10/10/20.
//  Copyright © 2020 Mr.Solanki. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var movieDetailTableView: UITableView!
    
    // MARK: - Objects
    var movieModel:MovieCellViewModel!
    var viewModel:MovieDetailViewModel = MovieDetailViewModel()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeVariables()
    }
    
    // MARK: - Custom Methods
    func initializeVariables() {
        
        movieDetailTableView.register(viewModel.detailCellNib, forCellReuseIdentifier: viewModel.detailCellIdentifier)
        movieDetailTableView.register(viewModel.castCrewCellNib, forCellReuseIdentifier: viewModel.castCrewCellIdentifier)
        movieDetailTableView.register(viewModel.similarMovieCellNib, forCellReuseIdentifier: viewModel.similarMovieCellIdentifier)
        bindingWork()
    }
    
    func configureViewModel(movieID:Int) {
        viewModel = MovieDetailViewModel.init(movieId: movieID)
    }
    
    func bindingWork() {
        viewModel.observerBlock = { [weak self] (state) in
            DispatchQueue.main.async {
                switch state {
                case .dataLoaded:
                    print("Data Loaded")
                    self?.movieDetailTableView.reloadData()
                case .dataFailed:
                    print("Data Failed")
                case .dataLoading:
                    print("Data Loading")
                default:
                    print("Default")
                }
            }
        }
    }
    
    // MARK: - Action Methods
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
extension MovieDetailViewController : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Movie Synopsis
        if let movieDetailModel = viewModel.items[indexPath.row] as? MovieDetailedModel {
            let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.detailCellIdentifier) as! MovieDetailCell
            cell.configureCell(viewModel: MovieDetailCellViewModel.init(movie: movieDetailModel))
            return cell
        }
        
        // Cast Cell
        if let viewModelData = viewModel.items[indexPath.row] as? CastCrewCellViewModel {
            let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.castCrewCellIdentifier) as! CastCrewTableCell
            cell.configureCell(viewModelData)
            return cell
        }
        
        // Similar Moview
        if let similarMovieData = viewModel.items[indexPath.row] as? MoviesModel {
                let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.similarMovieCellIdentifier) as! SimilarMovieTableCell
            cell.configureCell(SimilarTableCellViewModel(modelData: similarMovieData))
                return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.detailCellIdentifier) as! MovieDetailCell
            return cell
        }
    }    
}
