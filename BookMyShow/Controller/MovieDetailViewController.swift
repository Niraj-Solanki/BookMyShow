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
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeVariables()
    }
    
    // MARK: - Custom Methods
    func initializeVariables() {
           movieDetailTableView.register(UINib.init(nibName: "MovieDetailCell", bundle: nil), forCellReuseIdentifier: "MovieDetailCell")
       }
    
    // MARK: - Action Methods
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
extension MovieDetailViewController : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MovieDetailCell.self), for: indexPath) as! MovieDetailCell
        cell.configureCell(movie: movieModel)
        return cell
    }
    
    
}
