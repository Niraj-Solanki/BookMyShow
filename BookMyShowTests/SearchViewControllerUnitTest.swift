//
//  SearchViewControllerUnitTest.swift
//  BookMyShowTests
//
//  Created by Neeraj Solanki on 11/10/20.
//  Copyright © 2020 Mr.Solanki. All rights reserved.
//

import XCTest
@testable import BookMyShow

class SearchViewControllerUnitTest: XCTestCase {
    
    var searchViewController:SearchViewController!
        
    override func setUp() {
        searchViewController = SearchViewController()
    }

    override func tearDown() {
        
    }

    func testCellIdentifier() {
        XCTAssert(searchViewController.viewModel.reusableIdentifier == "MovieTableCell", "Cell ReusableIdentifier Mismatch.")
    }
    
    func testObserverOnSearch() {
        searchViewController.viewModel.observerBlock = { (state) in
            switch state {
            case .searchUpdated:
                XCTAssert(self.searchViewController.search.searchBar.text == "demo","Seach Not Working")
            default:
                print("")
            }
        }
        self.searchViewController.search.searchBar.text = "demo "
        searchViewController.viewModel.updateSearch(text: self.searchViewController.search.searchBar.text ?? "")
    }
}

