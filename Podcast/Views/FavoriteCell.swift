//
//  FavoriteCell.swift
//  Podcast
//
//  Created by ashim Dahal on 6/6/18.
//  Copyright © 2018 ashim Dahal. All rights reserved.
//

import UIKit
import AlamofireImage

class FavoriteCell: UICollectionViewCell {
    
    var podcast : Podcast! {
        didSet {
            podcastNameLabel.text = podcast.trackName
            artistNameLabel.text = podcast.artistName
            guard let stringURL = podcast.artworkUrl600 else {return}
            guard let url = URL(string: stringURL) else {return}
            podcastImage.af_setImage(withURL: url)
        }
    }
    
    let podcastImage : UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "appicon"))
        return image
    }()
    
    let podcastNameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.text = "Podcast Name"
        return label
    }()
    
    let artistNameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "Artist Name"
        label.textColor = .lightGray
        return label
    }()
    
    override init(frame: CGRect) {
    super.init(frame: frame)
    
        setupViewsAndAnchors()
    
    }
    fileprivate func setupViewsAndAnchors() {
        let stackView = UIStackView(arrangedSubviews: [podcastImage,podcastNameLabel,artistNameLabel])
        podcastImage.heightAnchor.constraint(equalTo: podcastImage.widthAnchor).isActive = true
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        NSLayoutConstraint.activate([stackView.topAnchor.constraint(equalTo: topAnchor), stackView.bottomAnchor.constraint(equalTo: bottomAnchor), stackView.leadingAnchor.constraint(equalTo: leadingAnchor), stackView.trailingAnchor.constraint(equalTo: trailingAnchor)])
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
