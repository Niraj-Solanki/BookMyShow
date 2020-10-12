//
//  SearchViewController.swift
//  BookMyShow
//
//  Created by Neeraj Solanki on 11/10/20.
//  Copyright © 2020 Mr.Solanki. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UINavigationControllerDelegate{

    //MARK:- Outlets
    @IBOutlet weak var movieListTableView: UITableView!
    
    //MARK:- Objects
    let search = UISearchController(searchResultsController: nil)
    let viewModel:SearchViewModel = SearchViewModel()
    
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeVariables()
        
    }

    //MARK:- Custom Methods
    func initializeVariables() {
        title = "Search Movies"
        initializeSearchController()
        navigationController?.delegate = self
        movieListTableView.register(viewModel.nib, forCellReuseIdentifier: viewModel.reusableIdentifier)
        movieListTableView.register(viewModel.headerNib, forHeaderFooterViewReuseIdentifier: viewModel.reuseableHeaderIdentifier)
        bindingWork()
       }
    
    func initializeSearchController() {
          search.searchResultsUpdater = self
          search.obscuresBackgroundDuringPresentation = false
          search.automaticallyShowsCancelButton = true
          search.hidesNavigationBarDuringPresentation = false
          search.searchBar.placeholder = "Type something here to search"
          search.searchBar.delegate = self
          navigationItem.searchController = search
      }
    
    func bindingWork() {
        viewModel.observerBlock = {  [weak self] (state) in
            DispatchQueue.main.async {
                switch state {
                case .searchUpdated:
                    self?.movieListTableView.reloadData()
                default:
                    print("Default")
                }
            }
        }
    }
}


//MARK:- UISearchBarDelegate
extension SearchViewController : UISearchResultsUpdating,UISearchBarDelegate
{
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        movieListTableView.endUpdates()
        viewModel.updateSearch(text: text)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        viewModel.isSearchBarHighlited = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.isSearchBarHighlited = false
    }
    
}


extension SearchViewController : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movieCell = tableView.dequeueReusableCell(withIdentifier: viewModel.reusableIdentifier) as! MovieTableCell
        movieCell.tag = indexPath.row
        movieCell.configureCell(viewModel: MovieCellViewModel(movie: viewModel.items[indexPath.row])){
            (image) in
            if movieCell.tag == indexPath.row {
                movieCell.moviePosterImageView.image = image
            }
            else{
                print("Not Same")
            }
        }
        return movieCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Add in Recent Search Data only and only when user is searched annything.
        if (search.searchBar.text ?? "").count > 0 {
            RecentSearchDataManager.shared.updateRecentSearch(newSearch: viewModel.items[indexPath.row])
        }
        
        let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: String(describing: MovieDetailViewController.self)) as! MovieDetailViewController
        detailViewController.configureViewModel(movieID: viewModel.items[indexPath.row].id ?? 0)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 218
    }
    
   func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
     return SearchHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 60))
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewModel.headerHeight
    }
}

extension SearchViewController : UIScrollViewDelegate
{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let scrollViewHeight = scrollView.frame.size.height
        let scrollOffset = scrollView.contentOffset.y
        let scrollContentSizeHeight = scrollView.contentSize.height
        
        //Pagination when 2 item left to view
        let contentHeight = 186 * 2
        if (scrollOffset + scrollViewHeight >= (scrollContentSizeHeight - CGFloat(contentHeight))) && (viewModel.currentPage < viewModel.totalPages)
        {
            viewModel.loadMore()
        }
    }
}

