//
//  NetworkTests.swift
//  MeliChallangeTests
//
//  Created by Juan Martin Rezk Elso on 18/3/23.
//

import XCTest
@testable import MeliChallange

final class NetworkTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func test_GetItem_Success() throws {
        let myExpectation = expectation(description: "task in background")
        Facade.shared.getFullItem(id: "Iphone") { (result) in
            myExpectation.fulfill()
            switch result {
            case .success(let fullProduct):
                XCTAssertNotNil(fullProduct)
            case .failure(_):
                break
            }

        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func test_GetItem_Failure() throws {
        let myExpectation = expectation(description: "task in background")
        Facade.shared.getFullItem(id: "") { (result) in
            myExpectation.fulfill()
            switch result {
            case .success(_):
                break
            case .failure(let error):
                XCTAssertNotNil(error)
            }

        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func test_LoadProductImage_Success() throws {
        let myExpectation = expectation(description: "task in background")
        let url = "http://mla-s1-p.mlstatic.com/943469-MLA31002769183_062019-I.jpg"
        Facade.shared.loadProductImage(url) {  (results) in
            myExpectation.fulfill()
            switch results {
            case .success(let product):
                XCTAssertNotNil(results)
                XCTAssertNotNil(product)
            case .failure(_):
                break
            }
        }
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    func test_LoadProductImage_Failure() throws {
        let myExpectation = expectation(description: "task in background")
        let url = "http://wrongUrl.jpg"
        Facade.shared.loadProductImage(url) {  (results) in
            myExpectation.fulfill()
            switch results {
            case .success(_):
                break
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        }
        waitForExpectations(timeout: 3, handler: nil)
    }

    func test_FilterProducts_Success_ArrayGreaterThan0() throws {
        let myExpectation = expectation(description: "task in background")
        Facade.shared.filterData(searchText: "Iphone", position: 0, limit: 20) { (results) in
            myExpectation.fulfill()
            switch results {
            case .success(let products):
                XCTAssertNotNil(results)
                XCTAssertGreaterThan(products.results.count, 0)
            case .failure(_):
                break
            }

        }
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    func test_FilterProducts_Failure() throws {
        let myExpectation = expectation(description: "task in background")
        Facade.shared.filterData(searchText: "", position: 0, limit: 20) { (results) in
            myExpectation.fulfill()
            switch results {
            case .success( _ ):
                break
            case .failure(let error):
                XCTAssertNotNil(error)
            }

        }
        waitForExpectations(timeout: 3, handler: nil)
    }

}
