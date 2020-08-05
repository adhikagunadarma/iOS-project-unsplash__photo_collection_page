//
//  PhotoCollectionViewController.swift
//  unsplash-the-kraken
//
//  Created by Josephine Fransisca on 16/11/19.
//  Copyright © 2019 Adhika gunadarma. All rights reserved.
//

import UIKit

private let reuseIdentifier = "PhotoCell"


class PhotoCollectionViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {

    private var currentPage = 1
    private var searchTerm = ""
    private let baseURL = "https://api.unsplash.com"
    private let apiKey = "029c013809b5db247d1f7e81d0b52d344b5fd2eb8ce00f376f439519ca909430"
    private var listPhotos = [PhotoImage]()
    

    private let sectionInsets = UIEdgeInsets(top: 50.0,
                                             left: 20.0,
                                             bottom: 50.0,
                                             right: 20.0)
    private let itemsPerRow: CGFloat = 2
    private var vSpinner : UIView?


    
    @IBOutlet weak var searchTextField: UITextField!
        
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    @IBAction func searchAction(_ sender: UIButton) {
        self.searchTerm = searchTextField.text!
        getUnsplashImage()
    }
    
    private func getUnsplashImage(){
        self.currentPage = 1
        self.listPhotos = []
        self.fetchData(searchTerm, currentPage)
    }
    
    private func getMoreDataFromScrolling(){
        self.currentPage += 1
        print(currentPage)
        self.fetchData(searchTerm, currentPage)
    }
    
    private func fetchData(_ searchTerm: String, _ currentPage: Int){
        self.showSpinner(onView: self.view)
        var urlRequest = URLRequest(url: URL(string:  "\(baseURL)/search/photos?page=\(currentPage)&query=\(searchTerm)")!)
           urlRequest.setValue("Client-ID \(apiKey)", forHTTPHeaderField: "Authorization")
           
           URLSession.shared.dataTask(with: urlRequest) { data, response, error in
               if let data = data {
                   do {
                    let images = try JSONDecoder().decode(ResponseUnsplash.self, from: data)
                    for image in images.results{
                        self.listPhotos.append(image)
                    }
                    self.removeSpinner()
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                    }
//                    print(self.listPhotos)
                    
                   } catch let error {
                       print(error)
                   }
               }
               }.resume()
    }
    
    private func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5,
                                                   green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    private func removeSpinner() {
        
        DispatchQueue.main.async {
            self.vSpinner?.removeFromSuperview()
            self.vSpinner = nil
        }
    }
    

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.listPhotos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! PhotoCollectionViewCell
        //set background to black
        cell.backgroundColor = .black
        
        // set loading indicator for each image !-
        let spinnerView = UIView.init(frame: cell.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5,
                                                   green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            cell.addSubview(spinnerView)
        }

        // get image URL from each image
        // initialize each cell with image
        let selectedPhoto = self.listPhotos[indexPath.item]
        let url = URL(string: selectedPhoto.urls.regular)
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                //remove loading indicator and change the image from URL
                spinnerView.removeFromSuperview()
                cell.imageView.image = UIImage(data: data!)
            }
        }
          
        return cell
    }
    
    // limiting 2 image  / row
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
      //2
      let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
      let availableWidth = view.frame.width - paddingSpace
      let widthPerItem = availableWidth / itemsPerRow
      
      return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
      return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      return sectionInsets.left
    }
    
    
    // handling when scroll view has reach the bottom of the page
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.row == self.listPhotos.count - 1 ) { //it's your last cell
            self.getMoreDataFromScrolling()
         }
    }
}
