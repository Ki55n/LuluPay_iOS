//
//  RecentTableViewCell.swift
//  LuluSDK
//
//  Created by Swathiga on 01/02/25.
//

import UIKit

class RecentTransactionCell: UITableViewCell {
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var lblStatus:UILabel!
    @IBOutlet weak var lblAmount:UILabel!
    @IBOutlet weak var lblDate:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
