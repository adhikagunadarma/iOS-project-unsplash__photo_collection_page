//
//  unsplash_the_krakenTests.swift
//  unsplash-the-krakenTests
//
//  Created by Josephine Fransisca on 07/08/20.
//  Copyright © 2020 Adhika gunadarma. All rights reserved.
//

import XCTest
@testable import unsplash_the_kraken

class unsplash_the_krakenTests: XCTestCase {

       var mockPresenter : MockPhotoCollectionPresenter!

       override func setUp() {
           super.setUp()
           self.mockPresenter = MockPhotoCollectionPresenter()
       }

       override func tearDown() {
           self.mockPresenter = nil
           super.tearDown()
       }
    
    func testPhotoViewModelData(){
        let photoObject = MockPhotoData.getPhoto()
        let photoViewModel = photoObject.map({
            return PhotoViewModel(dataModel : $0)
        })
        
        for i in 0...photoViewModel.count - 1{
            XCTAssertEqual(photoViewModel[i].getPhotoRegular, photoObject[i].urls.regular)
            XCTAssertEqual(photoViewModel[i].getPhotoId, photoObject[i].id)
        }
    }

    func testReinitCollectionViewAfterSearchQueryIsChanged(){
        
        let searchQuery = "Unsplashy"
        let listPhoto : [PhotoViewModel] = []
        
        self.mockPresenter.getNewPhotos(searchQuery, listPhoto)
        
        XCTAssertEqual(self.mockPresenter.listPhotosViewModel.count, 0)
        XCTAssertEqual(self.mockPresenter.searchTerm, searchQuery)
        XCTAssertEqual(self.mockPresenter.pageNumber, 1)
    }
    
    func testPageNumberIncremented(){
        
        self.mockPresenter.getMorePhotos()
        
        XCTAssertEqual(self.mockPresenter.pageNumber, 2)
    }
}
