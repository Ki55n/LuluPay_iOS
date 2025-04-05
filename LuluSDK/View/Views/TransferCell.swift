//
//  TransferCell.swift
//  Sample
//
//  Created by Swathiga on 27/01/25.
//

import UIKit

class TransferCell: UITableViewCell {
    @IBOutlet weak var imgTransfer:UIImageView!
    @IBOutlet weak var viewTransfer:UIView!
    @IBOutlet weak var viewScan:UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
