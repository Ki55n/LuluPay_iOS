//
//  ProfileTCell.swift
//  Sample
//
//  Created by Swathiga on 21/01/25.
//

import UIKit

class ProfileTCell: UITableViewCell {
    @IBOutlet var imgPrtofile:UIImageView!
    @IBOutlet var lblTitle:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
