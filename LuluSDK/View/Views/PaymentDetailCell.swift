//
//  PaymentDetailCell.swift
//  LuluSDK
//
//  Created by Swathiga on 04/02/25.
//

import UIKit

class PaymentDetailCell: UITableViewCell {
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblAmount:UILabel!
    @IBOutlet weak var lblCurrencyCode:UILabel!
    @IBOutlet weak var imgCurrency:UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
