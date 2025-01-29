//
//  SettingsCell.swift
//  Sample
//
//  Created by Swathiga on 20/01/25.
//

import UIKit

class SettingsCell: UITableViewCell {
    @IBOutlet var lblTitle:UILabel!
    @IBOutlet var imgIcon:UIImageView!
    @IBOutlet var imgArrow:UIImageView!
    @IBOutlet var viewMain:UIView!
    @IBOutlet var viewShadow:UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
