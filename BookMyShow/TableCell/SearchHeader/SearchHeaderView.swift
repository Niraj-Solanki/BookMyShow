//
//  SearchHeaderView.swift
//  BookMyShow
//
//  Created by Neeraj Solanki on 12/10/20.
//  Copyright © 2020 Mr.Solanki. All rights reserved.
//

import UIKit
class SearchHeaderView: UIView {
    @IBOutlet var contentView: SearchHeaderView!
    //MARK:- Life Cycle
       override init(frame: CGRect) {
           super.init(frame: frame)
           commonInit()
       }
       
       required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
           commonInit()
       }
       
       private func commonInit() {
        Bundle.main.loadNibNamed("SearchHeaderView", owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
       }
}
