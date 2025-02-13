//
//  ExchangeRateCell.swift
//  Sample
//
//  Created by Swathiga on 24/01/25.
//

import UIKit

class ExchangeRateCell: UITableViewCell {
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var buyRateLabel: UILabel!
    @IBOutlet weak var sellRateLabel: UILabel!
    @IBOutlet weak var viewHeader: UIStackView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
