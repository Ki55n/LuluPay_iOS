//
//  ButtonCell.swift
//  Sample
//
//  Created by Swathiga on 22/01/25.
//

import UIKit

class ButtonCell: UITableViewCell {
    @IBOutlet var btnTitle:UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
