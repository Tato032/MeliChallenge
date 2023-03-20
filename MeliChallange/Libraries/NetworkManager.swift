//
//  NetworkManager.swift
//  MeliChallange
//
//  Created by Juan Martin Rezk Elso on 10/3/23.
//

import Foundation
import UIKit

protocol Manager {
    func getItem(id: String, completion: @escaping (Result<FullProduct, Error>) -> Void)
    func loadImageUsingCacheWithUrlString(_ urlString: String, completion: @escaping (Result<UIImage, Error>) -> Void)
    func filterProducts(searchText: String, position: Int, limit: Int, completion: @escaping (Result<ProductResult, Error>) -> Void)
}

enum NetworkError: Error {
    case urlError
    case serverError
    case parsingError
    case dataError
}

class NetworkManager: Manager {
        private enum Constants {
        static let getItemApiRequestURL = "https://api.mercadolibre.com/items/"
        static let filterApiRequestURL = "https://api.mercadolibre.com/sites/MLA/search?q="
    }
    
    /// This method is use to get a Product with all their properties in order to show them on a detail view
    /// - Parameters:
    ///   - id: given id needed to find an specific Product
    ///   - completion: closure that implement an specific block of code when the API request is complete
    func getItem(id: String, completion: @escaping (Result<FullProduct, Error>) -> Void) {
        
        guard let item = id.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed), !item.isEmpty, let url = URL(string: Constants.getItemApiRequestURL + item) else {
            completion(.failure(NetworkError.urlError))
            return
        }
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil, let myResponse = response as? HTTPURLResponse, myResponse.statusCode == 200, let myData = data else {
                completion(.failure(NetworkError.urlError))
                return
            }
            
            do {
                let fullProduct = try JSONDecoder().decode(FullProduct.self, from: myData)
                completion(.success(fullProduct))
            }
            catch {
                completion(.failure(NetworkError.parsingError))
            }
        }
        dataTask.resume()
        
    }
    
    let imageCache = NSCache<NSString, AnyObject>()
    
    /// Method use to save an image on the cache memory in case is not in there yet
    /// - Parameters:
    ///   - urlString: URL of an specific image to save
    ///   - completion: Closure that implement an specific block of code when the API request is complete
    func loadImageUsingCacheWithUrlString(_ urlString: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        if let cachedImage = imageCache.object(forKey: "\(urlString)" as NSString) as? UIImage {
            completion(.success(cachedImage))
            return
        }
        //No cache, so create new one and set image
        guard let url = URL(string: "\(urlString)") else {
            completion(.failure(NetworkError.urlError))
            return
        }
        URLSession.shared.dataTask(with: url, completionHandler: { (data, _, error) in
            if let _ = error {
                completion(.failure(NetworkError.serverError))
                return
            }
            DispatchQueue.main.async(execute: {
                guard let data = data, let downloadedImage = UIImage(data: data) else {
                    completion(.failure(NetworkError.dataError))
                    return
                }
                self.imageCache.setObject(downloadedImage, forKey: "\(urlString)" as NSString)
                completion(.success(downloadedImage))
            })
        }).resume()
    }
    
    /// Method use to find products by filtering them
    /// - Parameters:
    ///   - searchText: An string with the given word used to filter
    ///   - position: position of the search
    ///   - limit: number of items limit number
    ///   - completion: Closure that implement an specific block of code when the API request is complete
    func filterProducts(searchText: String, position: Int, limit: Int, completion: @escaping (Result<ProductResult, Error>) -> Void) {
        guard let searchValue = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed), !searchText.isEmpty else {
            completion(.failure(NetworkError.urlError))
            return
        }
        var urlString = Constants.filterApiRequestURL + searchValue
        
        if position > 0 {
            urlString += "&offset=\(position)"
         }
         
         if limit > 0 {
             urlString += "&limit=\(limit)"
         }
        guard let url = URL(string: urlString), !searchText.isEmpty else {
            completion(.failure(NetworkError.urlError))
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil, let myResponse = response as? HTTPURLResponse, myResponse.statusCode == 200, let myData = data else {
                completion(.failure(NetworkError.urlError))
                return
            }
            
            do {
                let products = try JSONDecoder().decode(ProductResult.self, from: myData)
                completion(.success(products))
            }
            catch {
                completion(.failure(NetworkError.parsingError))
            }
        }
        dataTask.resume()
    }
}
