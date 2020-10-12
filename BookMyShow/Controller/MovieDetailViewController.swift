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
    var viewModel:MovieDetailViewModel = MovieDetailViewModel()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeVariables()
    }
    
    // MARK: - Custom Methods
    func initializeVariables() {
        
        // register Custom Xibs
        movieDetailTableView.register(viewModel.detailCellNib, forCellReuseIdentifier: viewModel.detailCellIdentifier)
        movieDetailTableView.register(viewModel.castCrewCellNib, forCellReuseIdentifier: viewModel.castCrewCellIdentifier)
        movieDetailTableView.register(viewModel.similarMovieCellNib, forCellReuseIdentifier: viewModel.similarMovieCellIdentifier)
        
        // Binding WOrk Call
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
    
    func playVideo() {
        if let videoURL = viewModel.trailerUrl {
            let webPlayer = WebVideoPlayerVC.init(nibName: "WebVideoPlayerVC", bundle: nil)
            webPlayer.videoUrl = videoURL
            navigationController?.pushViewController(webPlayer, animated: true)
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
            cell.configureCell(viewModel: MovieDetailCellViewModel(movie: movieDetailModel))
            cell.playBackBlock = { [weak self] in
                self?.playVideo()
            }
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
            cell.openMovieDetailBlock = {[weak self] (movieId) in
                let detailViewController = self?.storyboard?.instantiateViewController(withIdentifier: String(describing: MovieDetailViewController.self)) as! MovieDetailViewController
                detailViewController.configureViewModel(movieID: movieId)
                self?.navigationController?.pushViewController(detailViewController, animated: true)
            }
            return cell
        }
        else{ // Else No matched Cell found
            let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.detailCellIdentifier) as! MovieDetailCell
            return cell
        }
    }    
}
