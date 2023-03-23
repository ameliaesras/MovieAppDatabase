//
//  ReviewsTableViewCell.swift
//  TMDB
//
//  Created by Amelia Esra Sihombing on 22/03/23.
//  Copyright © 2023 Amelia Esra S. All rights reserved.
//

import UIKit
import Kingfisher

class ReviewsTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var labelUsername: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelContent: UILabel!
    
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    var cellViewModel: ReviewCellViewModel? {
        didSet {
            labelUsername.text = cellViewModel?.username
            labelName.text = cellViewModel?.name
            labelContent.text = cellViewModel?.content
            profileImg.makeRounded()
            
            if cellViewModel?.imagePath != "" {
                profileImg.kf.indicatorType = .activity
                profileImg.kf.setImage(with: URL(string: APIConstants.imagesBaseURL + "original" + (cellViewModel?.imagePath ?? "")))
            } else {
                profileImg.image = UIImage(named: "user")
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
