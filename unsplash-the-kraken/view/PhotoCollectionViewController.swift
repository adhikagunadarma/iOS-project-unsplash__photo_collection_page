//
//  PhotoCollectionViewController.swift
//  unsplash-the-kraken
//
//  Created by Josephine Fransisca on 16/11/19.
//  Copyright © 2019 Adhika gunadarma. All rights reserved.
//

import SDWebImage
import UIKit

private let reuseIdentifier = "PhotoCell"


class PhotoCollectionViewController: UICollectionViewController {
    
    private let baseURL = "https://api.unsplash.com"
    private let apiKey = "029c013809b5db247d1f7e81d0b52d344b5fd2eb8ce00f376f439519ca909430"
    
    private var listPhotos = [PhotoViewModel]()
    lazy var presenter = PhotoCollectionPresenter(with: self)

    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func searchAction(_ sender: UIButton) {
        self.listPhotos = []
        self.showSpinner(onView: self.view)
        self.presenter.getNewPhotos(self.searchTextField.text!)
    }
    

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listPhotos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! PhotoCollectionViewCell
        cell.imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
//        cell.imageView.sd_setImage(with: URL(string: self.listPhotos[indexPath.item].getPhoto), placeholderImage : nil)
        return cell
    }
     
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.row == self.listPhotos.count - 1 ) { //it's your last cell
            self.showSpinner(onView: self.view)
            self.presenter.getMorePhotos()
        }
    }
    
}

extension PhotoCollectionViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
            
                let viewWidth = collectionView.frame.size.width
                let paddingSpace = CGFloat(16)
                let marginSpace = CGFloat(16)
                let availableWidth = viewWidth - paddingSpace - marginSpace
                let widthPerItem = availableWidth / CGFloat(2)
                let heightPerItem = widthPerItem
                return CGSize(width: widthPerItem, height: heightPerItem)
            }
        
    //     // buat margin
          func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
                let margin = CGFloat(8.0)
              return UIEdgeInsets (top: margin, left: margin, bottom: margin, right: margin)
          }

          //buat padding
          func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            let padding = CGFloat(8.0)
              return CGFloat(padding)
          }
}


extension PhotoCollectionViewController : PresenterPhotoCollection{
    func updateData(_ photos: [PhotoViewModel]) {
        self.removeSpinner()
        self.listPhotos.append(contentsOf: photos)
        self.collectionView.reloadData()
        
        
    }
    
    func showError(_ message: String) {
        self.removeSpinner()
        self.presentAlert(message)
    }

}

var vSpinner : UIView?
 
extension UICollectionViewController {
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
    
    func presentAlert(_ messageText : String){
        let alert = UIAlertController(title: "Error", message: messageText, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
}
