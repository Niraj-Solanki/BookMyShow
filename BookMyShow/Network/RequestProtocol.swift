//
//  RequestProtocol.swift
//  BookMyShow
//
//  Created by Neeraj Solanki on 10/10/20.
//  Copyright © 2020 Mr.Solanki. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete  = "DELETE"
}

public typealias HTTPHeaders = [String: String]
public typealias BMSParameters = [String: Any]
protocol RequestProtocol {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var parameters: BMSParameters? { get }
    var headers: HTTPHeaders? { get }
    var encoding: RequestEncoder {get}
}
