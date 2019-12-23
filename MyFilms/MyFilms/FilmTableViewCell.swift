//
//  FilmTableViewCell.swift
//  MyFilms
//
//  Created by Jon Phipps on 08/03/2019.
//  Copyright © 2019 Jon Phipps. All rights reserved.
//

import UIKit

class FilmTableViewCell: UITableViewCell {
    
    @IBOutlet weak var filmImageView: UIImageView!
    @IBOutlet weak var filmTitleLabel: UILabel!
    @IBOutlet weak var filmYearLabel: UILabel!
    @IBOutlet weak var filmRatingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
