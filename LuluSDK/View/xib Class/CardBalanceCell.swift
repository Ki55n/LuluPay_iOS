//
//  CardBalanceCell.swift
//  Sample
//
//  Created by Swathiga on 24/01/25.
//

import UIKit

class CardBalanceCell: UITableViewCell {
    @IBOutlet weak var cardBackgroundView: UIView!
    @IBOutlet weak var accountBalanceLabel: UILabel!
    @IBOutlet weak var balanceValueLabel: UILabel!
    @IBOutlet weak var cardLogoImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Card styling
        cardBackgroundView.layer.cornerRadius = 12
        cardBackgroundView.layer.shadowColor = UIColor.black.cgColor
        cardBackgroundView.layer.shadowOpacity = 0.1
        cardBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 4)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
