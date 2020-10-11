//
//  MovieDetailControllerUnitTest.swift
//  BookMyShowTests
//
//  Created by Neeraj Solanki on 11/10/20.
//  Copyright © 2020 Mr.Solanki. All rights reserved.
//

import XCTest
@testable import BookMyShow
class MovieDetailControllerUnitTest: XCTestCase {

   var detailViewController:MovieDetailViewController!
        
    override func setUp() {
        detailViewController = MovieDetailViewController()
    }

    override func tearDown() {
        
    }

    func testCrewCellIdentifier() {
        XCTAssert(detailViewController.viewModel.castCrewCellIdentifier == "CastCrewTableCell", "Cell ReusableIdentifier Mismatch.")
    }
    
    func testDetailCellIdentifier() {
        XCTAssert(detailViewController.viewModel.detailCellIdentifier == "MovieDetailCell", "Cell ReusableIdentifier Mismatch.")
    }
    
    func testSimilarMovieCellIdentifier() {
        XCTAssert(detailViewController.viewModel.similarMovieCellIdentifier == "SimilarMovieTableCell", "Cell ReusableIdentifier Mismatch.")
    }
}
