//
//  ButtonCell.swift
//  Sample
//
//  Created by Swathiga on 22/01/25.
//

import UIKit

class ButtonCell: UITableViewCell {
    @IBOutlet var btnTitle:UIButton!
    @IBOutlet var btnCancel:UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnTitle.layer.cornerRadius = 10
        btnTitle.layer.masksToBounds = true
        
        btnCancel.layer.cornerRadius = 10
        btnCancel.layer.masksToBounds = true
        btnCancel.layer.borderWidth = 0.6
        btnCancel.layer.borderColor = UIColor.lightGray.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
