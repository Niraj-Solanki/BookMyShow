//
//  ParameterEncoder.swift
//  BookMyShow
//
//  Created by Neeraj Solanki on 10/10/20.
//  Copyright © 2020 Mr.Solanki. All rights reserved.
//

import UIKit
protocol RequestEncoder {
     func encode(urlRequest: inout URLRequest , with parameters:BMSParameters) throws
}
struct URLParameterEncoder : RequestEncoder {
    public static var `default`: JSONParameterEncoder { return JSONParameterEncoder() }
    public func encode(urlRequest: inout URLRequest, with parameters: BMSParameters) throws {
        
        guard let url = urlRequest.url else { throw BMSError("Invalid Url")}
        
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
            parameters.isEmpty == false {
            
            var queryItemsArr = [URLQueryItem]()
            
            // from each key-value pairs in params dictionary-> convert it into array of URLQueryItem
            for (parameterKey, parameterValue) in parameters {
                
                // Create query Item
                let queryItem = URLQueryItem(name: parameterKey, value: "\(parameterValue)")
                queryItemsArr.append(queryItem)
            }
            
            // Set query items
            urlComponents.queryItems = queryItemsArr
            urlRequest.url = urlComponents.url
        }
    }
}
struct JSONParameterEncoder : RequestEncoder {

   static let CONTENT_TYPE_HEADER_FIELD = "Content-Type"
   static let CONTENT_TYPE_HEADER_JSON    = "application/json"
    public static var `default`: JSONParameterEncoder { return JSONParameterEncoder() }

    public func encode(urlRequest: inout URLRequest, with parameters: BMSParameters) throws {
        do {
        let bodyData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        urlRequest.httpBody = bodyData

            if (urlRequest.value(forHTTPHeaderField:JSONParameterEncoder.CONTENT_TYPE_HEADER_FIELD ) == nil){
                urlRequest.setValue(JSONParameterEncoder.CONTENT_TYPE_HEADER_JSON, forHTTPHeaderField: JSONParameterEncoder.CONTENT_TYPE_HEADER_FIELD)
            }
        }
        catch let error{
            throw BMSError(error.localizedDescription)
        }
    }
}
