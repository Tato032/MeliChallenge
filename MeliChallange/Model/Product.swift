//
//  Product.swift
//  MeliChallange
//
//  Created by Juan Martin Rezk Elso on 10/3/23.
//

import Foundation

struct Product: Decodable {
    let id: String
    let title: String
    let price: Double
    let permalink: String
    let thumbnail: String
    let installments: Installments?
    
}

struct Installments: Decodable {
    let quantity: Int
    let amount: Double
}

struct ProductResult: Decodable {
    let results: [Product]
}
