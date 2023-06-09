//
//  Facade.swift
//  MeliChallange
//
//  Created by Juan Martin Rezk Elso on 10/3/23.
//

import Foundation
import UIKit

final class Facade {
    static let shared = Facade()
    private init() {}
    
    private let networkManager = NetworkManager()
    
    func getFullItem(id: String, result: @escaping (Result<FullProduct, Error>) -> Void) {
        networkManager.getItem(id: id, completion: result)
    }
    
    func loadProductImage(_ urlString: String, result: @escaping (Result<UIImage, Error>) -> Void) {
        networkManager.loadImage(urlString, completion: result)
    }
    
    func filterData(searchText: String, position: Int, limit: Int, result: @escaping (Result<ProductResult, Error>) -> Void) {
        networkManager.filterProducts(searchText: searchText, position: position, limit: limit, completion: result)
    }
}
