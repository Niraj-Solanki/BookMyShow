//
//  ServerError.swift
//  BookMyShow
//
//  Created by Neeraj Solanki on 10/10/20.
//  Copyright © 2020 Mr.Solanki. All rights reserved.
//

import Foundation
struct ServerError: Decodable {
    let status: String?
    let error: String?
}
