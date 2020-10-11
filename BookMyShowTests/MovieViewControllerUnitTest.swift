//
//  MovieViewControllerUnitTest.swift
//  BookMyShowTests
//
//  Created by Neeraj Solanki on 11/10/20.
//  Copyright © 2020 Mr.Solanki. All rights reserved.
//

import XCTest
@testable import BookMyShow

class MovieViewControllerUnitTest: XCTestCase {
    
    var movieViewController:MovieViewController!
        
    override func setUp() {
        movieViewController = MovieViewController()
    }

    override func tearDown() {
        
    }

    func testCellIdentifier() {
        XCTAssert(movieViewController.viewModel.reusableIdentifier == "MovieTableCell", "Cell ReusableIdentifier Mismatch.")
    }
}
