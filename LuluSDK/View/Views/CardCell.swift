//
//  CardCell.swift
//  Sample
//
//  Created by Swathiga on 21/01/25.
//

import UIKit

class CardCell: UITableViewCell {
    @IBOutlet var lblCardNo:UILabel!
    @IBOutlet var btnView:UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
