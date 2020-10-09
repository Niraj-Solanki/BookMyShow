//
//  BMSError.swift
//  BookMyShow
//
//  Created by Neeraj Solanki on 10/10/20.
//  Copyright © 2020 Mr.Solanki. All rights reserved.
//

import Foundation
typealias BMSErrorHandler = (BMSError?) -> Void

struct BMSError: Error {
    var localizedDescription: String
    init(_ localizedDescription: String) {
        self.localizedDescription = localizedDescription
    }
}
