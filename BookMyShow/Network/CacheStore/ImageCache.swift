//
//  ImageCache.swift
//  BookMyShow
//
//  Created by Neeraj Solanki on 10/10/20.
//  Copyright © 2020 Mr.Solanki. All rights reserved.
//


import UIKit
protocol ImageProtocol {
    func saveImage(url:URL,image:UIImage?)
    func getImage(url:URL) -> UIImage?
    func imageExist(url:URL) -> Bool
}
class ImageCache:ImageProtocol {
    
    public static let shared = ImageCache()
    private let imageCache = NSCache<NSString, AnyObject>()
    
    //MARK:- Image Protocol
    func saveImage(url: URL, image: UIImage?) {
        guard let image = image else { return }
        imageCache.setObject(image, forKey: url.absoluteString as NSString)
    }
    
    func getImage(url: URL) -> UIImage? {
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) as? UIImage {
            return cachedImage
        }
        else{
            return nil
        }
    }
    
    func imageExist(url: URL) -> Bool {
         return (imageCache.object(forKey: url.absoluteString as NSString) as? UIImage) != nil
    }
    
    
    private init() {}
    
}
