//
//  FavoritesController.swift
//  Podcast
//
//  Created by ashim Dahal on 4/21/18.
//  Copyright © 2018 ashim Dahal. All rights reserved.
//

import UIKit

class FavoritesController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var podcasts = UserDefaults.standard.savedPodcasts()
 
    let cellID = "CellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.podcasts = UserDefaults.standard.savedPodcasts()
        self.collectionView?.reloadData()
        UIApplication.mainTabBarController()?.viewControllers?[1].tabBarItem.badgeValue = nil
    }
   
    fileprivate func setupCollectionView(){
        collectionView?.backgroundColor = .white
        collectionView?.register(FavoriteCell.self , forCellWithReuseIdentifier: cellID)
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        collectionView?.addGestureRecognizer(gesture)
    }
    
    @objc fileprivate func handleLongPress(gesture : UILongPressGestureRecognizer){
        
        let location = gesture.location(in: collectionView)
        guard let selectedIndexPathItem = collectionView?.indexPathForItem(at: location) else {return}
     
        let alertController = UIAlertController(title: "Delete podcast", message: "Do you want to delete podcast", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (_) in
            let deletedPodcast = self.podcasts.remove(at: selectedIndexPathItem.item)
            self.collectionView?.deleteItems(at: [selectedIndexPathItem])
            
            // perform archive delet action

            UserDefaults.standard.deletePodcast(podcast : deletedPodcast)
          
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController , animated:  true)
        
    }
   
    // MARK:- Collection View Properties
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        let epishodController = EpishodController()
        epishodController.podcast = self.podcasts[indexPath.item]
        navigationController?.pushViewController(epishodController, animated: true)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! FavoriteCell
        cell.podcast = podcasts[indexPath.item]
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 3 * 16) / 2
        let height = width + 46
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
}
