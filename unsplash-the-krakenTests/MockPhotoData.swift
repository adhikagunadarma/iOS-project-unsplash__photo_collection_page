//
//  MockPhotoData.swift
//  unsplash-the-krakenTests
//
//  Created by Josephine Fransisca on 07/08/20.
//  Copyright © 2020 Adhika gunadarma. All rights reserved.
//

import Foundation
@testable import unsplash_the_kraken

class MockPhotoData{
    static func getPhoto() -> [PhotoImage]{
        var listPhoto : [PhotoImage] = []
        
        for i in 0...5 {
            listPhoto.append(PhotoImage(id: "id-\(i)",
                urls: URLs(raw: "test raw-\(i)", full: "test full-\(i)", regular: "test regular-\(i)", small: "test small-\(i)", thumb: "test thumb-\(i)")
            ))
        }
        return listPhoto
    }
}
