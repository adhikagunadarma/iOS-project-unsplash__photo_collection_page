//
//  PhotoImageViewModel.swift
//  unsplash-the-kraken
//
//  Created by Josephine Fransisca on 05/08/20.
//  Copyright © 2020 Adhika gunadarma. All rights reserved.
//

import Foundation

class PhotoViewModel{
    private let dataModel : PhotoImage
    
    init(dataModel : PhotoImage) {
        self.dataModel = dataModel
    }
    
    public var getPhoto : String{
        return dataModel.urls.regular
    }
}
