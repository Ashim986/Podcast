//
//  PodcastCell.swift
//  Podcast
//
//  Created by ashim Dahal on 4/29/18.
//  Copyright © 2018 ashim Dahal. All rights reserved.
//

import UIKit
import AlamofireImage


class PodcastCell: UITableViewCell {
    
    @IBOutlet weak var podcastImageView : UIImageView!
    @IBOutlet weak var trackNameLabel : UILabel!
    @IBOutlet weak var artistNameLabel : UILabel!
    @IBOutlet weak var epishodCountLabel : UILabel!
    
    
    var podcast : Podcast! {
        didSet {
            
            trackNameLabel.text = podcast.trackName
            artistNameLabel.text = podcast.artistName
            epishodCountLabel.text = "\(podcast.trackCount ?? 0) Epishods"
            
            guard let artistImageUrl = podcast.artworkUrl600 else {return}
            guard let url = URL(string: artistImageUrl) else {return}
            //Method 1
//            podcastImageView.af_setImage(withURL: url)

            //Method 2
            podcastImageView.af_setImage(withURL: url, placeholderImage: #imageLiteral(resourceName: "appicon"), filter: nil, imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: true, completion: nil)
//
//            URLSession.shared.dataTask(with: url) { (data, response, err) in
//                if let err = err {
//                    print("failed to get response", err)
//                }
//                guard let data = data else {return}
//
//                DispatchQueue.main.async {
//                     self.podcastImageView.image = UIImage(data: data)
//                }
//                print("finished downloading Image Data",data)
//            }.resume()
        }
    }

    
    
}
