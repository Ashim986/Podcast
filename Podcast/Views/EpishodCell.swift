//
//  EpishodCell.swift
//  Podcast
//
//  Created by ashim Dahal on 5/20/18.
//  Copyright © 2018 ashim Dahal. All rights reserved.
//

import UIKit
import AlamofireImage

class EpishodCell: UITableViewCell {
    
    var epishod : Epishod!{
        didSet {
            descriptionLabel.text = epishod.description
            titleLabel.text = epishod.title
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM,dd,yyyy"
            publicationDateLabel.text = dateFormatter.string(from: epishod.pubDate)
            guard let imageUrl = epishod.imageUrl?.toSecureHTTPS() else {return}
            guard let url = URL(string: imageUrl) else {return}
            epishodImageView.af_setImage(withURL: url)
        }
    }
    
    @IBOutlet weak var epishodImageView: UIImageView!
    @IBOutlet weak var publicationDateLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet{
            descriptionLabel.numberOfLines = 2
        }
    }
    @IBOutlet weak var downloadPercentage: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet{
            titleLabel.numberOfLines = 2
        }
    }
    
    
}
    

    

