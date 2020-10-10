//
//  MovieViewController.swift
//  BookMyShow
//
//  Created by Neeraj Solanki on 10/10/20.
//  Copyright © 2020 Mr.Solanki. All rights reserved.
//

import UIKit

class MovieViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var movieListTableView: UITableView!
    
    //MARK:- Objects
    var viewModel:MovieViewModel = MovieViewModel()
    
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeVariables()
    }
    
    //MARK:- Custom Methods
    func initializeVariables() {
        movieListTableView.register(viewModel.nib, forCellReuseIdentifier: viewModel.reusableIdentifier)
        bindingWork()
    }
    
    func bindingWork() {
           viewModel.observerBlock = {  [weak self] (state) in
               DispatchQueue.main.async {
                   switch state {
                   case .dataLoaded:
                       print("Data Loaded")
//                       self?.refreshControl.endRefreshing()
                       self?.movieListTableView.reloadData()
//                       self?.noConnectionView.isHidden = true
                       self?.viewModel.getLoader().dismiss(animated: false, completion: nil)
                       
                   case .dataFailed:
                       print("Data Failed")
//                       self?.refreshControl.endRefreshing()
//                       self?.noConnectionView.isHidden = false
                       self?.viewModel.getLoader().dismiss(animated: false, completion: nil)
                       
                   case .dataLoading:
                       print("Data Loading")
//                       if let loader = self?.viewModel.getLoader()
//                       {
//                           self?.present(loader, animated: false, completion: nil)
//                       }
                   default:
                       print("Default")
                   }
               }
           }
       }
    //MARK:- Action Methods
    
}

extension MovieViewController : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movieCell = tableView.dequeueReusableCell(withIdentifier: "MovieTableCell", for: indexPath) as! MovieTableCell
        movieCell.configureCell(viewModel: MovieCellViewModel(movie: viewModel.items[indexPath.row]))
        return movieCell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 218
    }
}

extension MovieViewController : UIScrollViewDelegate
{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let scrollViewHeight = scrollView.frame.size.height
        let scrollOffset = scrollView.contentOffset.y
        let scrollContentSizeHeight = scrollView.contentSize.height
        
        //Pagination when 3 item left to view
        let contentHeight = 186 * 3
        if (scrollOffset + scrollViewHeight >= (scrollContentSizeHeight - CGFloat(contentHeight))) && (viewModel.currentPage < viewModel.totalPages)
        {
            viewModel.loadMore()
        }
    }
}
