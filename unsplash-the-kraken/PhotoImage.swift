//
//  PhotoImage.swift
//  unsplash-the-kraken
//
//  Created by Josephine Fransisca on 16/11/19.
//  Copyright © 2019 Adhika gunadarma. All rights reserved.
//

import Foundation

struct ResponseUnsplash : Decodable{
    let total : Int
    let total_pages : Int
    let results : [PhotoImage]
    
}

struct PhotoImage: Decodable {
   let id: String
   let urls: URLs
}

struct URLs: Decodable {
   let raw: String
   let full: String
   let regular: String
   let small: String
   let thumb: String
}
