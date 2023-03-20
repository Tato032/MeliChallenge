//
//  ProductResult.swift
//  MeliChallange
//
//  Created by Juan Martin Rezk Elso on 20/3/23.
//

import Foundation

struct ProductResult: Decodable {
    let results: [Product]
    let paging: Paging
}

struct Paging: Decodable {
    let total: Int
}
