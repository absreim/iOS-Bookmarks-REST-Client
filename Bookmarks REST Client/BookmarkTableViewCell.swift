//
//  BookmarkTableViewCell.swift
//  Bookmarks REST Client
//
//  Created by Brook Li on 3/28/18.
//  Copyright © 2018 Brook Li. All rights reserved.
//

import UIKit

class BookmarkTableViewCell: UITableViewCell {

    // MARK: Properties
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var uriLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
