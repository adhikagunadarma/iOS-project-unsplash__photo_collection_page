//
//  PhotoCollectionPresenter.swift
//  unsplash-the-kraken
//
//  Created by Josephine Fransisca on 05/08/20.
//  Copyright © 2020 Adhika gunadarma. All rights reserved.
//

import Foundation
import Alamofire

protocol PresenterPhotoCollection{
    func updateData(_ photos : [PhotoViewModel])
    func showError(_ message : String)
}

protocol PhotoCollectionToPresenter{
    func getNewPhotos(_ searchText : String)
    func getMorePhotos()
}

class PhotoCollectionPresenter {
    private var searchTerm = ""
    private var pageNumber = 1
    private let baseURL = "https://api.unsplash.com"
    private let apiKey = "029c013809b5db247d1f7e81d0b52d344b5fd2eb8ce00f376f439519ca909430"
    
    weak var view : PhotoCollectionViewController?
    
    init(with view : PhotoCollectionViewController) {
        self.view = view
    }
    
    func getPhotos(){
        var urlRequest = URLRequest(url: URL(string:  "\(baseURL)/search/photos?page=\(self.pageNumber)&query=\(self.searchTerm)")!)
        urlRequest.setValue("Client-ID \(self.apiKey)", forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = HTTPMethod.get.rawValue
        
        Alamofire.request(urlRequest).responseData{ (response) in
            switch (response.result){
            case .success(let data):
                
                guard let photoData = try? JSONDecoder().decode(ResponseUnsplash.self, from : data) else{
                    self.view?.showError("Something wrong happened!")
                    return
                }
                let photos : [PhotoImage] = photoData.results
                let photosViewModel : [PhotoViewModel] = photos.map({
                    return PhotoViewModel(dataModel : $0)
                })
                
                self.view?.updateData(photosViewModel)
            case .failure(let error):
                self.view?.showError(error.localizedDescription)
           
            }
        }
    }
    
}

extension PhotoCollectionPresenter : PhotoCollectionToPresenter{
    func getMorePhotos() {
        // this will get the more image with the same search term
        self.pageNumber += 1
        self.getPhotos()
    }
    
    func getNewPhotos(_ searchText: String) {
        // this will reset the page number into the beginning again
        self.searchTerm = searchText
        self.pageNumber = 1
        self.getPhotos()
    }
    

    
    
}
