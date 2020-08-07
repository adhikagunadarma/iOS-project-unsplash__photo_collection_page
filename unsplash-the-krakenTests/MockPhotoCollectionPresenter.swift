//
//  MockPhotoCollectionPresenter.swift
//  unsplash-the-krakenTests
//
//  Created by Josephine Fransisca on 07/08/20.
//  Copyright © 2020 Adhika gunadarma. All rights reserved.
//

import Foundation
import Alamofire
@testable import unsplash_the_kraken


class MockPhotoCollectionPresenter {
    var searchTerm = ""
    var pageNumber = 1
    var listPhotosViewModel = [PhotoViewModel]()
}

extension MockPhotoCollectionPresenter : PhotoCollectionToPresenter {
    func getMorePhotos() {
        self.pageNumber += 1
        //           self.getPhotos()
    }
    
    func getNewPhotos(_ searchText: String, _ listPhoto : [PhotoViewModel]) {
        self.listPhotosViewModel = listPhoto
        self.searchTerm = searchText
        self.pageNumber = 1
        //           self.getPhotos()
    }
    
    
}
