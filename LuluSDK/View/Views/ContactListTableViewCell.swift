//
//  ContactListTableViewCell.swift
//  LuluSDK
//
//  Created by Swathiga on 04/02/25.
//

import UIKit

class ContactListTableViewCell: UITableViewCell {
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var lblAccountNumber:UILabel!
    @IBOutlet weak var imgContact:UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
