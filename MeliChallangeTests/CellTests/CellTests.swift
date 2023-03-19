//
//  CellTests.swift
//  MeliChallangeTests
//
//  Created by Juan Martin Rezk Elso on 18/3/23.
//

import XCTest
@testable import MeliChallange

final class CellTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_MovieCell_setupDataCorrectly() throws {
        let fakeProduct = Product(id: "id",
                                  title: "testProduct",
                                  price: 1400,
                                  permalink: "",
                                  thumbnail: "",
        installments: nil)
        let cell =  ProductTableViewCell()
        cell.setUp(product: fakeProduct)
        XCTAssert(cell.productDescription.text == "testProduct")
        XCTAssert(cell.productTitle.text == "$1,400")
    }

}
