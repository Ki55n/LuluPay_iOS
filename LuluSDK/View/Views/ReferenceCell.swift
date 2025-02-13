//
//  ReferenceCell.swift
//  LuluSDK
//
//  Created by Swathiga on 04/02/25.
//

import UIKit

class ReferenceCell: UITableViewCell {
    @IBOutlet weak var txtFieldRef:UITextField!
    @IBOutlet weak var btnNext:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
