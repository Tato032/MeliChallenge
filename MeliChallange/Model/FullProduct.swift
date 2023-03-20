//
//  FullProduct.swift
//  MeliChallange
//
//  Created by Juan Martin Rezk Elso on 17/3/23.
//

import Foundation

struct FullProduct: Decodable {
    let pictures: [Pictures]?
    let attributes: [Attributes]?
}

struct Pictures: Decodable {
    let url: String?
}

struct Attributes: Decodable {
    let name: String?
    let value_name: String? 
}
