//
//  HeaderViewCell.swift
//  Sample
//
//  Created by Swathiga on 24/01/25.
//

import UIKit

class HeaderViewCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var notificationButton: UIButton!
    @IBOutlet weak var viewMain: UIView!


    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
